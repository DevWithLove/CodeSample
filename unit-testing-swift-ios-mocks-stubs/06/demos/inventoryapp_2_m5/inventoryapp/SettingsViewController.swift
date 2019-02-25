//
//  SettingsViewController.swift
//  inventoryapp
//
//  Created by Brett Romero on 12/25/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var fontSize: UISlider!
    @IBOutlet var fontSizeDisplay: UILabel!
    @IBOutlet var daysOlderPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fontSize.value = Float(PreferenceManager.getFontSize())
        self.fontSizeDisplay.text = String(PreferenceManager.getFontSize())
        self.daysOlderPicker.selectRow(InventoryManager.days.index(of: PreferenceManager.getDaysOlderThan())!, inComponent: 0, animated: true)
    }

    @IBAction func fontSizeChange(_ sender: Any) {
        let fontSizeAdjusted = Int(self.fontSize.value)
        self.fontSizeDisplay.text = String(fontSizeAdjusted)
        PreferenceManager.setFontSize(fontSize: fontSizeAdjusted)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return InventoryManager.days.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(InventoryManager.days[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        PreferenceManager.setDaysOlderThan(days: InventoryManager.days[row])
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
