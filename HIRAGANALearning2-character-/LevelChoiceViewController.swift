//
//  LevelChoiceViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/05.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

// 出題形式を選ぶ
class LevelChoiceViewController: UIViewController {
    
    @IBOutlet weak var SCView: UIView!
    @IBOutlet weak var levelChoiceSC: UISegmentedControl!
    var gameLevel = 0
    
    @IBOutlet weak var characterHintButton: UIButton!
    var characterShowUpBool = UserDefaults.standard.bool(forKey: Constants.characterShowUpKey)
    
    @IBOutlet weak var level1: UIImageView!
    @IBOutlet weak var level2: UIImageView!
    @IBOutlet weak var level3: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var modeView: UIView!
    @IBOutlet weak var HiraganaModeLabel: UILabel!
    @IBOutlet weak var KatakanaModeLabel: UILabel!
    var modeBool = UserDefaults.standard.bool(forKey: Constants.HiraganaKey)
    
    var imageViewArray:[UIImageView] = []
    
    var VS:VisualSetting!
    var SE: SoundEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetting()
        SE = SoundEffect.sharedSoundEffect
        
        gameLevel = UserDefaults.standard.integer(forKey: Constants.gameLevelKey)
        levelChoiceSC.selectedSegmentIndex = gameLevel
        imageViewArray = [level1,level2,level3]
        imageViewArray[gameLevel].alpha = 1.0
        for image in imageViewArray{
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTaped(_:)))
            image.addGestureRecognizer(tapGesture)
            image.isUserInteractionEnabled = true
        }
        
        characterHintButton.setImage(UIImage(named: "CheckOn"), for: .selected)
        characterHintButton.isSelected = characterShowUpBool
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(modeChange))
        modeView.addGestureRecognizer(tapGesture)
        
        modeLabelChange()
        // Do any additional setup after loading the view.
    }
    
    func layoutSetting(){
        VS = VisualSetting()
        VS.backgraundView(self)
        titleLabel.font = VS.fontAdjust(viewSize: .important)
        characterHintButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        nextButton.titleLabel?.font = VS.fontAdjust(viewSize: .normal)
        cancelButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        HiraganaModeLabel.font = VS.fontAdjust(viewSize: .verySmall)
        KatakanaModeLabel.font = VS.fontAdjust(viewSize: .verySmall)
        
        characterHintButton.layer.cornerRadius = VS.cornerRadiusAdjust(characterHintButton.frame.size, type: .normal)
        nextButton.layer.cornerRadius = VS.cornerRadiusAdjust(characterHintButton.frame.size, type: .normal)
        cancelButton.layer.cornerRadius = VS.cornerRadiusAdjust(cancelButton.frame.size, type: .small)
        HiraganaModeLabel.layer.cornerRadius = VS.cornerRadiusAdjust(HiraganaModeLabel.frame.size, type: .small)
        KatakanaModeLabel.layer.cornerRadius = VS.cornerRadiusAdjust(KatakanaModeLabel.frame.size, type: .small)

        levelChoiceSC.frame = SCView.frame
        
        HiraganaModeLabel.clipsToBounds = true
        KatakanaModeLabel.clipsToBounds = true
        HiraganaModeLabel.backgroundColor = UIColor.flatSandDark
        KatakanaModeLabel.backgroundColor = UIColor.flatPowderBlueDark
        HiraganaModeLabel.layer.borderWidth = HiraganaModeLabel.frame.width / 30
        KatakanaModeLabel.layer.borderWidth = KatakanaModeLabel.frame.width / 30
        HiraganaModeLabel.layer.borderColor = UIColor.flatOrange.cgColor
        KatakanaModeLabel.layer.borderColor = UIColor.flatBlue.cgColor
        
        if UserDefaults.standard.bool(forKey: Constants.HiraganaKey){
            modeView.bringSubview(toFront: HiraganaModeLabel)
        }else{
            modeView.bringSubview(toFront: KatakanaModeLabel)
        }
        
        VS.fontAdjustOfSegmentedControl(levelChoiceSC, .small)
    }
    
    @objc func modeChange(){
        modeBool = !modeBool
        UserDefaults.standard.set(modeBool, forKey: Constants.HiraganaKey)
        modeLabelChange()
        VS.colorSetting()
        setThemeUsingPrimaryColor(VS.normalOutletColor, with: .contrast)

        self.loadView()
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.viewDidLoad()
        })
        SE.play(.modeChange)
    }
    
    func modeLabelChange(){
        if modeBool{
            modeView.bringSubview(toFront: HiraganaModeLabel)
        }else{
            modeView.bringSubview(toFront: KatakanaModeLabel)
        }
        imageChange()
    }
    
    func imageChange(){
        var imageArray:[UIImage] = []
        if modeBool{
            imageArray = [UIImage(named: "Level1+H")!,UIImage(named: "Level2+H")!,UIImage(named: "Level3+H")!,UIImage(named: "Level1")!,UIImage(named: "Level2")!,UIImage(named: "Level3")!]
        }else{
            imageArray = [UIImage(named: "Level1K+H")!,UIImage(named: "Level2K+H")!,UIImage(named: "Level3K+H")!,UIImage(named: "Level1K")!,UIImage(named: "Level2K")!,UIImage(named: "Level3K")!]

        }
        if characterShowUpBool{
            level1.image = imageArray[0]
            level2.image = imageArray[1]
            level3.image = imageArray[2]
        }else{
            level1.image = imageArray[3]
            level2.image = imageArray[4]
            level3.image = imageArray[5]
        }
    }
    
    @IBAction func levelChanged(_ sender: UISegmentedControl) {
        gameLevel = sender.selectedSegmentIndex
        for i in 0 ..< imageViewArray.count{
            if i == sender.selectedSegmentIndex{
                imageViewArray[i].alpha = 1.0
            }else{
                imageViewArray[i].alpha = 0.5
            }
        }
    }
    
    @objc func imageTaped(_ sender:UITapGestureRecognizer){
        let tapImage = sender.view as! UIImageView
        levelChoiceSC.selectedSegmentIndex = tapImage.tag
        levelChanged(levelChoiceSC)
    }
    
    
    @IBAction func changeCharacterHint(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        characterShowUpBool = sender.isSelected
        imageChange()
    }
    
    @IBAction func nextButton(_ sender: Any) {
        UserDefaults.standard.set(gameLevel, forKey: Constants.gameLevelKey)
        UserDefaults.standard.set(characterShowUpBool, forKey: Constants.characterShowUpKey)
        self.performSegue(withIdentifier: "problemChoice", sender: nil)
    }
    
    @IBAction func soundPlay(_ sender: UIButton) {
        switch sender.tag{
        case 1:SE.play(.tap)
        case 2:SE.play(.cancel)
        case 3:SE.play(.important)
        default:break
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToLevelChoice(segue:UIStoryboardSegue){
        
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
