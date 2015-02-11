////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Maurice Ribble (Copyright 2010, 2011)
// Camera Axe - http://www.cameraaxe.com
// Open Source, licensed under a Creative Commons Attribution-NonCommercial 3.0 License (http://creativecommons.org/licenses/by-nc/3.0/)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////
// Function: flexibleSensorMenu - Handles menuing for the generic sensor/flash menu.  Lots of flexibility to combine
//   different uses of the two sensors and 2 devices.
// Parameters:
//   None
// Returns:
//   None
////////////////////////////////////////
void sensorMenu()
{
  byte button = BUTTON_NONE;
  byte yAdj;
  static int staticVal1a[2] = {0xFFFF,0xFFFF}; // Need bit 16 to be 1 or helpPrintCurSensorValue doesn't work correctly
  static int staticVal1b[2] = {0xFFFF,0xFFFF}; // Need bit 16 to be 1 or helpPrintCurSensorValue doesn't work correctly
  static int staticVal2a[2] = {0xFFFF,0xFFFF}; // Need bit 16 to be 1 or helpPrintCurSensorValue doesn't work correctly
  static int staticVal2b[2] = {0xFFFF,0xFFFF}; // Need bit 16 to be 1 or helpPrintCurSensorValue doesn't work correctly
  const char *noYesString[]      = {"No ", "Yes"};
  const char *sensorString[]     = {"None    ", "Sensor1 ", "Sensor2 ", "S1_or_S2", "S1_and_2"};
  const char *trigTypeString[]   = {"Low     ", "High    ", "Threshld" };
  const char *powerString[]      = {"On      ", "Off_Sen1", "Off_Sen2"};
  const char *camFlashString[]   = {"Normal   ", "Pre-focus"};
  
  if (g_menuPosition < 8)
    yAdj = 0;
  else if (g_menuPosition < 10)
    yAdj = 9;
  else if (g_menuPosition < 12)
    yAdj = 19;
  else
    yAdj = 27;

  g_dogm.setXY(16, 56+yAdj);
  g_dogm.print("General Sensor Menu");
  g_dogm.setBox(0, 54+yAdj, 127, 55+yAdj);

  // Draw constant words
  g_dogm.setXY(43, 46+yAdj);
  g_dogm.print("Device1  Device2");
  g_dogm.setXY(0, 37+yAdj);
  g_dogm.print("Trig Sen");
  g_dogm.setXY(0, 28+yAdj);
  g_dogm.print("Delay ms");
  g_dogm.setXY(0, 19+yAdj);
  g_dogm.print("Bulb sec");
  g_dogm.setXY(0, 10+yAdj);
  g_dogm.print("Prefocus");
  g_dogm.setXY(43, 0+yAdj);
  g_dogm.print("Sensor1  Sensor2");
  g_dogm.setXY(0, -9+yAdj);
  g_dogm.print("Trig Typ");
  g_dogm.setXY(0, -18+yAdj);
  g_dogm.print("Trig Val");
  g_dogm.setXY(0, -27+yAdj);
  g_dogm.print("Power");

  // Draw constant lines
  g_dogm.setVLine(41, 0, 53);
  g_dogm.setBox(42, 45+yAdj, 127, 45+yAdj);
  g_dogm.setBox(42, 8+yAdj, 127, 9+yAdj);
  g_dogm.setBox(42, 0+yAdj, 127, 0+yAdj);
  g_dogm.setBox(0, 45+yAdj, 40, 53+yAdj);
  g_dogm.setBox(0, 0+yAdj, 40, 9+yAdj);

  // Input current sensor values
  if ((g_eepromShadow[EEPROM_DEVICE_TRIG_SENSOR1] == 1) || (g_eepromShadow[EEPROM_DEVICE_TRIG_SENSOR2] == 1) ||
      (g_eepromShadow[EEPROM_DEVICE_TRIG_SENSOR1] >  2) || (g_eepromShadow[EEPROM_DEVICE_TRIG_SENSOR2] >  2))  // Only display if a device is using sensor1
    helpPrintCurSensorValue(58,  -18+yAdj, 0, g_eepromShadow[EEPROM_SENSOR_LOW_HIGH_THRESH1], staticVal1a, staticVal1b);
    
  if ((g_eepromShadow[EEPROM_DEVICE_TRIG_SENSOR1] >= 2) || (g_eepromShadow[EEPROM_DEVICE_TRIG_SENSOR2] >= 2))  // Only display if a device is using sensor2
    helpPrintCurSensorValue(103, -18+yAdj, 1, g_eepromShadow[EEPROM_SENSOR_LOW_HIGH_THRESH2], staticVal2a, staticVal2b);

  // Draw the changable values in this menu (only one can be selected at a time)
  button |= lcdSetString(43, 37+yAdj, g_menuPosition==0, g_editVal, 5, 8, EEPROM_DEVICE_TRIG_SENSOR1, sensorString);
  button |= lcdSetString(88, 37+yAdj, g_menuPosition==1, g_editVal, 5, 8, EEPROM_DEVICE_TRIG_SENSOR2, sensorString);

  button |= lcdSetNumber(43, 28+yAdj, g_menuPosition==2, g_editVal, &g_cursorPos, EEPROM_DEVICE_DELAY1, 9, 5);
  button |= lcdSetNumber(88, 28+yAdj, g_menuPosition==3, g_editVal, &g_cursorPos, EEPROM_DEVICE_DELAY2, 9, 5);

  button |= lcdSetNumber(43, 19+yAdj, g_menuPosition==4, g_editVal, &g_cursorPos, EEPROM_DEVICE_CYCLE1, 9, 2);
  button |= lcdSetNumber(88, 19+yAdj, g_menuPosition==5, g_editVal, &g_cursorPos, EEPROM_DEVICE_CYCLE2, 9, 2);

  button |= lcdSetString(43, 10+yAdj, g_menuPosition==6, g_editVal, 2, 3, EEPROM_DEVICE_PREFOCUS1, noYesString);
  button |= lcdSetString(88, 10+yAdj, g_menuPosition==7, g_editVal, 2, 3, EEPROM_DEVICE_PREFOCUS2, noYesString);
  
  button |= lcdSetString(43, -9+yAdj, g_menuPosition==8, g_editVal, 3, 8, EEPROM_SENSOR_LOW_HIGH_THRESH1, trigTypeString);
  button |= lcdSetString(88, -9+yAdj, g_menuPosition==9, g_editVal, 3, 8, EEPROM_SENSOR_LOW_HIGH_THRESH2, trigTypeString);

  button |= lcdSetNumber(43, -18+yAdj,  g_menuPosition==10, g_editVal, &g_cursorPos, EEPROM_SENSOR_TRIG_VAL1, 9, 3);
  button |= lcdSetNumber(88, -18+yAdj,  g_menuPosition==11, g_editVal, &g_cursorPos, EEPROM_SENSOR_TRIG_VAL2, 9, 3);
  
  button |= lcdSetString(43, -27+yAdj,  g_menuPosition==12, g_editVal, 3, 8, EEPROM_SENSOR_POWER1, powerString);
  button |= lcdSetString(88, -27+yAdj,  g_menuPosition==13, g_editVal, 3, 8, EEPROM_SENSOR_POWER2, powerString);

  menuProcessButton(button);
  
  if (!g_editVal)
  {
    switch (button)
    {
      case BUTTON_LEFT:
      case BUTTON_RIGHT:
        {
          if (g_menuPosition%2) // is odd
            --g_menuPosition;
          else                // is even
            ++g_menuPosition;
        }
        break;
      case BUTTON_UP:
        {
          if (g_menuPosition<=1)
            g_menuPosition += 12;
          else
            g_menuPosition -= 2;
        }
        break;
      case BUTTON_DOWN:
        {
          if (g_menuPosition>=12)
            g_menuPosition -= 12;
          else
            g_menuPosition += 2;
        }
        break;
    }
  }
}

////////////////////////////////////////
// Function: sensorFunc - Handles camera/flash triggering for the generic sensor/flash menu.  Since each device can be
//                        triggered by any sensor this function acts as a crossbar
// Parameters:
//   None
// Returns:
//   None
////////////////////////////////////////
void sensorFunc()
{
  unsigned long deviceDelayTimes[2] = {0,0};
  unsigned long deviceCycleTimes[2] = {0,0};
  int prevSensorVals[2] = {-1, -1};
  
  attachInterrupt(0, activeButtonISR, LOW);
  g_dogm.start();
  do 
  {
    g_dogm.setXY(19, 56);
    g_dogm.print("General Photo Mode");
    g_dogm.xorBox(0, 54, 127, 63);
    g_dogm.setXY(10, 0);
    g_dogm.print("Press Activate to Exit");
  } 
  while( g_dogm.next() );

  if (g_eepromShadow[EEPROM_DEVICE_PREFOCUS1])
     triggerDevicePins(0, HIGH, LOW, LOW);
  if (g_eepromShadow[EEPROM_DEVICE_PREFOCUS2])
     triggerDevicePins(1, HIGH, LOW, LOW);

  while (g_menuMode == MENUMODE_PHOTO)
  {
    unsigned long curTime = micros();  // micros() has a resolution of 4 microseconds
    int sensorVals[2] = {-1,-1};

    byte s;  // sensor number 0/1
    byte d;  // device number 0/1
    
    for(d=0; d<2; ++d)
    {
      for(s=0; s<2; ++s)
      {
        helpSensorDevicePass(curTime, s, d, deviceDelayTimes, deviceCycleTimes, sensorVals, prevSensorVals);
      }
    }
  }
  
  triggerDevicePins(0, LOW, LOW, LOW);
  triggerDevicePins(1, LOW, LOW, LOW);
  setSensorPower(0, HIGH);
  setSensorPower(1, HIGH);
  detectButtonPress(true); // Just using this to debounce buttons
}

////////////////////////////////////////
// Function: helpPrintCurSensorValue - This reads an analog pin and prints out the value to the LCD
// Parameters:
//   x            - X position on LCD to start drawing (bottom left is 0,0)
//   y            - Y position on LCD to start drawing (bottom left is 0,0)
//   sensor       - The analog sensor you want to read from
//   lowHighThres - 0 means track lowest values; 1 means track highest values; 2 means use threshold
//   valuesA      - An array of 2 values being updated. 2 values are needed so we can double buffer results.
//   valuesB      - Same as valuesA, but more storage needed for threshold
// Returns:
//   This updates the pass by reference "value" varible
////////////////////////////////////////
void helpPrintCurSensorValue(byte x, byte y, byte sensor, int lowHighThresh, int *valuesA, int *valuesB)
{
  int i;
  int sensorValMin;
  int sensorValMax;
  byte activeIndex, prevIndex;
  
  if ( (millis()%1000) < 500 )  // Update every 0.5 second
  {
    activeIndex = 0;
    prevIndex = 1;
  }
  else
  {
    activeIndex = 1;
    prevIndex = 0;
  }

  // This figures out the sensor value for a few quick checks
  sensorValMin = readSensorAnalog(sensor);
  sensorValMax = sensorValMin;
  for(i=0; i<5; ++i)
  {
    int tSensorVal = readSensorAnalog(sensor);
    sensorValMin = min(sensorValMin, tSensorVal);
    sensorValMax = max(sensorValMax, tSensorVal);
  }
  
  sensorValMin = min(sensorValMin, 999);  // Clamp to a max value of 999
  sensorValMax = min(sensorValMax, 999);
  
  // We use the msb of prevIndex to track whether we have rest the running total during
  // this half second period
  if (valuesA[activeIndex] & 0x8000)
  {
    valuesA[activeIndex] = sensorValMin;
    valuesA[prevIndex] = valuesA[prevIndex] | 0x8000;
    valuesB[activeIndex] = sensorValMax;
    valuesB[prevIndex] = valuesB[prevIndex] | 0x8000;
  }
  else
  {
    if (lowHighThresh == 0)
      valuesA[activeIndex] = min(sensorValMin,  valuesA[activeIndex]);
    else if (lowHighThresh == 1)
      valuesA[activeIndex] = max(sensorValMax,  valuesA[activeIndex]);
    else // (lowHighThresh == 2)
    {
      valuesA[activeIndex] = min(sensorValMin,  valuesA[activeIndex]);
      valuesB[activeIndex] = max(sensorValMin,  valuesB[activeIndex]);
    }
  }

  g_dogm.setXY(x, y);
  g_dogm.print("/");
  if ( lowHighThresh == 2)
  {
    g_dogm.print((valuesB[prevIndex] & 0x7fff)-(valuesA[prevIndex] & 0x7fff));
  }
  else
    g_dogm.print(valuesA[prevIndex] & 0x7fff);
}

////////////////////////////////////////
// Function: sensorDevicePass - This function does all the work and sensorFunc gets the credit (see sensorFunc)
// Parameters:
//   curTime          - The current time measured in microseconds
//   s                - Current sensor (either 0 or 1)
//   d                - Current device (either 0 or 1)
//   deviceDelayTimes - Returns the microsecond time when device delay expires (array of size 2)
//   deviceCycleTimes - Returns the microsecond time when device cycle expires (array of size 2)
//   sensorVals       - Returns the value measured by sensor (array of size 2)
// Returns:
//   See parameters: deviceDelayTimes, deviceCycleTimes, sensorVals
////////////////////////////////////////
inline static void helpSensorDevicePass(unsigned long curTime, byte s, byte d, unsigned long *deviceDelayTimes, unsigned long *deviceCycleTimes, int *sensorVals, int *prevSensorVals)
{
  byte i;
  boolean deviceOr  = (g_eepromShadow[EEPROM_DEVICE_TRIG_SENSOR1+d] == 3);
  boolean deviceAnd = (g_eepromShadow[EEPROM_DEVICE_TRIG_SENSOR1+d] == 4);
  
  // If DeviceX is using SensorX
  if ((s+1 == g_eepromShadow[EEPROM_DEVICE_TRIG_SENSOR1+d]) || deviceOr || deviceAnd)
  {
    if ( !deviceDelayTimes[d] && !deviceCycleTimes[d] ) // If not in delay or cycle
    {
      boolean t = false;
      if (deviceOr || deviceAnd)
      {
        if (s == 1)
          return;
          
        for(i=0; i<2; ++i)
        {
          if (sensorVals[i] == -1)
            sensorVals[i] = readSensorAnalog(i);
        }
      }
      else
      {  
        if (sensorVals[s] == -1)
          sensorVals[s] = readSensorAnalog(s);
      }

      // Preven threshold from instantly triggering on first try
      if (prevSensorVals[0] < 0)
        prevSensorVals[0] = sensorVals[0];
      if (prevSensorVals[1] < 0)
        prevSensorVals[1] = sensorVals[1];
      
      // Testing for (or), (and), (single active sensor)
      if (deviceOr || deviceAnd)
      {
        boolean te[2] = {false, false};
        
        for (i=0; i<2; ++i)
        {
          if (((g_eepromShadow[EEPROM_SENSOR_LOW_HIGH_THRESH1+i]==0) && (sensorVals[i] < g_eepromShadow[EEPROM_SENSOR_TRIG_VAL1+i])) ||                      // Trigger on low signal
              ((g_eepromShadow[EEPROM_SENSOR_LOW_HIGH_THRESH1+i]==1) && (sensorVals[i] > g_eepromShadow[EEPROM_SENSOR_TRIG_VAL1+i])) ||                      // Trigger on high signal
              ((g_eepromShadow[EEPROM_SENSOR_LOW_HIGH_THRESH1+i]==2) && (abs(sensorVals[i]-prevSensorVals[i]) > g_eepromShadow[EEPROM_SENSOR_TRIG_VAL1+i]))) // Trigger on threshold signal
          {
            te[i] = true;
          }
          
          //Serial.print((int)te[0]);  Serial.println((int)te[1]);
          //Serial.print(sensorVals[0]); Serial.print(" "); Serial.print(sensorVals[1]); Serial.print(" ");
          //Serial.print(prevSensorVals[0]); Serial.print(" "); Serial.print(prevSensorVals[1]); Serial.println(" ");
          if (te[0] && te[1])
            t = true;
          else if (deviceOr && (te[0] || te[1]))
            t = true;
        }
      }
      else if (((g_eepromShadow[EEPROM_SENSOR_LOW_HIGH_THRESH1+s]==0) && (sensorVals[s] < g_eepromShadow[EEPROM_SENSOR_TRIG_VAL1+s])) ||                     // Trigger on low signal
              ((g_eepromShadow[EEPROM_SENSOR_LOW_HIGH_THRESH1+s]==1) && (sensorVals[s] > g_eepromShadow[EEPROM_SENSOR_TRIG_VAL1+s])) ||                      // Trigger on high signal
              ((g_eepromShadow[EEPROM_SENSOR_LOW_HIGH_THRESH1+s]==2) && (abs(sensorVals[s]-prevSensorVals[s]) > g_eepromShadow[EEPROM_SENSOR_TRIG_VAL1+s]))) // Trigger on threshold signal
      {
        t = true;
      }
      
      if (t)
      {
        deviceDelayTimes[d] = (unsigned long)curTime + (unsigned long)g_eepromShadow[EEPROM_DEVICE_DELAY1+d]*(unsigned long)100;
        
        if (g_eepromShadow[EEPROM_SENSOR_POWER1] == d+1) // Off on sensor1
          setSensorPower(0, LOW);
        if (g_eepromShadow[EEPROM_SENSOR_POWER2] == d+1) // Off on sensor2
          setSensorPower(1, LOW);
      }
    }
    else 
    {
      // The third part of this check prevents bugs from a timer overflow
      if ( deviceDelayTimes[d] && (deviceDelayTimes[d] < curTime) && (curTime - deviceDelayTimes[d] < 1000000000) )
      {
         const unsigned long cycleTime = g_eepromShadow[EEPROM_DEVICE_CYCLE1+d]*1000000;
         
        triggerDevicePins(d, HIGH, HIGH, HIGH);
        deviceDelayTimes[d] = 0;
        deviceCycleTimes[d] = curTime + cycleTime;
      }
      else if ( deviceCycleTimes[d] && (deviceCycleTimes[d] < curTime) && (curTime - deviceCycleTimes[d] < 1000000000) )
      {
        if (g_eepromShadow[EEPROM_DEVICE_PREFOCUS1+d])
          triggerDevicePins(d, HIGH, LOW, LOW);
        else
          triggerDevicePins(d, LOW, LOW, LOW);
          
        deviceCycleTimes[d] = 0;
   
        if (g_eepromShadow[EEPROM_SENSOR_POWER1] == d+1)  // Turn power back on
          setSensorPower(0, HIGH);
        if (g_eepromShadow[EEPROM_SENSOR_POWER2] == d+1)  // Turn power back on
          setSensorPower(1, HIGH);

        prevSensorVals[0] = -1;  // Reset so threshold doesn't trigger immediately on next pass
        prevSensorVals[1] = -1;  // Reset so threshold doesn't trigger immediately on next pass
        delay(200);  // Lets us trigger retrigger
      }
    }
  }
}


