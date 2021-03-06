//
//  ProblemChoiceViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/05.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit
import RealmSwift

// 問題集から一つ選ぶ
class ProblemChoiceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var gameLevel = 0
    
    @IBOutlet weak var selectCardsPV: UIPickerView!
    let PickerViewTitles = ["全て","デッキ１","デッキ２","デッキ３","デッキ４","デッキ５","デッキ６","デッキ７","デッキ８","デッキ９","デッキ１０"]
    var selectedDeck = -1
    @IBOutlet weak var selectHintSC: UISegmentedControl!
    var useColorHintBool = true
    @IBOutlet weak var colorHintLabel: UILabel!
    @IBOutlet weak var settingView: UIView!
    var problemSetting1View:ProblemSetting1View!
    var problemSetting2View:ProblemSetting2View!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toHomeButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var choicesSettingLabel: UILabel!
    @IBOutlet weak var cardsLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var segmentedControlView: UIView!
    @IBOutlet weak var colorHintView: UIView!
    
    let realm = try! Realm()
    
    var cardDataArray: [CardData] = []
    
    var VS: VisualSetting!
    var SE: SoundEffect!
    
    @IBOutlet weak var helpButton: UIButton!
    var helpImageView:UIImageView!
    var helpView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetting()
        SE = SoundEffect.sharedSoundEffect
        
        selectCardsPV.dataSource = self
        selectCardsPV.delegate = self
        
        gameLevel = UserDefaults.standard.integer(forKey: Constants.gameLevelKey)
        useColorHintBool = UserDefaults.standard.bool(forKey: Constants.useColorHintKey)
        if useColorHintBool{
            selectHintSC.selectedSegmentIndex = 0
        }else{
            selectHintSC.selectedSegmentIndex = 1
        }
        useColorHintChange(selectHintSC)
        if gameLevel == 2{
            problemSetting2View = ProblemSetting2View(frame: settingView.frame)
            self.view.insertSubview(problemSetting2View, aboveSubview: settingView)
            helpImageView = UIImageView(image: UIImage(named:"Help5"))
        }else{
            problemSetting1View = ProblemSetting1View(frame: settingView.frame)
            self.view.insertSubview(problemSetting1View, aboveSubview: settingView)
            helpImageView = UIImageView(image: UIImage(named:"Help4"))
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        selectCardsPV.reloadInputViews()
    }
    
    func layoutSetting(){
        VS = VisualSetting()
        VS.backgraundView(self.view)
        choicesSettingLabel.backgroundColor = VS.borderColor
        cardsLabel.backgroundColor = VS.borderColor
        hintLabel.backgroundColor = VS.borderColor
        choicesSettingLabel.cornerLayout(.normal)
        cardsLabel.cornerLayout(.normal)
        hintLabel.cornerLayout(.normal)
        choicesSettingLabel.clipsToBounds = true
        cardsLabel.clipsToBounds = true
        hintLabel.clipsToBounds = true

        startButton.backgroundColor = VS.importantOutletColor
        startButton.titleLabel?.font = VS.fontAdjust(viewSize: .important)
        cancelButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        toHomeButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        choicesSettingLabel.font = VS.fontAdjust(viewSize: .small)
        cardsLabel.font = VS.fontAdjust(viewSize: .small)
        hintLabel.font = VS.fontAdjust(viewSize: .small)
        colorHintLabel.font = VS.fontAdjust(viewSize: .veryImportant)
        VS.fontAdjustOfSegmentedControl(selectHintSC, .small)
        
        selectHintSC.frame = segmentedControlView.frame
        startButton.buttonTapActionSetting(.circle)
        cancelButton.buttonTapActionSetting(.circle)
        toHomeButton.buttonTapActionSetting(.circle)
        
        VS.borderMake(view: colorHintView, side: colorHintView.frame.height, color: VS.borderColor)
        colorHintView.cornerLayout(.verySmall)
        
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

            helpImageView.frame = self.view.frame
            helpImageView.contentMode = UIViewContentMode.scaleAspectFit
            self.view.insertSubview(helpImageView, belowSubview: helpButton)
        }else{
            helpImageView.removeFromSuperview()
            helpView.removeFromSuperview()
            helpButton.shadowDisappear()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 11
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerView.frame.height / 3
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.size.width, height: pickerView.frame.size.height / 3))
        label.textAlignment = .center
        label.text = PickerViewTitles[row]
        label.font = VS.fontAdjust(viewSize: .small)
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDeck = row - 1
    }

    @IBAction func useColorHintChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            useColorHintBool = true
            colorHintLabel.textColor = UIColor.flatRed
        }else{
            useColorHintBool = false
            colorHintLabel.textColor = UIColor.flatBlack
        }
    }
    
    @IBAction func startButton(_ sender: Any) {
        UserDefaults.standard.set(useColorHintBool, forKey: Constants.useColorHintKey)
        if gameLevel == 2{
            let SLevel = problemSetting2View.syllabaryLevel
            UserDefaults.standard.set(SLevel, forKey: Constants.syllabaryLevelKey)
            let SLines = problemSetting2View.syllabaryLines
            print(SLines)
            UserDefaults.standard.set(SLines, forKey: Constants.syllabaryLinesKey)
        }else{
            let SBool = problemSetting1View.useSimilarBool
            let DBool = problemSetting1View.useDakuonBool
            let YBool = problemSetting1View.useYouonBool
            let amountLevel = problemSetting1View.amountLevel
            UserDefaults.standard.set(SBool, forKey: Constants.useSimilarKey)
            UserDefaults.standard.set(DBool, forKey: Constants.useDakuonKey)
            UserDefaults.standard.set(YBool, forKey: Constants.useYouonKey)
            UserDefaults.standard.set(amountLevel, forKey: Constants.amountLevelKey)
        }
        let results = realm.objects(Card.self)
        cardDataArray = []
        for card in results{
            let cardData = CardData.init(card)
            if selectedDeck == -1{
                cardDataArray.append(cardData)
            }else{
                if cardData.boolArray[selectedDeck]{
                    cardDataArray.append(cardData)
                }
            }
        }
        if cardDataArray.count < 10{
            popUp()
        }else{
            soundPlay(startButton)
            performSegue(withIdentifier: "toGame", sender: nil)
        }
    }
    
    func popUp(){
        print("popup")
        let alertController: UIAlertController = UIAlertController(title: "デッキのカードが足りません", message: "カードが10枚以上必要です", preferredStyle: .alert)
        let card = UIAlertAction(title: "カード編集へ", style: .default, handler:{(action: UIAlertAction!) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performSegue(withIdentifier: "toCard", sender: nil)
            }
        })
        let cancel = UIAlertAction(title: "デッキを変える", style: .cancel)

        alertController.addAction(card)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func soundPlay(_ sender: UIButton) {
        switch sender.tag{
        case 1:SE.play(.tap)
        case 2:SE.play(.cancel)
        default:break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGame"{
            let gameVC = segue.destination as! GameViewController
            switch gameLevel{
            case 0:gameVC.searchingVC.cardDataArray = self.cardDataArray
            case 1:gameVC.sortingVC.cardDataArray = self.cardDataArray
            case 2:gameVC.syllabaryVC.cardDataArray = self.cardDataArray
            default:break
            }

        }
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
