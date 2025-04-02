//
//  HomeVC.swift
//  BackgroundTaskDemo
//
//  Created by Nirzar Gandhi on 25/02/25.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var societyBtn: UIButton!
    
    
    // MARK: - Properties
    
    
    // MARK: -
    // MARK: - View init Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        
        self.setControlsProperty()
    }
    
    fileprivate func setControlsProperty() {
        
        // Society Buttton
        self.societyBtn.backgroundColor = .black
        self.societyBtn.setTitleColor(.white, for: .normal)
        self.societyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        self.societyBtn.titleLabel?.lineBreakMode = .byClipping
        self.societyBtn.layer.masksToBounds = true
        self.societyBtn.showsTouchWhenHighlighted = false
        self.societyBtn.adjustsImageWhenHighlighted = false
        self.societyBtn.adjustsImageWhenDisabled = false
        self.societyBtn.setTitle("SocietyVC", for: .normal)
    }
}


// MARK: - Button Touch & Action
extension HomeVC {
    
    @IBAction func societyBtnTouch(_ sender: Any) {
        
        let homeVC = SocietyVC(nibName: "SocietyVC", bundle: nil)
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
}
