//
//  SpeechViewController.swift
//  WorkoutClub
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 hackntuios.minithon.teama. All rights reserved.
//

import UIKit
import Speech
import CoreLocation

class SpeechViewController: UIViewController, UINavigationControllerDelegate {
    
    //@IBOutlet weak var textView: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var microphoneButton: UIButton!
    
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "zh-TW"))
    // en-US
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTast: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    @IBOutlet weak var redBtn: UIButton!
    @IBOutlet weak var greenBtn: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    
    @IBOutlet weak var startTimerBtn: UIButton!
    @IBOutlet weak var stopTimerBtn: UIButton!
    @IBOutlet weak var shareTimerBtn: UIButton!
    
    var zeroTime = TimeInterval()
    var timer : Timer = Timer()
    
    let locationManager = CLLocationManager()
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var distanceTraveled = 0.0
    
    @IBOutlet weak var tableView: UITableView!
    
    var HICTs:[HICTDataModel] = [
        HICTDataModel(image:"JumpingJacks", HICT: "開合跳", isDone: false)
        ]
    
    var HICTname:String = ""
    var deleteTableViewNumber = 0
    var HICTList = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ///Speech
        microphoneButton.isEnabled = false
        microphoneButton.layer.cornerRadius = 30
        microphoneButton.layer.masksToBounds = true
        
        locationManager.requestWhenInUseAuthorization();
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        else {
            print("Location service disabled");
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
            case .restricted:
                isButtonEnabled = false
                print("Speed recognition restricted on the device")
            case .notDetermined:
                isButtonEnabled = false
                print("Speed recongnition not yet authorized")
            }
            
            OperationQueue.main.addOperation {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func microphoneTapped(_ sender: Any) {
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
            microphoneButton.setTitle("Start Recording", for: .normal)
        } else {
            startRecording()
            microphoneButton.setTitle("Stop Recording", for: .normal)
        }
        
    }

    
    func startRecording() {
        if recognitionTast != nil {
            recognitionTast?.cancel()
            recognitionTast = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode =  audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecongnitionReuset object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTast = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.textView.text = result?.bestTranscription.formattedString
                
                //TODO :-  控制UI,取後面兩個字串,命令字串只有兩個字
                let saySomething: String = self.textView.text!
                
                let saySomethingLength = saySomething.characters.count
                print(saySomethingLength)
                
                let subString2 = saySomething[saySomething.index(saySomething.endIndex, offsetBy: -2)..<saySomething.endIndex]
                
                //TODO: 傳 enum 判斷 sport type, 開合跳 
                
                switch subString2 {
                case "測試":
                    print("Good")
                case "紅燈":
                    print("RED")
                    self.redBtn.setTitle("RED", for: .normal)
                    self.greenBtn.setTitle("", for: .normal)
                case "綠燈":
                    print("Green")
                    self.greenBtn.setTitle("Green", for: .normal)
                    self.redBtn.setTitle("", for: .normal)
                case "開始":
                    print("開始:")
                    self.greenBtn.setTitle("Green", for: .normal)
                    self.redBtn.setTitle("Red", for: .normal)
                    //self.startTimerBtn.addTarget(self, action: #selector(SpeechViewController.startTimer), for: .touchUpInside)
                    self.speechStartTimer()
                    self.startTimerBtn.showsTouchWhenHighlighted = true
                    self.startTimerBtn.alpha = 0.5
                    self.shareTimerBtn.alpha = 0.5
                case "暫停":
                    print("暫停")
                case "停止":
                    print("停止")
                    self.speechStopTimer()
                    self.stopTimerBtn.alpha = 0.5
                    self.startTimerBtn.alpha = 1.0
                    self.shareTimerBtn.alpha = 1.0
                case "下下":
                    print("下下")
                    self.deleteTableViewNumber += 1
                case "上上":
                    print("上上")
                    self.addBtnAction()
                case "關閉":
                    print("關閉")
                    //                        isFinal = true
                    //                        self.audioEngine.stop()
                    //                        inputNode.removeTap(onBus: 0)
                    //
                    //                        self.recognitionRequest = nil
                    //                        self.recognitionTast = nil
                    //
                //                        self.microphoneButton.isEnabled = true
                case "合跳":
                    print("開合跳")
                    self.HICTname = "開合跳"
                    self.addBtnAction()
                case "空椅":
                    print("坐太空椅")
                    self.HICTname = "坐太空椅"
                    self.addWallSitAction()
                case "伏地挺身":
                    print("伏地挺身")
                    self.HICTname = "伏地挺身"
                    self.addPushUpAction()
                case "捲腹":
                    print("捲腹")
                    self.HICTname = "捲腹"
                    self.addAbdominalCrunchAction()
                case "登階":
                    print("登階")
                    self.HICTname = "登階"
                    self.addStepUpOntoChairAction()
                case "OK":
                    self.HICTList += 1
                    self.addHICTAction()
                    
                default:
                    print("Error")
                }
                
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTast = nil
                
                self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        textView.text = "Say something, I listening!"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func startTimer(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(SpeechViewController.updateTime), userInfo: nil, repeats: true)
        zeroTime = Date.timeIntervalSinceReferenceDate
        
        distanceTraveled = 0.0
        startLocation = nil
        lastLocation = nil
        
        locationManager.startUpdatingLocation()
    }
    
    func speechStartTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(SpeechViewController.updateTime), userInfo: nil, repeats: true)
        zeroTime = Date.timeIntervalSinceReferenceDate
        
        distanceTraveled = 0.0
        startLocation = nil
        lastLocation = nil
        
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func stopTimer(_ sender: Any) {
        timer.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    func speechStopTimer() {
        timer.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func share(_ sender: Any) {
        print("test")
        red()
    }
    
    func updateTime() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        var timePassed: TimeInterval = currentTime - zeroTime
        let minutes = UInt8(timePassed / 60.0)
        timePassed -= (TimeInterval(minutes) * 60)
        let seconds = UInt8(timePassed)
        timePassed -= TimeInterval(seconds)
        let millisecsX10 = UInt8(timePassed * 100)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strMSX10 = String(format: "%02d", millisecsX10)
        
        timerLabel.text = "\(strMinutes):\(strSeconds):\(strMSX10)"
        
        if timerLabel.text == "60:00:00" {
            timer.invalidate()
            locationManager.stopUpdatingLocation()
        }
    }
    
    // 按下新增按鈕時執行動作的方法
    func addBtnAction() {
        print("新增一筆資料")
        //info.insert("new row", at: 0)
        HICTs.insert(HICTDataModel(image:"JumpingJacks", HICT: HICTname, isDone: false), at: 0)
        // 新增 cell 在第一筆 row
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        tableView.endUpdates()
    }
    
    func addWallSitAction() {
        HICTs.insert(HICTDataModel(image:"WallSit", HICT: HICTname, isDone: false), at: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        tableView.endUpdates()
    }
    
    func addPushUpAction() {
        HICTs.insert(HICTDataModel(image:"Push-up", HICT: HICTname, isDone: false), at: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        tableView.endUpdates()
    }
    
    func addAbdominalCrunchAction() {
        HICTs.insert(HICTDataModel(image:"AbdominalCrunch", HICT: HICTname, isDone: false), at: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        tableView.endUpdates()
    }
    
    func addStepUpOntoChairAction() {
        HICTs.insert(HICTDataModel(image:"Step-upOntoChair", HICT: HICTname, isDone: false), at: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        tableView.endUpdates()
    }
    
    func addHICTAction() {
        print("新增一筆資料")
        switch HICTList {
        case 1:
            HICTs.insert(HICTDataModel(image:"WallSit", HICT: "坐太空椅", isDone: false), at: 0)
        case 2:
            HICTs.insert(HICTDataModel(image:"Push-up", HICT: "伏地挺身", isDone: false), at: 0)
        case 3:
            HICTs.insert(HICTDataModel(image:"AbdominalCrunch", HICT: "捲腹", isDone: false), at: 0)
        case 4:
            HICTs.insert(HICTDataModel(image:"Step-upOntoChair", HICT: "登階", isDone: false), at: 0)
        case 5:
            HICTs.insert(HICTDataModel(image:"Squat", HICT: "深蹲", isDone: false), at: 0)
        case 6:
            HICTs.insert(HICTDataModel(image:"TricepsDipOnChair", HICT: "三頭肌撐體", isDone: false), at: 0)
        case 7:
            HICTs.insert(HICTDataModel(image:"Plank", HICT: "棒式", isDone: false), at: 0)
        case 8:
            HICTs.insert(HICTDataModel(image:"HighKneesRunningInPlace", HICT: "原地高抬膝", isDone: false), at: 0)
        case 9:
            HICTs.insert(HICTDataModel(image:"Lunge", HICT: "弓步", isDone: false), at: 0)
        case 10:
            HICTs.insert(HICTDataModel(image:"Push-upAndRotation", HICT: "T型伏地挺身", isDone: false), at: 0)
        case 11:
            HICTs.insert(HICTDataModel(image:"SidePlank", HICT: "側棒式", isDone: false), at: 0)
        case 12:
            HICTs.insert(HICTDataModel(image:"HandsomeBoy", HICT: "You got it", isDone: false), at: 0)
            //dismiss(animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        default:
            print("error")
            HICTList -= 1
        }
        // 新增 cell 在第一筆 row
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        tableView.endUpdates()
    }

}

extension SpeechViewController: SFSpeechRecognizerDelegate {
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
    
}

extension SpeechViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first as CLLocation!
        } else {
            let lastDistance = lastLocation.distance(from: locations.last as CLLocation!)
            distanceTraveled += lastDistance * 0.000621371
            
            let trimmedDistance = String(format: "%.2f", distanceTraveled)
            
            milesLabel.text = "\(trimmedDistance) Miles"
        }
        
        lastLocation = locations.last as CLLocation!
    }
}

extension SpeechViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HICTs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DoneCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HICTTableViewCell
        
        // Configure the cell...
        cell.thumbnailImageView.image = UIImage(named: HICTs[indexPath.row].image)
        cell.nameLabel.text = HICTs[indexPath.row].HICT
        //cell.accessoryType = HICTs[indexPath.row].isDone ? .checkmark : .none
        
        return cell
    }
}

extension SpeechViewController: UITableViewDelegate {
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            HICTs.remove(at: indexPath.row)
            print(indexPath.row)
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        print(indexPath)
//        if deleteTableViewNumber == 1 {
//            // Delete the row from the data source
//            if editingStyle == .delete {
//                // Delete the row from the data source
//                HICTs.remove(at: 1)
//            }
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
        
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // Social Sharing Button
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Share", handler: { (action, indexPath) -> Void in
            
            let defaultText = "Just checking in at " + self.HICTs[indexPath.row].HICT
            if let imageToShare = UIImage(named: self.HICTs[indexPath.row].image) {
                let activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        })
        
        // Delete button
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete",handler: { (action, indexPath) -> Void in
            
            // Delete the row from the data source
            self.HICTs.remove(at: indexPath.row)
            print(indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            print(indexPath)
        })
        
//        if deleteTableViewNumber == 1 {
//            // Delete the row from the data source
//            self.HICTs.remove(at: 1)
//            
//            self.tableView.deleteRows(at: [indexPath], with: .fade)
//
//        }
        
        // Set the button color
        shareAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        return [deleteAction, shareAction]
    }
    
    
    //TODO:- TEST
    func red() {
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            
            if editingStyle == .delete {
                // Delete the row from the data source
                HICTs.remove(at: 0)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            //        if deleteTableViewNumber == 1 {
            //            // Delete the row from the data source
            //            if editingStyle == .delete {
            //                // Delete the row from the data source
            //                HICTs.remove(at: 1)
            //            }
            //            tableView.deleteRows(at: [indexPath], with: .fade)
            //        }
        }
        
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            
            // Social Sharing Button
            let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Share", handler: { (action, indexPath) -> Void in
                
                let defaultText = "Just checking in at " + self.HICTs[indexPath.row].HICT
                if let imageToShare = UIImage(named: self.HICTs[indexPath.row].image) {
                    let activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
                    self.present(activityController, animated: true, completion: nil)
                }
            })
            
            // Delete button
            let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete",handler: { (action, indexPath) -> Void in
                
                // Delete the row from the data source
                //indexPath = 1
                self.HICTs.remove(at: 1)
                
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            })
            
            //        if deleteTableViewNumber == 1 {
            //            // Delete the row from the data source
            //            self.HICTs.remove(at: 1)
            //
            //            self.tableView.deleteRows(at: [indexPath], with: .fade)
            //
            //        }
            
            // Set the button color
            shareAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
            deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
            
            return [deleteAction, shareAction]
        }

        
    }


}

