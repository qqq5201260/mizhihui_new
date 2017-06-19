#!/usr/bin/env python

import sys

def get_desired_capabilities():
    desired_caps = {
        'platformName': 'iOS',
        'platformVersion': '10.3',
#        'deviceName': 'iPhone 6',
            'deviceName': 'iPhone 7 Plus',
#        'udid': '88a7b932971aeba4c0ee0ba135bb7234e6a99297',
#         'udid':'B2EA949D-E5E9-4BD9-ADE6-68D2A8347',
#                'realDeviceLogger':'/usr/local/lib/node_modules/deviceconsole/deviceconsole',
#        'app': '/Users/czl/Desktop/diapTestipa/diapTest.ipa',
                'bundleId':'com.million.mizward',
        'newCommandTimeout': 600,
        'automationName': 'Appium',
    
#        'xcodeOrgId':'B3LET74VX6',
#        'xcodeSigningId':'iPhone Developer',
        'noReset': False,
        'connectHardwareKeyboard':True
    }

    return desired_caps

def get_uri():
    return 'http://0.0.0.0:4723/wd/hub'

def flushio():
    sys.stdout.flush()
