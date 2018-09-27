//
//  EditDeckViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/05.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit
import RealmSwift

// デッキ編集
class EditDeckViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var inDeckCV: UICollectionView!
    @IBOutlet weak var outOfDeckCV: UICollectionView!
    
    let realm = try! Realm()
    
    var collectionCard: CollectionCardData!
    
    var deckInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetting()
        
        
        let nib = UINib(nibName: "CardCollectionViewCell", bundle: nil)
        inDeckCV.dataSource = self
        inDeckCV.delegate = self
        inDeckCV.register(nib, forCellWithReuseIdentifier: "Cell")
        outOfDeckCV.dataSource = self
        outOfDeckCV.delegate = self
        outOfDeckCV.register(nib, forCellWithReuseIdentifier: "Cell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let results = realm.objects(Card.self).sorted(byKeyPath: "id", ascending: true)
        collectionCard = CollectionCardData.init(results)
        collectionCard.deckSort()
        collectionCard.deckSieve(deckInt)
        
        inDeckCV.reloadData()
        outOfDeckCV.reloadData()
    }
    
    func layoutSetting(){
        VisualSetting().backgraundView(self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1{
            return collectionCard.resultCardDataArray.count
        }else{
            return collectionCard.restCardDataArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CardCollectionViewCell
        
        if collectionView.tag == 1{
            cell.createCard(collectionCard.resultCardDataArray[indexPath.row])
        }else{
            cell.createCard(collectionCard.restCardDataArray[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectDeck = deckInt
        if collectionView.tag == 1{
            let selectCD = collectionCard.resultCardDataArray[indexPath.row]
            collectionCard.putOutDeck(selectCD, selectDeck)
        }else{
            let selectCD = collectionCard.restCardDataArray[indexPath.row]
            collectionCard.putInDeck(selectCD, selectDeck)
        }
        inDeckCV.reloadData()
        outOfDeckCV.reloadData()
    }
    
    @IBAction func deckChange(_ sender: UISegmentedControl) {
        deckInt = segmentedControl.selectedSegmentIndex
        collectionCard.deckSieve(deckInt)
        inDeckCV.reloadData()
        outOfDeckCV.reloadData()
    }
    
    
    @IBAction func exitButton(_ sender: Any) {
        collectionCard.editDeck()
        self.dismiss(animated: true, completion: nil)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
