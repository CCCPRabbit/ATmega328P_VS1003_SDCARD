/**
 * @file main.c
 * @author CCCPRabbit
 * @date 2026-06-25
 * @brief Main function
 */

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "main.h"
#include "spi.h"
#include "usart_interrupt.h"
#include "vs1003.h"
#include "ff.h"
#include "mmc_avr.h"

#define LED_PORT    PORTD
#define LED_PIN     PD4
#define LED_ON      LED_PORT&=~(1<<LED_PIN)
#define LED_OFF     LED_PORT|=1<<LED_PIN
#define LED_TOGGLE  LED_PORT^=1<<LED_PIN
#define AUDIO_SHUTDOWN_PORT PORTD
#define AUDIO_SHUTDOWN_PIN  PD6
#define ENCODER_PIN     PINC
#define ENCODER_A_PIN   PC0
#define ENCODER_B_PIN   PC1

#define STOP_STATE  0
#define WAIT_STATE  1
#define PLAY_STATE  2

#define FILE_COUNT_MAX  50

// Voltage Reference: AVCC pin
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))

volatile uint16_t tick=0;

#ifdef DEBUG
char usart_string[32];
#endif

uint8_t SpinCheck(uint16_t encoder_count);
uint16_t Encoder(void);
uint8_t CountFiles(char file_path_list[][FF_SFN_BUF+1]);
unsigned int ReadADC(unsigned char adc_input);

ISR(TIMER0_COMPA_vect)
{
    static uint8_t _10ms_counter=0;
    tick++;

    _10ms_counter++;
    if(_10ms_counter>=10)
    {
        _10ms_counter=0;
        mmc_disk_timerproc();
    }
}

int main(){
    // Add your code here and press Ctrl + Shift + B to build
    FATFS fs;
    FIL fil;
    FRESULT res;
    volatile uint16_t led_tick=0;
    uint8_t state=WAIT_STATE,file_count,mp3_buffer[32];
    char file_path_list[FILE_COUNT_MAX][FF_SFN_BUF+1];
    uint16_t adc_value;

    SD_CS_PORT|=(1<<SD_CS_PIN);
    DDRD=(1<<SD_CS_PIN)|(1<<AUDIO_SHUTDOWN_PIN)|(1<<LED_PIN);

    AUDIO_SHUTDOWN_PORT|=(1<<AUDIO_SHUTDOWN_PIN);

    //timer0 Clock : 125.000 kHz, Mode: CTC top=OCR0A, Timer Period: 1 ms
    TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (1<<WGM01) | (0<<WGM00);
    TCCR0B=(0<<WGM02) | (0<<CS02) | (1<<CS01) | (1<<CS00);
    TCNT0=0x00;
    OCR0A=0x7C;
    OCR0B=0x00;

    TIMSK0=(0<<OCIE0B) | (1<<OCIE0A) | (0<<TOIE0);//timer interrupt enable

    // ADC Clock frequency: 1000.000 kHz
    // ADC Voltage Reference: AVCC pin
    DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
    ADMUX=ADC_VREF_TYPE;
    ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
    ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

    #ifdef DEBUG
    InitUART(8,1);
    #endif
    sei();
    SPIInit();
    VS1003_Init();

    res=f_mount(&fs,"",0);
    #ifdef DEBUG
    sprintf(usart_string,"f_mount %d\r",res);
    USARTPuts(usart_string);
    #endif
    file_count=CountFiles(file_path_list);
    #ifdef DEBUG
    sprintf(usart_string,"file_count %d\r",file_count);
    USARTPuts(usart_string);
    for(uint8_t i=0;i<file_count;i++){
        sprintf(usart_string,"%s\r",file_path_list[i]);
        USARTPuts(usart_string);
    }
    #endif
    if(file_count==0){
        #ifdef DEBUG
        sprintf(usart_string,"no file\r");
        USARTPuts(usart_string);
        #endif
        while(1){}
    }

    for(uint8_t i=0;i<6;i++)
    adc_value^=ReadADC(2+i);
    srand(adc_value);//TODO adc as seed
    #ifdef DEBUG
    sprintf(usart_string,"seed %d\r",adc_value);
    USARTPuts(usart_string);
    #endif

    while(1){
        uint8_t spin;
        uint16_t encoder_count;
        encoder_count=Encoder();
        spin=SpinCheck(encoder_count);

        switch(state){
        case STOP_STATE:
            if(spin){
                uint8_t random_num;
                state=PLAY_STATE;
                random_num=rand()%file_count;
                #ifdef DEBUG
                sprintf(usart_string,"rand %d\r",random_num);
                USARTPuts(usart_string);
                #endif
                res=f_open(&fil,file_path_list[random_num],FA_READ);
                #ifdef DEBUG
                sprintf(usart_string,"f_open %d\r",res);
                USARTPuts(usart_string);
                #endif
            }
            break;
        case PLAY_STATE:
            if (VS_DREQ_PIN_REG & (1 << VS_DREQ_PIN)) {
                uint16_t bytes_read=0;
                f_read(&fil, mp3_buffer, 32, &bytes_read);
                if(bytes_read>=0)
                    VS1003_SendMusicData(mp3_buffer, bytes_read);
                else
                    state=WAIT_STATE;
            }

            if(!spin){
                state=STOP_STATE;
                VS1003_WriteRegister(SCI_MODE,0x0804|SM_OUTOFWAV);
                f_close(&fil);
            }
            break;
        case WAIT_STATE:
            if(!spin){
                state=STOP_STATE;
            }
            break;
        default:state=STOP_STATE;
        }

        if(tick-led_tick>=300){
            led_tick=tick;
            LED_TOGGLE;
        }
    }

    return 0;
}

uint8_t SpinCheck(uint16_t encoder_count){
    static uint16_t old_tick=0,last_count=0;
    static uint8_t state=0;
    switch(state){
    case 0:
        if((int16_t)encoder_count-(int16_t)last_count>=3){
            old_tick=tick;
            last_count=encoder_count;
            state=1;
        }
        else if(tick-old_tick>=500){
            old_tick=tick;
            last_count=encoder_count;
        }
        break;
    case 1:
        if((int16_t)encoder_count-(int16_t)last_count>0){
            old_tick=tick;
            last_count=encoder_count;
        }
        else if(tick-old_tick>300){
            old_tick=tick;
            state=0;
        }
    }
    return state;
}

uint16_t Encoder(void){
    static uint8_t encoder_state=0;
    static uint16_t encoder_count=0;
    encoder_state=((encoder_state<<2)&0x0c)|(ENCODER_PIN&((1<<ENCODER_A_PIN)|(1<<ENCODER_B_PIN)));
    switch(encoder_state){
    case 0x0d:
    case 0x0b:
    case 0x02:
    case 0x04:encoder_count++;break;
    case 0x07:
    case 0x0e:
    case 0x08:
    case 0x01:encoder_count--;break;
    }
    return encoder_count;
}

uint8_t CountFiles(char file_path_list[][FF_SFN_BUF+1]){
    DIR dir;
    FILINFO fno;
    FRESULT res;
    int count = 0;

    res = f_opendir(&dir, "");
    #ifdef DEBUG
    sprintf(usart_string,"f_opendir %d\r",res);
    USARTPuts(usart_string);
    #endif
    for (;;)
    {
        res = f_readdir(&dir, &fno);
        if (res != FR_OK || fno.fname[0] == 0) break;
        memcpy(file_path_list[count],fno.fname,FF_SFN_BUF+1);
        #ifdef DEBUG
        sprintf(usart_string,"f_readdir %d\r",res);
        USARTPuts(usart_string);
        #endif

        // 디렉토리, 볼륨레이블, 숨김/시스템 파일 제외
        if (fno.fattrib & (AM_DIR | AM_HID | AM_SYS))
        {
            continue;
        }

        count++;
    }
    res=f_closedir(&dir);
    #ifdef DEBUG
    sprintf(usart_string,"f_closedir %d\r",res);
    USARTPuts(usart_string);
    #endif

    return count;
}

unsigned int ReadADC(unsigned char adc_input)
{
    ADMUX=adc_input | ADC_VREF_TYPE;
    _delay_us(10);
    ADCSRA|=(1<<ADSC);
    while ((ADCSRA & (1<<ADIF))==0);
    ADCSRA|=(1<<ADIF);
    return ADCW;
}