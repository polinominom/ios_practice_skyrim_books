//
//  Logger.swift
//  Skyrim Books
//
//  Created by Çağrı Yıldız on 05/08/2017.
//  Copyright © 2017 Çağrı Yıldız. All rights reserved.
//

import Foundation
import os

class Logger
{

    static func log(message: StaticString, args: String)
    {
        if #available(iOS 10.0, *)
        {
            os_log(message, log:OSLog.default, type:.debug, args)
        } else
        {
            // Fallback on earlier versions
            NSLog("\(message)", args)
        }
    }
}
