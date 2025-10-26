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
        ...	                    newCommandTimeout=240
        ...	                    adbExecTimeout=200000
...                                 uiautomator2ServerInstallTimeout=180000
...                                 uiautomator2ServerLaunchTimeout=180000  
...                                 noReset=true
...                                 appium:skipServerInstallation=false
        Wait Until Page Contains    WEBDRIVER        10s
Finish session
        Close Application