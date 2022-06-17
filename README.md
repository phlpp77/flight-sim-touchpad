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

### Overview
#### Main screen
![Simulator Screen Shot - iPad Pro (11-inch) (3rd generation) - 2022-05-13 at 09 59 08](https://user-images.githubusercontent.com/16270691/168238581-3e2ea5fc-8cb9-4254-918c-de0098acc3ec.png)

#### Settings screen
![Simulator Screen Shot - iPad Pro (11-inch) (3rd generation) - 2022-05-13 at 09 59 56](https://user-images.githubusercontent.com/16270691/168238621-adb6c61a-4231-490d-b0f0-0f0c0c97984a.png)

### Start
- [ ] Start the app "TouchPad" with the bluish icon with an airplane
- [ ] Open settings via the gear icon in the top left corner of the screen
- [ ] Connect to the websocket server via tapping the field at the top or the toggle next to "Connect Server"
- [ ] When server is connected (stated at the top in green), declare offsets the same way
- [ ] Connect to the MQTT server for real time logging
- [ ] Exit the window via tapping in the outside space

### End / Export
- [ ] Do NOT close the app directly after usage, the log data can be lost
- [ ] Open settings via the gear icon in the top left corner of the screen
- [ ] Scroll to them bottom of the settings to find the button "Export log file"
- [ ] Give the logfile an unused name
- [ ] Tap "export"
- [ ] The app can be closed now
- [ ] The exported document (format .csv) can be found in the files app in the documents on the iPad
