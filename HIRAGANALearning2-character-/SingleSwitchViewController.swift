//
//  SingleSwitchViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/06.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit
import SVProgressHUD

class SingleSwitchViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cursorSpeedTitleLabel: UILabel!
    @IBOutlet weak var decisionLabel: UILabel!
    @IBOutlet weak var SETTEILabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toHomeButton: UIButton!
    @IBOutlet weak var decisionButton: UIButton!
    @IBOutlet weak var cursorSpeedButton: UIButton!
    var cursorSpeed:Float = 0.0
    var selectedRow =  0
    @IBOutlet weak var decisionSwitchOutlet: UIButton!
    var decisionSwitch = ""
    
    var cursorAlert: UIAlertController!
    var alertController: UIAlertController!
    var cursorSpeedPickerView: UIPickerView = UIPickerView()
    var cursorSpeedArray:[Float] = [0.0,0.5,1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5,7.0,7.5,8.0,8.5,9.0,9.5,10.0]
    
    let userDefaults = UserDefaults.standard
    
    var SE: SoundEffect!
    
    @IBOutlet weak var helpButton: UIButton!
    var helpImageView:UIImageView!
    var helpView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetting()
        SE = SoundEffect.sharedSoundEffect
        
        SVProgressHUD.setMinimumDismissTimeInterval(0)
        
        cursorSpeedPickerView.dataSource = self
        cursorSpeedPickerView.delegate = self
        
        if userDefaults.integer(forKey: Constants.SwitchKey) == 1{
            cursorSpeed = userDefaults.float(forKey: Constants.cursorSpeedKey)
            cursorSpeedButton.setTitle(String(cursorSpeed), for: .normal)
            decisionSwitch = userDefaults.string(forKey: Constants.singleDecisionKey)!
            decisionSwitchOutlet.setTitle(decisionSwitch, for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    func layoutSetting(){
        let VS = VisualSetting()
        VS.backgraundView(self.view)
        decisionButton.backgroundColor = VS.importantOutletColor
        
        titleLabel.font = VS.fontAdjust(viewSize: .important)
        cursorSpeedTitleLabel.font = VS.fontAdjust(viewSize: .important)
        decisionLabel.font = VS.fontAdjust(viewSize: .important)
        SETTEILabel.font = VS.fontAdjust(viewSize: .small)
        secondLabel.font = VS.fontAdjust(viewSize: .normal)
        cancelButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        toHomeButton.titleLabel?.font = VS.fontAdjust(viewSize: .small)
        decisionButton.titleLabel?.font = VS.fontAdjust(viewSize: .normal)
        
        cursorSpeedButton.titleLabel?.font = VS.fontAdjust(viewSize: .important)
        decisionSwitchOutlet.titleLabel?.font = VS.fontAdjust(viewSize: .important)
        
        cancelButton.buttonTapActionSetting(.circle)
        toHomeButton.buttonTapActionSetting(.circle)
        decisionButton.buttonTapActionSetting(.circle)
        cursorSpeedButton.buttonTapActionSetting(.circle)
        decisionSwitchOutlet.buttonTapActionSetting(.circle)

        lineView.layer.cornerRadius = lineView.frame.width / 5
        lineView.layer.borderWidth = 4.0
        lineView.layer.borderColor = UIColor.flatLime.cgColor
        
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
            helpImageView = UIImageView(image: UIImage(named:"Help15"))
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
        return cursorSpeedArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var text = ""
        if row > 0{
            text = String(cursorSpeedArray[row])
        }
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.size.width, height: pickerView.frame.size.height / 3))
        label.textAlignment = .center
        label.text = text
        label.font = UIFont(name: "Hiragino Maru Gothic ProN", size: 25)!
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cursorSpeed = cursorSpeedArray[row]
        if row == 0{
            cursorSpeedButton.setTitle("", for: .normal)
        }else{
            cursorSpeedButton.setTitle(String(cursorSpeed), for: .normal)
        }
    }
    
    @IBAction func cursorSpeed(_ sender: Any) {
        cursorAlert = UIAlertController(title: "カーソル移動のスピード設定", message: "下記の中から選んでください\n\n\n\n\n", preferredStyle: .alert)
        let  cancel = UIAlertAction(title: "キャンセル", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            self.cancel()
        })
        let ok = UIAlertAction(title: "OK", style: .destructive, handler:{
            (action: UIAlertAction!) -> Void in
            self.cursorSpeedAdded()
        })
        
        
        cursorAlert.addAction(cancel)
        cursorAlert.addAction(ok)
        present(cursorAlert, animated: true, completion: { () -> Void in
            let frame = CGRect(x: 0, y: 50, width: self.cursorAlert.view.frame.width * 0.5, height: 90)
            self.cursorSpeedPickerView = UIPickerView(frame: frame)
            self.cursorSpeedPickerView.dataSource = self
            self.cursorSpeedPickerView.delegate = self
            self.cursorSpeedPickerView.center.x = self.cursorAlert.view.frame.width / 2
            self.cursorAlert.view.addSubview(self.cursorSpeedPickerView)
        })
        
    }
    @objc func cursorSpeedAdded(){
        cursorAlert.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancel(){
        cursorSpeed = 0
        cursorSpeedButton.setTitle("", for: .normal)
        cursorAlert.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func decisionSwitch(_ sender: Any) {
        alertController = UIAlertController(title: "「決定」ボタンの設定", message: "使用するキーやスイッチを押してください（英数入力）", preferredStyle: .alert)
        alertController.addTextField{ (textField: UITextField!) -> Void in
            textField.addTarget(self, action: #selector(self.decisionAdded), for: .editingChanged)
        }
        let  cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    @objc func decisionAdded(){
        let text = alertController.textFields?.first?.text!.lowercased()
        decisionSwitchOutlet.setTitle(text, for: .normal)
        alertController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func decisionButton(_ sender: Any) {
        let singleDecision = decisionSwitchOutlet.titleLabel?.text
        if cursorSpeed == 0.0{
            SVProgressHUD.showError(withStatus: "「カーソル移動の速さ」が未設定です")
        }else if singleDecision == nil {
            SVProgressHUD.showError(withStatus: "「決定」ボタンが未設定です")
        }else if singleDecision!.isHiragana || singleDecision!.isKatakana{
            SVProgressHUD.showError(withStatus: "ひらがな・カタカナはボタン設定に使用できません")
        }else if (singleDecision?.count)! > 1{
            SVProgressHUD.showError(withStatus: "2文字以上入力されています")
        }else{

            userDefaults.set(1, forKey: Constants.SwitchKey)
            userDefaults.set(cursorSpeed, forKey: Constants.cursorSpeedKey)
            userDefaults.set(singleDecision!, forKey: Constants.singleDecisionKey)
            SVProgressHUD.showSuccess(withStatus: "1ボタン操作を登録しました")
            soundPlay(decisionButton)
            self.dismiss(animated: true, completion: nil)
        }
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
