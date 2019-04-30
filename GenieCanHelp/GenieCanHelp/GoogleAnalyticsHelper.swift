//
//  GoogleAnalyticsHelper.swift
//  GenieCanHelp
//
//  Created by Shehzad on 5/1/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit
import Firebase

class GoogleAnalyticsHelper
{
    static func setUp()
    {
        
        FirebaseApp.configure()
        
        /*
        guard let gai = GAI.sharedInstance()
        else {
            assert(false, "Google Analytics not configured correctly")
            return
        }
        
        gai.tracker(withTrackingId: Constants.GoogleAnalyticsTrackingId)
        // Optional: automatically report uncaught exceptions.
        gai.trackUncaughtExceptions = true
        gai.dispatchInterval = 20
        // Optional: set Logger to VERBOSE for debug information.
        // Remove before app release.
        gai.logger.logLevel = .verbose;
         */
    
    }
    
    static func trackScreen(_ title: String, className:String)
    {
        Analytics.setScreenName(title, screenClass: className)
        
        //Analytics.logEvent("Screen", parameters: ["title" : title])
        
        /*
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set("ScreenName", value: name)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        */
    }
}
