//
//  SwitchControlViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/06.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit
import SVProgressHUD

class SwitchControlViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetting()
        
        SVProgressHUD.setMinimumDismissTimeInterval(0)

        // Do any additional setup after loading the view.
    }
    
    func layoutSetting(){
        VisualSetting().backgraundView(self)

    }
    
    @IBAction func removeSwitch(_ sender: Any) {
        let alertController = UIAlertController(title: "ボタン設定を解除しますか？", message: nil, preferredStyle: .alert)
        let OK = UIAlertAction(title: "OK", style: .destructive, handler: {
            (acrion:UIAlertAction) -> Void in
            let userDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: Constants.SwitchKey)
            userDefaults.removeObject(forKey: Constants.cursorSpeedKey)
            userDefaults.removeObject(forKey: Constants.singleDecisionKey)
            userDefaults.removeObject(forKey: Constants.toNextKey)
            userDefaults.removeObject(forKey: Constants.toPreviousKey)
            userDefaults.removeObject(forKey: Constants.multiDecisionKey)
            SVProgressHUD.showSuccess(withStatus: "ボタン操作を解除しました")
        })
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alertController.addAction(OK)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
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
