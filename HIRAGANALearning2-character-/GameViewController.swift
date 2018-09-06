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
    
    var matchingVC:SearchingViewController!
    var sortingVC:SortingViewController!
    var syllabaryVC:SyllabaryViewController!
    
    var sideMenuVC = SideMenuViewController()
    
    var choiceLevel = 0
    
    override func awakeFromNib() {
        switch choiceLevel {
        case 0:
            matchingVC = SearchingViewController()
            matchingVC = storyboard?.instantiateViewController(withIdentifier: "matching") as! SearchingViewController
            mainViewController = matchingVC
        case 1:
            sortingVC = SortingViewController()
            sortingVC = storyboard?.instantiateViewController(withIdentifier: "sorting") as! SortingViewController
            mainViewController = sortingVC
        case 2:
            syllabaryVC = SyllabaryViewController()
            syllabaryVC = storyboard?.instantiateViewController(withIdentifier: "syllabary") as! SyllabaryViewController
            mainViewController = syllabaryVC
        default:break
        }
        sideMenuVC = storyboard?.instantiateViewController(withIdentifier: "sideMenu") as! SideMenuViewController
        rightViewController = sideMenuVC
        SlideMenuOptions.panGesturesEnabled = false
        SlideMenuOptions.contentViewDrag = false
        SlideMenuOptions.tapGesturesEnabled = true
        
        super.awakeFromNib()
        
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
