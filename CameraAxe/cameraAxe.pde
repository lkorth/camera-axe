
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Maurice Ribble (Copyright 2010, 2011)
// Camera Axe - http://www.cameraaxe.com
// Open Source, licensed under a Creative Commons Attribution-NonCommercial 3.0 License (http://creativecommons.org/licenses/by-nc/3.0/)
// Compiled with Arduino Software 0021 (http://arduino.cc)
//
// REVISIONS:
// 400  (10-03-2010) - Initial release (complete rewrite from 3.0 branch)
//
// 401  (11-21-2010) - Added Threshold to general menu
//                   - Added OR and AND of sensors to general menu
//                   - Added HDR stops to intervalometer menu
//                   - Added 10 second backlight mode to settings menu
//                   - Fixed bug in timelapse mode so it is more accurate
//                   - Disabled the internal pullup resistors for Sensor1 and Sensor2 (makes them work much better with some sensors)
//                   - General Menu now will retrigger if it gets a constant trigger signal
// 402 (1-29-2010    - Recoded intervalometer to work on timers rather than delicate polling loops (improved accuracy of timer in this mode)
//                   - Fixed but in intervalometer where shot after delay didn't count towards total shots
//                   - Increased duration between photos in intervalometer to 0.5 seconds since some cameras (Rebel) weren't working reliably with shorter times
//                   - Added a mirror lockup option to intervalometer
//                   - Updated source and display to use the "photo mode" instead of "trigger mode"
//                   - Fix bug where setting LCD backlight off wasn't correctly applied if you cycled the power
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// This code is the firmware for the CameraAxe4 which is a flash/camera trigger tool.  This hardware contains the following
// interfaces to the external world:
// A) 7 buttons to control a menu
// B) 1 LCD to display a menu (DOGM128 128x64)
// C) 2 3.5 mm jack for driving flashes or cameras (called devices in code)
// D) 2 3.5 mm jack to analog sensors (power to these ports can be enabled/disable via a transistor - over 100mA supported)
// E) 2 LEDs

#include <EEPROM.h>
#include <DogmCA.h>

#define __CAMERA_AXE_VERSION__ "4.0.2"

// Memory offsets into EEPROM (saves settings when power goes off)
#define EEPROM_ACTIVE_MENU                     0
#define EEPROM_DEVICE_TRIG_SENSOR1             1
#define EEPROM_DEVICE_TRIG_SENSOR2             2
#define EEPROM_DEVICE_DELAY1                   3
#define EEPROM_DEVICE_DELAY2                   4
#define EEPROM_DEVICE_CYCLE1                   5
#define EEPROM_DEVICE_CYCLE2                   6
#define EEPROM_DEVICE_PREFOCUS1                7
#define EEPROM_DEVICE_PREFOCUS2                8
#define EEPROM_SENSOR_LOW_HIGH_THRESH1         9
#define EEPROM_SENSOR_LOW_HIGH_THRESH2        10
#define EEPROM_SENSOR_TRIG_VAL1               11
#define EEPROM_SENSOR_TRIG_VAL2               12
#define EEPROM_SENSOR_POWER1                  13
#define EEPROM_SENSOR_POWER2                  14
#define EEPROM_PROJECTILE_SENSOR_DISTANCE     15
#define EEPROM_PROJECTILE_SENSOR_LOW_HIGH     16
#define EEPROM_PROJECTILE_INCH_CM             17
#define EEPROM_VALVE_DROP1_SIZE               18
#define EEPROM_VALVE_DROP2_DELAY              19
#define EEPROM_VALVE_DROP2_SIZE               20
#define EEPROM_VALVE_PHOTO_DELAY              21
#define EEPROM_INTERVALOMETER_DELAY_SEC       22
#define EEPROM_INTERVALOMETER_DELAY_MIN       23
#define EEPROM_INTERVALOMETER_DELAY_HOUR      24
#define EEPROM_INTERVALOMETER_SEC             25
#define EEPROM_INTERVALOMETER_MIN             26
#define EEPROM_INTERVALOMETER_HOUR            27
#define EEPROM_INTERVALOMETER_SHOTS           28
#define EEPROM_INTERVALOMETER_BULB            29
#define EEPROM_INTERVALOMETER_HDRSTOPS        30
#define EEPROM_INTERVALOMETER_MIRRORLOCKUP    31
#define EEPROM_FAST_DELAY                     32
#define EEPROM_FAST_LOW_HIGH                  33
#define EEPROM_GENERAL_LCD_BACKLIGHT          34
#define EEPROM_SIZE                           35

// global enums
enum { BUTTON_NONE, BUTTON_MENU, BUTTON_SELECT, BUTTON_UP, BUTTON_DOWN, BUTTON_LEFT, BUTTON_RIGHT, BUTTON_ACTIVATE};
enum { MENUMODE_MENU, MENUMODE_PHOTO};
enum { MENU_GENERAL_SENSOR, MENU_PROJECTILE, MENU_VALVE, MENU_INTERVALOMETER, MENU_FAST, MENU_GENERAL_SETTINGS, MENU_MAX_SIZE};  // Active menu

// Global Variables
DogmCA        g_dogm(getLcdPinA0());        // LCD class
int           g_eepromShadow[EEPROM_SIZE];  // Shadow copy of values stored in flash memory
volatile byte g_menuMode;                   // Tracks if you are in menu mode or photo mode
byte          g_cursorPos;                  // Cursor's current position while editing a number
boolean       g_editVal;                    // Editing mode or normal mode
byte          g_menuPosition;               // Position in the menu
unsigned long g_backlightMs;                // Time until backlight turns off;

////////////////////////////////////////
// Function: setup - This function gets run once during startup
// Parameters:
//   None
// Returns:
//   None
////////////////////////////////////////
void setup()
{
  //Serial.begin(9600); // open hw serial for debugging

  g_menuMode          = MENUMODE_MENU;
  g_cursorPos         = 0;
  g_editVal           = false;
  g_menuPosition      = 0;

  setupCameraAxePins();
  g_dogm.setFont(font_5x8, 5, 8);

  // Holding activate button when turning on the Camera Axe forces a factory reset
  if (detectButtonPress(false) == BUTTON_ACTIVATE)
  {
    loadDefaultSettings();
  }

  loadShadowFromEeprom();

  if (g_eepromShadow[EEPROM_GENERAL_LCD_BACKLIGHT] == 0)
      lcdPower(LOW);
  
  if (g_eepromShadow[EEPROM_GENERAL_LCD_BACKLIGHT] == 2)
    g_backlightMs = millis() + 10000; // 10 seconds
  else
    g_backlightMs = 0xffffffff;
}

////////////////////////////////////////
// Function: loadDefaults - Loads the default values into the eeprom
// Parameters:
//   None
// Returns:
//   None
////////////////////////////////////////
void loadDefaultSettings()
{
  eepromWriteInt(EEPROM_ACTIVE_MENU, MENU_GENERAL_SENSOR);
  
  eepromWriteInt(EEPROM_DEVICE_TRIG_SENSOR1, 1);
  eepromWriteInt(EEPROM_DEVICE_TRIG_SENSOR2, 0);
  eepromWriteInt(EEPROM_DEVICE_DELAY1, 0);
  eepromWriteInt(EEPROM_DEVICE_DELAY2, 0);
  eepromWriteInt(EEPROM_DEVICE_CYCLE1, 2);
  eepromWriteInt(EEPROM_DEVICE_CYCLE2, 2);
  eepromWriteInt(EEPROM_DEVICE_PREFOCUS1, 0);
  eepromWriteInt(EEPROM_DEVICE_PREFOCUS2, 0);
  eepromWriteInt(EEPROM_SENSOR_LOW_HIGH_THRESH1, 1);
  eepromWriteInt(EEPROM_SENSOR_LOW_HIGH_THRESH2, 1);
  eepromWriteInt(EEPROM_SENSOR_TRIG_VAL1, 800);
  eepromWriteInt(EEPROM_SENSOR_TRIG_VAL2, 800);
  eepromWriteInt(EEPROM_SENSOR_POWER1, 0);
  eepromWriteInt(EEPROM_SENSOR_POWER2, 0);
  
  eepromWriteInt(EEPROM_PROJECTILE_SENSOR_DISTANCE, 60);
  eepromWriteInt(EEPROM_PROJECTILE_SENSOR_LOW_HIGH, 0);
  eepromWriteInt(EEPROM_PROJECTILE_INCH_CM, 0);
  
  eepromWriteInt(EEPROM_VALVE_DROP1_SIZE, 50);
  eepromWriteInt(EEPROM_VALVE_DROP2_DELAY, 0);
  eepromWriteInt(EEPROM_VALVE_DROP2_SIZE, 0);
  eepromWriteInt(EEPROM_VALVE_PHOTO_DELAY, 200);
  
  eepromWriteInt(EEPROM_INTERVALOMETER_DELAY_SEC, 0);
  eepromWriteInt(EEPROM_INTERVALOMETER_DELAY_MIN, 0);
  eepromWriteInt(EEPROM_INTERVALOMETER_DELAY_HOUR, 0);
  eepromWriteInt(EEPROM_INTERVALOMETER_SEC, 30);
  eepromWriteInt(EEPROM_INTERVALOMETER_MIN, 0);
  eepromWriteInt(EEPROM_INTERVALOMETER_HOUR, 0);
  eepromWriteInt(EEPROM_INTERVALOMETER_SHOTS, 0);
  eepromWriteInt(EEPROM_INTERVALOMETER_BULB, 10);
  eepromWriteInt(EEPROM_INTERVALOMETER_HDRSTOPS, 0);
  eepromWriteInt(EEPROM_INTERVALOMETER_MIRRORLOCKUP, 0);
  
  eepromWriteInt(EEPROM_FAST_DELAY, 0);
  eepromWriteInt(EEPROM_FAST_LOW_HIGH, 0);

  eepromWriteInt(EEPROM_GENERAL_LCD_BACKLIGHT, 1);

  g_dogm.start();
  do 
  {
    g_dogm.setXY(26, 41);
    g_dogm.print("Reset Successful");
    g_dogm.setXY(28, 32);
    g_dogm.print("Release buttons");
  } 
  while( g_dogm.next() );
  detectButtonPress(true);  // Waits for all buttons to be released
}

////////////////////////////////////////
// Function: loadShadowFromEeprom - Loads values from eeprom into shadow copy (shadow is in ram)
// Parameters:
//   None
// Returns:
//   None
////////////////////////////////////////
void loadShadowFromEeprom()
{
  g_eepromShadow[EEPROM_ACTIVE_MENU]                = eepromReadInt(EEPROM_ACTIVE_MENU, 0, MENU_MAX_SIZE-1);
  
  g_eepromShadow[EEPROM_DEVICE_TRIG_SENSOR1]         = eepromReadInt(EEPROM_DEVICE_TRIG_SENSOR1, 0, 4);
  g_eepromShadow[EEPROM_DEVICE_TRIG_SENSOR2]         = eepromReadInt(EEPROM_DEVICE_TRIG_SENSOR2, 0, 4);
  g_eepromShadow[EEPROM_DEVICE_DELAY1]               = eepromReadInt(EEPROM_DEVICE_DELAY1, 0, 9999);
  g_eepromShadow[EEPROM_DEVICE_DELAY2]               = eepromReadInt(EEPROM_DEVICE_DELAY2, 0, 9999);
  g_eepromShadow[EEPROM_DEVICE_CYCLE1]               = eepromReadInt(EEPROM_DEVICE_CYCLE1, 0, 99);
  g_eepromShadow[EEPROM_DEVICE_CYCLE2]               = eepromReadInt(EEPROM_DEVICE_CYCLE2, 0, 99);
  g_eepromShadow[EEPROM_DEVICE_PREFOCUS1]            = eepromReadInt(EEPROM_DEVICE_PREFOCUS1, 0, 1);
  g_eepromShadow[EEPROM_DEVICE_PREFOCUS2]            = eepromReadInt(EEPROM_DEVICE_PREFOCUS2, 0, 1);
  g_eepromShadow[EEPROM_SENSOR_LOW_HIGH_THRESH1]     = eepromReadInt(EEPROM_SENSOR_LOW_HIGH_THRESH1, 0, 2);
  g_eepromShadow[EEPROM_SENSOR_LOW_HIGH_THRESH2]     = eepromReadInt(EEPROM_SENSOR_LOW_HIGH_THRESH2, 0, 2);
  g_eepromShadow[EEPROM_SENSOR_TRIG_VAL1]            = eepromReadInt(EEPROM_SENSOR_TRIG_VAL1, 0, 999);
  g_eepromShadow[EEPROM_SENSOR_TRIG_VAL2]            = eepromReadInt(EEPROM_SENSOR_TRIG_VAL2, 0, 999);
  g_eepromShadow[EEPROM_SENSOR_POWER1]               = eepromReadInt(EEPROM_SENSOR_POWER1, 0, 2);
  g_eepromShadow[EEPROM_SENSOR_POWER2]               = eepromReadInt(EEPROM_SENSOR_POWER2, 0, 2);

  g_eepromShadow[EEPROM_PROJECTILE_SENSOR_DISTANCE]  = eepromReadInt(EEPROM_PROJECTILE_SENSOR_DISTANCE, 0, 999);
  g_eepromShadow[EEPROM_PROJECTILE_SENSOR_LOW_HIGH]  = eepromReadInt(EEPROM_PROJECTILE_SENSOR_LOW_HIGH, 0, 1);
  g_eepromShadow[EEPROM_PROJECTILE_INCH_CM]          = eepromReadInt(EEPROM_PROJECTILE_INCH_CM, 0, 1);

  g_eepromShadow[EEPROM_VALVE_DROP1_SIZE]            = eepromReadInt(EEPROM_VALVE_DROP1_SIZE, 0, 999);
  g_eepromShadow[EEPROM_VALVE_DROP2_DELAY]           = eepromReadInt(EEPROM_VALVE_DROP2_DELAY, 0, 999);
  g_eepromShadow[EEPROM_VALVE_DROP2_SIZE]            = eepromReadInt(EEPROM_VALVE_DROP2_SIZE, 0, 999);
  g_eepromShadow[EEPROM_VALVE_PHOTO_DELAY]           = eepromReadInt(EEPROM_VALVE_PHOTO_DELAY, 0, 999);

  g_eepromShadow[EEPROM_INTERVALOMETER_DELAY_SEC]    = eepromReadInt(EEPROM_INTERVALOMETER_DELAY_SEC, 0, 59);
  g_eepromShadow[EEPROM_INTERVALOMETER_DELAY_MIN]    = eepromReadInt(EEPROM_INTERVALOMETER_DELAY_MIN, 0, 59);
  g_eepromShadow[EEPROM_INTERVALOMETER_DELAY_HOUR]   = eepromReadInt(EEPROM_INTERVALOMETER_DELAY_HOUR, 0, 99);
  g_eepromShadow[EEPROM_INTERVALOMETER_SEC]          = eepromReadInt(EEPROM_INTERVALOMETER_SEC, 0, 59);
  g_eepromShadow[EEPROM_INTERVALOMETER_MIN]          = eepromReadInt(EEPROM_INTERVALOMETER_MIN, 0, 59);
  g_eepromShadow[EEPROM_INTERVALOMETER_HOUR]         = eepromReadInt(EEPROM_INTERVALOMETER_HOUR, 0, 99);
  g_eepromShadow[EEPROM_INTERVALOMETER_SHOTS]        = eepromReadInt(EEPROM_INTERVALOMETER_SHOTS, 0, 9999);
  g_eepromShadow[EEPROM_INTERVALOMETER_BULB]         = eepromReadInt(EEPROM_INTERVALOMETER_BULB, 0, 9999);
  g_eepromShadow[EEPROM_INTERVALOMETER_HDRSTOPS]     = eepromReadInt(EEPROM_INTERVALOMETER_HDRSTOPS, 0, 9);
  g_eepromShadow[EEPROM_INTERVALOMETER_MIRRORLOCKUP] = eepromReadInt(EEPROM_INTERVALOMETER_MIRRORLOCKUP, 0, 1);
  
  g_eepromShadow[EEPROM_FAST_DELAY]                  = eepromReadInt(EEPROM_FAST_DELAY, 0, 9999);
  g_eepromShadow[EEPROM_FAST_LOW_HIGH]               = eepromReadInt(EEPROM_FAST_LOW_HIGH, 0, 1);

  g_eepromShadow[EEPROM_GENERAL_LCD_BACKLIGHT]       = eepromReadInt(EEPROM_GENERAL_LCD_BACKLIGHT, 0, 2);
}

////////////////////////////////////////
// Function: loop - This function gets run in a continous loop
// Parameters:
//   None
// Returns:
//   None
////////////////////////////////////////
void loop()
{
  g_dogm.start();
  
  do 
  {
    if (g_menuMode == MENUMODE_MENU)
    {
      if (g_eepromShadow[EEPROM_GENERAL_LCD_BACKLIGHT] == 2)
      {
        if (millis() > g_backlightMs)
          lcdPower(LOW);
        else
          lcdPower(HIGH);
      }

      // Menus
      switch (g_eepromShadow[EEPROM_ACTIVE_MENU])
      {
        case MENU_GENERAL_SENSOR:
          sensorMenu();
          break;
        case MENU_PROJECTILE:
          projectileMenu();
          break;
        case MENU_VALVE:
          valveMenu();
          break;
        case MENU_INTERVALOMETER:
          intervalometerMenu();
          break;
        case MENU_FAST:
          fastTriggerMenu();
          break;
        case MENU_GENERAL_SETTINGS:
          generalSettingsMenu();
          break;
      }
    }
  } while( g_dogm.next() );
  
  if (g_menuMode == MENUMODE_PHOTO)
  {
    // Photo Mode Functions
    switch (g_eepromShadow[EEPROM_ACTIVE_MENU])
    {
      case MENU_GENERAL_SENSOR:
        sensorFunc();
        break;
      case MENU_PROJECTILE:
        projectileFunc();
        break;
      case MENU_VALVE:
        valveFunc();
        break;
      case MENU_INTERVALOMETER:
        intervalometerFunc();
        break;
      case MENU_FAST:
        fastTriggerFunc();
      case MENU_GENERAL_SETTINGS:
        // No photo mode for the settings menu
        g_menuMode = MENUMODE_MENU;
        break;
    }
  }
}


