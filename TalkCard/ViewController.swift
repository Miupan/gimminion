//
//  ViewController.swift
//  TalkCard
//
//  Created by 美羽 on 2021/06/02.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate{
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var number:Int = 0
    var selectednumber:Int = 0
    
    //カード名の配列
    let cardName:[String] = ["はい", "いいえ", "ありがとう", "ごめんなさい", "ちょっとキツイ", "やりたい！", "おはよう", "久しぶり", "じゃあね"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionViewFlowLayout.estimatedItemSize = CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.height / 4)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //DataManagerの宣言
    let dataManager = DataManager.shared
    //DataManagerの読み出し
    lazy var fetchedResultsController: NSFetchedResultsController<Card> = {
        let _controller:NSFetchedResultsController<Card> = dataManager.getFetchedResultController(with: ["date"])
        _controller .delegate = self
        return _controller
    }()
    
    //データ取得
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
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


