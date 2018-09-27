//
//  switchControlSystem.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/20.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

protocol SwitchControlDelegate {
    func scan()
    func toNextKeyPushed()
    func toPreviousKeyPushed()
    func decisionKeyPushed(_ cursorNumber:Int)
//    func keyInputAlert()
}

extension SwitchControlDelegate{
    func scan(){}
    func toNextKeyPushed(){}
    func toPreviousKeyPushed(){}
}

class SwitchControlSystem{
    var delegate: SwitchControlDelegate?
    
    var switchTextField:UITextField!
//    キー設定
    var switchs = 0
    var decisionKey:String!
    
    var switchTimer:Timer?
    var cursorSpeed:Float?
    
    var toNextKey:String?
    var toPreviousKey:String?
    
//    移動設定
    var cursorRectArray: [CGRect]!
    var cursorNumber = 0
    var choicesArray:[String]!
    var choiceString:String!
    
    var cursor:UIView!
    
    let userDefaults = UserDefaults.standard
    
    init(_ switchInt:Int,_ rectArray:[CGRect],_ superview:UIView,_ choicesView:UIView) {
        SVProgressHUD.setMinimumDismissTimeInterval(0)
        
        switchs = switchInt
        switchTextField = UITextField()
        switchTextField.frame.origin = CGPoint(x: superview.frame.width, y: superview.frame.height)
        switchTextField.inputAssistantItem.leadingBarButtonGroups.removeAll()
        switchTextField.inputAssistantItem.trailingBarButtonGroups.removeAll()
        switchTextField.becomeFirstResponder()
        superview.addSubview(switchTextField)
        
        switch switchs {
        case 3:
            toPreviousKey = userDefaults.string(forKey: Constants.toPreviousKey)
            fallthrough
        case 2:
            toNextKey = userDefaults.string(forKey: Constants.toNextKey)
            decisionKey = userDefaults.string(forKey: Constants.multiDecisionKey)
        case 1:
            cursorSpeed = userDefaults.float(forKey: Constants.cursorSpeedKey)
            switchTimer = Timer.scheduledTimer(timeInterval: TimeInterval(cursorSpeed!), target: self, selector: #selector(toNext), userInfo: nil, repeats: true)
            decisionKey = userDefaults.string(forKey: Constants.singleDecisionKey)
        default:break
        }
        
        switchTextField.addTarget(self, action: #selector(keySetting), for: .editingChanged)

        
        cursorRectArray = rectArray
        cursor = UIView(frame: cursorRectArray[0])
        cursor.backgroundColor = UIColor.clear
        cursor.layer.cornerRadius = 3.0
        cursor.layer.borderWidth = 2.0
        cursor.layer.borderColor = UIColor.flatYellow.cgColor
        choicesView.addSubview(cursor)
    }
    
    func resetCursor(_ rectArray:[CGRect], _ choicesView:UIView){
        cursorRectArray = rectArray
        cursorNumber = 0
        cursor.frame = cursorRectArray[0]
        choicesView.addSubview(cursor)
    }
    
    func startTimer(){
        if !(switchTimer?.isValid)!{
            switchTimer = Timer.scheduledTimer(timeInterval: TimeInterval(cursorSpeed!), target: self, selector: #selector(toNext), userInfo: nil, repeats: true)
        }
    }
    
    @objc func stopTimer(){
        if (switchTimer?.isValid)!{
            switchTimer?.invalidate()
        }
    }
    
    @objc func keySetting(){
        let str = switchTextField.text!.lowercased()
        if str.isHiragana || str.isKatakana{ alert() }
        if str == decisionKey{ decision() }
        if switchs == 3 && str == toPreviousKey{ toPrevious() }
        if switchs >= 2 && str == toNextKey{ toNext() }
        switchTextField.text = ""
    }
    
    @objc func toNext(){
        if cursorNumber == cursorRectArray.count - 1{
            cursorNumber = 0
        }else{
            cursorNumber += 1
        }
        cursor.frame = cursorRectArray[cursorNumber]
        delegate?.toNextKeyPushed()
    }
    
    @objc func toPrevious(){
        if cursorNumber == 0{
            cursorNumber = cursorRectArray.count - 1
        }else{
            cursorNumber -= 1
        }
        cursor.frame = cursorRectArray[cursorNumber]
        delegate?.toPreviousKeyPushed()
        
    }
    
    @objc func decision(){
        delegate?.decisionKeyPushed(cursorNumber)
    }
    
    @objc func alert(){
        SVProgressHUD.showError(withStatus: "日本語入力をオフにしてください")
    }
    
}
