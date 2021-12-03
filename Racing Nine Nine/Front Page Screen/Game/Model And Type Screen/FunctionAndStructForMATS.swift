//
//  FunctionAndStructForMATS.swift
//  Racing Nine Nine
//
//  Created by Dogpa's MBAir M1 on 2021/11/26.
//

import Foundation
import UIKit




//重置resetBorder
func resetBorder(_ buttonCollection:[UIButton]) {
    for button in buttonCollection.indices {
        buttonCollection[button].layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0)
        buttonCollection[button].layer.borderWidth = 0
    }
}

//設定layer.cornerRadius
func setLayerCornerRadius (_ buttons:[UIButton]) {
    for button in buttons.indices {
        buttons[button].layer.cornerRadius = buttons[button].frame.height / 3
    }
}



//監測是否有按下模式的按鈕
func buttonObserver (sender:UIButton, compareString:[String], buttonSelection:[UIButton]) -> Int {
    var index: Int?
    for select in buttonSelection.indices {
        if sender.currentTitle == compareString[select] {
            buttonSelection[select].layer.borderWidth = CGFloat(5)
            buttonSelection[select].layer.borderColor = CGColor(srgbRed: 255/255, green: 100/255, blue: 100/255, alpha: 1)
            index = select
        }
    }
    return index!
}

//車輛imageView的image名稱分割成兩個array給不同的使用者
let playerOneTrafficArray = ["playerOneCar","playerOneFlight","playerOneRocket","playerOneScooter","playerOneShip","playerOneTrain"]
let playerTwoTrafficArray = ["playerTwoCar","playerTwoFlight","playerTwoRocket","playerTwoScooter","playerTwoShip","playerTwoTrain"]
