//
//  MultipleSwitchViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/06.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

class MultipleSwitchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetting()
        // Do any additional setup after loading the view.
    }
    
    func layoutSetting(){
        VisualSetting().colorAdjust(self)
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