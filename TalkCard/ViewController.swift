//
//  ViewController.swift
//  TalkCard
//
//  Created by 美羽 on 2021/06/02.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet var collectionView: UICollectionView!
    
    var number:Int = 0
    var selectednumber:Int = 0
    
    //カード名の配列
    let cardName:[String] = ["はい", "いいえ", "ありがとう", "ごめんなさい"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        cell.nameLabel.text = cardName[indexPath.row]
        return cell
    }
    
    
    @IBAction func imageButton1(sender: UIButton) {
        selectednumber = sender.tag
        performSegue(withIdentifier: "EditViewController", sender: nil)
    }
    
    @IBSegueAction func toEditViewController(coder: NSCoder, sender:Any?, segueIdentifier: String?) -> EditViewController? {
        return EditViewController(coder: coder)
        
    }
}


