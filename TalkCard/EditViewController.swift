//
//  EditViewController.swift
//  TalkCard
//
//  Created by 美羽 on 2021/06/09.
//

import AVFoundation
import UIKit

class EditViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    
    var number: Int = 0
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var isRecording = false
    var isPlaying = false
    
    @IBOutlet var registationImage:UIImageView!
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var conditionLabel:UILabel!
    @IBOutlet var nameTextField:UITextField!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func recordButtonAction(){
        if !isRecording {
            let  session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord)
            try! session.setActive(true)
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try! AVAudioRecorder(url: getURL(), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            isRecording = true //録音中の状態
            conditionLabel.text = "録音中"
            recordButton.setTitle("停止", for: .normal)
            playButton.isEnabled = false
        }else{
            audioRecorder.stop()
            isRecording = false //録音する前の状態
            conditionLabel.text = "録音待機"
            recordButton.setTitle("録音する", for: .normal)
            playButton.isEnabled = true
        }
    }
    
    func getURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let url = docsDirect.appendingPathComponent(stringFromDate(date: Date(), format: "yyyyMMddHHmmSS"))
        return url
        
    }
    
    @IBAction func playButtonAction(){
        if !isPlaying {
            audioPlayer = try! AVAudioPlayer(contentsOf: getURL())
            audioPlayer.delegate = self
            audioPlayer.play()
            
            isPlaying = true //再生中の状態
            conditionLabel.text = "再生中"
            playButton.setTitle("停止", for: .normal)
            recordButton.isEnabled = false
        }else{
            audioPlayer.stop()
            isPlaying = false //再生停止中の状態
            conditionLabel.text = "録音待機"
            playButton.setTitle("再生", for: .normal)
            recordButton.isEnabled = true
        }
        
    }
    
    func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func add(number: Int){
        
    }
    
    //画像入れるメソッド
    @IBAction func putImageButton(){
        
        
    }
    

    //userdefaultsに保存する公式
    let saveData: UserDefaults = UserDefaults.standard
    
    @IBAction func saveButton(){
        //userdefaultsに書き込み
        saveData.set(registationImage.image, forKey: "image")
        saveData.set(nameTextField.text, forKey: "cardname")
    }
    
    
    
}
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    

