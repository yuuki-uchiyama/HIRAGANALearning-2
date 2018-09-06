//
//  ViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/05.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit
import ChameleonFramework
import RealmSwift

class VisualSetting{
    func buttonAdjust(){
        
    }
    func colorAdjust(_ VC:UIViewController){
        VC.view.backgroundColor = UIColor.flatSandDark
        VC.view.layer.cornerRadius = 5.0
        VC.view.layer.borderWidth = VC.view.frame.height / 50
        VC.view.layer.borderColor = UIColor.flatOrange.cgColor
    }
}

//ゲーム・音量設定・カード設定・送受信への案内VC
class ViewController: UIViewController {
    let realm = try! Realm()

    let wordArray = ["やま", "くるま", "にわとり", "れもん", "らいおん", "もも", "めろん", "みかん", "ふね", "ひこうき", "ねこ", "いぬ", "とら", "とまと", "とうもろこし", "すいか", "しんかんせん", "さる", "さつまいも", "こあら", "くま", "きりん", "きゅうり", "きのこ", "きつね", "うま", "うし", "め", "みみ", "ひ", "は", "て", "くつした", "すいとう"]

    override func viewDidLoad() {
        super.viewDidLoad()
        VisualSetting().colorAdjust(self)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func defaultDataInput(){
        if !UserDefaults.standard.bool(forKey: Constants.defaultSettingKey){
            for i in 0 ... 49{
                let card = Card()
                card.id = i
                card.word = wordArray[i]
                card.originalDeck1 = true
                card.image = UIImagePNGRepresentation(UIImage(named: "\(wordArray[i])")!)! as NSData
                try! realm.write{
                    realm.add(card, update: true)
                }
            }
            UserDefaults.standard.register(defaults: [Constants.volumeKey: 0.5])
        }
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

