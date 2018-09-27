//
//  ProblemSetting2View.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/08.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

class ProblemSetting2View: UIView, UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var linesPickerView: UIPickerView!
    
    var syllabaryLevel = 0
    var syllabaryLines = 0
    var imageArray:[UIImageView] = []
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    func loadNib(){
        let view = Bundle.main.loadNibNamed("ProblemSetting2View", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
        linesPickerView.dataSource = self
        linesPickerView.delegate = self
        
        syllabaryLevel = UserDefaults.standard.integer(forKey: Constants.syllabaryLevelKey)
        segmentControl.selectedSegmentIndex = syllabaryLevel
        syllabaryLines = UserDefaults.standard.integer(forKey: Constants.syllabaryLinesKey)
        linesPickerView.selectRow(syllabaryLines, inComponent: 0, animated: false)
        imageArray = [image1,image2,image3]
        imageArray[syllabaryLevel].alpha = 1.0
        if syllabaryLevel != 1{
            linesPickerView.isUserInteractionEnabled = false
            linesPickerView.alpha = 0.5
        }
        
        for image in imageArray{
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTaped(_:)))
            image.addGestureRecognizer(tapGesture)
            image.isUserInteractionEnabled = true
        }
        

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let stringArray = ["＋１行","＋２行","＋３行","＋４行","＋５行"]
        return stringArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        syllabaryLines = row
    }
    
    @IBAction func lineChanged(_ sender: UISegmentedControl) {
        syllabaryLevel = sender.selectedSegmentIndex
        for image in imageArray{
            if image.tag == sender.selectedSegmentIndex{
                image.alpha = 1.0
            }else{
                image.alpha = 0.5
            }
        }
        if syllabaryLevel == 1{
            linesPickerView.isUserInteractionEnabled = true
            linesPickerView.alpha = 1.0
        }else{
            linesPickerView.isUserInteractionEnabled = false
            linesPickerView.alpha = 0.5
        }
    }
    
    @objc func imageTaped(_ sender:UITapGestureRecognizer){
        let tapImage = sender.view as! UIImageView
        segmentControl.selectedSegmentIndex = tapImage.tag
        lineChanged(segmentControl)
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
