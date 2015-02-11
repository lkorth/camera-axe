////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Maurice Ribble (Copyright 2010, 2011)
// Camera Axe - http://www.cameraaxe.com
// Open Source, licensed under a Creative Commons Attribution-NonCommercial 3.0 License (http://creativecommons.org/licenses/by-nc/3.0/)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// This mode uses a special sensor that has two gate triggers that go high when triggered.  The gates are
// seperated by SENSOR_DISTANCE units.  This mode uses digital signals instead of analog to improve
// speed (analog reads on ATMEL 168 take 100 micro seconds).  The time taken to trigger these sensors lets
// me calculate the velocity of the projectile.  Then assuming constant velocity (ie this doesn't work for
// objects being acclerated by gravity) it can caculate how long to wait until impact with the target (user
// provided distance in inches or cm).


////////////////////////////////////////
// Function: projectileMenu - Main menu function for projectile sensor
//
// Parameters:
//   None
// Returns:
//   None
////////////////////////////////////////
void projectileMenu()
{
  byte button = BUTTON_NONE;
  const char *lowHighString[]   = {"Low ", "High"};
  const char *inchCmString[]    = {"Inch", "Cm  "};
  
  // Draw constant words
  g_dogm.setXY(26, 56);
  g_dogm.print("Projectile Menu");
  g_dogm.setXY(0, 46);
  g_dogm.print("Distance");
  g_dogm.setXY(0, 37);
  g_dogm.print("Low/High Trigger");
  g_dogm.setXY(0, 28);
  g_dogm.print("Distance Units");
  
  // Draw constant lines
  g_dogm.setVLine(95, 0, 54);
  g_dogm.setBox(0, 54, 127, 55);
  
  // Draw the changable values in this menu (only one can be selected at a time)
  button |= lcdSetNumber(97, 46, g_menuPosition==0, g_editVal, &g_cursorPos, EEPROM_PROJECTILE_SENSOR_DISTANCE, 9, 99);
  button |= lcdSetString(97, 37, g_menuPosition==1, g_editVal, 2, 4, EEPROM_PROJECTILE_SENSOR_LOW_HIGH, lowHighString);
  button |= lcdSetString(97, 28, g_menuPosition==2, g_editVal, 2, 4, EEPROM_PROJECTILE_INCH_CM, inchCmString);
  menuProcessButton(button);
  
  if (!g_editVal)
  {
    switch (button)
    {
      case BUTTON_UP:
        {
          if (g_menuPosition == 0)
            g_menuPosition = 2;
          else
            --g_menuPosition;
        }
        break;
      case BUTTON_DOWN:
        {
          if (g_menuPosition == 2)
            g_menuPosition = 0;
          else
            ++g_menuPosition;
        }
        break;
    }
  }  
}

////////////////////////////////////////
// Function: projectileFunc - Handles projectile triggering
//
// Parameters:
//   None
// Returns:
//   None
////////////////////////////////////////
void projectileFunc()
{
  int i;
  int targetDistance = g_eepromShadow[EEPROM_PROJECTILE_SENSOR_DISTANCE];
  byte lowHigh       = g_eepromShadow[EEPROM_PROJECTILE_SENSOR_LOW_HIGH];
  byte inchCm        = g_eepromShadow[EEPROM_PROJECTILE_INCH_CM];
  unsigned long int distanceBetweenSensors;
  
  attachInterrupt(0, activeButtonISR, LOW);
  
  helpProjectileLCD(inchCm, 0, false);
  
  lowHigh = (lowHigh == 0) ? LOW : HIGH;
  
  if (inchCm == 0)
    distanceBetweenSensors = 200;  // Distance between sensors is 2.00 inches
  else
    distanceBetweenSensors = 508;  // Distance between sensors is 2.00 inches (or 5.08 cm)

  startNanoSec();
  
  while(g_menuMode == MENUMODE_PHOTO)
  {
    unsigned long startTime;
    unsigned long endTime;
    unsigned long impactTime;

    if (readSensorDigitalFast(0) == lowHigh)  // If sensor1 detects projectile
      {
      startTime =  nanoSec();

      // Look for sensor2 to detect projectile
      do {
        endTime = nanoSec();
        if (endTime - startTime > 1000000000)  // If we have waited 1 second and there has not been a detection projectile must have missed second sensor
        {
          helpProjectileLCD(inchCm, 0, true);
          endNanoSec();
          delay(5000);
          startNanoSec();
          helpProjectileLCD(inchCm, 0, false);
          endTime = 0;
          break;
        }
      } while(readSensorDigitalFast(1) != lowHigh);
      
      if (endTime)
      {
        unsigned long int elapsedTime;
        unsigned long int hundredthInchCmPerSec;
        unsigned long int impactTime;
        unsigned long int curTime;

        resetTimer0();
        
        elapsedTime             = (endTime - startTime);// ? (endTime - startTime) : 1;
        hundredthInchCmPerSec   = (distanceBetweenSensors*1000000)/(elapsedTime/1000);
        impactTime              = (1000000000/hundredthInchCmPerSec)*10*targetDistance;  // If changing be careful about overflowing int32
        
        while (nanoSec() < impactTime)  // Wait for impact
        {}
                
        //trigger flash
        triggerDevicePins(0, HIGH, HIGH, HIGH);
        triggerDevicePins(1, HIGH, HIGH, HIGH);
        
        // Display how fast the projectile was moving
        helpProjectileLCD(inchCm, hundredthInchCmPerSec/100, false);
        endNanoSec();
        delay(1000);
        startNanoSec();

        // Turn off flash
        triggerDevicePins(0, LOW, LOW, LOW);
        triggerDevicePins(1, LOW, LOW, LOW);
      }
    }
  }

  endNanoSec();
  triggerDevicePins(0, LOW, LOW, LOW);
  triggerDevicePins(1, LOW, LOW, LOW);
  detectButtonPress(true); // Just using this to debounce buttons
}


////////////////////////////////////////
// Function: helpProjectileLCD - Prints lcd menu to LCD
//
// Parameters:
//   inchCm        - 0=inches and 1=centimeters
//   inchCmPerSec  - The number of inches or centimeters traveled per second
//   sensorFailure - false= no failure, true=failure
// Returns:
//   None
////////////////////////////////////////
void helpProjectileLCD(byte inchCm, unsigned long int inchCmPerSec, boolean sensorFailure)
{
  boolean biggerUnits = false;
  
  if (!inchCm && inchCmPerSec >= 48)
  {
    inchCmPerSec /= 12;
    biggerUnits = true;
  }
  else if (inchCm && inchCmPerSec >= 400)
  {
    inchCmPerSec /= 100;
    biggerUnits = true;
  }
  
  g_dogm.start();
  do 
  {
    g_dogm.setXY(12, 56);
    g_dogm.print("Projectile Photo Mode");
    g_dogm.xorBox(0, 54, 127, 63);
    
    g_dogm.setXY(0, 36);
    if (sensorFailure)
      g_dogm.print(" Sensor2 did not trigger ");
    else
      g_dogm.print("  Ready for projectile!  ");

    if (inchCmPerSec)
    {
      g_dogm.setXY(0, 20);
  
      if (!inchCm)
      {
        if (biggerUnits)
          g_dogm.print("Feet");
        else
          g_dogm.print("Inches");
      }
      else
      {
        if (biggerUnits)
          g_dogm.print("Meters");
        else
          g_dogm.print("Centimeters");
      }
      g_dogm.print("/sec: ");
      g_dogm.print(inchCmPerSec);
    }
    
    g_dogm.setXY(10, 0);
    g_dogm.print("Press Activate to Exit");
  } 
  while( g_dogm.next() );
}

