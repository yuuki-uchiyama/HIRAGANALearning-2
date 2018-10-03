//
//  ProblemSetting2View.swift
//  HIRAGANALearning2-character-
//
//  Created by 内山由基 on 2018/09/08.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit

class ProblemSetting2View: UIView, UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet weak var SCView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var linesPickerView: UIPickerView!
    
    var syllabaryLevel = 0
    var syllabaryLines = 0
    var imageArray:[UIImageView] = []
    
    var VS: VisualSetting!
    
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
        
        layoutSetting()
        
        linesPickerView.dataSource = self
        linesPickerView.delegate = self
        
        syllabaryLevel = UserDefaults.standard.integer(forKey: Constants.syllabaryLevelKey)
        segmentControl.selectedSegmentIndex = syllabaryLevel
        syllabaryLines = UserDefaults.standard.integer(forKey: Constants.syllabaryLinesKey)
        linesPickerView.selectRow(syllabaryLines, inComponent: 0, animated: false)
        
        imageSetting()
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
    
    func layoutSetting(){
        VS = VisualSetting()
        segmentControl.frame = SCView.frame
        VS.fontAdjustOfSegmentedControl(segmentControl, .verySmall)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerView.frame.height / 3
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let stringArray = ["＋１行","＋２行","＋３行","＋４行","＋５行"]
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.size.width, height: pickerView.frame.size.height / 2))
        label.textAlignment = .center
        label.text = stringArray[row]
        label.font = VS.fontAdjust(viewSize: .small)
        label.adjustsFontSizeToFitWidth = true
        return label
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
    
    func imageSetting(){
        var imageArray:[UIImage] = []
        let modeBool = UserDefaults.standard.bool(forKey: Constants.HiraganaKey)
        let characterShowUpBool = UserDefaults.standard.bool(forKey: Constants.characterShowUpKey)
        if modeBool{
            imageArray = [UIImage(named: "1H")!,UIImage(named: "2H")!,UIImage(named: "3H")!,UIImage(named: "1")!,UIImage(named: "2")!,UIImage(named: "3")!]
        }else{
            imageArray = [UIImage(named: "1KH")!,UIImage(named: "2KH")!,UIImage(named: "3KH")!,UIImage(named: "1K")!,UIImage(named: "2K")!,UIImage(named: "3K")!]
        }
        
        if characterShowUpBool{
            image1.image = imageArray[0]
            image2.image = imageArray[1]
            image3.image = imageArray[2]
        }else{
            image1.image = imageArray[3]
            image2.image = imageArray[4]
            image3.image = imageArray[5]
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
