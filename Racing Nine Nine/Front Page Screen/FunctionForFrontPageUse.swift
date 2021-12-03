//
//  FunctionForFrontPageUse.swift
//  Racing Nine Nine
//
//  Created by Dogpa's MBAir M1 on 2021/11/30.
//

import Foundation
import UIKit


let controllerArray = [
    "GameModelAndTypeViewController",
    "SearchBillvoardTypeViewController",
    "GameInstructionViewController"
]


//用於指派UIStoruboard ID 後回傳使用
//用於跳轉頁面指定跳到哪一個頁面使用
func getViewControllerName (_ int:Int) -> String {
    
    return controllerArray[int]
    
}


//延展UIViewController的功能
extension UIViewController {
    
    
    //跳轉頁面
    //輸入controllerArray的值後跳到對應的頁面
    func transferViewController (_ pageIndex: Int) {
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: getViewControllerName(pageIndex))
        view.modalPresentationStyle = .fullScreen
        present(view, animated: true, completion: nil)
    }
}

