//
//  GameModelAndTypeViewController.swift
//  Racing Nine Nine
//
//  Created by Dogpa's MBAir M1 on 2021/11/26.
//

import UIKit

class GameModelAndTypeViewController: UIViewController {
    
    
    @IBOutlet var playerCountButton: [UIButton]!    //遊戲模式
    @IBOutlet var difficuityButton: [UIButton]!     //難度
    @IBOutlet var calculationButton: [UIButton]!    //運算
    @IBOutlet weak var nextStepButton: UIButton!    //下一步選擇車輛
    
    //對應button名稱的Array
    let playerArray = ["單人練習","電腦對戰","雙人對抗"]
    let difficuityArray = ["數學小老師","數學高材生","數學教授"]
    let calculationArray = ["加法","減法","乘法"]
    
    //選擇模式的三個參數透過button的tag來協助改變，因為不會有4所以設定4變數供後續改變
    var playerIndex = 4 {
        didSet {
            indexObserver()
        }
    }
    var difficuityIndex = 4 {
        didSet {
            indexObserver()
        }
    }
    var calculationIndex = 4 {
        didSet {
            indexObserver()
        }
    }
    
    
    //監測3個Index是否小於4
    func indexObserver() {
        if playerIndex < 4, difficuityIndex < 4, calculationIndex < 4 {
            nextStepButton.isHidden = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextStepButton.isHidden = true                                      //先藏起來選擇完成後才跳出
        nextStepButton.layer.cornerRadius = nextStepButton.frame.height / 3 //隱藏後只能在viewDidLoad設定layerCornerRadius

    }
    

    //設定自定義Function圓角
    override func viewDidLayoutSubviews() {
        setLayerCornerRadius(playerCountButton)
        setLayerCornerRadius(difficuityButton)
        setLayerCornerRadius(calculationButton)
        
    }
    
    
    //單雙人電腦
    @IBAction func playerCountChoose(_ sender: UIButton) {
        resetBorder(playerCountButton)
        playerIndex = buttonObserver(sender: sender, compareString: playerArray, buttonSelection: playerCountButton)
       
    }

    
    //難度
    @IBAction func difficuityModelChoose(_ sender: UIButton) {
        resetBorder(difficuityButton)
        difficuityIndex = buttonObserver(sender: sender, compareString: difficuityArray, buttonSelection: difficuityButton)
       
    }
    
    
    //加減乘法
    @IBAction func calculationChoose(_ sender: UIButton) {
        resetBorder(calculationButton)
        calculationIndex = buttonObserver(sender: sender, compareString: calculationArray, buttonSelection: calculationButton)
    }
    
    //跳下一頁帶資料過去
    @IBAction func goToSelectTrafficVC(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(identifier: "TrafficSelectViewController") as! TrafficSelectViewController
        controller.playerIndex = playerIndex
        controller.difficuityIndex  = difficuityIndex
        controller.calculationIndex = calculationIndex
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
    }
    
    
    //前往遊戲說明
    @IBAction func goTOInstructionVC(_ sender: UIButton) {
        self.transferViewController(2)
    }
    
    
    //返回遊戲首頁
    @IBAction func backToFrontPage(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
