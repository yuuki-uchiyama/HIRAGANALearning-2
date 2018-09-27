//
//  File.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/06.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let defaultSettingKey = "defaultSetting"
    
//    ゲーム設定
    static let gameLevelKey = "gameLevel"
    static let characterShouUpKey = "characterShowUp"
    static let useSimilarKey = "similar"
    static let useDakuonKey = "dakuon"
    static let useYouonKey = "youon"
    static let amountOfChoicesKey = "choices"
    static let syllabaryLevelKey = "SyllabaryLevel"
    static let syllabaryLinesKey = "SyllabaryLine"
    static let useColorHintKey = "colorHint"
    
//    環境設定
    static let volumeKey = "volume"
    static let tapSoundKey = "tap"
    static let incorrectSoundKey = "incorrect"
    static let correctSoundKey = "correct"

//    switchControl設定
    static let SwitchKey = "Switch" //0=スイッチなし　1=シングル　2=マルチ（戻るボタンなし）　3=マルチ（戻るボタンあり）
    static let cursorSpeedKey = "cursorSpeed"
    static let singleDecisionKey = "singleDecision"
    
    static let toNextKey = "toNext"
    static let toPreviousKey = "toPrevious"
    static let multiDecisionKey = "multiDecision"
    
    
    
    
    
    
    
    static let choiceLebelTutorialKey = "CLTutorial"
    static let recordTutorialKey = "RecTutorial"
    static let resultTutorialKey = "ResTutorial"
    
    

    
    static let hintSpeadKey = "hintSpead"
    
    

}
struct Communication{
    static let serviceType : String = "STAPP-HIRAGANA"
}

enum DashedLineType {
    case All,Top,Down,Right,Left
}

extension UIView {
    
    func drawDashedLine(color: UIColor, lineWidth: CGFloat, lineSize: NSNumber, spaceSize: NSNumber, type: DashedLineType) {
        let dashedLineLayer: CAShapeLayer = CAShapeLayer()
        dashedLineLayer.frame = self.bounds
        dashedLineLayer.strokeColor = color.cgColor
        dashedLineLayer.lineWidth = lineWidth
        dashedLineLayer.lineDashPattern = [lineSize, spaceSize]
        let path: CGMutablePath = CGMutablePath()
        
        switch type {
            
        case .All:
            dashedLineLayer.fillColor = nil
            dashedLineLayer.path = UIBezierPath(rect: dashedLineLayer.frame).cgPath
        case .Top:
            path.move(to: CGPoint(x: 0.0, y: 0.0))
            path.addLine(to: CGPoint(x: self.frame.size.width, y: 0.0))
            dashedLineLayer.path = path
        case .Down:
            path.move(to: CGPoint(x: 0.0, y: self.frame.size.height))
            path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
            dashedLineLayer.path = path
        case .Right:
            path.move(to: CGPoint(x: self.frame.size.width, y: 0.0))
            path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
            dashedLineLayer.path = path
        case .Left:
            path.move(to: CGPoint(x: 0.0, y: 0.0))
            path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
            dashedLineLayer.path = path
        }
        self.layer.addSublayer(dashedLineLayer)
    }
}
