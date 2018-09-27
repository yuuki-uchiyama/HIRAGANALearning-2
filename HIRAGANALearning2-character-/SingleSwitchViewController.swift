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
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toHomeButton: UIButton!
    @IBOutlet weak var decisionButton: UIButton!
    @IBOutlet weak var cursorSpeedTextField: UITextField!
    var cursorSpeed:Float = 0.0
    var selectedRow =  0
    @IBOutlet weak var decisionSwitchOutlet: UIButton!
    var decisionSwitch = ""
    
    var alertController: UIAlertController!
    var cursorSpeedPickerView: UIPickerView = UIPickerView()
    var cursorSpeedArray:[Float] = [0.5,1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5,7.0,7.5,8.0,8.5,9.0,9.5,10.0]
    
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetting()
        
        SVProgressHUD.setMinimumDismissTimeInterval(0)
        
        cursorSpeedPickerView.dataSource = self
        cursorSpeedPickerView.delegate = self
        
        let toolbar = UIToolbar(frame: CGRect(x:0, y:0, width:0, height:35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
        toolbar.setItems([cancelItem, doneItem], animated: true)
        self.cursorSpeedTextField.inputView = cursorSpeedPickerView
        self.cursorSpeedTextField.inputAccessoryView = toolbar
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(done))
        self.view.addGestureRecognizer(tapGesture)
        
        if userDefaults.integer(forKey: Constants.SwitchKey) == 1{
            cursorSpeed = userDefaults.float(forKey: Constants.cursorSpeedKey)
            cursorSpeedTextField.text = String(cursorSpeed)
            decisionSwitch = userDefaults.string(forKey: Constants.singleDecisionKey)!
            decisionSwitchOutlet.setTitle(decisionSwitch, for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    func layoutSetting(){
        VisualSetting().backgraundView(self)
        lineView.layer.cornerRadius = 10.0
        lineView.layer.borderWidth = 4.0
        lineView.layer.borderColor = UIColor.flatLime.cgColor

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cursorSpeedArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return String(cursorSpeedArray[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
    
    @objc func cancel(){
        cursorSpeedTextField.endEditing(true)
    }
    @objc func done(){
        cursorSpeed = cursorSpeedArray[selectedRow]
        cursorSpeedTextField.text = String(cursorSpeed)
        cursorSpeedTextField.endEditing(true)
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
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
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
