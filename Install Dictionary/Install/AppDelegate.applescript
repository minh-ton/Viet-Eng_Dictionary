--
--  AppDelegate.applescript
--  Install
--
--  Created by Ford on 2/11/20.
--  Copyright © 2020 Ford. All rights reserved.
--

script AppDelegate
	property parent : class "NSObject"
    property pathToResources : "NSString"
	
	-- IBOutlets
    
    -- Texts:
	property theWindow : missing value
    property mainTitle : missing value
    property mainSubtitle : missing value
    property stepCount : missing value
    property stepDescription : missing value
    property progressLabel : missing value
    property actionButtonTitle : missing value
    
    -- Buttons:
    property nextStepButton : missing value
    property actionButton1 : missing value
    property actionButton2 : missing value
    property actionButton3 : missing value
    property step3 : missing value
    property step4 : missing value
    property startDict : missing value
    
    -- Other:
    property myProgressBar : missing value
    
    -- Images
    property step1IMG : missing value
    property step2IMG : missing value
    property step3IMG : missing value
    property step4IMG : missing value
    property installerIMG : missing value
    
    -- Status item
    on stopClicked_(sender)
        do shell script "killall Install"
    end stopClicked
    
    on openDict_(sender)
        tell startDict to setHidden_(true)
        tell step3 to setHidden_(true)
        tell step4 to setHidden_(true)
        tell actionButton1 to setHidden_(true)
        tell actionButton2 to setHidden_(true)
        tell actionButton3 to setHidden_(true)
        tell nextStepButton to setHidden_(false)
        
        tell myProgressBar to setHidden_(true)
        tell installerIMG to setHidden_(true)
        mainTitle's setStringValue_("Hmm...Actually there is one more thing to do...")
        mainSubtitle's setStringValue_("These are some basic steps how to get your new Dictionary enabled.")
        tell stepCount to setHidden_(false)
        stepCount's setStringValue_("Step 1")
        tell stepDescription to setHidden_(false)
        stepDescription's setStringValue_("First, open Dictionary app by " & return & "double-clicking its icon in " & return & "the Applications folder.")
        tell actionButtonTitle to setHidden_(true)
        tell progressLabel to setHidden_(true)
        tell step1IMG to setHidden_(false)
    end openDict_
    
    on Step2enable_(sender)
        tell nextStepButton to setHidden_(true)
        tell step3 to setHidden_(false)
        tell step1IMG to setHidden_(true)
        tell step2IMG to setHidden_(false)
        stepCount's setStringValue_("Step 2")
        stepDescription's setStringValue_("Next, press 'Dictionary' on the top left of the menubar and click 'Preferences'.")
    end Step2enable_
    
    on Step3enable_(sender)
        tell step3 to setHidden_(true)
        tell step4 to setHidden_(false)
        tell step2IMG to setHidden_(true)
        tell step3IMG to setHidden_(false)
        stepCount's setStringValue_("Step 3")
        stepDescription's setStringValue_("Then, scroll down until you find 'Vietnamese - English Dictionary'. Check the tickbox on the left.")
    end Step3enable_
    
    on Step4enable_(sender)
        tell step4 to setHidden_(true)
        tell startDict to setHidden_(false)
        tell step3IMG to setHidden_(true)
        tell step4IMG to setHidden_(false)
        stepCount's setStringValue_("Step 4")
        stepDescription's setStringValue_("Close the preferences window and enjoy your new Dictionary.")
    end Step4enable_
    
    on StartDict_(sender)
        tell application "Dictionary"
            activate
        end tell
        delay 3
        do shell script "killall Install"
    end StartDict_
        
    
    on continueClicked_(sender)
        actionButtonTitle's setStringValue_("Stop")
        tell actionButton1 to setHidden_(true)
        tell actionButton2 to setHidden_(false)
        tell actionButton3 to setHidden_(true)
        
        
        -- All functions here
        require_admPass()
        QuitDict()
        CompatCheck()
        checkAvai()
        DectectOld()
        InstallDict()
        InstallComplete()
        
    end continueClicked_
    
    on issueClicked_(sender)
        do shell script "open https://github.com/Minh-Ton/Viet-Eng_Dictionary/issues"
    end issueClicked_
    
    on repoClicked_(sender)
        do shell script "open https://github.com/Minh-Ton/Viet-Eng_Dictionary"
    end repoClicked_
    
on applicationWillFinishLaunching_(aNotification)
    mainTitle's setStringValue_("Welcome to the Vietnamese - English Dictionary Installation")
    mainSubtitle's setStringValue_("This utility will install a copy of the Vietnamese - English Dictionary taken from newer versions of macOS.")
    progressLabel's setStringValue_("Press Continue to start the installation.")
    actionButtonTitle's setStringValue_("Continue")
    tell actionButton1 to setHidden_(false)
    tell actionButton2 to setHidden_(true)
    tell actionButton3 to setHidden_(true)
    tell step1IMG to setHidden_(true)
    tell step2IMG to setHidden_(true)
    tell step3IMG to setHidden_(true)
    tell step4IMG to setHidden_(true)
    tell stepCount to setHidden_(true)
    tell stepDescription to setHidden_(true)
    tell nextStepButton to setHidden_(true)
    tell step3 to setHidden_(true)
    tell step4 to setHidden_(true)
    tell startDict to setHidden_(true)
end applicationWillFinishLaunching_

-- Functions

on require_admPass()
    --Require administrator privileges
    progressLabel's setStringValue_("Starting helper...")
    delay 1
    set c to 0
    set c to c + 3
    activate
    do shell script "echo" with administrator privileges
    tell myProgressBar to setDoubleValue_(c)
    
    -- Asking for Apple Events
    tell myProgressBar to setDoubleValue_(c)
    delay 3
    set c to 3
    set c to c + 2
    activate
    tell myProgressBar to setDoubleValue_(c)
    
end require_admPass

on CompatCheck()
    -- Check compatibility
    set c to 5
    set c to c + 10
    delay 3
    progressLabel's setStringValue_("Checking system compatibility...")
    set osver to (do shell script "defaults read /System/Library/CoreServices/SystemVersion.plist ProductVersion | cut -c-5")
    if osver is "10.15" then -- For this, the compatibility is already macOS 10.11+ so no need to check for older versions of macOS as v1.0 does.
        activate
        display alert "You already had a copy of the Vietnamese - English built in with your version of macOS." message "This software can only run on macOS 10.11 to 10.14, which do not have the Vietnamese - English Dictionary provided by Apple." buttons {"Cancel Installation"} default button "Cancel Installation"
        if the button returned of the result is "Cancel Installation" then
            do shell script "killall Install"
        end if
    end if
    tell myProgressBar to setDoubleValue_(c)
end CompatCheck

on checkAvai()
    -- Check availability
    set c to 15
    set c to c + 10
    progressLabel's setStringValue_("Checking installed dictionaries...")
    set dictPath to (path to library folder from user domain as text) & "Dictionaries:Vietnamese - English.dictionary" as text
    delay 1
    tell application "Finder" to if (exists dictPath) then
    display alert "You already had a copy of the Dictionary installed on your Mac." message "Press Reinstall to reinstall or upgrade the dictionary." & return & return & "It might take a few seconds to reinstall/upgrade the software." buttons {"Reinstall"} default button "Reinstall"
    if the button returned of the result is "Reinstall" then
        delay 1
        activate
        progressLabel's setStringValue_("Removing older version of the dictionary...")
        do shell script ("rm -rf " & quoted form of POSIX path of dictPath) with administrator privileges
end if
end if

tell myProgressBar to setDoubleValue_(c)
end checkAvai

on DectectOld()
    delay 3
    set c to 25
    set c to c + 10
    progressLabel's setStringValue_("Checking files and folders...")
    set oldtemp to (path to home folder as text) & "temp" as text
    tell application "Finder" to if (exists oldtemp) then
        try
            do shell script ("rm -rf " & quoted form of POSIX path of oldtemp) with administrator privileges
        end try
    end if
    delay 3
    progressLabel's setStringValue_("Downloading resources...")
    tell myProgressBar to setDoubleValue_(c)
end DectectOld

on QuitDict()
    tell application "System Events"
        if exists (application process "Dictionary") then
            tell application "Dictionary" to quit
        end if
    end tell
end QuitDict
    
on InstallDict()
    delay 3
    activate
    progressLabel's setStringValue_("Installing Vietnamese - English Dictionary...")
    do shell script "mkdir ~/temp"
    do shell script "chflags hidden ~/temp"
    do shell script "curl -L -s -o  ~/temp/Dictionary.zip https://github.com/Minh-Ton/Vietnamese-English_Dictionary_for_macOS/raw/resources/dict_res/Dictionary.zip" with administrator privileges
    do shell script "unzip -qq ~/temp/Dictionary.zip -d ~/temp" with administrator privileges
    do shell script "cp -R ~/temp/*.dictionary ~/Library/Dictionaries/" with administrator privileges
    set c to 35
    repeat 66 times
        delay 0.1
        tell myProgressBar to setDoubleValue_(c)
        set c to c + 1
    end repeat
    display notification "" with title "Vietnamese - English Dictionary is installed." subtitle "Installation completed successfully."
    activate
    progressLabel's setStringValue_("Installed Vietnamese - English Dictionary for macOS.")
    do shell script "afplay /System/Library/Components/CoreAudio.component/Contents/SharedSupport/SystemSounds/system/payment_success.aif"
end InstallDict

on InstallComplete()
    tell actionButton1 to setHidden_(true)
    tell actionButton2 to setHidden_(true)
    tell actionButton3 to setHidden_(false)
    actionButtonTitle's setStringValue_("Enable Dictionary")
    set tempfol to (path to home folder as text) & "temp" as text
    do shell script ("rm -rf " & quoted form of POSIX path of tempfol) with administrator privileges
end InstallComplete

end script
