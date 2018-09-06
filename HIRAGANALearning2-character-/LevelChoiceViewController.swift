//
//  LevelChoiceViewController.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/05.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

// 出題形式を選ぶ
class LevelChoiceViewController: UIViewController {
    
    @IBOutlet weak var levelChoiceSC: UISegmentedControl!
    
    @IBOutlet weak var level1: UIImageView!
    @IBOutlet weak var level2: UIImageView!
    @IBOutlet weak var level3: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSetting()
        // Do any additional setup after loading the view.
    }
    
    func layoutSetting(){
        VisualSetting().colorAdjust(self)
    }
    
    @IBAction func levelChanged(_ sender: UISegmentedControl) {
        let imageViewArray:[UIImageView] = [level1, level2, level3]
        for i in 0 ..< imageViewArray.count{
            if i == sender.selectedSegmentIndex{
                imageViewArray[i].alpha = 1.0
            }else{
                imageViewArray[i].alpha = 0.5
            }
        }
    }
    
    @IBAction func nextButton(_ sender: Any) {
        if levelChoiceSC.selectedSegmentIndex == 2{
            self.performSegue(withIdentifier: "syllabaryChoice", sender: nil)
            
        }else{
            self.performSegue(withIdentifier: "problemChoice", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "problemChoice"{
            let problemChoiceVC = segue.destination as! ProblemChoiceViewController
            if levelChoiceSC.selectedSegmentIndex == 0{
                problemChoiceVC.toSearchBool = true
            }else{
                problemChoiceVC.toSearchBool = false

            }
        }else{
            let syllabaryChoiceVC = segue.destination as! SyllabaryChoiceViewController

        }
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
