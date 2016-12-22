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

class SpeechViewController: UIViewController {
    
    @IBOutlet weak var textView: UILabel!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ///Speech
        microphoneButton.isEnabled = false

        
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
                case "上上":
                    print("上上")
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

