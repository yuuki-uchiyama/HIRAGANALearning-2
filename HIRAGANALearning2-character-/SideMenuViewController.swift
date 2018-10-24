//
//  SideMenuViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/05.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

protocol SideMenuDelegete {
    func changeProblem()
    func changeHelpView(_ bool:Bool)
    func toHome()
    func toLevelChoice()
}

// ゲームの設定画面
class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var toHomeButton: UIButton!
    @IBOutlet weak var toLevelChoiceButton: UIButton!
    @IBOutlet weak var tapSoundButton: UIButton!
    @IBOutlet weak var correctSoundButton: UIButton!
    @IBOutlet weak var incorrectSoundButton: UIButton!
    @IBOutlet weak var changeProblemButton: UIButton!
    
    var delegete:SideMenuDelegete?
    
    var SE: SoundEffect!
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var helpButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetting()
        SE = SoundEffect.sharedSoundEffect
        // Do any additional setup after loading the view.
    }
    
    func layoutSetting(){
        let VS = VisualSetting()
        VS.backgraundView(self.view)
        toHomeButton.titleLabel?.font = VS.fontAdjust(viewSize: .normal)
        toLevelChoiceButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        tapSoundButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        correctSoundButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        incorrectSoundButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        changeProblemButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        
        let buttonArray:[UIButton] = [toHomeButton,toLevelChoiceButton,tapSoundButton,correctSoundButton,incorrectSoundButton,changeProblemButton]
        for button in buttonArray{
            button.buttonTapActionSetting(.circle)
        }
        
        if !userDefaults.bool(forKey: Constants.tapSoundKey){
            tapSoundButton.alpha = 0.2
        }
        if !userDefaults.bool(forKey: Constants.correctSoundKey){
            correctSoundButton.alpha = 0.2
        }
        if !userDefaults.bool(forKey: Constants.incorrectSoundKey){
            incorrectSoundButton.alpha = 0.2
        }
        helpButton.helpButtonAction()
    }
    
    @IBAction func helpViewChange(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.delegete?.changeHelpView(sender.isSelected)
        if sender.isSelected{
            helpButton.shadowSetting()
        }else{
            helpButton.shadowDisappear()
        }
    }
    
    @IBAction func toHome(_ sender: Any) {
        self.delegete?.toHome()
    }
    
    @IBAction func toLevelChoice(_ sender: Any) {
        self.delegete?.toLevelChoice()

    }
    
    @IBAction func tapSound(_ sender: UIButton) {
        let bool = !userDefaults.bool(forKey: Constants.tapSoundKey)
        userDefaults.set(bool, forKey: Constants.tapSoundKey)
        if bool{sender.alpha = 1.0}else{sender.alpha = 0.2}
        SE.boolChange(.tap)
    }
    
    @IBAction func correctSound(_ sender: UIButton) {
        let bool = !userDefaults.bool(forKey: Constants.correctSoundKey)
        userDefaults.set(bool, forKey: Constants.correctSoundKey)
        if bool{sender.alpha = 1.0}else{sender.alpha = 0.2}
        SE.boolChange(.correct)
    }
    @IBAction func incorrectSound(_ sender: UIButton) {
        let bool = !userDefaults.bool(forKey: Constants.incorrectSoundKey)
        userDefaults.set(bool, forKey: Constants.incorrectSoundKey)
        if bool{sender.alpha = 1.0}else{sender.alpha = 0.2}
        SE.boolChange(.incorrect)
    }
    
    @IBAction func changeProblem(_ sender: Any) {
        self.delegete?.changeProblem()
        closeRight()
    }
    
    @IBAction func soundPlay(_ sender: UIButton) {
        switch sender.tag{
        case 1:SE.play(.tap)
        case 2:SE.play(.cancel)
        default:break
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
