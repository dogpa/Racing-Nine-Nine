//
//  GamingScreenFunction.swift
//  Racing Nine Nine
//
//  Created by Dogpa's MBAir M1 on 2021/11/29.
//

import Foundation
import UIKit

//判斷遊戲模式改變運算符號
func checkCalcultion(_ calculation:Int) -> String {
    switch calculation {
    case 0:
        return "＋"
    case 1:
        return "－"
    case 2:
        return "Ｘ"
    default:
        return ""
    }
}









