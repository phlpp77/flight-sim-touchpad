# Touchpad for Flight Simulator
This iPad App should be used with the FSUIPC Websocket Server to connect to a flight simulator. At the moment the following aircraft data can be manipulated.

### Aircraft data that can be manipulated

Aircraft Data  | Manipulator
------------- | -------------
Speed  | Vertical Slider
Heading  | Ring Slider
Altitude | Vertical Slider
Flaps | Rotated vertical Slider
Landing gear | Rotated vertical Slider
Spoiler / Speed breaks | Rotated vertical Slider

### Usage

#### Start
- [ ] Start the app "TouchPad" with the bluish icon with an airplane
- [ ] Open settings via the gear icon in the top left corner of the screen
- [ ] Connect to the websocket server via tapping the field at the top or the toggle next to "Connect Server"
- [ ] When server is connected (stated at the top in green), declare offsets the same way
- [ ] Connect to the MQTT server for real time logging
- [ ] Exit the window via tapping in the outside space

#### End / Export
- [ ] Do NOT close the app directly after usage, the log data can be lost
- [ ] Open settings via the gear icon in the top left corner of the screen
- [ ] Scroll to them bottom of the settings to find the button "Export log file"
- [ ] Give the logfile an unused name
- [ ] Tap "export"
- [ ] The app can be closed now
- [ ] The exported document (format .csv) can be found in the files app in the documents on the iPad

### Overview

#### Main screen
![Screenshot-Main-Screen](https://user-images.githubusercontent.com/16270691/179506437-731b492e-4ce2-4f9f-b01b-3f9a6cb4d6ab.png)

#### Second screen
![Screenshot-Second-Screen](https://user-images.githubusercontent.com/16270691/179506508-236e6482-3cc4-45dc-9688-373761b993f8.png)


#### Settings screen
![Screenshot-Settings-View](https://user-images.githubusercontent.com/16270691/179506547-28fda2ab-95a4-4056-9b0e-2e57d0f8f722.png)

