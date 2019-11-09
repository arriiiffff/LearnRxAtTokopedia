//
//  FilterViewController.swift
//  TokopediaRxExample
//
//  Created by GITS on 10/11/19.
//  Copyright © 2019 Muhammad Arif. All rights reserved.
//

import UIKit
import TTRangeSlider

protocol FilterDelegate {
    func applyChanges(pmin: String, pmax: String, wholeSale: String, official: String, fshop:String)
}

class FilterViewController: UIViewController {

    @IBOutlet weak var labelMinimumPrice: UILabel!
    @IBOutlet weak var labelMaximumPrice: UILabel!
    @IBOutlet weak var sliderRange: TTRangeSlider!
    @IBOutlet weak var wholeSaleSwitch: UISwitch!
    @IBOutlet weak var viewGoldMerchant: UIView!
    @IBOutlet weak var viewOfficialStore: UIView!
    
    var fshop = "2"
    
    var delegate: FilterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sliderRange.delegate = self
        self.resetAllData()
        // Do any additional setup after loading the view.
    }
    
    func resetAllData() {
        self.sliderRange.selectedMinimum = 10000
        self.sliderRange.selectedMaximum = 10000000
        self.labelMinimumPrice.text = "\(String(format: "Rp %.0f", self.sliderRange.selectedMinimum))"
        self.labelMaximumPrice.text = "\(String(format: "Rp %.0f", self.sliderRange.selectedMaximum))"
        self.wholeSaleSwitch.isOn = false
        self.viewGoldMerchant.isHidden = false
        self.viewOfficialStore.isHidden = false
    }

    @IBAction func btnApply(_ sender: UIButton) {
        if self.viewGoldMerchant.isHidden == true {
            self.fshop = "1"
        } else {
            self.fshop = "2"
        }
        self.dismiss(animated: true, completion: {
            self.delegate?.applyChanges(pmin: "\(String(format: "%.0f", self.sliderRange.selectedMinimum))", pmax: "\(String(format: "%.0f", self.sliderRange.selectedMaximum))", wholeSale: "\(self.wholeSaleSwitch.isOn)", official: "\(!self.viewOfficialStore.isHidden)", fshop:self.fshop)
        })
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnReset(_ sender: Any) {
        self.resetAllData()
    }
    
    @IBAction func btnGoldMerchat(_ sender: Any) {
        self.viewGoldMerchant.isHidden = true
    }
    
    @IBAction func btnOfficialStore(_ sender: Any) {
        self.viewOfficialStore.isHidden = true
    }
    
    @IBAction func btnShopType(_ sender: Any) {
        let storyboard = UIStoryboard(name: "FilterDetail", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "FilterDetailVC") as? FilterDetailViewController else { return }
        if self.viewGoldMerchant.isHidden == true {
            vc.goldMerchant = false
        }
        if self.viewOfficialStore.isHidden == true {
            vc.officialStore = false
        }
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension FilterViewController: TTRangeSliderDelegate {
    
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        self.labelMinimumPrice.text = "\(String(format: "Rp %.0f", selectedMinimum))"
        self.labelMaximumPrice.text = "\(String(format: "Rp %.0f", selectedMaximum))"
    }
    
}

extension FilterViewController: FilterDetailDelegate {
    func applyChanges(goldMerchant: Bool, officialStore: Bool) {
        self.viewGoldMerchant.isHidden = !goldMerchant
        self.viewOfficialStore.isHidden = !officialStore
    }
    
}
