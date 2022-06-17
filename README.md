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
![Screenshot-Main-Screen](https://user-images.githubusercontent.com/16270691/174300377-06b7af12-fab1-4906-93ef-596ba978d8f5.png)

#### Second screen
![Screenshot-Second-Screen](https://user-images.githubusercontent.com/16270691/174300436-a6cc81b6-58eb-477f-9100-b02e61e9f3ea.png)

#### Settings screen
![Screenshot-Settings-View](https://user-images.githubusercontent.com/16270691/174300260-8856451d-5b8b-4e70-8cc9-2f31c3d1b414.png)
