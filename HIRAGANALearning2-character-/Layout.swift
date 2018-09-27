//
//  Layout.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/26.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework

class VisualSetting{
    
    enum size{
        case important
        case normal
        case small
    }
    
    enum cornerType{
        case small
        case normal
        case circle
    }
    
    var viewScale = 0
    
    init() {
        switch UIScreen.main.bounds.size.width{
//            SE
        case 0.0 ..< 570.0: viewScale = 10
//            6,6S,7,8
        case 570.0 ..< 670.0:viewScale = 20
//            6+,6S+,7+,8+
        case 670.0 ..< 740.0:viewScale = 30
//            X,XS,XR
        case 740.0 ..< 900.0:viewScale = 40
//            iPad
        default:viewScale = 50
        }
    }
    
    func backgraundView(_ VC:UIViewController){
        VC.view.backgroundColor = UIColor.flatSandDark
        VC.view.layer.cornerRadius = 5.0
        VC.view.layer.borderWidth = VC.view.frame.height / 50
        VC.view.layer.borderColor = UIColor.flatOrange.cgColor
    }
    
    func fontAdjust(viewSize:size) -> UIFont{
        var sizeInt = viewScale
        switch viewSize {
        case .small:sizeInt += 1
        case .normal:sizeInt += 2
        case .important:sizeInt += 3
        }
        
        switch sizeInt {
        case 11:
            return UIFont(name: "Hiragino Maru Gothic ProN", size: 15)!
        case 12:
            return UIFont(name: "Hiragino Maru Gothic ProN", size: 23)!
        case 13:
            return UIFont(name: "Hiragino Maru Gothic ProN", size: 32)!
        case 21:
            return UIFont(name: "Hiragino Maru Gothic ProN", size: 20)!
        case 22:
            return UIFont(name: "Hiragino Maru Gothic ProN", size: 30)!
        case 23:
            return UIFont(name: "Hiragino Maru Gothic ProN", size: 38)!
        case 31:
            return UIFont(name: "Hiragino Maru Gothic ProN", size: 25)!
        case 32:
            return UIFont(name: "Hiragino Maru Gothic ProN", size: 35)!
        case 33:
            return UIFont(name: "Hiragino Maru Gothic ProN", size: 45)!
        case 41:
            return UIFont(name: "Hiragino Maru Gothic ProN", size: 26)!
        case 42:
            return UIFont(name: "Hiragino Maru Gothic ProN", size: 38)!
        case 43:
            return UIFont(name: "Hiragino Maru Gothic ProN", size: 50)!
        case 51:
            return UIFont(name: "Hiragino Maru Gothic ProN", size: 33)!
        case 52:
            return UIFont(name: "Hiragino Maru Gothic ProN", size: 45)!
        case 53:
            return UIFont(name: "Hiragino Maru Gothic ProN", size: 60)!
            
        default:return UIFont(name: "Hiragino Maru Gothic ProN", size: 15)!
        }
    }
    
    func cornerRadiusAdjust(_ size:CGSize,type:cornerType) -> CGFloat{
        switch type {
        case .small:
            return size.height / 6.0
        case .normal:
            return size.height / 4.0
        case .circle:
            return size.height / 2.0
        }
    }
    
}
