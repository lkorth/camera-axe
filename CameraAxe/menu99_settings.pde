////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Maurice Ribble (Copyright 2010, 2011)
// Camera Axe - http://www.cameraaxe.com
// Open Source, licensed under a Creative Commons Attribution-NonCommercial 3.0 License (http://creativecommons.org/licenses/by-nc/3.0/)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////
// Function: generalSettingsMenu - Handles menuing for general settings
// Parameters:
//   None
// Returns:
//   None
////////////////////////////////////////
void generalSettingsMenu()
{
  byte button = BUTTON_NONE;
  const char *g_backlightString[] = {"Off   ", "On    ", "10 sec"};

  // Draw constant words
  g_dogm.setXY(16, 56);
  g_dogm.print("General Settings");
  g_dogm.setXY(0, 46);
  g_dogm.print("Backlight");
  
  g_dogm.setXY(0, 0);
  g_dogm.print("Version: ");  
  g_dogm.print(__CAMERA_AXE_VERSION__);
  
  // Draw constant lines
  g_dogm.setVLine(81, 19, 54);
  g_dogm.setBox(0, 54, 127, 55);
  
  // Draw the changable values in this menu (only one can be selected at a time)
  button |= lcdSetString(83, 46, g_menuPosition==0, g_editVal, 3, 6, EEPROM_GENERAL_LCD_BACKLIGHT, g_backlightString);
  
  switch (g_eepromShadow[EEPROM_GENERAL_LCD_BACKLIGHT])
  {
    case 0:
      lcdPower(LOW);
      break;
    case 1:
      lcdPower(HIGH);
      break;
  }

  menuProcessButton(button);
}

