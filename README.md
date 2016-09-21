# SurviveAmsterdam

Work in progress toy project, to show how it is possible to build a complete
application (mobile and [API services](https://github.com/darthpelo/SurviveAmsterdam-backend)) only with Swift :)

[Here](https://github.com/darthpelo/SurviveAmsterdam/tree/swift2.3) the Swift 2.3 version.

[Here](https://github.com/darthpelo/SurviveAmsterdam/tree/swift3.0) the Swift 3.0 version. It is still in progress because `R.swift` pod is not ready.

### Note
Before build the project, it is necessary to add a *plist* file to the project, with the name `keys.plist` and add your Foursquare API key and secret key, in this format:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>foursquare</key>
	<dict>
		<key>clientid</key>
		<string></string>
		<key>clientsecret</key>
		<string></string>
		<key>categoryid</key>
		<string>4d4b7105d754a06378d81259</string>
	</dict>
</dict>
</plist>
```
