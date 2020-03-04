//
//  Validation.swift
//  RumeshChandima-cobsccomp182p-024
//
//  Created by Geeth Rangana on 2/23/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import UIKit

class Validation{
    
    static func isValidInput(textField:String) -> Bool{
        
        if (textField.isEmpty){
        
            return false
            
        }
        return true
    }
    
}
