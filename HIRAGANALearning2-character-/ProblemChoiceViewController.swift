//
//  ProblemChoiceViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/05.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

// 問題集から一つ選ぶ
class ProblemChoiceViewController: UIViewController {
    
    var toSearchBool:Bool!
    
    @IBOutlet weak var selectCardsPV: UIPickerView!
    @IBOutlet weak var levelChoiceSC: UISegmentedControl!
    @IBOutlet weak var selectHintSC: UISegmentedControl!
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetting()
        // Do any additional setup after loading the view.
    }
    
    func layoutSetting(){
        VisualSetting().colorAdjust(self)
    }

    @IBAction func levelChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            image1.alpha = 0.5
            image2.alpha = 1.0
        }else{
            image1.alpha = 1.0
            image2.alpha = 0.5
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameVC = segue.destination as! GameViewController
        gameVC.choiceLevel = levelChoiceSC.selectedSegmentIndex
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
