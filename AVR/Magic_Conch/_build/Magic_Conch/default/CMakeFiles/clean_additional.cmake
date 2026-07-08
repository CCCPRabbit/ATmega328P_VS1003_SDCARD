# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "")
  file(REMOVE_RECURSE
  "Y:\\project\\Magic_Conch\\AVR\\Magic_Conch\\out\\Magic_Conch\\default.eep"
  "Y:\\project\\Magic_Conch\\AVR\\Magic_Conch\\out\\Magic_Conch\\default.hex"
  "Y:\\project\\Magic_Conch\\AVR\\Magic_Conch\\out\\Magic_Conch\\default.lss"
  "Y:\\project\\Magic_Conch\\AVR\\Magic_Conch\\out\\Magic_Conch\\default.srec"
  "Y:\\project\\Magic_Conch\\AVR\\Magic_Conch\\out\\Magic_Conch\\default.usersignatures"
  )
endif()
