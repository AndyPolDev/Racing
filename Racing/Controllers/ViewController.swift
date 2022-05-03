import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var startButtonView: UIView!
    @IBOutlet weak var highScoreButtonView: UIView!
    @IBOutlet weak var settingsButtonView: UIView!
    @IBOutlet weak var startButtonOutlet: UIButton!
    @IBOutlet weak var highScoreButtonOutlet: UIButton!
    @IBOutlet weak var settingsButtonOutlet: UIButton!
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let font = UIFont(name: "Gasalt-Regular", size: 30)
        startButtonOutlet.setAttributedTitle(attributedStringWithShadow(text: "Start"), for: .normal)
        startButtonOutlet.titleLabel?.font = font
        highScoreButtonOutlet.setAttributedTitle(attributedStringWithShadow(text: "High Score"), for: .normal)
        highScoreButtonOutlet.titleLabel?.font = font
        settingsButtonOutlet.setAttributedTitle(attributedStringWithShadow(text: "Settings"), for: .normal)
        settingsButtonOutlet.titleLabel?.font = font
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        startButtonView.roundCorners()
        startButtonView.dropShadow()
        highScoreButtonView.roundCorners()
        highScoreButtonView.dropShadow()
        settingsButtonView.roundCorners()
        settingsButtonView.dropShadow()
          
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else {
            fatalError("Something is wrong with the GameViewController identification")
        }
        
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func highScoreButtonPressed(_ sender: UIButton) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "HighScoreViewController") as? HighScoreViewController else {
            fatalError("Something is wrong with the HighScoreViewController identification")
        }
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {
            fatalError("Something is wrong with the SettingsViewController identification")
        }
        navigationController?.pushViewController(controller, animated: true)
        
    }
 
    
    func attributedStringWithShadow(text: String) -> NSMutableAttributedString {
        let myString = text
        let myShadow = NSShadow()
        myShadow.shadowBlurRadius = 3
        myShadow.shadowOffset = CGSize(width: 3, height: 3)
        myShadow.shadowColor = UIColor.gray
        let myAttribute = [ NSAttributedString.Key.shadow: myShadow ]
        let myAttributeString = NSMutableAttributedString(string: myString, attributes: myAttribute)
        
        return myAttributeString
    }
    
}

extension UIView {
    func roundCorners(_ radius: Int = 20) {
        self.layer.cornerRadius = CGFloat(radius)
    }
    
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 15
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        
    }
}
