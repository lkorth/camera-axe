////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Maurice Ribble (Copyright 2010, 2011)
// Camera Axe - http://www.cameraaxe.com
// Open Source, licensed under a Creative Commons Attribution-NonCommercial 3.0 License (http://creativecommons.org/licenses/by-nc/3.0/)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// This mode is meant to be used instead of the general menu when really fast triggers are needed.
// It is less flexible to ensure faster responce times, but for cases where you want a really responcive
// trigger you will need to live with the reduced functionality.

////////////////////////////////////////
// Function: projectileMenu - Main menu function for fast triggering
//
// Parameters:
//   None
// Returns:
//   None
////////////////////////////////////////
void fastTriggerMenu()
{
  byte button = BUTTON_NONE;
  const char *lowHighString[]   = {"Low ", "High"};
  
  // Draw constant words
  g_dogm.setXY(21, 56);
  g_dogm.print("Fast Trigger Menu");
  g_dogm.setXY(0, 46);
  g_dogm.print("Delay (ms)");
  g_dogm.setXY(0, 37);
  g_dogm.print("Low/High Trigger");
  g_dogm.setXY(34, 8);
  g_dogm.print("Use Sensor 1");
  
  // Draw constant lines
  g_dogm.setVLine(95, 0, 54);
  g_dogm.setBox(0, 54, 127, 55);
  
  // Draw the changable values in this menu (only one can be selected at a time)
  button |= lcdSetNumber(97, 46, g_menuPosition==0, g_editVal, &g_cursorPos, EEPROM_FAST_DELAY, 9, 5);
  button |= lcdSetString(97, 37, g_menuPosition==1, g_editVal, 2, 4, EEPROM_FAST_LOW_HIGH, lowHighString);

  menuProcessButton(button);
  
  if (!g_editVal)
  {
    switch (button)
    {
      case BUTTON_UP:
        {
          if (g_menuPosition == 0)
            g_menuPosition = 1;
          else
            --g_menuPosition;
        }
        break;
      case BUTTON_DOWN:
        {
          if (g_menuPosition == 1)
            g_menuPosition = 0;
          else
            ++g_menuPosition;
        }
        break;
    }
  }  
}

////////////////////////////////////////
// Function: fastTriggerFunc - Handles fast triggering
//
// Parameters:
//   None
// Returns:
//   None
////////////////////////////////////////
void fastTriggerFunc()
{
  byte lowHigh           = g_eepromShadow[EEPROM_FAST_LOW_HIGH];
  unsigned int fastDelay = g_eepromShadow[EEPROM_FAST_DELAY];
  unsigned int msDelay;
  unsigned int usDelay;

  lowHigh = (lowHigh == 0) ? LOW : HIGH;
  msDelay = fastDelay/10;
  usDelay = (fastDelay%10)*100;
  
  attachInterrupt(0, activeButtonISR, LOW);
  g_dogm.start();
  do 
  {
    g_dogm.setXY(25, 56);
    g_dogm.print("Fast Photo Mode");
    g_dogm.xorBox(0, 54, 127, 63);
    g_dogm.setXY(10, 0);
    g_dogm.print("Press Activate to Exit");
  } 
  while( g_dogm.next() );
  
  while (g_menuMode == MENUMODE_PHOTO)
  {
    if (readSensorDigitalFast(0) == lowHigh)
    {
      setSensorPower(0, LOW); // Turn off power to sensors
      setSensorPower(1, LOW);
  
      delay(msDelay);
      delayMicroseconds(usDelay);
      
      triggerDevicePins(0, HIGH, HIGH, HIGH);  // Trigger flash
      triggerDevicePins(1, HIGH, HIGH, HIGH);  // Trigger flash
      
      delay(1000); // Wait 1 second
      
      setSensorPower(0, HIGH);
      setSensorPower(1, HIGH);
      triggerDevicePins(0, LOW, LOW, LOW);
      triggerDevicePins(1, LOW, LOW, LOW);
    }
  }
      
  triggerDevicePins(0, LOW, LOW, LOW);
  triggerDevicePins(1, LOW, LOW, LOW);
  setSensorPower(0, HIGH);
  setSensorPower(1, HIGH);
  detectButtonPress(true); // Just using this to debounce buttons
}


