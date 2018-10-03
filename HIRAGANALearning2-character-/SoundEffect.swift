//
//  SoundEffect.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/10/01.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//
import UIKit
import AVFoundation

class SoundEffect{
    static let sharedSoundEffect = SoundEffect()
    
    var player:AVAudioPlayer!
    var rewardPlayer:AVAudioPlayer!
    
    enum soundType{
        case tap
        case cancel
        case important
        case start
        case next
        case same
        case dragBegan
        case dragEnded
        case correct
        case incorrect
        case fanfare
        case result
        case stamp
        case modeChange
        case card
    }
    
    enum boolType{
        case tap
        case correct
        case incorrect
        case all
    }
    
    let SEDic:[soundType:String] = [.tap:"tapSound",.cancel:"Cancel",.important:"Important",.start:"StartVoice",.next:"NextProblem",.same:"SameProblem",.dragBegan:"DragBegan",.dragEnded:"DragEnded",.correct:"CorrectSound",.incorrect:"IncorrectSound",.fanfare:"Fanfare",.result:"Result",.stamp:"Stamp",.modeChange:"ModeChange",.card:"Card"]
    
    var volume:Float!
    var tapSEBool = UserDefaults.standard.bool(forKey: Constants.tapSoundKey)
    var correctSEBool = UserDefaults.standard.bool(forKey: Constants.correctSoundKey)
    var incorrectSEBool = UserDefaults.standard.bool(forKey: Constants.incorrectSoundKey)
    
    private init(){ }
    
    func boolCheck(_ type:soundType) -> Bool{
        switch type {
        case .tap,.cancel,.important,.start,.next,.same,.dragBegan,.dragEnded,.modeChange,.card:
            return tapSEBool
        case .correct,.fanfare,.result,.stamp:
            return correctSEBool
        case .incorrect:
            return incorrectSEBool
        }
    }
    
    func play(_ type:soundType){
        let soundBool = boolCheck(type)
        
        if soundBool{
            let dataName = SEDic[type]!
            if let asset = NSDataAsset(name: dataName){
                player = try! AVAudioPlayer(data: asset.data)
                player.volume = UserDefaults.standard.float(forKey: Constants.volumeKey)
                player.play()
            }
        }
    }
    
    func rewardVoice(_ rate:Int){
        let soundBool = boolCheck(.result)
        
        if soundBool{
            var asset: NSDataAsset!
            switch rate {
            case 0 ... 30:
                asset = NSDataAsset(name: "Result1")
            case 31 ... 60:
                asset = NSDataAsset(name: "Result2")
            case 61 ... 80:
                asset = NSDataAsset(name: "Result3")
            case 81 ... 100:
                asset = NSDataAsset(name: "Result4")
            default:
                break
            }
            if asset != nil{
                rewardPlayer = try! AVAudioPlayer(data: asset.data)
                rewardPlayer.volume = UserDefaults.standard.float(forKey: Constants.volumeKey)
                rewardPlayer.play()
            }
        }
    }
    
    func boolChange(_ type:boolType){
        switch type {
        case .tap:tapSEBool = UserDefaults.standard.bool(forKey: Constants.tapSoundKey)
        case .correct:correctSEBool = UserDefaults.standard.bool(forKey: Constants.correctSoundKey)
        case .incorrect:incorrectSEBool = UserDefaults.standard.bool(forKey: Constants.incorrectSoundKey)
        case .all:
            tapSEBool = UserDefaults.standard.bool(forKey: Constants.tapSoundKey)
            correctSEBool = UserDefaults.standard.bool(forKey: Constants.correctSoundKey)
            incorrectSEBool = UserDefaults.standard.bool(forKey: Constants.incorrectSoundKey)
        }
    }
}
