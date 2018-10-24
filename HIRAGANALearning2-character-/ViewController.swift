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
import AVFoundation
import BWWalkthrough


//ゲーム・音量設定・カード設定・送受信への案内VC
class ViewController: UIViewController, BWWalkthroughViewControllerDelegate {
    let realm = try! Realm()

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var communicationButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var switchControlButton: UIButton!
    @IBOutlet weak var switchControlLabel: UILabel!
    
    
    var SE: SoundEffect!
    var VS:VisualSetting!
    
    let userDefaults = UserDefaults.standard

    let wordArray = ["あかちゃん","あめ","いか","いちご","いぬ","いるか","うさぎ","うし","うま","かさ","かたつむり","かに","かば","かめ","きつね","きのこ","きゅうり","きりん","くつ","くつした","くま","くり","くるま","くれよん","けーき","こあら","ごはん","ごりら","さかな","さくらんぼ","さつまいも","さる","しか","じてんしゃ","しんかんせん","すいか","すいとう","すべりだい","せんぷうき","ぞう","そうじき","だいこん","たいや","たおる","たこ","たこやき","たぬき","てれび","でんしゃ","でんわ","といれ","とうもろこし","とけい","とまと","とら","なす","にわとり","にんじん","ねこ","ばいく","ぱいなっぷる","はさみ","はち","ばなな","はぶらし","ぱん","ぱんだ","ぴーまん","ぴあの","ひこうき","ふうせん","ぶた","ぶどう","ふね","へび","ぺんぎん","ぽすと","みかん","みみ","めがね","めろん","もも","やま","ゆきだるま","らいおん","りんご","れいぞうこ","れもん","ろうそく","わに"]
    
    var walkthrough :BWWalkthroughViewController!
    
    @IBOutlet weak var helpButton: UIButton!
    var helpImageView:UIImageView!
    var helpView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultDataInput()
        
        SE = SoundEffect.sharedSoundEffect

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func defaultDataInput(){
//        userDefaults.set(false, forKey: Constants.defaultSettingKey)
        
        if !userDefaults.bool(forKey: Constants.defaultSettingKey){
            print("初期設定開始")
            for i in 0 ..< wordArray.count{
                print(wordArray[i])
                let card = Card()
                card.id = i
                card.word = wordArray[i]
                card.image = UIImagePNGRepresentation(UIImage(named: wordArray[i])!)! as NSData
                try! realm.write{
                    realm.add(card, update: true)
                }
            }
            userDefaults.set(0, forKey: Constants.gameLevelKey)
            userDefaults.set(true, forKey: Constants.HiraganaKey)
            userDefaults.set(false, forKey: Constants.characterShowUpKey)
            userDefaults.set(false, forKey: Constants.useSimilarKey)
            userDefaults.set(false, forKey: Constants.useDakuonKey)
            userDefaults.set(false, forKey: Constants.useYouonKey)
            userDefaults.set(0, forKey: Constants.amountLevelKey)
            userDefaults.set(true, forKey: Constants.useColorHintKey)
            userDefaults.set(0, forKey: Constants.syllabaryLevelKey)
            userDefaults.set(1, forKey: Constants.syllabaryLinesKey)
            userDefaults.set(Float(0.5), forKey: Constants.volumeKey)
            userDefaults.set(true, forKey: Constants.tapSoundKey)
            userDefaults.set(true, forKey: Constants.correctSoundKey)
            userDefaults.set(true, forKey: Constants.incorrectSoundKey)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutSetting()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !userDefaults.bool(forKey: Constants.defaultSettingKey){
            WalkThroughSetting()
        }
    }
    
    func layoutSetting(){
        VS = VisualSetting()
        VS.backgraundView(self.view)
        setThemeUsingPrimaryColor(VS.normalOutletColor, with: .contrast)
        startButton.backgroundColor = VS.importantOutletColor
        startButton.titleLabel?.font = VS.fontAdjust(viewSize: .important)
        cardButton.titleLabel?.font = VS.fontAdjust(viewSize: .normal)
        settingButton.titleLabel?.font = VS.fontAdjust(viewSize: .normal)
        switchControlButton.titleLabel?.font = VS.fontAdjust(viewSize: .normal)
        communicationButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        switchControlLabel.font = VS.fontAdjust(viewSize: .sentence)
        
        startButton.buttonTapActionSetting(.circle)
        cardButton.buttonTapActionSetting(.circle)
        settingButton.buttonTapActionSetting(.circle)
        switchControlButton.buttonTapActionSetting(.circle)
        communicationButton.buttonTapActionSetting(.circle)
        
        helpButton.helpButtonAction()
    }
    
    @IBAction func helpViewChange(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            helpButton.shadowSetting()
            helpView = UIView(frame: self.view.frame)
            helpView.backgroundColor = UIColor.flatGray
            helpView.alpha = 0.8
            self.view.insertSubview(helpView, belowSubview: helpButton)
            helpImageView = UIImageView(image: UIImage(named:"Help2"))
            helpImageView.frame = self.view.frame
            helpImageView.contentMode = UIViewContentMode.scaleAspectFit
            self.view.insertSubview(helpImageView, belowSubview: helpButton)
        }else{
            helpImageView.removeFromSuperview()
            helpView.removeFromSuperview()
            helpButton.shadowDisappear()
        }
    }
    
    @IBAction func soundPlay(_ sender: Any) {
        SE.play(.tap)
    }
    
    func WalkThroughSetting(){
        let StoryBoard = UIStoryboard(name: "WalkThrough", bundle: nil)
        walkthrough = StoryBoard.instantiateViewController(withIdentifier: "TOP") as? BWWalkthroughViewController
        let WT1 = StoryBoard.instantiateViewController(withIdentifier: "WT1")
        let WT2 = StoryBoard.instantiateViewController(withIdentifier: "WT2")
        let WT3 = StoryBoard.instantiateViewController(withIdentifier: "WT3")
        let WT4 = StoryBoard.instantiateViewController(withIdentifier: "WT4")
        let WT5 = StoryBoard.instantiateViewController(withIdentifier: "WT5")
        let WT6 = StoryBoard.instantiateViewController(withIdentifier: "WT6")
        let WT7 = StoryBoard.instantiateViewController(withIdentifier: "WT7")
        walkthrough.delegate = self
        
        walkthrough.add(viewController: WT1)
        walkthrough.add(viewController: WT2)
        walkthrough.add(viewController: WT3)
        walkthrough.add(viewController: WT4)
        walkthrough.add(viewController: WT5)
        walkthrough.add(viewController: WT6)
        walkthrough.add(viewController: WT7)

        self.present(walkthrough, animated: true, completion: nil)
        
        walkthrough.view.backgroundColor = VS.baseColor
        walkthrough.closeButton?.backgroundColor = VS.importantOutletColor
        walkthrough.closeButton?.cornerLayout(.circle)
        walkthrough.closeButton?.titleLabel?.font = VS.fontAdjust(viewSize: .normal)
        walkthrough.nextButton?.backgroundColor = UIColor.clear
        walkthrough.prevButton?.backgroundColor = UIColor.clear
        walkthrough.nextButton?.setTitleColor(VS.importantOutletColor, for: .normal)
        walkthrough.prevButton?.setTitleColor(VS.importantOutletColor, for: .normal)
        
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
        userDefaults.set(true, forKey: Constants.defaultSettingKey)
    }
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        if pageNumber == 6{
            walkthrough.closeButton?.setTitle("OK!", for: .normal)
        }else{
            if walkthrough.closeButton?.titleLabel?.text == "OK!"{
                walkthrough.closeButton?.setTitle("Skip", for: .normal)
            }
        }
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHome(segue:UIStoryboardSegue){
        
    }

}

