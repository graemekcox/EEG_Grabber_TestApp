//
//  EEGData.swift
//  EEG_GAE_TestApp
//
//  Created by Graeme Cox on 2017-07-05.
//  Copyright © 2017 Graeme Cox. All rights reserved.
//

import Foundation
import UIKit

class EEG{
    
    init?(name: String, setLength: Int, timestamp: String)
    {
        if name.isEmpty || setLength == 0 || timestamp.isEmpty
        {
            return nil
        }
        
        self.name = name
        self.setLength = setLength
        self.timestamp = timestamp
        
        
    }
    
    var name: String //name of data set
    var setLength: Int //length of data points
    var timestamp:String //data and time of data
    
    
    
}
