# ATmega328P SD Card Audio Player

A standalone audio playback device built around the **ATmega328P** microcontroller. The device reads audio files stored on an **SD card** and plays them back through the **VS1003** audio decoder.

## Overview

- **MCU:** ATmega328P
- **Storage:** SD Card (FAT filesystem)
- **Audio Decoder:** VS1003
- **File System:** [FatFs](http://elm-chan.org/fsw/ff/00index_e.html) by ChaN

## How It Works

1. The ATmega328P communicates with an SD card to read audio files.
2. FatFs handles the FAT filesystem parsing, allowing files to be listed and read from the SD card.
3. The audio data is streamed to the VS1003 decoder chip, which decodes and outputs the audio.

## Third-Party Libraries

This project uses [**FatFs**](http://elm-chan.org/fsw/ff/00index_e.html), a generic FAT filesystem module created by ChaN, to handle file access on the SD card. FatFs is used under its own license terms; please refer to the FatFs documentation for details.

## License

Except for the FatFs component (which retains its original license from ChaN), all other code and content in this project are licensed under:

**Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)**

You are free to share and adapt this work for non-commercial purposes, as long as you give appropriate credit and distribute your contributions under the same license. See [https://creativecommons.org/licenses/by-nc-sa/4.0/](https://creativecommons.org/licenses/by-nc-sa/4.0/) for full license details.
