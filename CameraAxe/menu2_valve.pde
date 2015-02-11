////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Maurice Ribble (Copyright 2010, 2011)
// Camera Axe - http://www.cameraaxe.com
// Open Source, licensed under a Creative Commons Attribution-NonCommercial 3.0 License (http://creativecommons.org/licenses/by-nc/3.0/)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// This sensor is times a solenoid valve opening to create one or two drops and take a picture.
// Device 1 is optionally attached to your camera (alternately you can trigger the camera manually with a long exposure)
// Here is the normal sequence 
//   Drop 1 is created
//   Wait and then create Drop 2
//   Wait and then trigger device 2 (flash)


////////////////////////////////////////
// Function: valveMenu - Handles menuing for the valve sensor
// Parameters:
//   None
// Returns:
//   None
////////////////////////////////////////
void valveMenu()
{
  byte button = BUTTON_NONE;

  // Draw constant words
  g_dogm.setXY(39, 56);
  g_dogm.print("Valve Menu");
  g_dogm.setXY(0, 46);
  g_dogm.print("Drop1 Size");
  g_dogm.setXY(0, 37);
  g_dogm.print("Drop2 Delay (ms)");
  g_dogm.setXY(0, 28);
  g_dogm.print("Drop2 Size");
  g_dogm.setXY(0, 19);
  g_dogm.print("Flash Delay (ms)");
  
  // Draw constant lines
  g_dogm.setVLine(105, 0, 54);
  g_dogm.setBox(0, 54, 127, 55);
  
  // Draw the changable values in this menu (only one can be selected at a time)
  button |= lcdSetNumber(107, 46, g_menuPosition==0, g_editVal, &g_cursorPos, EEPROM_VALVE_DROP1_SIZE, 9, 3);
  button |= lcdSetNumber(107, 37, g_menuPosition==1, g_editVal, &g_cursorPos, EEPROM_VALVE_DROP2_DELAY, 9, 3);
  button |= lcdSetNumber(107, 28, g_menuPosition==2, g_editVal, &g_cursorPos, EEPROM_VALVE_DROP2_SIZE, 9, 3);
  button |= lcdSetNumber(107, 19, g_menuPosition==3, g_editVal, &g_cursorPos, EEPROM_VALVE_PHOTO_DELAY, 9, 3);

  menuProcessButton(button);
  
  if (!g_editVal)
  {
    switch (button)
    {
      case BUTTON_UP:
        {
          if (g_menuPosition == 0)
            g_menuPosition = 3;
          else
            --g_menuPosition;
        }
        break;
      case BUTTON_DOWN:
        {
          if (g_menuPosition == 3)
            g_menuPosition = 0;
          else
            ++g_menuPosition;
        }
        break;
    }
  }  
}

////////////////////////////////////////
// Function: valveFunc - Handles triggering for valve menu
// Parameters:
//   None
// Returns:
//   None
////////////////////////////////////////
void valveFunc()
{
  g_dogm.start();
  do 
  {
    g_dogm.setXY(0, 56);
    g_dogm.print("     Valve Photo Mode");
    g_dogm.xorBox(0, 54, 127, 63);

    g_dogm.setXY(0, 36);
    g_dogm.print("       Valve Active");
  } 
  while( g_dogm.next() );

  setSensorMode(0, OUTPUT);
  setSensorMode(1, OUTPUT);
  setSensor(0, LOW);
  setSensor(1, LOW);

  // Trigger camera
  triggerDevicePins(0, HIGH, HIGH, HIGH);
  delay(100);

  // Create drop 1
  setSensor(0, HIGH);
  setSensor(1, HIGH);
  delay(g_eepromShadow[EEPROM_VALVE_DROP1_SIZE]);
  setSensor(0, LOW);
  setSensor(1, LOW);

  // Create drop 2
  delay(g_eepromShadow[EEPROM_VALVE_DROP2_DELAY]);
  setSensor(0, HIGH);
  setSensor(1, HIGH);
  delay(g_eepromShadow[EEPROM_VALVE_DROP2_SIZE]);
  setSensor(0, LOW);
  setSensor(1, LOW);
  delay(g_eepromShadow[EEPROM_VALVE_PHOTO_DELAY]);

  // Trigger flash
  triggerDevicePins(1, HIGH, HIGH, HIGH);
  delay(200);
  triggerDevicePins(1, LOW, LOW, LOW);

  setSensorMode(0, INPUT);
  setSensorMode(1, INPUT);

  // Turn camera off
  triggerDevicePins(0, LOW, LOW, LOW);

  g_menuMode = MENUMODE_MENU;  // Always return to menu in this mode
}

