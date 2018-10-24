//
//  GameViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/05.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class GameViewController: SlideMenuController, SlideMenuControllerDelegate {
    
    var searchingVC:SearchingViewController!
    var sortingVC:SortingViewController!
    var syllabaryVC:SyllabaryViewController!
    
    var sideMenuVC = SideMenuViewController()
    
    var gameLevel = 0

    
    override func awakeFromNib() {
        delegate = self
        sideMenuVC = storyboard?.instantiateViewController(withIdentifier: "sideMenu") as! SideMenuViewController
        
        
        SlideMenuOptions.rightViewWidth = self.view.frame.width / 4
        rightViewController = sideMenuVC
        SlideMenuOptions.panGesturesEnabled = false
        SlideMenuOptions.contentViewDrag = false
        SlideMenuOptions.tapGesturesEnabled = true
        SlideMenuOptions.contentViewOpacity = 0.0

        
        gameLevel = UserDefaults.standard.integer(forKey: Constants.gameLevelKey)
        switch gameLevel {
        case 0:
            searchingVC = SearchingViewController()
            searchingVC = storyboard?.instantiateViewController(withIdentifier: "searching") as? SearchingViewController
            mainViewController = searchingVC
            sideMenuVC.delegete = searchingVC
        case 1:
            sortingVC = SortingViewController()
            sortingVC = storyboard?.instantiateViewController(withIdentifier: "sorting") as? SortingViewController
            mainViewController = sortingVC
            sideMenuVC.delegete = sortingVC
        case 2:
            syllabaryVC = SyllabaryViewController()
            syllabaryVC = storyboard?.instantiateViewController(withIdentifier: "syllabary") as? SyllabaryViewController
            mainViewController = syllabaryVC
            sideMenuVC.delegete = syllabaryVC
        default:break
        }
        super.awakeFromNib()

    }
    
    func rightWillClose() {
        if sideMenuVC.helpButton.isSelected{
            sideMenuVC.helpViewChange(sideMenuVC.helpButton)
        }
        switch gameLevel {
        case 0:searchingVC.coverView.removeFromSuperview()
        case 1:sortingVC.coverView.removeFromSuperview()
        case 2:syllabaryVC.coverView.removeFromSuperview()
        default:break
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
