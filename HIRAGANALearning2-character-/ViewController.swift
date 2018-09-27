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



//ゲーム・音量設定・カード設定・送受信への案内VC
class ViewController: UIViewController {
    let realm = try! Realm()

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var communicationButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var switchControlButton: UIButton!

    let wordArray = ["やま", "くるま", "にわとり", "れもん", "らいおん", "もも", "めろん", "みかん", "ふね", "ひこうき", "ねこ", "いぬ", "とら", "とまと", "とうもろこし", "すいか", "しんかんせん", "さる", "さつまいも", "こあら", "くま", "きりん", "きゅうり", "きのこ", "きつね", "うま", "うし"]
//     "め", "みみ", "ひ", "は", "て", "くつした", "すいとう"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultDataInput()
        layoutSetting()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func defaultDataInput(){
//        UserDefaults.standard.set(false, forKey: Constants.defaultSettingKey)
        
        if !UserDefaults.standard.bool(forKey: Constants.defaultSettingKey){
            for i in 0 ..< wordArray.count{
                print(wordArray[i])
                let card = Card()
                card.id = i
                card.word = wordArray[i]
                card.originalDeck1 = true
                card.image = UIImagePNGRepresentation(UIImage(named: wordArray[i])!)! as NSData
                try! realm.write{
                    realm.add(card, update: true)
                }
            }
            UserDefaults.standard.set(0, forKey: Constants.gameLevelKey)
            UserDefaults.standard.set(false, forKey: Constants.characterShouUpKey)
            UserDefaults.standard.set(false, forKey: Constants.useSimilarKey)
            UserDefaults.standard.set(false, forKey: Constants.useDakuonKey)
            UserDefaults.standard.set(false, forKey: Constants.useYouonKey)
            UserDefaults.standard.set(0, forKey: Constants.amountOfChoicesKey)
            UserDefaults.standard.set(true, forKey: Constants.useColorHintKey)
            UserDefaults.standard.set(0, forKey: Constants.syllabaryLevelKey)
            UserDefaults.standard.set(1, forKey: Constants.syllabaryLinesKey)
            UserDefaults.standard.set(Float(0.5), forKey: Constants.volumeKey)
            UserDefaults.standard.set(false, forKey: Constants.tapSoundKey)
            UserDefaults.standard.set(false, forKey: Constants.correctSoundKey)
            UserDefaults.standard.set(false, forKey: Constants.incorrectSoundKey)
            
            UserDefaults.standard.set(true, forKey: Constants.defaultSettingKey)
        }
    }
    
    func layoutSetting(){
        let VS = VisualSetting()
        VS.backgraundView(self)
        startButton.titleLabel?.font = VS.fontAdjust(viewSize: .important)
        cardButton.titleLabel?.font = VS.fontAdjust(viewSize: .normal)
        settingButton.titleLabel?.font = VS.fontAdjust(viewSize: .normal)
        switchControlButton.titleLabel?.font = VS.fontAdjust(viewSize: .normal)
        communicationButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        
        startButton.layer.cornerRadius = VS.cornerRadiusAdjust(startButton.frame.size, type: .normal)
        cardButton.layer.cornerRadius = VS.cornerRadiusAdjust(cardButton.frame.size, type: .normal)
        settingButton.layer.cornerRadius = VS.cornerRadiusAdjust(settingButton.frame.size, type: .normal)
        switchControlButton.layer.cornerRadius = VS.cornerRadiusAdjust(switchControlButton.frame.size, type: .normal)
        communicationButton.layer.cornerRadius = VS.cornerRadiusAdjust(communicationButton.frame.size, type: .normal)
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHome(segue:UIStoryboardSegue){
        
    }

}

