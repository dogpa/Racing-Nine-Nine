//
//  FrontPageViewController.swift
//  Racing Nine Nine
//
//  Created by Dogpa's MBAir M1 on 2021/11/30.
//

import UIKit

class FrontPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //跳遊戲選擇畫面
    @IBAction func startToPlay(_ sender: UIButton) {
        self.transferViewController(0)
        
    }
    
    //跳排行榜
    @IBAction func checkBillBoard(_ sender: UIButton) {
        self.transferViewController(1)
    }
    
    


}
