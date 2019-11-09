//
//  FilterDetailViewController.swift
//  TokopediaRxExample
//
//  Created by GITS on 10/11/19.
//  Copyright © 2019 Muhammad Arif. All rights reserved.
//

import UIKit

protocol FilterDetailDelegate {
    func applyChanges(goldMerchant: Bool, officialStore: Bool)
}

class FilterDetailViewController: UIViewController {

    @IBOutlet weak var imageGoldMerchant: UIImageView!
    @IBOutlet weak var imageOfficialStore: UIImageView!
    
    var goldMerchant = true
    var officialStore = true
    
    var delegate: FilterDetailDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.goldMerchant == false {
            self.imageGoldMerchant.image = UIImage(named: "ic_unselected")
        }
        if self.officialStore == false {
            self.imageOfficialStore.image = UIImage(named: "ic_unselected")
        }
        // Do any additional setup after loading the view.
    }
    
    func resetAllData() {
        self.imageGoldMerchant.image = UIImage(named: "ic_selected")
        self.imageOfficialStore.image = UIImage(named: "ic_selected")
        self.goldMerchant = true
        self.officialStore = true
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnReset(_ sender: Any) {
        self.resetAllData()
    }
    
    @IBAction func btnApply(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.applyChanges(goldMerchant: self.goldMerchant, officialStore: self.officialStore)
        }
    }
    
    @IBAction func btnGoldMerchant(_ sender: UIButton) {
        if self.goldMerchant == false {
            self.imageGoldMerchant.image = UIImage(named: "ic_selected")
            self.goldMerchant = true
        } else {
            self.imageGoldMerchant.image = UIImage(named: "ic_unselected")
            self.goldMerchant = false
        }
    }
    
    @IBAction func btnOfficialStore(_ sender: UIButton) {
        if self.officialStore == false {
            self.imageOfficialStore.image = UIImage(named: "ic_selected")
            self.officialStore = true
        } else {
            self.imageOfficialStore.image = UIImage(named: "ic_unselected")
            self.officialStore = false
        }
    }
}
