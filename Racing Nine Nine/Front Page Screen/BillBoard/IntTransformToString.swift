//
//  IntTransformToString.swift
//  Racing Nine Nine
//
//  Created by Dogpa's MBAir M1 on 2021/11/30.
//

import Foundation


func timerIndexToTimeString(_ timeIndex:Int) -> String {
    
    var calculateHour = 0                           //取得timeIndex計算的小時
    var calculateMin = 0                            //取得timeIndex計算的分鐘
    var calculateSec = 0                            //取得timeIndex計算的秒數
    var calculateMiSec = 0                          //取得timeIndex計算的毫秒
    var totalStr = ""                               //取得上面所有timeIndex需要使用的資料存入
    
    
    calculateHour = timeIndex / 360000              //取得timeIndex換算的小時時間存入calculateHour
    calculateMin = timeIndex / 6000                 //取得timeIndex換算的分鐘時間存入calculateMin
    calculateSec = (timeIndex / 100) % 60           //取得timeIndex換算的秒數時間存入calculateSec
    calculateMiSec = timeIndex % 100                //取得timeIndex換算的微秒時間存入calculateMiSec


    //透過判斷指派hourStr為需要的數字字串，讓0能夠在只有一位數時出現
    let hourStr = calculateHour > 9 ? "\(calculateHour)":"0\(calculateHour)"
    let minStr = calculateMin > 9 ? "\(calculateMin)":"0\(calculateMin)"
    let secStr = calculateSec > 9 ? "\(calculateSec)":"0\(calculateSec)"
    let miSecStr = calculateMiSec > 9 ? "\(calculateMiSec)":"0\(calculateMiSec)"

    //totalStr一樣透過時間來指派是否出現hourStr的值，完成後將totalStr顯示在label上
    totalStr = calculateMin>59 ? "\(hourStr):\(minStr):\(secStr).\(miSecStr)":"\(minStr):\(secStr).\(miSecStr)"
    return totalStr
}

