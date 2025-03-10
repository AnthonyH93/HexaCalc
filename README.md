# HexaCalc

## Available on the iOS App Store
https://apps.apple.com/app/hexacalc/id1529225315

## App Icon

![alt text](HexaCalcIconGreen1024.png?raw=true)

## About
Three tabbed calculator for decimal, hexadecimal and binary for iOS built in Swift with Xcode. Provides numerous operations and seamless conversion between the three tabs.

With a seperate screen for each of the number systems users can focus on exactly what system they need - many of the apps currently on the app store with similar functionality have all three number systems on the same screen or they are severely outdated in terms of UI.

Switching tabs will result in instant conversion of the current value on the screen and will allow you to complete operations on that current number on the new screen.

For the hexadecimal and binary calculators there is a limit of 64 bits as they use integer conversion, however the decimal calculator will allow you to work with larger numbers even when the other two calculator screens show an error.

Tapping on the calculator output label causes the currently displayed number to be copied to your phone's clipboard. This works for any of the three tabs!

Note: All screenshots shown were taken on an iPhone X simulator.

## System Requirements

This app is optimized to run and look amazing on all iPhones and iPads which are supported by iOS13/iPadOS13.

For iPads this includes support for both landscape and portrait modes as well as support for any multitasking screen size and Slide Over.

## Operations

### Hexadecimal Calculator
* Addition, subtraction, multiplication, division
* AND, OR, XOR, NOT
* 2's compliment, left shift, right shift
* All clear, delete

### Device Screenshots for Hexacdecimal Calculator

Green Positive Hexadecimal Output | Green Negative Hexadecimal Output | Red Negative Hexadecimal White Text Output | Calculation History for Hexadecimal Calculator
---------------------- | -------------- | --------------------- | -----------------------------------
![alt text](DeviceScreenshots/1.6.0/GreenPositiveHex.png?raw=true) | ![alt text](DeviceScreenshots/1.6.0/GreenNegativeHex.png?raw=true) | ![alt text](DeviceScreenshots/1.6.0/RedNegativeHexWhiteText.png?raw=true) | ![alt text](DeviceScreenshots/1.6.0/CalculationHistoryHex.png?raw=true)

### Binary Calculator
* Addition, subtraction, multiplication, division
* AND, OR, XOR, NOT
* 1's compliment, 2's compliment, left shift, right shift
* All clear, delete

### Device Screenshots for Binary Calculator

Green Positive Binary Output | Green Negative Binary Output | Red Negative Binary White Text Output | Teal Copy Value Binary Calculator
---------------------- | -------------- | --------------------- | -----------------------------------
![alt text](DeviceScreenshots/1.6.0/GreenPositiveBin.png?raw=true) | ![alt text](DeviceScreenshots/1.6.0/GreenNegativeBin.png?raw=true) | ![alt text](DeviceScreenshots/1.6.0/RedNegativeBinWhiteText.png?raw=true) | ![alt text](DeviceScreenshots/1.6.0/TealCopyBin.png?raw=true)

### Decimal Calculator
* Addition, subtraction, multiplication, division
* Modulus, exponentiation, square root
* All clear, delete, plus/minus, dot

### Device Screenshots for Decimal Calculator

Green Positive Decimal Output | Green Negative Decimal Output | Red Negative Decimal White Text Output | Orange Paste Value Decimal Calculator
---------------------- | -------------- | --------------------- | -----------------------------------
![alt text](DeviceScreenshots/1.6.0/GreenPositiveDec.png?raw=true) | ![alt text](DeviceScreenshots/1.6.0/GreenNegativeDec.png?raw=true) | ![alt text](DeviceScreenshots/1.6.0/RedNegativeDecWhiteText.png?raw=true) | ![alt text](DeviceScreenshots/1.6.0/OrangePasteDec.png?raw=true)

## User Customization

This app uses data persistance to implement saved user customization allowing each user to choose their customizations through a settings menu.

### Customization options
* 10 different system colours which change the colour of buttons and the app icon
* The ability to disable or enable any combination of calculator tabs allowing the user to focus on what is important for them
* The option to change the default calculator text colour from white to your selected colour
* Options for the copy and paste clipboard gestures as well as the ability to disable them
* The option to override the default selected tab on app launch
* Control over the appearance of the calculation history button
* Ability to clear the local history

The settings menu also includes navigation to the About HexaCalc view which has links to the privacy policy and terms and conditions documents.

### Device Screenshots for Settings Tab

Default Settings View | Changing Colour Settings | Red Two Tab Settings View | Changing Icon to Blue
---------------------- | -------------- | --------------------- | -----------------------------------
![alt text](DeviceScreenshots/1.6.0/DefaultSettings.png?raw=true) |  ![alt text](DeviceScreenshots/1.6.0/ChangeColourSettings.png?raw=true) | ![alt text](DeviceScreenshots/1.6.0/RedTwoTabsSettings.png?raw=true) | ![alt text](DeviceScreenshots/1.6.0/ChangeIconBlue.png?raw=true)

## Future Development
There are many features that I would like to add to HexaCalc and these are some of the ones that I will look into implementing next:
- [ ] Localization
  * As of now, the app only supports English, it would be great to add support for many more languages
- [x] Improve the bit shift operations
  * Bit shifting is a common operation, but it is only implemented on the binary calculator and only with shifts of 1
  * Add X>>Y and X<<Y to both the binary and hexadecimal calculators
- [x] Modulo operator
  * The modulo operation would be a good addition to the hexadecimal/decimal calculators
- [x] History
  * Adding calculation history for each of the calculators
- [ ] Support for any number base
  * The app only includes binary, hexadecimal and decimal, more number bases could be added (such as octal)
- [ ] Full calculator customization
  * Add more optional calculator buttons and let users create their own layout with their desired operations

Thank you for looking at this project!
