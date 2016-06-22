require 'rubygems'
require 'appium_lib'

APP_PATH = '../build/SurviveAmsterdam.app.zip'

desired_caps = {
	caps: {
		platformName: 'iOS',
		versionNumber: '9.3',
		deviceName: 'iPhone 6',
		app: APP_PATH
	},
	appium_lib: {
		sauce_username:   nil, # don't run on Sauce
		sauce_access_key: nil
	}
}

Appium::Driver.new(desired_caps).start_driver

module Test
	module IOS
		Appium.promote_singleton_appium_methods Test

		navBarTitle = "//UIAApplication[1]/UIAWindow[1]/UIANavigationBar[1]/UIAStaticText[1]"

		find_element(:xpath, "//UIAApplication[1]/UIAWindow[1]/UIANavigationBar[1]/UIAButton[2]").click

		# Find every textfield.
		elements = textfields
		values = ["Bread", "AH"]
		elements.each_with_index do |element, index|
			element.send_keys(values[index])
		end

		find_element(:xpath, "//UIAApplication[1]/UIAWindow[1]/UIANavigationBar[1]/UIAButton[3]").click

		alert_accept

		title = find_element(:xpath, navBarTitle)
		raise Exception unless title.label == "Products"

		driver_quit
	end
end
