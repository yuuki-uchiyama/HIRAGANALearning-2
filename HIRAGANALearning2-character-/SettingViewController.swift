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
    
    var volume:Float = 0.0
    var tapSoundBool = true
    var correctSoundBool = true
    var incorrectSoundBool = true
    
    let userDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetting()
        
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
        VisualSetting().backgraundView(self)
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
