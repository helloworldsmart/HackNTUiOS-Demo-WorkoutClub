//
//  SpeechViewController.swift
//  WorkoutClub
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 hackntuios.minithon.teama. All rights reserved.
//

import UIKit
import Speech

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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ///Speech
        microphoneButton.isEnabled = false

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
                case "暫停":
                    print("暫停")
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

