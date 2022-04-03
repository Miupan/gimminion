//
//  EditViewController.swift
//  TalkCard
//
//  Created by 美羽 on 2021/06/09.
//

import AVFoundation
import UIKit

class EditViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextFieldDelegate{
    
    var number: Int = 0
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var isRecording = false
    var isPlaying = false
    
    var recievedTitle: String = ""
    
    @IBOutlet var registationImage:UIImageView!
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var conditionLabel:UILabel!
    @IBOutlet var nameTextField:UITextField!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //nameTextFieldのdelegateをEditViewControllerが受け取る
        nameTextField.delegate = self
        if recievedTitle == "" {
            //タイトルがきてない→再生も録音もできないのでエラー処理をする
        }
    }
    
    //画面をタッチした時キーボードをしまう
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Return押した時にキーボードしまう
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //キーボードを非表示にする
        nameTextField.endEditing(true)
        return true
    }

    @IBAction func recordButtonAction(){
        if !isRecording {
            let session = AVAudioSession.sharedInstance()
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
        let url = docsDirect.appendingPathComponent(recievedTitle)
        return url
        
    }
    
    @IBAction func playButtonAction(){
        if !isPlaying {
            //let audioSession = AVAudioSession.sharedInstance()
            //try audioSession.setCategory(AVAudioSession.Category.ambient)
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
    
    //カメラロール使用時に選択した画像をアプリ内に表示するメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        registationImage.image = info[.editedImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    //画像入れるメソッド
    @IBAction func putImageButton(){
        //カメラロール使えるか？確認
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //カメラロールの画像選択→画像表示までの一連の流れ
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        }
        
    }

}


