//
//  TrafficSelectViewController.swift
//  Racing Nine Nine
//
//  Created by Dogpa's MBAir M1 on 2021/11/27.
//

import UIKit

class TrafficSelectViewController: UIViewController {
    
    
    var playerIndex : Int?                              //玩家數量
    var difficuityIndex : Int?                          //難度
    var calculationIndex : Int?                         //計算方式
    var playerOneTrafficIndex: Int?                     //p1選擇照片
    var playerTwoTrafficIndex: Int?                     //p2選擇照片
    
    
    @IBOutlet var playerOneTrafficButton: [UIButton]!   //p1的照片button的collection
    
    @IBOutlet var playerTwoTrafficButton: [UIButton]!   //p2的照片button的collection
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in playerTwoTrafficButton.indices {
            
            playerOneTrafficButton[index].tag = index
            playerTwoTrafficButton[index].tag = index
            playerOneTrafficButton[index].setTitle(playerOneTrafficArray[index], for: .normal)
            playerTwoTrafficButton[index].setTitle(playerTwoTrafficArray[index], for: .normal)
            playerOneTrafficButton[index].layer.cornerRadius = playerOneTrafficButton[index].frame.height / 4
            playerTwoTrafficButton[index].layer.cornerRadius = playerTwoTrafficButton[index].frame.height / 4
            if playerIndex! < 2 {
                playerTwoTrafficButton[index].isHidden = true
            }
        }
    }
    
    
    //提出警告
    func showAlert () {
        let alert = UIAlertController(title: "未選擇車輛", message: "選一台帥的吧", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "好", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    //玩家一的車輛選擇
    @IBAction func playerOneTrafficChoose(_ sender: UIButton) {
        resetBorder(playerOneTrafficButton)
        playerOneTrafficIndex = buttonObserver(sender: sender, compareString: playerOneTrafficArray, buttonSelection: playerOneTrafficButton)
    }
    
    
    //玩家二的車輛選擇
    @IBAction func playerTwoTrafficChoose(_ sender: UIButton) {
        resetBorder(playerTwoTrafficButton)
        playerTwoTrafficIndex = buttonObserver(sender: sender, compareString: playerTwoTrafficArray, buttonSelection: playerTwoTrafficButton)

    }
    
    
    //回模式選擇頁
    @IBAction func backModelAndTypeVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //帶資料前往遊戲畫面
    @IBAction func goToPlayVC(_ sender: UIButton) {
        
        if playerOneTrafficIndex == nil {
            showAlert()
        }else if playerIndex == 2, playerTwoTrafficIndex == nil {
            showAlert()
        }else{
            let controller = storyboard?.instantiateViewController(identifier: "GamingCsreenViewController") as! GamingCsreenViewController
            controller.playerIndex = playerIndex
            controller.difficuityIndex  = difficuityIndex
            controller.calculationIndex = calculationIndex
            controller.playerOneTrafficIndex = playerOneTrafficIndex
            controller.playerTwoTrafficIndex = playerTwoTrafficIndex
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: false, completion: nil)
        }
        
    }
    
    
    
}
