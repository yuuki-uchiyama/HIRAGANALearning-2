//
//  MultipleSwitchViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/06.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit
import SVProgressHUD

class MultipleSwitchViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toHomeButton: UIButton!
    @IBOutlet weak var toNextButton: UIButton!
    @IBOutlet weak var toPreviousButton: UIButton!
    @IBOutlet weak var decisionSwitchButton: UIButton!
    @IBOutlet weak var useSwitchButton: UIButton!
    @IBOutlet weak var toNextLabel: UILabel!
    var toNextKey = ""
    @IBOutlet weak var toPreviousLabel: UILabel!
    var toPreviousKey = ""
    @IBOutlet weak var decisionSwitchLabel: UILabel!
    var decisionSwitchKey = ""
    
    
    
    @IBOutlet weak var SETTEILabel: UILabel!
    @IBOutlet weak var decisionButton: UIButton!
    
    let userDefaults = UserDefaults.standard
    
    var alertController: UIAlertController!
    
    var SE: SoundEffect!

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setMinimumDismissTimeInterval(0)
        
        layoutSetting()
        SE = SoundEffect.sharedSoundEffect
        
        if userDefaults.integer(forKey: Constants.SwitchKey) == 3{
            useSwitchButton.isSelected = true
            toPreviousButton.isEnabled = true
            toPreviousButton.alpha = 1.0
            toPreviousKey = userDefaults.string(forKey: Constants.toPreviousKey)!
        }else{
            useSwitchButton.isSelected = false
            toPreviousButton.isEnabled = false
            toPreviousButton.alpha = 0.2
        }
        if userDefaults.integer(forKey: Constants.SwitchKey) > 1{
            toNextKey = userDefaults.string(forKey: Constants.toNextKey)!
            decisionSwitchKey = userDefaults.string(forKey: Constants.multiDecisionKey)!
        }
        toNextLabel.text = toNextKey
        toPreviousLabel.text = toPreviousKey
        decisionSwitchLabel.text = decisionSwitchKey
        // Do any additional setup after loading the view.
    }
    
    func layoutSetting(){
        let VS = VisualSetting()
        VS.backgraundView(self.view)
        decisionButton.backgroundColor = VS.importantOutletColor
        useSwitchButton.backgroundColor = UIColor.clear
        
        titleLabel.font = VS.fontAdjust(viewSize: .important)
        toNextLabel.font = VS.fontAdjust(viewSize: .important)
        toPreviousLabel.font = VS.fontAdjust(viewSize: .important)
        decisionSwitchLabel.font = VS.fontAdjust(viewSize: .important)
        cancelButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        toHomeButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        toNextButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        toPreviousButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        decisionSwitchButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        decisionButton.titleLabel?.font = VS.fontAdjust(viewSize: .normal)
        useSwitchButton.titleLabel?.font = VS.fontAdjust(viewSize: .verySmall)
        useSwitchButton.setImage(UIImage(named: "Check"), for: .selected)
        SETTEILabel.font = VS.fontAdjust(viewSize: .verySmall)
        
        cancelButton.buttonTapActionSetting(.circle)
        toHomeButton.buttonTapActionSetting(.circle)
        decisionButton.buttonTapActionSetting(.circle)
        toNextButton.buttonTapActionSetting(.circle)
        toPreviousButton.buttonTapActionSetting(.circle)
        decisionSwitchButton.buttonTapActionSetting(.circle)
    }
    
    @IBAction func toNextSwitchSet(_ sender: Any) {
        alertController = UIAlertController(title: "「次へ進む」ボタンの設定", message: "使用するキーやスイッチを押してください（英数入力）", preferredStyle: .alert)
        alertController.addTextField{ (textField: UITextField!) -> Void in
            textField.addTarget(self, action: #selector(self.toNextAdded), for: .editingChanged)
        }
        let  cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    @objc func toNextAdded(){
        let text = alertController.textFields?.first?.text?.lowercased()
        toNextKey = text!
        toNextLabel.text = text
        alertController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func thirdSwitch(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        toPreviousButton.isEnabled = sender.isSelected
        if sender.isSelected{
            toPreviousButton.alpha = 1.0
        }else{
            toPreviousButton.alpha = 0.2
        }
    }
    
    @IBAction func toPreviousSwitchSet(_ sender: Any) {
        alertController = UIAlertController(title: "「前へ戻る」ボタンの設定", message: "使用するキーやスイッチを押してください（英数入力）", preferredStyle: .alert)
        alertController.addTextField{ (textField: UITextField!) -> Void in
            textField.addTarget(self, action: #selector(self.toPreviousAdded), for: .editingChanged)
        }
        let  cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    @objc func toPreviousAdded(){
        let text = alertController.textFields?.first?.text?.lowercased()
        toPreviousKey = text!
        toPreviousLabel.text = text
        alertController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func decisionSwitchSet(_ sender: Any) {
        alertController = UIAlertController(title: "「決定」ボタンの設定", message: "使用するキーやスイッチを押してください（英数入力）", preferredStyle: .alert)
        alertController.addTextField{ (textField: UITextField!) -> Void in
            textField.addTarget(self, action: #selector(self.decisionAdded), for: .editingChanged)
        }
        let  cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    @objc func decisionAdded(){
        let text = alertController.textFields?.first?.text?.lowercased()
        decisionSwitchKey = text!
        decisionSwitchLabel.text = text
        alertController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func multipleSwitchSet(_ sender: Any) {
        if toNextKey == "" || decisionSwitchKey == ""{
            SVProgressHUD.showError(withStatus: "未設定のボタンがあります")
        }else if toNextKey.count > 1 || decisionSwitchKey.count > 1 || toPreviousKey.count > 1{
            SVProgressHUD.showError(withStatus: "2文字以上入力されています")
        }else if toNextKey == decisionSwitchKey{
            SVProgressHUD.showError(withStatus: "同じボタンが設定されています")
        }else if toNextKey.isHiragana || toNextKey.isKatakana || decisionSwitchKey.isHiragana || decisionSwitchKey.isKatakana {
            SVProgressHUD.showError(withStatus: "ひらがな・カタカナはボタン設定に使用できません")
        }else if useSwitchButton.isSelected{
            if toPreviousKey == ""{
                SVProgressHUD.showError(withStatus: "「前へ」ボタンを設定するか、「使用しない」にチェックを入れてください")
            }else if toPreviousKey == toNextKey || toPreviousKey == decisionSwitchKey{
                SVProgressHUD.showError(withStatus: "同じボタンが設定されています")
            }else if toPreviousKey.isHiragana || toPreviousKey.isKatakana{
                SVProgressHUD.showError(withStatus: "ひらがな・カタカナはボタン設定に使用できません")
            }else{
                setting(3)
            }
        }else{
            setting(2)
        }
    }
    func setting(_ switchInt:Int){
        userDefaults.set(toNextKey, forKey: Constants.toNextKey)
        userDefaults.set(decisionSwitchKey, forKey: Constants.multiDecisionKey)
        if switchInt == 3{
            userDefaults.set(toPreviousKey, forKey: Constants.toPreviousKey)
        }
        userDefaults.set(switchInt, forKey: Constants.SwitchKey)
        SVProgressHUD.showSuccess(withStatus: "\(switchInt)つのボタン操作を登録しました")
        soundPlay(decisionButton)
        self.dismiss(animated: true, completion: nil)
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
