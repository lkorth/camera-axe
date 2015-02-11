/*
  FONT -Sony-Fixed-Medium-R-Normal--16-120-100-100-C-80-ISO8859-1
  COPYRIGHT Copyright (c) 1987, 1988 Sony Corp. 
  Use
      extern const char font_8x16[] PROGMEM;
  to declare the font.
*/
#include <avr/pgmspace.h>
#ifndef PROGMEM
#define PROGMEM
#endif
const char font_8x16[1461] PROGMEM = {
  0x04, 0x02, 0x03, 0x04, 0x08, 0x10, 0x02, 0x04, 0x08, 0x01, 0x00, 0x12, 0x48, 0x0f, 0x08, 0x1c, 
  0x08, 0x00, 0x00, 0x08, 0x08, 0x08, 0x08, 0x1c, 0x1c, 0x1c, 0x1c, 0x1c, 0x1c, 0x11, 0x08, 0x0e, 
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x12, 0x24, 0x24, 0x36, 0x36, 0x11, 0x28, 
  0x0e, 0x12, 0x12, 0x12, 0x12, 0x7f, 0x24, 0x24, 0x24, 0x24, 0x24, 0xfe, 0x48, 0x48, 0x48, 0x13, 
  0x48, 0x10, 0x08, 0x08, 0x1e, 0x29, 0x49, 0x4b, 0x48, 0x28, 0x1c, 0x0a, 0x09, 0x69, 0x49, 0x2a, 
  0x1c, 0x08, 0x13, 0x48, 0x10, 0x01, 0x31, 0x4a, 0x4a, 0x4a, 0x4c, 0x34, 0x08, 0x08, 0x16, 0x19, 
  0x29, 0x29, 0x29, 0x46, 0x40, 0x10, 0x08, 0x0d, 0x4e, 0x31, 0x11, 0x29, 0x2a, 0x2a, 0x74, 0x04, 
  0x0a, 0x12, 0x12, 0x12, 0x0c, 0x11, 0x08, 0x0e, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x00, 0x03, 0x04, 0x04, 0x07, 0x07, 0x13, 0x48, 0x10, 0x40, 0x20, 0x10, 0x10, 0x08, 0x08, 0x08, 
  0x08, 0x08, 0x08, 0x08, 0x08, 0x10, 0x10, 0x20, 0x40, 0x13, 0x48, 0x10, 0x01, 0x02, 0x04, 0x04, 
  0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x04, 0x04, 0x02, 0x01, 0x0e, 0x08, 0x0b, 0x00, 
  0x00, 0x08, 0x1c, 0x49, 0x6b, 0x1c, 0x6b, 0x49, 0x1c, 0x08, 0x0e, 0x08, 0x0b, 0x00, 0x00, 0x08, 
  0x08, 0x08, 0x08, 0x7f, 0x08, 0x08, 0x08, 0x08, 0x08, 0x48, 0x05, 0x03, 0x04, 0x04, 0x07, 0x07, 
  0x0a, 0x08, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x7f, 0x07, 0x28, 0x04, 0x02, 0x07, 0x07, 
  0x02, 0x13, 0x48, 0x10, 0x01, 0x01, 0x02, 0x02, 0x04, 0x04, 0x08, 0x08, 0x08, 0x10, 0x10, 0x10, 
  0x20, 0x20, 0x40, 0x40, 0x11, 0x28, 0x0e, 0x18, 0x24, 0x24, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 
  0x42, 0x42, 0x24, 0x24, 0x18, 0x10, 0x08, 0x0d, 0x3e, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 
  0x08, 0x08, 0x08, 0x0e, 0x08, 0x10, 0x08, 0x0d, 0x7e, 0x42, 0x44, 0x04, 0x08, 0x10, 0x10, 0x20, 
  0x40, 0x46, 0x42, 0x24, 0x18, 0x10, 0x08, 0x0d, 0x1c, 0x22, 0x41, 0x41, 0x40, 0x20, 0x1c, 0x20, 
  0x40, 0x41, 0x41, 0x22, 0x1c, 0x10, 0x08, 0x0d, 0x3c, 0x10, 0x10, 0x10, 0x7f, 0x11, 0x11, 0x12, 
  0x12, 0x14, 0x14, 0x18, 0x10, 0x10, 0x08, 0x0d, 0x1c, 0x22, 0x41, 0x43, 0x40, 0x40, 0x41, 0x23, 
  0x1d, 0x01, 0x01, 0x01, 0x3f, 0x10, 0x08, 0x0d, 0x1c, 0x22, 0x41, 0x41, 0x41, 0x41, 0x23, 0x1d, 
  0x01, 0x01, 0x62, 0x42, 0x3c, 0x11, 0x28, 0x0e, 0x08, 0x08, 0x08, 0x08, 0x10, 0x10, 0x10, 0x10, 
  0x20, 0x20, 0x20, 0x41, 0x41, 0x7f, 0x10, 0x08, 0x0d, 0x1c, 0x22, 0x41, 0x41, 0x41, 0x22, 0x1c, 
  0x22, 0x41, 0x41, 0x41, 0x22, 0x1c, 0x10, 0x08, 0x0d, 0x1c, 0x22, 0x41, 0x40, 0x40, 0x5c, 0x62, 
  0x41, 0x41, 0x41, 0x41, 0x22, 0x1c, 0x0c, 0x08, 0x09, 0x1c, 0x1c, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x1c, 0x1c, 0x0e, 0x48, 0x0b, 0x0c, 0x08, 0x18, 0x1c, 0x1c, 0x00, 0x00, 0x00, 0x00, 0x1c, 0x1c, 
  0x13, 0x48, 0x10, 0x40, 0x20, 0x20, 0x10, 0x10, 0x08, 0x08, 0x04, 0x04, 0x08, 0x08, 0x10, 0x10, 
  0x20, 0x20, 0x40, 0x0c, 0x08, 0x09, 0x00, 0x00, 0x00, 0x00, 0x7f, 0x00, 0x00, 0x00, 0x7f, 0x13, 
  0x48, 0x10, 0x01, 0x02, 0x02, 0x04, 0x04, 0x08, 0x08, 0x10, 0x10, 0x08, 0x08, 0x04, 0x04, 0x02, 
  0x02, 0x01, 0x12, 0x48, 0x0f, 0x08, 0x1c, 0x08, 0x00, 0x00, 0x08, 0x08, 0x10, 0x20, 0x20, 0x40, 
  0x43, 0x41, 0x22, 0x1c, 0x10, 0x08, 0x0d, 0x3c, 0x42, 0x01, 0x59, 0x65, 0x45, 0x45, 0x45, 0x65, 
  0x59, 0x41, 0x42, 0x3c, 0x10, 0x08, 0x0d, 0x63, 0x41, 0x41, 0x41, 0x3e, 0x22, 0x22, 0x22, 0x22, 
  0x14, 0x14, 0x14, 0x08, 0x10, 0x08, 0x0d, 0x3f, 0x42, 0x42, 0x42, 0x42, 0x22, 0x1e, 0x22, 0x42, 
  0x42, 0x42, 0x22, 0x1f, 0x10, 0x08, 0x0d, 0x3c, 0x42, 0x42, 0x41, 0x01, 0x01, 0x01, 0x01, 0x01, 
  0x01, 0x42, 0x62, 0x5c, 0x10, 0x08, 0x0d, 0x1f, 0x22, 0x22, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 
  0x42, 0x22, 0x22, 0x1f, 0x10, 0x08, 0x0d, 0x7f, 0x42, 0x42, 0x42, 0x12, 0x12, 0x1e, 0x12, 0x12, 
  0x02, 0x42, 0x42, 0x7f, 0x10, 0x08, 0x0d, 0x0f, 0x02, 0x02, 0x02, 0x12, 0x12, 0x1e, 0x12, 0x12, 
  0x02, 0x42, 0x42, 0x7f, 0x10, 0x08, 0x0d, 0x58, 0x66, 0x42, 0x41, 0x41, 0x41, 0xf1, 0x01, 0x01, 
  0x02, 0x42, 0x64, 0x58, 0x10, 0x08, 0x0d, 0xe7, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x7e, 0x42, 
  0x42, 0x42, 0x42, 0xe7, 0x10, 0x08, 0x0d, 0x7f, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 
  0x08, 0x08, 0x08, 0x7f, 0x10, 0x08, 0x0d, 0x1c, 0x22, 0x41, 0x41, 0x41, 0x40, 0x40, 0x40, 0x40, 
  0x40, 0x40, 0x40, 0xf8, 0x10, 0x08, 0x0d, 0xc7, 0x42, 0x22, 0x22, 0x12, 0x12, 0x0a, 0x0e, 0x12, 
  0x12, 0x22, 0x22, 0x67, 0x10, 0x08, 0x0d, 0x7f, 0x42, 0x42, 0x42, 0x02, 0x02, 0x02, 0x02, 0x02, 
  0x02, 0x02, 0x02, 0x0f, 0x10, 0x08, 0x0d, 0x63, 0x41, 0x41, 0x41, 0x41, 0x49, 0x49, 0x49, 0x55, 
  0x55, 0x55, 0x63, 0x41, 0x10, 0x08, 0x0d, 0x43, 0x61, 0x51, 0x51, 0x51, 0x49, 0x49, 0x49, 0x45, 
  0x45, 0x45, 0x43, 0xe1, 0x10, 0x08, 0x0d, 0x1c, 0x22, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 0x41, 
  0x41, 0x41, 0x22, 0x1c, 0x10, 0x08, 0x0d, 0x0f, 0x02, 0x02, 0x02, 0x02, 0x1e, 0x22, 0x42, 0x42, 
  0x42, 0x42, 0x22, 0x1f, 0x12, 0x48, 0x0f, 0x60, 0x10, 0x1c, 0x22, 0x22, 0x5d, 0x41, 0x41, 0x41, 
  0x41, 0x41, 0x41, 0x22, 0x22, 0x1c, 0x10, 0x08, 0x0d, 0xc7, 0x42, 0x22, 0x22, 0x22, 0x12, 0x1e, 
  0x22, 0x42, 0x42, 0x42, 0x22, 0x1f, 0x10, 0x08, 0x0d, 0x1d, 0x23, 0x41, 0x41, 0x41, 0x20, 0x18, 
  0x06, 0x01, 0x01, 0x21, 0x32, 0x2c, 0x10, 0x08, 0x0d, 0x3e, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 
  0x08, 0x08, 0x08, 0x49, 0x49, 0x7f, 0x10, 0x08, 0x0d, 0x3c, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 
  0x42, 0x42, 0x42, 0x42, 0x42, 0xe7, 0x10, 0x08, 0x0d, 0x08, 0x08, 0x14, 0x14, 0x22, 0x22, 0x22, 
  0x22, 0x41, 0x41, 0x41, 0x41, 0x63, 0x10, 0x08, 0x0d, 0x22, 0x22, 0x22, 0x55, 0x55, 0x55, 0x49, 
  0x49, 0x49, 0x41, 0x41, 0x41, 0x63, 0x10, 0x08, 0x0d, 0x63, 0x41, 0x22, 0x22, 0x14, 0x14, 0x14, 
  0x08, 0x14, 0x14, 0x22, 0x22, 0x77, 0x10, 0x08, 0x0d, 0x3e, 0x08, 0x08, 0x08, 0x08, 0x08, 0x14, 
  0x14, 0x22, 0x22, 0x22, 0x41, 0x63, 0x10, 0x08, 0x0d, 0x7f, 0x41, 0x42, 0x42, 0x04, 0x04, 0x08, 
  0x08, 0x08, 0x10, 0x11, 0x21, 0x7f, 0x13, 0x48, 0x10, 0x78, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 
  0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x78, 0x11, 0x28, 0x0e, 0x40, 0x40, 0x20, 0x20, 
  0x10, 0x10, 0x08, 0x08, 0x04, 0x04, 0x02, 0x02, 0x01, 0x01, 0x13, 0x48, 0x10, 0x0f, 0x08, 0x08, 
  0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x0f, 0x11, 0x08, 0x0e, 
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x41, 0x22, 0x14, 0x08, 0x04, 0x48, 
  0x01, 0x7f, 0x11, 0x08, 0x0e, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x04, 
  0x04, 0x0c, 0x0c, 0x0c, 0x08, 0x09, 0xde, 0x61, 0x41, 0x41, 0x42, 0x7c, 0x40, 0x42, 0x3c, 0x10, 
  0x08, 0x0d, 0x1e, 0x22, 0x42, 0x42, 0x42, 0x42, 0x42, 0x22, 0x1e, 0x02, 0x02, 0x02, 0x03, 0x0c, 
  0x08, 0x09, 0x3c, 0x42, 0x41, 0x01, 0x01, 0x01, 0x41, 0x62, 0x5c, 0x10, 0x08, 0x0d, 0x7c, 0x22, 
  0x21, 0x21, 0x21, 0x21, 0x21, 0x22, 0x3c, 0x20, 0x20, 0x20, 0x60, 0x0c, 0x08, 0x09, 0x3c, 0x42, 
  0x41, 0x01, 0x01, 0x7f, 0x41, 0x22, 0x1c, 0x10, 0x08, 0x0d, 0x3e, 0x08, 0x08, 0x08, 0x08, 0x08, 
  0x08, 0x08, 0x7f, 0x08, 0x08, 0x88, 0x70, 0x0e, 0x48, 0x0b, 0x3e, 0x41, 0x41, 0x21, 0x1e, 0x02, 
  0x1c, 0x22, 0x22, 0x22, 0xdc, 0x10, 0x08, 0x0d, 0xe7, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x46, 
  0x3a, 0x02, 0x02, 0x02, 0x03, 0x11, 0x08, 0x0e, 0xff, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 
  0x1e, 0x00, 0x00, 0x00, 0x18, 0x18, 0x13, 0x48, 0x10, 0x1c, 0x22, 0x41, 0x41, 0x40, 0x40, 0x40, 
  0x40, 0x40, 0x40, 0x7c, 0x00, 0x00, 0x00, 0x60, 0x60, 0x10, 0x08, 0x0d, 0xc7, 0x42, 0x42, 0x22, 
  0x26, 0x1a, 0x12, 0x22, 0x42, 0x02, 0x02, 0x02, 0x03, 0x10, 0x08, 0x0d, 0xff, 0x10, 0x10, 0x10, 
  0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x1e, 0x0c, 0x08, 0x09, 0xdb, 0x49, 0x49, 0x49, 
  0x49, 0x49, 0x49, 0x49, 0x36, 0x0c, 0x08, 0x09, 0xe7, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x46, 
  0x3b, 0x0c, 0x08, 0x09, 0x1c, 0x22, 0x41, 0x41, 0x41, 0x41, 0x41, 0x22, 0x1c, 0x0e, 0x48, 0x0b, 
  0x0f, 0x02, 0x02, 0x1e, 0x22, 0x42, 0x42, 0x42, 0x42, 0x22, 0x1f, 0x0e, 0x48, 0x0b, 0x78, 0x20, 
  0x20, 0x3c, 0x22, 0x21, 0x21, 0x21, 0x21, 0x22, 0x7c, 0x0c, 0x08, 0x09, 0x3f, 0x04, 0x04, 0x04, 
  0x04, 0x04, 0x44, 0x4c, 0x37, 0x0c, 0x08, 0x09, 0x3d, 0x43, 0x41, 0x40, 0x3c, 0x02, 0x42, 0x62, 
  0x5c, 0x0f, 0x08, 0x0c, 0x38, 0x44, 0x44, 0x04, 0x04, 0x04, 0x04, 0x04, 0x3f, 0x04, 0x04, 0x04, 
  0x0c, 0x08, 0x09, 0x9c, 0x62, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x63, 0x0c, 0x08, 0x09, 0x08, 
  0x14, 0x14, 0x22, 0x22, 0x22, 0x41, 0x41, 0x63, 0x0c, 0x08, 0x09, 0x22, 0x22, 0x22, 0x55, 0x55, 
  0x49, 0x49, 0x49, 0x49, 0x0c, 0x08, 0x09, 0x77, 0x22, 0x14, 0x14, 0x08, 0x14, 0x14, 0x22, 0x77, 
  0x0e, 0x48, 0x0b, 0x02, 0x05, 0x09, 0x08, 0x10, 0x10, 0x28, 0x24, 0x44, 0x42, 0xe7, 0x0c, 0x08, 
  0x09, 0x7f, 0x42, 0x44, 0x08, 0x08, 0x10, 0x10, 0x22, 0x7e, 0x13, 0x48, 0x10, 0x60, 0x10, 0x10, 
  0x10, 0x10, 0x10, 0x10, 0x08, 0x04, 0x08, 0x10, 0x10, 0x10, 0x10, 0x10, 0x60, 0x13, 0x48, 0x10, 
  0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 
  0x13, 0x48, 0x10, 0x03, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x08, 0x10, 0x08, 0x04, 0x04, 0x04, 
  0x04, 0x04, 0x03, 0x11, 0x08, 0x0e, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
  0x00, 0x30, 0x49, 0x06, 0x00
};
