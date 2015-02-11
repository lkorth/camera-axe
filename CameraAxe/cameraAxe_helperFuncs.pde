////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Maurice Ribble (Copyright 2010, 2011)
// Camera Axe - http://www.cameraaxe.com
// Open Source, licensed under a Creative Commons Attribution-NonCommercial 3.0 License (http://creativecommons.org/licenses/by-nc/3.0/)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Define digital/analog hardware pins
#define LED_1_PIN              0
#define LED_2_PIN              1
#define BUTTON_ACTIVATE_PIN    2
#define DEVICE1_SHUTTER_PIN    3
#define DEVICE1_FOCUS_PIN      4
#define DEVICE2_SHUTTER_PIN    5
#define DEVICE2_FOCUS_PIN      6
// NOT USED                    7
#define LCD_POWER_PIN          8
#define LCD_A0_PIN             9
#define LCD_CS_PIN             1
#define LCD_SI_PIN            11
//(Reserved for LCD)          12
#define LCD_SCL_PIN           13
#define BUTTONS_APIN           0
#define BUTTONS_PIN           14
// NOT USED                    1
#define SENSOR1_APIN           2
#define SENSOR1_PIN           16
#define SENSOR1_POWER_PIN     17
#define SENSOR2_APIN           4
#define SENSOR2_PIN           18
#define SENSOR2_POWER_PIN     19

////////////////////////////////////////
// Function: activeButtonIRS - The interupt service routine to handle pressing of the active button
// Parameters:
//   None
// Returns:
//   None
////////////////////////////////////////
void activeButtonISR()
{
  g_menuMode = MENUMODE_MENU;
  detachInterrupt(0);
}

////////////////////////////////////////
// Function: getLcdPinA0 - Returns the LCD pin number
// Parameters:
//   None
// Returns:
//   Value of the LCD pin
////////////////////////////////////////
byte getLcdPinA0()
{
  return LCD_A0_PIN;
}

////////////////////////////////////////
// Function: readSensorAnalog - Reads the analog value from sensors
// Parameters:
//   s - 0 is Sensor1 and 1 is Sensor2
// Returns:
//   Analog value for that sensor
////////////////////////////////////////
int readSensorAnalog(byte s)
{
  return analogRead(SENSOR1_APIN + s*2); // takes about 100 microseconds
}

////////////////////////////////////////
// Function: readSensorDigital - Reads the digital value from sensors
// Parameters:
//   s - 0 is Sensor1 and 1 is Sensor2
// Returns:
//   Digital value for that sensor
////////////////////////////////////////
int readSensorDigital(byte s)
{
  return digitalRead(SENSOR1_PIN + s*2);
}

int readSensorDigitalFast(byte s)  // 15 times faster than readSensorDigital()
{
  return bitRead(PINC, 2 + s*2);
}

////////////////////////////////////////
// Function: setSensorPower - Turns the power off/on for a sensor
// Parameters:
//   s   - 0 is Sensor1 and 1 is Sensor2
//   val - Valid values are LOW or HIGH
// Returns:
//   None
////////////////////////////////////////
void setSensorPower(byte s, byte val)
{
  digitalWrite(SENSOR1_POWER_PIN+s*2,  val);
}

////////////////////////////////////////
// Function: setSensorMode - Sets the mode (input or output) for each sensor
// Parameters:
//   s   - 0 is Sensor1 and 1 is Sensor2
//   val - Valid values are INPUT or OUTPUT
// Returns:
//   None
////////////////////////////////////////
void setSensorMode(byte s, byte val)
{
  pinMode(SENSOR1_PIN+s*2,  val);
}

////////////////////////////////////////
// Function: setSensor - Sets the output of the sensors (only valid if sensor mode is OUTPUT)
// Parameters:
//   s   - 0 is Sensor1 and 1 is Sensor2
//   val - Valid values are LOW or HIGH
// Returns:
//   None
////////////////////////////////////////
void setSensor(byte s, byte val)
{
  digitalWrite(SENSOR1_PIN+s*2, val);
}

////////////////////////////////////////
// Function: lcdPower - Turns the LCD backlight off/on
// Parameters:
//   val - Valid values are LOW or HIGH
// Returns:
//   None
////////////////////////////////////////
void lcdPower(byte val)
{
  digitalWrite(LCD_POWER_PIN, val);
}

////////////////////////////////////////
// Function: triggerDevicePins - Triggers and untriggers a device (camera/flash)
// Parameters:
//   device  - 0 is Device1 and 1 is Device2
//   focus   - Valid values are LOW or HIGH
//   Shutter - Valid values are LOW or HIGH
//   led     - Valid values are LOW or HIGH
// Returns:
//   None
////////////////////////////////////////
void triggerDevicePins(byte device, byte focus, byte shutter, byte led)
{
  digitalWrite(DEVICE1_FOCUS_PIN+device*2, focus);
  digitalWrite(DEVICE1_SHUTTER_PIN+device*2, shutter);
  digitalWrite(LED_1_PIN+device, led);
}

////////////////////////////////////////
// Function: setupCameraAxePins - Sets up the initial values of the camera axe hw pins
// Parameters:
//   None
// Returns:
//   None
////////////////////////////////////////
void setupCameraAxePins()
{
  // Setup input/output on all pins being used as digital in/outs
  pinMode(LED_1_PIN,           OUTPUT);
  pinMode(LED_2_PIN,           OUTPUT);
  pinMode(BUTTON_ACTIVATE,     INPUT);
  pinMode(DEVICE1_SHUTTER_PIN, OUTPUT);
  pinMode(DEVICE1_FOCUS_PIN,   OUTPUT);
  pinMode(DEVICE2_SHUTTER_PIN, OUTPUT);
  pinMode(DEVICE2_FOCUS_PIN,   OUTPUT);
  pinMode(LCD_POWER_PIN,       OUTPUT);
  // All the LCD pins are setup in the DogmCA class
  pinMode(SENSOR1_POWER_PIN,   OUTPUT);
  pinMode(SENSOR2_POWER_PIN,   OUTPUT);

  // Default values  
  digitalWrite(LED_1_PIN, LOW);
  digitalWrite(LED_2_PIN, LOW);
  digitalWrite(DEVICE1_SHUTTER_PIN, LOW);
  digitalWrite(DEVICE1_FOCUS_PIN,   LOW);
  digitalWrite(DEVICE2_SHUTTER_PIN, LOW);
  digitalWrite(DEVICE2_FOCUS_PIN,  LOW);
  digitalWrite(LCD_POWER_PIN,      HIGH);
  digitalWrite(SENSOR1_POWER_PIN,  HIGH);
  digitalWrite(SENSOR2_POWER_PIN,  HIGH);

  digitalWrite(BUTTONS_PIN, HIGH);         // Turn on 20K pullup
  digitalWrite(BUTTON_ACTIVATE_PIN, HIGH);
  //digitalWrite(SENSOR1_PIN, HIGH);
  //digitalWrite(SENSOR2_PIN, HIGH);
}

////////////////////////////////////////
// Function: lcdSetString - Sets a string using buttons and the LCD
// Parameters:
//   x            - X position on LCD to start drawing (bottom left is 0,0)
//   y            - Y position on LCD to start drawing (bottom left is 0,0)
//   selected     - The current value should be selected (ie xor box drawn around it)
//   edit         - If true we should enter edit mode for this value
//   numStrings   - The number of strings in the list of string ("strings")
//   stringLength - The lenght of a string (all strings should be the same length)
//   eepromPos    - Location in the list of values stored in the eeprom
//   strings      - A list of strings that the user can select from
// Returns:
//   Last button pressed which caused us to exit this function
////////////////////////////////////////
byte lcdSetString(byte x, byte y, boolean selected, boolean edit, byte numStrings, byte stringLength, byte eepromPos, const char **strings)
{
  byte button;
  byte val = g_eepromShadow[eepromPos];
  
  if (!selected)
  {
    // If this value is not selected nothing can change so just print out the value
    g_dogm.setXY(x, y);
    g_dogm.print(strings[val]);
    return BUTTON_NONE;
  }
  
  button = detectButtonPress(true);
  
  if (edit)  // If in edit mode see if anything changed
  {
    switch (button)
    {
      case BUTTON_NONE:
      case BUTTON_MENU:
      case BUTTON_SELECT:
      case BUTTON_LEFT:
      case BUTTON_RIGHT:
      case BUTTON_ACTIVATE:
          break;  // Do nothing
      case BUTTON_UP:
        {
          if (val == 0)
            val = numStrings - 1;
          else
            --val;
          g_eepromShadow[eepromPos] = val;
          eepromWriteInt(eepromPos, val);
        }
        break;
      case BUTTON_DOWN:
        {
          val = (val+1)%numStrings;
          g_eepromShadow[eepromPos] = val;
          eepromWriteInt(eepromPos, val);
        }
        break;
    }     
  }
  
  g_dogm.setXY(x, y);
  g_dogm.print(strings[val]);

  // xor box if not editing or blink the changing string in edit mode
  if ( !edit || (millis()%800) < 400 ) // Blink every 800 ms
  {
    g_dogm.xorBox(x, y, x+stringLength*g_dogm.charWidth-1, y+g_dogm.charHeight-1);
  }
  
  return button;
}


////////////////////////////////////////
// Function: lcdSetNumber - Sets a number using buttons and the LCD (up to increase number, down decrease number, left
//     to move to left digit, right to move to right digit) (numbers wrap from 9->0 and 0->9)
// Parameters:
//   x            - X position on LCD to start drawing (bottom left is 0,0)
//   y            - Y position on LCD to start drawing (bottom left is 0,0)
//   selected     - The current value should be selected (ie xor box drawn around it)
//   edit         - If true we should enter edit mode for this value
//   cursorPos    - Position of the cursor should be between 0 (0 is all the way to the right) and numChars (modified value is returned by reference)
//   eepromPos    - Location in the list of values stored in the eeprom
//   maxDigit     - Max most significant digit (useful for time where you only want to allow 59 seconds)
//   numChars     - Number of chars in this number (special case of 5 means 4+1 decimal place; 6 means 5+1 decimal place; 99 means 2+1 decimal place;)
// Returns:
//   Last button pressed which caused us to exit this function
////////////////////////////////////////
byte lcdSetNumber(byte x, byte y, boolean selected, boolean edit, byte *cursorPos, byte eepromPos, byte maxDigit, byte numChars)
{
  int val = g_eepromShadow[eepromPos];
  unsigned int bcdVal = decimalToBcd(val);
  byte button;
  byte adjNumChars = (numChars == 99) ? 4 : numChars;
  const unsigned int bcdClearMask[4] = {0xFFF0, 0xFF0F, 0xF0FF, 0x0FFF};
  
  if (!selected)
  {
    lcdPrintZeros(x, y, bcdVal, numChars);
    return BUTTON_NONE;
  }

  *cursorPos = min(*cursorPos, adjNumChars-1); // Clamp cursor position

  button = detectButtonPress(true);

  if (edit)
  {
    switch (button)
    {
      case BUTTON_NONE:
      case BUTTON_MENU:
      case BUTTON_SELECT:
      case BUTTON_ACTIVATE:
          break;  // Do nothing
      case BUTTON_UP:
      case BUTTON_DOWN:
        {
          unsigned int tempBcd = bcdVal;
          byte adjCursorPos;  
          
          if (((numChars == 5)||(numChars == 6)||(numChars==99)) && *cursorPos > 1)  // special - adjusts for decimal point
            adjCursorPos = (*cursorPos-1);
          else
            adjCursorPos = *cursorPos;

          tempBcd = (tempBcd >> (adjCursorPos*4)) & 0xF;  // Isolate single digit in BCD number that is changing

          if (button == BUTTON_UP)
          {
            if ((tempBcd == maxDigit) && (*cursorPos == numChars-1))
              tempBcd = 0;
            else if (tempBcd == 9)
              tempBcd = 0;
            else
              ++tempBcd;
          }
          else // BUTTON_DOWN
          {
            if ((tempBcd == 0) && (*cursorPos == numChars-1))
              tempBcd = maxDigit;
            else if (tempBcd == 0)
              tempBcd = 9;
            else
              --tempBcd;
          }

          bcdVal = (bcdVal & bcdClearMask[adjCursorPos]) | (tempBcd << (adjCursorPos*4));  // Mask out BCD character changing and replace with new
          val = bcdToDecimal(bcdVal);
          g_eepromShadow[eepromPos] = val;
          eepromWriteInt(eepromPos, val);
       }
        break;
      case BUTTON_LEFT:
        {
          *cursorPos = (*cursorPos + 1) % adjNumChars;
          if (((numChars == 5) || (numChars == 6) || (numChars == 99)) && (*cursorPos == 1))  // special - adjusts for decimal point
            ++(*cursorPos);
        }
        break;
      case BUTTON_RIGHT:
        {
          if (*cursorPos == 0)
            *cursorPos = adjNumChars-1;
          else
            --(*cursorPos);

          if (((numChars == 5) || (numChars == 6) || (numChars == 99)) && (*cursorPos == 1))  // special - adjusts for decimal point
            --(*cursorPos);
        }
        break;
    }
  }

  lcdPrintZeros(x, y, bcdVal, numChars);
  
  // Invert a box around this number box
  g_dogm.xorBox(x, y, x+g_dogm.charWidth*adjNumChars-1, y+g_dogm.charHeight-1);
  
  // Flip the selected char again
  if (edit && (millis()%800) < 400 ) // Blink every 800 ms
  {
    byte xBlink = x + (adjNumChars - (*cursorPos) - 1) * g_dogm.charWidth;
    g_dogm.xorBox(xBlink, y, xBlink+g_dogm.charWidth-1, y+g_dogm.charHeight-1);
  }

  return button;
}

////////////////////////////////////////
// Function: lcdPrintZeros - Prints a number to the LCD and fills in empty digits with zeros
// Parameters:
//   x            - X position on LCD to start drawing (bottom left is 0,0)
//   y            - Y position on LCD to start drawing (bottom left is 0,0)
//   bcdVal       - The value being displayed, it must be passed in as a BCD (binary coded decimal)
//   numDigits    - Number of digits being printed (4 is the max) (ex:: bcdVal-45 and numDigit-3 would print 045)
// Returns:
//   None
////////////////////////////////////////
void lcdPrintZeros(byte x, byte y, unsigned int bcdVal, byte numDigits)
{
  byte i;
  unsigned int tempBcd;
  boolean insertDecimal0 = false;
  boolean insertDecimal1 = false;
  boolean insertDecimal2 = false;
  
  if (numDigits == 5)
  {
    numDigits = 4;
    insertDecimal0 = true;
  }
  else if (numDigits == 6)
  {
    numDigits = 5;
    insertDecimal1 = true;
  }
  else if (numDigits == 99)
  {
    numDigits = 3;
    insertDecimal2 = true;
  }

  g_dogm.setXY(x,y);

  for(i=0; i<numDigits; ++i)
  {
    tempBcd = bcdVal >> (numDigits-1-i)*4;
    g_dogm.print(tempBcd & 0xF);
    
    if (insertDecimal0 && i==2)
      g_dogm.print(".");
    else if (insertDecimal1 && i==3)
      g_dogm.print(".");
    else if (insertDecimal2 && i==1)
      g_dogm.print(".");
  }
}

////////////////////////////////////////
// Function: detectButtonPress - Figures out which button was pressed and does ss debounce
// Parameters:
//   None
// Returns:
//   The button that was pressed
//
// DETAILED DESCRIPTION BELOW
//
// To allow multiple buttons to work off a single pin the Camera Axe attaches
// 6 buttons with some resistors in this configuration.
//           1K       1K        1K        1K        1K        1K
//  5V____/\/\/\____/\/\/\____/\/\/\____/\/\/\____/\/\/\____/\/\/\____GND
//                |         |         |         |         |         |
//                |         |         |         |         |         |
//              \         \         \         \         \         \
//               \         \         \         \         \         \
//                |         |         |         |         |         |
//                |         |         |         |         |         |
// BUTTONS_PIN-------------------------------------------------------
//
// During init we set the button pin using a 20K internal pullup resistor
// in the microcontroller so ths signal isn't floating when no buttons are
// pressed.  Using some simple parallel/serial resistor and voltage
// divider equations I get get these ideal values:
//
// No button pressed:    5.0000 V  =  1023  [range          >941]
// Menu button pressed:  4.2000 V  =  859   [range <=941 && >781]
// Set button pressed:   3.4375 V  =  703   [range <=781 && >625]
// Up button pressed:    2.6744 V  =  547   [range <=625 && >465]
// Down button pressed:  1.8750 V  =  384   [range <=465 && >205]
// Left button pressed:  1.0000 V  =  205   [range <=205 && >102]
// Right button pressed: 0.0000 V  =  0     [range <=102        ]
//
////////////////////////////////////////
byte detectButtonPress(boolean waitForRelease)
{
  int buttonVal;
  buttonVal = analogRead(BUTTONS_APIN);
  byte button;

  if (analogRead(BUTTONS_APIN) <= 941)
    delay(1);

  if (buttonVal > 941)
    button = BUTTON_NONE;
  else if (buttonVal <= 941 && buttonVal > 781)
    button = BUTTON_MENU;
  else if (buttonVal <= 781 && buttonVal > 625)
    button = BUTTON_SELECT;
  else if (buttonVal <= 625 && buttonVal > 465)
    button = BUTTON_UP;
  else if (buttonVal <= 465 && buttonVal > 205)
    button = BUTTON_DOWN;
  else if (buttonVal <= 205 && buttonVal > 102)
    button = BUTTON_LEFT;
  else //if (buttonVal <= 102)
  button = BUTTON_RIGHT;

  if (digitalRead(BUTTON_ACTIVATE_PIN) == LOW)
    button = BUTTON_ACTIVATE;

  if ((button != BUTTON_NONE) && waitForRelease)
  {
    // Spin waiting for the button to be released
    while ( (analogRead(BUTTONS_APIN) <= 941 ) || (digitalRead(BUTTON_ACTIVATE_PIN) == LOW) )
    {
      delay(1);
    }

    delay(1);  //debounce buttons
  }
  
  if ((button != BUTTON_NONE) && (g_eepromShadow[EEPROM_GENERAL_LCD_BACKLIGHT] == 2))
    g_backlightMs = millis() + 10000; // 10 seconds

  return button;
}

////////////////////////////////////////
// Function: decimalToBcd - Converts a decimal to a BCD (binary coded decimal)
// Parameters:
//   dec - The decimal number
// Returns:
//   The BCD number
////////////////////////////////////////
unsigned int decimalToBcd(unsigned int dec)
{
  unsigned int bcd = 0;
  unsigned int i = 0;

  while (dec)
  {
    bcd += ((dec % 10)<<i);   // Convert lowest-order number
    i += 4;
    dec /= 10;
  }

  return(bcd);
}

////////////////////////////////////////
// Function: bcdToDecimal - Converts a BCD (binary coded decimal) to a decimal
// Parameters:
//   bcd - The bcd number
// Returns:
//   The decimal number
////////////////////////////////////////
unsigned int bcdToDecimal(unsigned int bcd)
{
  unsigned int dec = 0;
  unsigned int i = 1;

  while(bcd)
  {
    dec += (bcd & 0xF)*i;
    i *= 10;
    bcd = bcd >> 4;
  }

  return(dec);
}

////////////////////////////////////////
// Function: eepromWriteInt -  Writes an integer (16 bits) to eeprom
// Parameters:
//   addr - The address in eeprom to write to
//   val  - The value being written
// Returns:
//   None
////////////////////////////////////////
void eepromWriteInt(int addr, int val)
{
  addr *= 2;  // int is 2 bytes
  EEPROM.write(addr+1, val&0xFF);
  val /= 256;
  EEPROM.write(addr+0, val&0xFF);
}

////////////////////////////////////////
// Function: eepromWriteInt -  Reads an integer (16 bits) from eeprom
// Parameters:
//   addr - The address in eeprom to read from
//   minVal  - Value being read clamps to this
//   maxVal  - Value being read clamps to this
// Returns:
//   The value being read from eeprom
////////////////////////////////////////
int eepromReadInt(int addr, int minVal, int maxVal)
{
  int val;

  addr *= 2;  // int is 2 bytes
  val = EEPROM.read(addr+0);
  val *= 256;
  val |= EEPROM.read(addr+1);
  val = constrain(val, minVal, maxVal);
  return val;
}

////////////////////////////////////////
// Function: menuProcessButton -  Most menus need to process certain buttons the same way, this handles that processing of button presses
// Parameters:
//   button - The byton press type
// Returns:
//   None
////////////////////////////////////////
void menuProcessButton(byte button)
{
  switch (button)
  {
    case BUTTON_NONE:
      break;  // Do nothing
    case BUTTON_MENU:
      {
        g_eepromShadow[EEPROM_ACTIVE_MENU] = (g_eepromShadow[EEPROM_ACTIVE_MENU]+1)%MENU_MAX_SIZE;
        eepromWriteInt(EEPROM_ACTIVE_MENU, g_eepromShadow[EEPROM_ACTIVE_MENU]);
        g_editVal = 0;
        g_menuPosition = 0;
        break;
      }
    case BUTTON_ACTIVATE:
      {
        g_menuMode = (g_menuMode == MENUMODE_MENU) ? MENUMODE_PHOTO : MENUMODE_MENU;
        g_editVal = 0;
        if ((g_menuMode == MENUMODE_PHOTO) && (g_eepromShadow[EEPROM_GENERAL_LCD_BACKLIGHT] == 2))
          lcdPower(LOW);
      }
      break;
    case BUTTON_SELECT:
      {
        g_editVal = !g_editVal;
        g_cursorPos = 4;
      }
      break;
  }
}

////////////////////////////////////////
// Function: nanoSec -  Returns the nanosecond count (similar to micro, but more precission and 4 times faster)
// Parameters:
//   None
// Returns:
//   Number of micros seconds in timer0
////////////////////////////////////////
extern volatile unsigned long timer0_overflow_count;
unsigned long nanoSec()
{
  return (((timer0_overflow_count << 8) + TCNT0)*500);
}

////////////////////////////////////////
// Function: resetTimer0 - Sets timer0 to 0
// Parameters:
//   None
// Returns:
//   None
////////////////////////////////////////
void resetTimer0()
{
  TCNT0 = 0;
  timer0_overflow_count = 0;
}

////////////////////////////////////////
// Function: startNanoSec - Call before nanoSec() - This forces timer0 scaling to 1
// Parameters:
//   None
// Returns:
//   None
////////////////////////////////////////
void startNanoSec()
{
  TCCR0B = 0x02;  // Force clock scaling to 1
}

////////////////////////////////////////
// Function: startNanoSec - Restores timer0 scaling to Arduino's 64 default (needed for all Arduino timing fucntions like delay, micro, milli,...)
// Parameters:
//   None
// Returns:
//   None
////////////////////////////////////////
void endNanoSec()
{
  TCCR0B = 0x03;  // Restore clock scaling to 64 (what Arduino expects)
}


