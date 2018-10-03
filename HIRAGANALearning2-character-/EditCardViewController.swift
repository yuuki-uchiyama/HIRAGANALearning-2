//
//  EditCardViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/05.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit
import RealmSwift

// カード編集
class EditCardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deckNoLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toHomeButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var SBView: UIView!
    @IBOutlet weak var deckSegmentControl: UISegmentedControl!
    @IBOutlet weak var SCView: UIView!
    @IBOutlet weak var cardCollectionView: UICollectionView!
    let realm = try! Realm()
    
    var collectionCard: CollectionCardData!

    var deckInt = -1
    var searchString = ""
    
    var SE: SoundEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSetting()
        SE = SoundEffect.sharedSoundEffect
        
        cardCollectionView.dataSource = self
        cardCollectionView.delegate = self
        searchBar.delegate = self
        
        let nib = UINib(nibName: "CardCollectionViewCell", bundle: nil)
        cardCollectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let results = realm.objects(Card.self).sorted(byKeyPath: "id", ascending: true)
        collectionCard = CollectionCardData.init(results)
        sortCard()
        
        cardCollectionView.reloadData()
        
    }
    
    func layoutSetting(){
        let VS = VisualSetting()
        VS.backgraundView(self)
        
        searchBar.frame = SBView.frame
        deckSegmentControl.frame = SCView.frame
        
        titleLabel.font = VS.fontAdjust(viewSize: .important)
        deckNoLabel.font = VS.fontAdjust(viewSize: .sentence)
        cancelButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        toHomeButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        VS.fontAdjustOfSegmentedControl(deckSegmentControl, .small)
        
        cancelButton.layer.cornerRadius = VS.cornerRadiusAdjust(cancelButton.frame.size, type: .small)
        toHomeButton.layer.cornerRadius = VS.cornerRadiusAdjust(toHomeButton.frame.size, type: .small)

        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionCard.resultCardDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CardCollectionViewCell
        cell.createCard(collectionCard.resultCardDataArray[indexPath.row])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SE.play(.card)
        performSegue(withIdentifier: "toAddCard", sender: collectionCard.resultCardDataArray[indexPath.row].card)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIScreen.main.bounds.size.width < 900.0{
            return CGSize(width: 70, height: 100)
        }else{
            return CGSize(width: 105, height: 150)
        }
    }
    
    @IBAction func deckChanged(_ sender: UISegmentedControl) {
        deckInt = sender.selectedSegmentIndex - 1
        sortCard()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchString = searchText
        sortCard()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func sortCard(){
        print("deckInt:\(deckInt) searchString:\(searchString)")
        collectionCard.search(deckInt, searchString)
        cardCollectionView.reloadData()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func soundPlay(_ sender: UIButton) {
        switch sender.tag{
        case 1:SE.play(.tap)
        case 2:SE.play(.cancel)
        case 3:SE.play(.important)
        default:break
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddCard"{
            let addCardVC = segue.destination as! AddCardViewController
            addCardVC.card = sender as? Card
            addCardVC.newCardBool = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func unwindToEditCard(segue:UIStoryboardSegue){
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
