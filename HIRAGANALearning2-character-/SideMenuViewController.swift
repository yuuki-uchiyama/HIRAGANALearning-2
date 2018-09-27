//
//  SideMenuViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/05.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

protocol SideMenuDelegete {
    func changeProblem()
}

// ゲームの設定画面
class SideMenuViewController: UIViewController {
    
    var delegete:SideMenuDelegete?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapSound(_ sender: UIButton) {
    }
    
    @IBAction func correctButton(_ sender: UIButton) {
    }
    
    @IBAction func incorrectButton(_ sender: UIButton) {
    }
    
    @IBAction func changeProblem(_ sender: Any) {
        self.delegete?.changeProblem()
        closeRight()
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
