*** Settings ***
Documentation    

Library    AppiumLibrary
Resource    screens/home.resource
Resource    screens/login.resource

*** Keywords ***
Start session
        Open Application    	    http://localhost:4723    
        ...                         platformName=Android	
        ...                         automationName=UIAutomator2
        ...	                    deviceName=Android Emulator	
        ...	                    app=${EXECDIR}/app/wdio.native.app.apk
        ...	                    udid=emulator-5554
        ...	                    autoGrantPermissions=true
        ...	                    appium:disableHiddenApiPolicy=false
        ...	                    appium:ignoreHiddenApiPolicyError=true
        ...	                    appium:skipDeviceInitialization=true
        ...	                    appPackage=com.wdiodemoapp
        ...	                    appActivity=.MainActivity
        Wait Until Page Contains    WEBDRIVER
Finish session
        Close Application