//
//  File.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/06.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

struct Constants {
    static let defaultSettingKey = "defaultSetting"
    
//    ゲーム設定
    static let gameLevelKey = "gameLevel"
    static let HiraganaKey = "HiraganaKatakana"
    static let characterShowUpKey = "characterShowUp"
    static let useSimilarKey = "similar"
    static let useDakuonKey = "dakuon"
    static let useYouonKey = "youon"
    static let amountLevelKey = "amountLevel"
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
    
}
struct Communication{
    static let serviceType : String = "STAPP-HIRAGANA"
}
