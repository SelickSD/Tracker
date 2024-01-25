//
//  Int + Extension.swift
//  Tracker
//
//  Created by Сергей Денисенко on 25.01.2024.
//

import Foundation

extension Int {
     func days() -> String {
         var dayString = ""

         if (self % 100) >= 11 && (self % 100) <= 14 {
             dayString = "дней"
             return "\(self) " + dayString
         }

         let value = self % 10
         
         switch value {
         case 1:
             dayString = "день"
         case 2...4:
             dayString = "дня"
         case 5...9:
             dayString = "дней"
         default:
             dayString = "дней"
         }
    return "\(self) " + dayString
    }
}
