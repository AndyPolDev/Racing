import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - outlets
    
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var chooseCarLabel: UILabel!
    @IBOutlet weak var carImageLabel: UIImageView!
    @IBOutlet weak var enterYourNameLabel: UILabel!
    @IBOutlet weak var selectSpeedLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    //MARK: - let
    
    let carImage = Car()
    
    //MARK: - var
    
    var carIndex = 0
    var carSpeed = 3
    var userName = ""
    
    
    //MARK: - lifecycle funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        carImageLabel.image = carImage.imageArray[carIndex]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let font = UIFont(name: "Gasalt-Regular", size: 22)
        backButtonOutlet.titleLabel?.font = font
        chooseCarLabel.font = font
        enterYourNameLabel.font = font
        selectSpeedLabel.font = font
        saveButtonOutlet.titleLabel?.font = font
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backButtonOutlet.roundCorners(10)
        backButtonOutlet.dropShadow()
        
        saveButtonOutlet.roundCorners(10)
        saveButtonOutlet.dropShadow()
        
        
    }
    
    //MARK: - IBActions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {

        navigationController?.popToRootViewController(animated: true)
        
    }
    
    
    @IBAction func previousImageButtonPressed(_ sender: UIButton) {
        
        showPreviousCarImage()
        
    }
    
    
    @IBAction func nextImageButtonPressed(_ sender: UIButton) {
        
        showNextCarImage()
        
    }
    
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
    
        changeCarSpeed(senderIndex: sender.selectedSegmentIndex)
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if userName == "" {
            showAlert()
        } else {
            let gameSettings = GameSettings(carIndex: carIndex, carSpeed: carSpeed, userName: userName)
            UserDefaults.standard.set(encodable: gameSettings, forKey: "gameSettings")
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    //MARK: - flow funcs
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.textField {
            self.textField.resignFirstResponder()
        }
        if let text = textField.text {
            if text == "" {
                showAlert()
            } else {
                userName = text
            }
        }
        
        return true
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Oops!", message: "Please enter your name", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showPreviousCarImage () {
        if carIndex == 0 {
            carIndex = carImage.imageArray.count - 1
            carImageLabel.image = carImage.imageArray[carIndex]
        } else {
            carIndex -= 1
            carImageLabel.image = carImage.imageArray[carIndex]
        }
    }
    
    func showNextCarImage() {
        if carIndex == carImage.imageArray.count - 1 {
            carIndex = 0
            carImageLabel.image = carImage.imageArray[carIndex]
        } else {
            carIndex += 1
            carImageLabel.image = carImage.imageArray[carIndex]
        }
    }
    
    func changeCarSpeed(senderIndex: Int) {
        switch senderIndex {
        case 0:
            carSpeed = 5
        case 1:
            carSpeed = 4
        case 2:
            carSpeed = 3
        default:
            carSpeed = 5
        }
    }
}


//MARK: - extensions
extension UserDefaults {
    
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
           let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
}
