//
//  ViewController.swift
//  TalkCard
//
//  Created by 美羽 on 2021/06/02.
//

import AVFoundation
import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AVAudioPlayerDelegate{
    
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var selectedTitle = String()
    
    var audioPlayer: AVAudioPlayer!
    
    var isPlaying = false
    
    //カード名をuserdefaultsに保存できるように
    let cardName:[String] = ["はい", "いいえ", "ありがとう", "ごめんなさい", "ちょっとキツイ", "やりたい！", "おはよう", "久しぶり", "じゃあね"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionViewFlowLayout.estimatedItemSize = CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.height / 4)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //cellの数を指定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //cellの数
        return cardName.count
    }
    
    //ID付きのcellを取得
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCell
        cell.delegate = self
        cell.nameLabel.text = cardName[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedTitle = cardName[indexPath.row]
        
        if !isPlaying {
            //let audioSession = AVAudioSession.sharedInstance()
            //try audioSession.setCategory(AVAudioSession.Category.ambient)
            audioPlayer = try! AVAudioPlayer(contentsOf: getURL())
            audioPlayer.delegate = self
            audioPlayer.play()
            
            isPlaying = true //再生中の状態
        }else{
            audioPlayer.stop()
            isPlaying = false //再生停止中の状態
        }
            
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toEditViewController" {
            let vc = segue.destination as! EditViewController
            vc.recievedTitle = selectedTitle
        }
    }
        
    func getURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let url = docsDirect.appendingPathComponent(selectedTitle)
        return url
    }
}
        


extension ViewController: CardCellDelegate {
    func editButtonPressed(title: String) {
        // editボタンが押されたときの処理
        selectedTitle = title
        performSegue(withIdentifier: "toEditViewController", sender: nil)
    }
}

    
