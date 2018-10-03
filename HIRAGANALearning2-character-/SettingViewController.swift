//
//  SettingViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/05.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

// 各種設定画面
class SettingViewController: UIViewController {
    
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var tapBanImage: UIImageView!
    @IBOutlet weak var correctBanImage: UIImageView!
    @IBOutlet weak var incorrectBanImage: UIImageView!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var correctView: UIView!
    @IBOutlet weak var incorrectView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var volumuTitleLabel: UILabel!
    @IBOutlet weak var SETitleLabel: UILabel!
    @IBOutlet weak var tapTextLabel: UILabel!
    @IBOutlet weak var correctTextLabel: UILabel!
    @IBOutlet weak var incorrectTextLabel: UILabel!
    
    @IBOutlet weak var toHomeButton: UIButton!
    @IBOutlet weak var defaultButton: UIButton!
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var correctButton: UIButton!
    @IBOutlet weak var incorrectButton: UIButton!
    
    
    var volume:Float = 0.0
    var tapSoundBool = true
    var correctSoundBool = true
    var incorrectSoundBool = true
    
    let userDefaults = UserDefaults.standard
    
    var SE:SoundEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetting()
        SE = SoundEffect.sharedSoundEffect

        
        volume = userDefaults.float(forKey: Constants.volumeKey)
        tapSoundBool = userDefaults.bool(forKey: Constants.tapSoundKey)
        correctSoundBool = userDefaults.bool(forKey: Constants.correctSoundKey)
        incorrectSoundBool = userDefaults.bool(forKey: Constants.incorrectSoundKey)
        volumeSlider.value = volume
        tapBanImage.isHidden = tapSoundBool
        correctBanImage.isHidden = correctSoundBool
        incorrectBanImage.isHidden = incorrectSoundBool
        
    }
    
    func layoutSetting(){
        let VS = VisualSetting()
        VS.backgraundView(self)
        defaultButton.backgroundColor = VS.importantOutletColor
        tapButton.backgroundColor = UIColor.clear
        correctButton.backgroundColor = UIColor.clear
        incorrectButton.backgroundColor = UIColor.clear

        titleLabel.font = VS.fontAdjust(viewSize: .important)
        volumuTitleLabel.font = VS.fontAdjust(viewSize: .normal)
        SETitleLabel.font = VS.fontAdjust(viewSize: .normal)
        tapTextLabel.font = VS.fontAdjust(viewSize: .verySmall)
        correctTextLabel.font = VS.fontAdjust(viewSize: .verySmall)
        incorrectTextLabel.font = VS.fontAdjust(viewSize: .verySmall)
        toHomeButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        defaultButton.titleLabel?.font = VS.fontAdjust(viewSize: .normal)
        
        toHomeButton.layer.cornerRadius = VS.cornerRadiusAdjust(toHomeButton.frame.size, type: .small)
        defaultButton.layer.cornerRadius = VS.cornerRadiusAdjust(defaultButton.frame.size, type: .circle)

        tapButton.imageFit()
        correctButton.imageFit()
        incorrectButton.imageFit()
    }
    
    @IBAction func volumeChange(_ sender: UISlider) {
        volume = sender.value
    }
    
    
    @IBAction func tapSoundChange(_ sender: UIButton) {
        tapSoundBool = !tapSoundBool
        UserDefaults.standard.set(!sender.isSelected, forKey: Constants.tapSoundKey)
        tapBanImage.isHidden = tapSoundBool
    }
    
    @IBAction func correctSoundChange(_ sender: UIButton) {
        correctSoundBool = !correctSoundBool
        UserDefaults.standard.set(!sender.isSelected, forKey: Constants.correctSoundKey)
        correctBanImage.isHidden = correctSoundBool
    }
    
    @IBAction func incorrectSoundChange(_ sender: UIButton) {
        incorrectSoundBool = !incorrectSoundBool
        UserDefaults.standard.set(!sender.isSelected, forKey: Constants.incorrectSoundKey)
        incorrectBanImage.isHidden = incorrectSoundBool
    }
    
    @IBAction func defaultButton(_ sender: Any) {
        volume = 0.5
        tapSoundBool = false
        correctSoundBool = false
        incorrectSoundBool = false
        volumeSlider.value = volume
        tapBanImage.isHidden = tapSoundBool
        correctBanImage.isHidden = correctSoundBool
        incorrectBanImage.isHidden = incorrectSoundBool
    }
    
    
    @IBAction func toHome(_ sender: Any) {
        userDefaults.set(volume, forKey: Constants.volumeKey)
        userDefaults.set(tapSoundBool, forKey: Constants.tapSoundKey)
        userDefaults.set(correctSoundBool, forKey: Constants.correctSoundKey)
        userDefaults.set(incorrectSoundBool, forKey: Constants.incorrectSoundKey)
        SE.boolChange(.all)
        SE.play(.cancel)
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
