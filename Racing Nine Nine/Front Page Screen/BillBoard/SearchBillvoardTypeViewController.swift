//
//  SearchBillvoardTypeViewController.swift
//  Racing Nine Nine
//
//  Created by Dogpa's MBAir M1 on 2021/11/30.
//

import UIKit
import CoreData

class SearchBillvoardTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext   //設定CordData
    var record: [TimeRecord]? {                                                                     //儲存CoreData資料
        didSet {
            if record != nil, record!.count > 0 {
                sortIndexArray = []
                var rankingIndex = 0
                for _ in record!.indices {
                    rankingIndex += 1
                    sortIndexArray.append(rankingIndex)
                }
            }
        }
    }
    
    @IBOutlet var difficuityButton: [UIButton]!         //難度Button的Collection
    
    @IBOutlet var calculationButton: [UIButton]!        //計算方式Button的Collection
    
    @IBOutlet weak var rankingTableView: UITableView!   //TableView
    
    var difficuity: Int? {                              //難度
        didSet {
            if difficuity != nil{
                tableViewIndexObsverer(button: difficuityButton, indexToSteBorder: difficuity!)
            }
        }
    }
    var calculation: Int? {                             //計算方式
        didSet{
            if calculation != nil {
                tableViewIndexObsverer(button: calculationButton, indexToSteBorder: calculation!)
            }
        }
    }
    var sortIndexArray:[Int] = []                       //儲存排名array用在顯示排名使用
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCoreData()
        setLayerCornerRadius(difficuityButton)
        setLayerCornerRadius(calculationButton)
        if calculation == nil , difficuity == nil {
            calculation = 0
            difficuity = 0
            tableViewIndexObsverer(button: calculationButton, indexToSteBorder: calculation!)
            tableViewIndexObsverer(button: difficuityButton, indexToSteBorder: difficuity!)
        }
        
        
    }
    
    ///**抓CoreData資料**
    func fetchCoreData () {
        do{
            let request = TimeRecord.fetchRequest() as NSFetchRequest<TimeRecord>
            let pred = NSPredicate(format: "recordType CONTAINS '\(difficuity ?? 0)\(calculation ?? 0)'")
            let sort = NSSortDescriptor(key: "recordTime", ascending: true)
            
            request.predicate = pred
            request.fetchLimit = 7
            request.sortDescriptors = [sort]
            self.record = try context.fetch(request)
            
            //self.record = try context.fetch(Record.fetchRequest())
            
            DispatchQueue.main.async {
                self.rankingTableView.reloadData()
            }
        }catch{
        }
    }
    
    ///**自定義function偵測改變的值**
    func tableViewIndexObsverer (button: [UIButton], indexToSteBorder:Int) {
        resetBorder(button)
        button[indexToSteBorder].layer.borderWidth = CGFloat(5)
        button[indexToSteBorder].layer.borderColor = CGColor(srgbRed: 255/255, green: 100/255, blue: 100/255, alpha: 1)
        fetchCoreData()
    }
    
    
    
    //設定difficuity的參數
    @IBAction func difficuityIndexObserver(_ sender: UIButton) {
        difficuity = sender.tag
    }
    
    
    //設定calculation的參數
    @IBAction func calculationIndexObserver(_ sender: UIButton) {
        calculation = sender.tag
    }
    
    
    //返回首頁
    @IBAction func backFrontPage(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: TableView相關
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return record?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BillboardTableViewCell", for: indexPath) as? BillboardTableViewCell else {return UITableViewCell()}
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        
        cell.rankingLabel.text = String(sortIndexArray[indexPath.row])
        cell.timeLabel.text =  "時間：\(timerIndexToTimeString(Int(record![indexPath.row].recordTime)))" //String(record![indexPath.row].recordTime)
        cell.dateLabel.text = dateFormatter.string(from: record![indexPath.row].recordDate!)

        return cell
    }
    

}
