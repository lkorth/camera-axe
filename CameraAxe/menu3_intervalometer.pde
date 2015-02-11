////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Maurice Ribble (Copyright 2010, 2011)
// Camera Axe - http://www.cameraaxe.com
// Open Source, licensed under a Creative Commons Attribution-NonCommercial 3.0 License (http://creativecommons.org/licenses/by-nc/3.0/)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////
// Function: intervalometerMenu - Handles menuing for the intervalometer
// Parameters:
//   None
// Returns:
//   None
////////////////////////////////////////
void intervalometerMenu()
{
  const char *noYesString[]      = {"No ", "Yes"};
  byte button = BUTTON_NONE;

  // Draw constant words
  g_dogm.setXY(16, 56);
  g_dogm.print("Intervalometer Menu");
  g_dogm.setXY(0, 46);
  g_dogm.print("Start Delay");
  g_dogm.setXY(87, 46);
  g_dogm.print("  :  :");
  g_dogm.setXY(0, 37);
  g_dogm.print("Interval");
  g_dogm.setXY(87, 37);
  g_dogm.print("  :  :");
  g_dogm.setXY(0, 28);
  g_dogm.print("# Shots (0=Inf)");
  g_dogm.setXY(0, 19);
  g_dogm.print("Bulb (sec)");
  g_dogm.setXY(0, 10);
  g_dogm.print("HDR Stops");
  g_dogm.setXY(0, 1);
  g_dogm.print("Mirror Lockup");
  
  
  // Draw constant lines
  g_dogm.setVLine(85, 0, 54);
  g_dogm.setBox(0, 54, 127, 55);
  
  // Draw the changable values in this menu (only one can be selected at a time)
  button |= lcdSetNumber(87, 46, g_menuPosition==0, g_editVal, &g_cursorPos, EEPROM_INTERVALOMETER_DELAY_HOUR, 9, 2);
  button |= lcdSetNumber(102, 46, g_menuPosition==1, g_editVal, &g_cursorPos, EEPROM_INTERVALOMETER_DELAY_MIN, 5, 2);
  button |= lcdSetNumber(117,  46, g_menuPosition==2, g_editVal, &g_cursorPos, EEPROM_INTERVALOMETER_DELAY_SEC, 5, 2);
  button |= lcdSetNumber(87, 37, g_menuPosition==3, g_editVal, &g_cursorPos, EEPROM_INTERVALOMETER_HOUR, 9, 2);
  button |= lcdSetNumber(102, 37, g_menuPosition==4, g_editVal, &g_cursorPos, EEPROM_INTERVALOMETER_MIN, 5, 2);
  button |= lcdSetNumber(117,  37, g_menuPosition==5, g_editVal, &g_cursorPos, EEPROM_INTERVALOMETER_SEC, 5, 2);
  button |= lcdSetNumber(87, 28, g_menuPosition==6, g_editVal, &g_cursorPos, EEPROM_INTERVALOMETER_SHOTS, 9, 4);
  button |= lcdSetNumber(87, 19, g_menuPosition==7, g_editVal, &g_cursorPos, EEPROM_INTERVALOMETER_BULB, 9, 5);
  button |= lcdSetNumber(87, 10, g_menuPosition==8, g_editVal, &g_cursorPos, EEPROM_INTERVALOMETER_HDRSTOPS, 9, 1);
  button |= lcdSetString(87, 1, g_menuPosition==9, g_editVal, 2, 3, EEPROM_INTERVALOMETER_MIRRORLOCKUP, noYesString);

  menuProcessButton(button);
  
  if (!g_editVal)
  {
    switch (button)
    {
      case BUTTON_UP:
        {
          if (g_menuPosition <= 2)
            g_menuPosition = 9;
          else if (g_menuPosition <=6)
            g_menuPosition = max(0, g_menuPosition-3);
          else
            --g_menuPosition;
        }
        break;
      case BUTTON_DOWN:
        {
          if (g_menuPosition == 9)
            g_menuPosition = 0;
          else if (g_menuPosition <= 4)
            g_menuPosition = min(6, g_menuPosition+3);
          else
            ++g_menuPosition;
        }
        break;
      case BUTTON_LEFT:
        {
          if (g_menuPosition == 0)
            g_menuPosition = 2;
          else if (g_menuPosition <= 2)
            --g_menuPosition;
          else if (g_menuPosition == 3)
            g_menuPosition = 5;
          else if (g_menuPosition <= 5)
            --g_menuPosition;
        }
        break;
      case BUTTON_RIGHT:
        {
          if (g_menuPosition == 2)
            g_menuPosition = 0;
          else if (g_menuPosition <= 1)
            ++g_menuPosition;
          else if (g_menuPosition == 5)
            g_menuPosition = 3;
          else if (g_menuPosition <= 4)
            ++g_menuPosition;
        }
        break;
    }
  }  
}

////////////////////////////////////////
// Function: helpDrawIntervalometer - Draws intervalometer menu to LCD
// Parameters:
//   delayHours   - Number of hours before we start taking shots
//   delayMinutes - Number of minutes before we start taking shots
//   delaySeconds - Number of seconds before we start taking shots
//   hours        - Number of hours between shots
//   minutes      - Number of minutes between shots
//   seconds      - Number of seconds between shots
//   shots        - Number of shots
//   bulb         - Time in seconds for exposure
//   hdrStops     - Number of bracketed stops for HDR images
// Returns:
//   None
////////////////////////////////////////
void helpDrawIntervalometer(int delayHours, int delayMinutes, int delaySeconds, int hours, int minutes, int seconds, int shots, int bulb, int hdrStops)
{
  g_dogm.start();
  do 
  {
    g_dogm.setXY(2, 56);
    g_dogm.print("Intervalometer Photo Mode");
    g_dogm.xorBox(0, 54, 127, 63);

    // Draw constant words
    g_dogm.setXY(0, 46);
    g_dogm.print("Start Delay");
    g_dogm.setXY(87, 46);
    g_dogm.print("  :  :");
    g_dogm.setXY(0, 37);
    g_dogm.print("Interval");
    g_dogm.setXY(87, 37);
    g_dogm.print("  :  :");
    g_dogm.setXY(0, 28);
    g_dogm.print("# Shots (0=Inf)");
    g_dogm.setXY(0, 19);
    g_dogm.print("Bulb (sec)");
    g_dogm.setXY(0, 10);
    g_dogm.print("HDR Stops");

    // Draw constant lines
    g_dogm.setVLine(85, 10, 54);
    g_dogm.setBox(0, 54, 127, 55);

    // Draw the changable values in this menu (only one can be selected at a time)
    lcdPrintZeros(87, 46, decimalToBcd(delayHours), 2);
    lcdPrintZeros(102, 46, decimalToBcd(delayMinutes), 2);
    lcdPrintZeros(117, 46, decimalToBcd(delaySeconds), 2);
    lcdPrintZeros(87, 37, decimalToBcd(hours), 2);
    lcdPrintZeros(102, 37, decimalToBcd(minutes), 2);
    lcdPrintZeros(117, 37, decimalToBcd(seconds), 2);
    lcdPrintZeros(87, 28, decimalToBcd(shots), 4);
    lcdPrintZeros(87, 19, decimalToBcd(bulb), 5);
    lcdPrintZeros(87, 10, decimalToBcd(hdrStops), 1);

    g_dogm.setXY(10, 0);
    g_dogm.print("Press Activate to Exit");
  } 
  while( g_dogm.next() );
}

////////////////////////////////////////
// Function: intervalometerFunc - Handles triggering for intervalometer
// Parameters:
//   None
// Returns:
//   None
////////////////////////////////////////
void intervalometerFunc()
{
  int delayHours          = g_eepromShadow[EEPROM_INTERVALOMETER_DELAY_HOUR];
  int delayMinutes        = g_eepromShadow[EEPROM_INTERVALOMETER_DELAY_MIN];
  int delaySeconds        = g_eepromShadow[EEPROM_INTERVALOMETER_DELAY_SEC];
  int hours               = g_eepromShadow[EEPROM_INTERVALOMETER_HOUR];
  int minutes             = g_eepromShadow[EEPROM_INTERVALOMETER_MIN];
  int seconds             = g_eepromShadow[EEPROM_INTERVALOMETER_SEC];
  int shots               = g_eepromShadow[EEPROM_INTERVALOMETER_SHOTS];
  int bulb                = g_eepromShadow[EEPROM_INTERVALOMETER_BULB];
  int hdrStops            = g_eepromShadow[EEPROM_INTERVALOMETER_HDRSTOPS];
  byte mirrorLockup       = g_eepromShadow[EEPROM_INTERVALOMETER_MIRRORLOCKUP];
  byte startingDelay      = ((delayHours != 0) || (delayMinutes != 0) || (delaySeconds != 0)) ? 1 : 0;
  byte tHdrShots          = 0;
  byte triggering         = 0;
  byte firstPass          = 1;
  unsigned long timer     = millis();
  unsigned long offTimer  = 0;
  unsigned long offLockup = 0;

  attachInterrupt(0, activeButtonISR, LOW);
  helpDrawIntervalometer(delayHours, delayMinutes, delaySeconds, hours, minutes, seconds, shots, bulb, hdrStops);
 
  while(g_menuMode == MENUMODE_PHOTO)
  {
    unsigned long msTillOff;
   
    while ((millis() < timer) && (g_menuMode == MENUMODE_PHOTO))  // This is the wait loop
    {
      if (offLockup && (millis() >= offLockup))
      {
        msTillOff = (bulb << tHdrShots)*100;
        offLockup = 0;
        
        triggerDevicePins(0, LOW, LOW, LOW);
        triggerDevicePins(1, LOW, LOW, LOW);
        delay(500);  // 0.5 second - Second part of mirror lockup for total of 2 seconds

        triggerDevicePins(0, HIGH, HIGH, HIGH);
        triggerDevicePins(1, HIGH, HIGH, HIGH);
        offTimer = millis() + msTillOff;
      }
      
      if (!offLockup && offTimer && (millis() >= offTimer))  // Handles turning off camera
      {
        int forceDelay = 0;
        
        if ((offTimer >= timer) || ((timer-offTimer) < 500))  // Handle case when bulb time goes past next internval time
          forceDelay = 500;
  
        offTimer = 0;
        ++tHdrShots;

        if (tHdrShots > hdrStops)  // Turn off trigger if all hdr shots taken (ie ready for next shot)
        {
          triggering = 0;
          if (shots == 1) // Exit when shots are done
            g_menuMode = MENUMODE_MENU;
        }

        triggerDevicePins(0, LOW, LOW, LOW);
        triggerDevicePins(1, LOW, LOW, LOW);
        delay(forceDelay);
      }
    }

    timer += 1000;

    if (startingDelay) // Start delay
    {
      if (firstPass == 0)
        delaySeconds--;
      else
        firstPass = 0;
      
      if ((delaySeconds == 0) && (delayMinutes == 0) && (delayHours == 0))
      {
        startingDelay = 0;
        triggering = 1;
      }
      else if ((delaySeconds == -1) && (delayMinutes == 0))
      {
        delaySeconds = 59;
        delayMinutes = 59;
        delayHours--;
      }
      else if (delaySeconds == -1)
      {
        delaySeconds = 59;
        delayMinutes--;
      }
    }
    else // Normal interval delay
    {
      if (firstPass == 0)
        seconds--;
      else
        firstPass = 0;

      if ((seconds == 0) && (minutes == 0) && (hours == 0))
      {
        triggering = 1;
      }
      else if ((seconds == -1) && (minutes == 0))
      {
        seconds = 59;
        minutes = 59;
        hours--;
      }
      else if (seconds == -1)
      {
        seconds = 59;
        minutes--;
      }
    }
    
    if (triggering && (offTimer == 0)) // Triggering
    {
      // trigger camera
      triggerDevicePins(0, HIGH, HIGH, HIGH);
      triggerDevicePins(1, HIGH, HIGH, HIGH);

      if ((seconds == 0) && (minutes == 0) && (hours == 0))
      {
        seconds = g_eepromShadow[EEPROM_INTERVALOMETER_SEC];
        minutes = g_eepromShadow[EEPROM_INTERVALOMETER_MIN];
        hours = g_eepromShadow[EEPROM_INTERVALOMETER_HOUR];
      }        

      if (tHdrShots > hdrStops)
      {
        shots = max (-1, shots-1); // Prevent shots from wrapping around
        tHdrShots = 0;
      }

      if (mirrorLockup)
      {
        offLockup = millis() + 1500; // 1.5 second mirror lockup time (another 0.5 seconds applied above for total 2 second)
        offTimer = offLockup;
      }
      else
      {
        msTillOff = (bulb << tHdrShots)*100;
        offTimer = millis() + msTillOff;
      }
    }

    if (hours < 0)
    {
      seconds = 0;
      minutes = 0;
      hours = 0;
      helpDrawIntervalometer(delayHours, delayMinutes, delaySeconds, hours, minutes, seconds, max(0, shots), bulb, hdrStops);
      seconds = 1;
    }
    else
      helpDrawIntervalometer(delayHours, delayMinutes, delaySeconds, hours, minutes, seconds, max(0, shots), bulb, hdrStops);
  }

  triggerDevicePins(0, LOW, LOW, LOW);
  triggerDevicePins(1, LOW, LOW, LOW);
  detectButtonPress(true); // Just using this to debounce buttons
}




