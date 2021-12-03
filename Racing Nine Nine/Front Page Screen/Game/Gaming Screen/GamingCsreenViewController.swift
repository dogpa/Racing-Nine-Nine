//
//  GamingCsreenViewController.swift
//  Racing Nine Nine
//
//  Created by Dogpa's MBAir M1 on 2021/11/29.
//

import UIKit
import CoreData


class GamingCsreenViewController: UIViewController {
    
    @IBOutlet weak var backFrontButton: UIButton!
    
    @IBOutlet weak var replayButton: UIButton!
    
    @IBOutlet weak var startButton: UIButton!
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //cordData
    var playerIndex : Int?                                  //0單人1電腦2雙人
    var difficuityIndex : Int?                              //0小老師2高材生3教授
    var calculationIndex : Int?                             //0加1減2乘
    var playerOneTrafficIndex : Int?                        //p1車子照片索引
    var playerTwoTrafficIndex : Int?                        //p2車子照片索引
    
    
    @IBOutlet weak var runwayImageView: UIImageView!        //賽道
    
    //player1 元件參數
    var playerOneAnswerCorrectTimes = 0                     //p1答對次數
    var answerForPlayerOne = 0 //儲存當下題目正確答案
    @IBOutlet weak var playerOneTrafficImage: UIImageView!  //p1車
    @IBOutlet weak var p1FirstNumIndexLabel: UILabel!       //第一個數字
    @IBOutlet weak var p1SecondNumIndexLabel: UILabel!      //第二個數字
    @IBOutlet weak var p1CalculationLabel: UILabel!         //運算符號
    @IBOutlet var P1AnswerSelectButton: [UIButton]!         //p1 button
    @IBOutlet weak var p1StackView: UIStackView!            //p1 的label與button
    
    
    
    //player2 元件參數
    var playerTwoAnswerCorrectTimes = 0 {                   //p2答對次數另外透過didset判斷是否有變化
        didSet {
            if playerTwoAnswerCorrectTimes == 15 {
                timer?.invalidate()
                playerTwoAnswerCorrectTimes = 17
                timerForComputer?.invalidate()
                if playerIndex == 1 {
                    showWInAlert(title: "電腦獲勝", message: "再練習一下")
                }else{
                    showWInAlert(title: "玩家2獲勝", message: "數學很棒！")
                }
                
                //如果是電腦模式就不寫紀錄到coredata
                if playerIndex == 2{
                    saveCoreDateInfo()
                }
                replayAndBackFrontButtonIsHidden(replay: false, backFront: false ,p1stack: false ,p2stack: false)
            }
        }
    }
    var answerForPlayerTwo = 0 //儲存當下題目正確答案
    @IBOutlet weak var playerTwoTrafficImage: UIImageView!  //p2車
    @IBOutlet weak var p2FirstNumIndexLabel: UILabel!
    @IBOutlet weak var p2SecondNumIndexLabel: UILabel!
    @IBOutlet weak var p2CalculationLabel: UILabel!
    @IBOutlet var p2AnswerSelectButton: [UIButton]!
    @IBOutlet weak var p2StackView: UIStackView!
    
    //電腦使用參數
    var computerAnswerCorrectTimes = 0
    var timerForComputer: Timer?
    
    //ViewController共用參數
    var timer : Timer?
    var timeIndex = 0
    var safeAreaFrame : CGRect?
    var avgMoveDIstance : CGFloat?
    
    //隨機顏色索引
    var buttonColor : [UIColor] = [.blue, .brown , .link, .lightGray, .orange, .purple, .systemGreen, .systemPink, .systemBlue, .systemRed, .cyan, .darkGray, .red, .yellow, .systemTeal, .green ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        p1CalculationLabel.text = checkCalcultion(calculationIndex!) //判斷計算模式改變計算p1 label
        p2CalculationLabel.text = checkCalcultion(calculationIndex!) //判斷計算模式改變計算p2 label
        playerOneTrafficImage.image = UIImage(named: playerOneTrafficArray[playerOneTrafficIndex!]) //p1車種設定
        if playerTwoTrafficIndex == nil {
            playerTwoTrafficImage.image = UIImage(named: playerTwoTrafficArray.randomElement()!)
        }else{
            playerTwoTrafficImage.image = UIImage(named: playerTwoTrafficArray[playerTwoTrafficIndex!]) //p2車種設定
        }
        
        
        runPlayerOneGameModel(calculationIndex!)
        if playerIndex != 0{
            runPlayerTwoGameModel(calculationIndex!)
        }
        
        replayAndBackFrontButtonIsHidden(replay: true, backFront: true ,p1stack: true ,p2stack: true)   //是否顯示指定的UI元件
        
        if playerIndex == 0 {
            playerTwoTrafficImage.isHidden = true
        }
        

        
    }
    

    
    override func viewDidLayoutSubviews() {
        let moveDIstance = ((runwayImageView.frame.width) - (runwayImageView.frame.width * 0.1) - (playerOneTrafficImage.frame.width) )
        avgMoveDIstance = moveDIstance / 15
        safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame

        
        //旋轉p2開始
        for p2 in p2AnswerSelectButton.indices {
            p2AnswerSelectButton[p2].transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        p2FirstNumIndexLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        p2SecondNumIndexLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        p2CalculationLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        //旋轉p2結束
        
        let trafficSIze = (runwayImageView.frame.maxY - runwayImageView.frame.minY) / 2 //正方形尺寸大小
        let playOneImageYLocation = ((runwayImageView.frame.maxY - runwayImageView.frame.minY) / 2 ) + runwayImageView.frame.minY
        
        playerOneTrafficImage.frame = CGRect(x:runwayImageView.frame.minX + (avgMoveDIstance! * CGFloat(playerOneAnswerCorrectTimes))  , y: playOneImageYLocation, width: trafficSIze, height: trafficSIze)
        playerTwoTrafficImage.frame = CGRect(x: runwayImageView.frame.minX + (avgMoveDIstance! * CGFloat(playerTwoAnswerCorrectTimes)) , y: runwayImageView.frame.minY, width: trafficSIze, height: trafficSIze)
        
        for button in P1AnswerSelectButton.indices {
            P1AnswerSelectButton[button].layer.cornerRadius = P1AnswerSelectButton[button].frame.height / 2
            p2AnswerSelectButton[button].layer.cornerRadius = P1AnswerSelectButton[button].frame.height / 2
        }
        p1FirstNumIndexLabel.layer.masksToBounds = true
        p1FirstNumIndexLabel.layer.cornerRadius = p1FirstNumIndexLabel.frame.height / 4
        p1SecondNumIndexLabel.layer.masksToBounds = true
        p1SecondNumIndexLabel.layer.cornerRadius = p1FirstNumIndexLabel.frame.height / 4
        p2FirstNumIndexLabel.layer.masksToBounds = true
        p2FirstNumIndexLabel.layer.cornerRadius = p1FirstNumIndexLabel.frame.height / 4
        p2SecondNumIndexLabel.layer.masksToBounds = true
        p2SecondNumIndexLabel.layer.cornerRadius = p1FirstNumIndexLabel.frame.height / 4
        startButton.layer.cornerRadius = startButton.frame.height / 2
        replayButton.layer.cornerRadius = replayButton.frame.height / 2
        backFrontButton.layer.cornerRadius = backFrontButton.frame.height / 2

    }
    
    
    //按下按鈕後與讀取畫面時執行的functon
    //依照遊戲計算方式與難度指派題目
    func runPlayerOneGameModel (_ calcultionType: Int) {
        if calcultionType == 0 {            //加
            answerForPlayerOne = plusGameModel(buttonCollection: P1AnswerSelectButton, firstLabel: p1FirstNumIndexLabel, secondLabel: p1SecondNumIndexLabel)
        } else if calcultionType == 1 {     //減
            answerForPlayerOne = subtractGameModel(buttonCollection: P1AnswerSelectButton, firstLabel: p1FirstNumIndexLabel, secondLabel: p1SecondNumIndexLabel)
        } else {                            //乘
            answerForPlayerOne = multGameModel(buttonCollection: P1AnswerSelectButton, firstLabel: p1FirstNumIndexLabel, secondLabel: p1SecondNumIndexLabel)
        }
    }
    
    func runPlayerTwoGameModel (_ calcultionType: Int) {
        if calcultionType == 0 {            //加
            answerForPlayerTwo = plusGameModel(buttonCollection: p2AnswerSelectButton, firstLabel: p2FirstNumIndexLabel, secondLabel: p2SecondNumIndexLabel)
        } else if calcultionType == 1 {     //減
            answerForPlayerTwo = subtractGameModel(buttonCollection: p2AnswerSelectButton, firstLabel: p2FirstNumIndexLabel, secondLabel: p2SecondNumIndexLabel)
        } else {                            //乘
            answerForPlayerTwo = multGameModel(buttonCollection: p2AnswerSelectButton, firstLabel: p2FirstNumIndexLabel, secondLabel: p2SecondNumIndexLabel)
        }
    }
    
    
    
    /// **電腦執行項目**
    @objc func runPlayerCpmputerGameModel () {
        if calculationIndex! == 0 {            //加
            answerForPlayerTwo = plusGameModel(buttonCollection: p2AnswerSelectButton, firstLabel: p2FirstNumIndexLabel, secondLabel: p2SecondNumIndexLabel)
            
            checkComputerAnswer ()
        } else if calculationIndex! == 1 {     //減
            answerForPlayerTwo = subtractGameModel(buttonCollection: p2AnswerSelectButton, firstLabel: p2FirstNumIndexLabel, secondLabel: p2SecondNumIndexLabel)
            checkComputerAnswer ()
        } else {                            //乘
            answerForPlayerTwo = multGameModel(buttonCollection: p2AnswerSelectButton, firstLabel: p2FirstNumIndexLabel, secondLabel: p2SecondNumIndexLabel)
            checkComputerAnswer ()
        }
    }
    
    func checkComputerAnswer () {
        if p2AnswerSelectButton[0].currentTitle == String(answerForPlayerTwo) {
            playerTwoAnswerCorrectTimes += 1
        }
    }
    
    
    //電腦自動跑function的時間參數function
    func getComputerDifficuityToTimer(_ difficuity:Int) -> Double {
        switch difficuity {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 1.5
        default:
            return 3
        }
    }
    
    
    
    
    //MARK:++++++++++++++++++++加法++++++++++++++++++++

    func plusGameModel (buttonCollection:[UIButton], firstLabel:UILabel, secondLabel:UILabel) -> Int {
        buttonColor.shuffle()
        let numberOne = plusDifficlityCheck(difficuityIndex!)
        let numberTwo = plusDifficlityCheck(difficuityIndex!)
        firstLabel.text = String(numberOne)
        secondLabel.text = String(numberTwo)
        let answer = numberOne + numberTwo
        let randomOne = plusRandom(difficuityIndex!)
        let randomTwo = plusRandom(difficuityIndex!)
        var buttonTitleIndexArray = [answer,randomTwo,randomOne]
        buttonTitleIndexArray.shuffle()
        for i in buttonCollection.indices {
            buttonCollection[i].setTitle(String(buttonTitleIndexArray[i]), for: .normal)
            buttonCollection[i].backgroundColor = buttonColor[i]
        }
        return answer
                    
    }
    
    
    //依照加法難度給加法隨機數
    
    func plusRandom(_ difficuity:Int) -> Int {
        switch difficuity {
        case 0:
            return Int.random(in: 0...10)
        case 1:
            return Int.random(in: 0...200)
        case 2:
            return Int.random(in: 0...19998)
        default:
            return 0
        }
    }
    
    //依照加法難度給加法參數
    func plusDifficlityCheck (_ difficuity:Int) -> Int {
        switch difficuity {
        case 0:
            return Int.random(in: 0...10)
        case 1:
            return Int.random(in: 0...100)
        case 2:
            return Int.random(in: 0...9999)
        default:
            return 0
        }
    }
    

    
    
    
    
    
    //MARK:－－－－－－－－－－減法－－－－－－－－－－－－
    
    func subtractGameModel (buttonCollection:[UIButton], firstLabel:UILabel, secondLabel:UILabel)  -> Int {
        buttonColor.shuffle()
        let numberOne = subtractDifficlityCheck(difficuityIndex!)
        let numberTwo = subtractDifficlityCheck(difficuityIndex!)
        firstLabel.text = String(numberOne)
        secondLabel.text = String(numberTwo)
        let answer = numberOne - numberTwo
        let randomOne = subtractRandom(difficuityIndex!)
        let randomTwo = subtractRandom(difficuityIndex!)
        var buttonTitleIndexArray = [answer,randomTwo,randomOne]
        buttonTitleIndexArray.shuffle()
        for i in buttonCollection.indices {
            buttonCollection[i].setTitle(String(buttonTitleIndexArray[i]), for: .normal)
            buttonCollection[i].backgroundColor = buttonColor[i]
        }
        return answer
                    
    }
    
    //依照減法難度給加法隨機數
    func subtractRandom(_ difficuity:Int) -> Int {
        switch difficuity {
        case 0:
            return Int.random(in: -20...20)
        case 1:
            return Int.random(in: -100...100)
        case 2:
            return Int.random(in: -1000...1000)
        default:
            return 0
        }
    }
    
    ////依照減法難度給加法參數
    func subtractDifficlityCheck (_ difficuity:Int) -> Int {
        switch difficuity {
        case 0:
            return Int.random(in: 0...20)
        case 1:
            return Int.random(in: 0...100)
        case 2:
            return Int.random(in: 0...1000)
        default:
            return 0
        }
    }
    
    
    
    

    
    
    
    //MARK:XXXXXXXXXXXXXXXXXXXXXXXXXXXXX 除法 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX**
    
    
    func multGameModel (buttonCollection:[UIButton], firstLabel:UILabel, secondLabel:UILabel)  -> Int {
        buttonColor.shuffle()
        let numberOne = multOneDifficlityCheck(difficuityIndex!)
        let numberTwo = multTwoDifficlityCheck(difficuityIndex!)
        firstLabel.text = String(numberOne)
        secondLabel.text = String(numberTwo)
        let answer = numberOne * numberTwo
        let randomOne = multRandom(difficuityIndex!)
        let randomTwo = multRandom(difficuityIndex!)
        var buttonTitleIndexArray = [answer,randomTwo,randomOne]
        buttonTitleIndexArray.shuffle()
        for i in buttonCollection.indices {
            buttonCollection[i].setTitle(String(buttonTitleIndexArray[i]), for: .normal)
            buttonCollection[i].backgroundColor = buttonColor[i]
        }
        return answer
    }
    
    //依照除法難度給除法隨機數
    func multRandom(_ difficuity:Int) -> Int {
        switch difficuity {
        case 0:
            return Int.random(in: 1...99)
        case 1:
            return Int.random(in: 99...891)
        case 2:
            return Int.random(in: 99...8901)
        default:
            return 0
        }
    }
    
    //依照除法難度給除法參數
    func multOneDifficlityCheck (_ difficuity:Int) -> Int {
        switch difficuity {
        case 0:
            return Int.random(in: 1...9)
        case 1:
            return Int.random(in: 1...9)
        case 2:
            return Int.random(in: 1...99)
        default:
            return 0
        }
    }
    //依照除法難度給除法第二個參數
    func multTwoDifficlityCheck (_ difficuity:Int) -> Int {
        switch difficuity {
        case 0:
            return Int.random(in: 1...9)
        case 1:
            return Int.random(in: 1...99)
        case 2:
            return Int.random(in: 1...99)
        default:
            return 0
        }
    }
    
    
    
    
    ///**警告視窗**
    func showWInAlert (title:String, message:String) {
        //"恭喜獲勝！", message: "你超棒的啦"
        let alert = UIAlertController (title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "了解", style: .default, handler: nil))
        present(alert, animated: false) {
            if self.playerIndex == 2 {
                alert.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
        }
    }
    
    
    
    
    ///**除存CoreData Function**
    func saveCoreDateInfo () {
        let result = TimeRecord(context: context)
        let date = Date()
        result.recordDate = date
        result.recordTime = Int32(timeIndex)
        result.recordType = "\(difficuityIndex!)\(calculationIndex!)"
        try! context.save()
        
    }
    
    
    
    ///**button顯示與否Function**
    func replayAndBackFrontButtonIsHidden (replay:Bool, backFront:Bool, p1stack:Bool, p2stack:Bool) {
        replayButton.isHidden = replay
        backFrontButton.isHidden = backFront
        p1StackView.isHidden = p1stack
        p2StackView.isHidden = p2stack
    }
    
    
    
    
    // MARK: 開始玩button
    @IBAction func startToplay(_ sender: UIButton) {
        sender.isHidden = true
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(runtimer), userInfo: nil, repeats: true)
        if playerIndex == 1 {
            timerForComputer = Timer.scheduledTimer(timeInterval: Double(getComputerDifficuityToTimer(difficuityIndex!)), target: self, selector: #selector(runPlayerCpmputerGameModel), userInfo: nil, repeats: true)
        }
        if playerIndex == 0 {
            replayAndBackFrontButtonIsHidden(replay: true, backFront: true, p1stack: false, p2stack: true)
            
        }else{
            replayAndBackFrontButtonIsHidden(replay: true, backFront: true, p1stack: false, p2stack: false)
        }
        
    }
    
    //每0.01秒timeIndex ＋1 用在 timer的scheduledTimer使用
    @objc func runtimer () {
        timeIndex += 1
        
    }
    
    
    
    
    

    // MARK: - p1的3個button
    @IBAction func playerOneChooseANswer(_ sender: UIButton) {
        
        if playerOneAnswerCorrectTimes != 15 {
            if sender.currentTitle == String(answerForPlayerOne) {
                playerOneTrafficImage.frame.origin.x += avgMoveDIstance!
                playerOneAnswerCorrectTimes += 1
            }else{
                if difficuityIndex == 2, playerOneAnswerCorrectTimes != 0  {
                    playerOneAnswerCorrectTimes -= 1
                }
            }
        }else{
            if sender.currentTitle == String(answerForPlayerOne) {
                playerOneTrafficImage.frame.origin.x = runwayImageView.frame.maxX - playerOneTrafficImage.frame.width
                playerOneAnswerCorrectTimes = 17
            }else{
                if difficuityIndex == 2, playerOneAnswerCorrectTimes != 0  {
                    playerOneAnswerCorrectTimes -= 1
                }
            }
        }

        runPlayerOneGameModel(calculationIndex!)
        
        if playerOneAnswerCorrectTimes == 17 {
            timer?.invalidate()
            saveCoreDateInfo()
            showWInAlert(title: "玩家1獲勝", message: "數學很棒！")
            replayAndBackFrontButtonIsHidden(replay: false, backFront: false, p1stack: true ,p2stack: true)
            if playerIndex == 1 {           //若是電腦對戰停止computer前進
                timerForComputer?.invalidate()
            }
            
        }
    }
    
    
    
    
    
    // MARK: - p2的3個button
    @IBAction func playerTwoChooseAnswer(_ sender: UIButton) {
        
        if playerIndex == 2 {
            if playerTwoAnswerCorrectTimes != 15 {
                if sender.currentTitle == String(answerForPlayerTwo) {
                    playerTwoTrafficImage.frame.origin.x += avgMoveDIstance!
                    playerTwoAnswerCorrectTimes += 1
                }else{
                    if difficuityIndex == 2, playerTwoAnswerCorrectTimes != 0 {
                        playerTwoAnswerCorrectTimes -= 1
                    }
                }
            }else{
                if sender.currentTitle == String(answerForPlayerTwo) {
                    playerTwoTrafficImage.frame.origin.x = runwayImageView.frame.maxX - playerTwoTrafficImage.frame.width
                    playerTwoAnswerCorrectTimes = 17
                }else{
                    if difficuityIndex == 2, playerTwoAnswerCorrectTimes != 0 {
                        playerTwoAnswerCorrectTimes -= 1
                    }
                }
            }
            runPlayerTwoGameModel(calculationIndex!)
            
        }

    }
    
    
    
    
    // MARK: 返回首頁
    @IBAction func backFrontPageVC(_ sender: UIButton) {
        self.view.window?.rootViewController?.dismiss(animated:  true , completion:  nil )
    }
    
    // MARK: 重玩
    @IBAction func replay(_ sender: UIButton) {
        computerAnswerCorrectTimes = 0
        playerTwoAnswerCorrectTimes = 0
        playerOneAnswerCorrectTimes = 0
        timeIndex = 0
        playerOneTrafficImage.frame.origin.x = runwayImageView.frame.minX
        playerTwoTrafficImage.frame.origin.x = runwayImageView.frame.minX
        replayAndBackFrontButtonIsHidden(replay: true, backFront: true, p1stack: true, p2stack: true)
        startButton.isHidden = false
        
    }
    

}
