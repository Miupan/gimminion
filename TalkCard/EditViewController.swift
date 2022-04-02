//
//  EditViewController.swift
//  TalkCard
//
//  Created by 美羽 on 2021/06/09.
//

import AVFoundation
import UIKit
import CoreData

class EditViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate, NSFetchedResultsControllerDelegate, UITextFieldDelegate{
    
    var number: Int = 0
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var isRecording = false
    var isPlaying = false
    
    let settings = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 44100,
        AVNumberOfChannelsKey: 2,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    let dataManager = DataManager.shared
    
    @IBOutlet var registationImage:UIImageView!
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var conditionLabel:UILabel!
    @IBOutlet var nameTextField:UITextField!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var playButton: UIButton!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Card> = {
        let _controller:NSFetchedResultsController<Card> = dataManager.getFetchedResultController(with: ["date"])
        _controller.delegate = self
        return _controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //nameTextFieldのdelegateをEditViewControllerが受け取る
        nameTextField.delegate = self
        // Do any additional setup after loading the view.
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

    //CoreDataでデータの取得
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            
            print(error)
        }
    }

    @IBAction func recordButtonAction(){
        if !isRecording {
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord)
            try! session.setActive(true)
            
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
    
    func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func add(number: Int){
        
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
    
    @IBAction func saveButtonPressed() {
        guard nameTextField.text != nil else {
            return
        }
        //CoreData
        let dataManager = DataManager.shared
        let newCard = dataManager.create()
        dataManager.saveContext()
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
    


