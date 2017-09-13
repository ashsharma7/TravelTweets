//
//  DataModel.swift
//  OKRoger-v1
//
//  Created by Ash Sharma on 4/4/16.
//  Copyright © 2016 Ash Sharma. All rights reserved.
//

import Foundation
import UIKit

public struct Airport: CustomStringConvertible {
    var name: String
    var city: String
    var country: String
    var codeIATA: String
   // var codeICAO: String
   // var latitude: Float
   // var longitude: Float
   // var altitude: Int
    var timezoneOffset: Float
    var twitterHandle: String
    var websiteAddress: String
    //var dst: String
    //var tzTimeZone: String
   
    public var longdescription: String {
        get {
            return codeIATA+","+name+","+city+","+country
        }
    }
    public var description: String {
        get {
            return name+", "+city+", "+country
        }
    }
    init() {
        name = ""
        city = ""
        country = ""
        codeIATA = ""
        timezoneOffset = 0
        twitterHandle = ""
        websiteAddress = ""
    }
}

public struct Constants {
    static let appleBlueColor = UIButton(type: UIButtonType.system).titleColor(for: UIControlState())!
}
