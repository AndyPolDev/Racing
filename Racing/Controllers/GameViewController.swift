import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var leftRoadSideImageView: UIImageView!
    @IBOutlet weak var roadImageView: UIImageView!
    @IBOutlet weak var rightRoadSideImageView: UIImageView!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var checkerView: UIView!
    
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var startButtonOutlet: UIButton!
    
    var userName = ""
    var roadSpeed = 0.0
    var carIndex = 0
    var score = 0
    let obstacleViewSide: CGFloat = 50
    let carView = UIImageView()
    var firstObstacleView = UIImageView()
    var secondObstacleView = UIImageView()
    var thirdObstacleView = UIImageView()
    let obstacleImageArray = [UIImage(named: "fire"), UIImage(named: "stone"), UIImage(named: "cono"), UIImage(named: "splotch")]
    var gameOver = false
    var raceResult = [RaceResult]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let loadedRaceResult = UserDefaults.standard.value([RaceResult].self, forKey: "raceResult") {
            self.raceResult = loadedRaceResult
        } else {
            print("Some problems with loading RaceResult array from FileManager")
        }
        
        if let gameSettings = UserDefaults.standard.value(GameSettings.self, forKey: "gameSettings") {
            roadSpeed = Double(gameSettings.carSpeed)
            userName = gameSettings.userName
            carIndex = gameSettings.carIndex

        } else {
            moveToGameSettings()
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let font = UIFont(name: "Gasalt-Regular", size: 22)
        backButtonOutlet.titleLabel?.font = font
        startButtonOutlet.titleLabel?.font = font
        scoreLabel.font = font
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createCar()
    }
    
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        let firstDelayRange = Double.random(in: roadSpeed * 0.2 ... roadSpeed * 0.4)
        let secondDelayRange = Double.random(in: roadSpeed * 0.6 ... roadSpeed * 0.8)
        
        animateBackground()
        repeatAnimatedObstacle(view: firstObstacleView)
        delayTimer(delay: firstDelayRange, view: secondObstacleView)
        delayTimer(delay: secondDelayRange, view: thirdObstacleView)
        
        
    }
    
    
    @IBAction func moveLeftButtonPressed(_ sender: UIButton) {
        
        if carView.frame.origin.x < -6 {
            gameOverOn()
        } else {
            carView.frame.origin.x -= 12
        }
    }
    
    
    @IBAction func moveRightButtonPressed(_ sender: UIButton) {
        
        if carView.frame.origin.x > gameView.frame.width + 6 - carView.frame.width {
            gameOverOn()
        } else {
            carView.frame.origin.x += 12
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    func gameOverOn() {
        gameOver = true
        removeBackgroundAnimation()
        removeObstacleAnimation()
        saveResult()
        blurEffectWithText(text: "Game Over")
    }
    
    func saveResult() {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH.mm"
        let currentDateTimeString = formatter.string(from: currentDateTime)
    
        let currentRaceResult = RaceResult(userName: userName, score: score, gameDateAndTime: currentDateTimeString)
        
        self.raceResult.append(currentRaceResult)
        
        UserDefaults.standard.set(encodable: self.raceResult, forKey: "raceResult")
        
    }
    
    func moveToGameSettings() {
        gameOver = true
        removeBackgroundAnimation()
        removeObstacleAnimation()
        showAlert()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Oops!", message: "Please enter the race settings", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {
                fatalError("Something is wrong with the SettingsViewController identification")
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func increaseScore(view: UIImageView) {
        _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            guard let obstacleLayer = view.layer.presentation(), let checkerLayer = self.checkerView.layer.presentation() else {
                fatalError("You have problem with checkerView or obstacleView")
            }
            if checkerLayer.frame.intersects(obstacleLayer.frame) {
                self.score += 1
                self.scoreLabel.text = "Score: \(self.score)"
            }
        }
    }
    
    func intersectsCheker(view: UIImageView) {
        _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            guard let carLayer = self.carView.layer.presentation(), let obstacleLayer = view.layer.presentation() else {
                fatalError("You have problem with carView or obstacleView")
            }
            
            if carLayer.frame.intersects(obstacleLayer.frame) {
                self.gameOverOn()
            }
        }
    }
    
    func delayTimer(delay: Double, view: UIImageView) {
        _ = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { timer in
            if self.gameOver {
                timer.invalidate()
            } else {
                self.repeatAnimatedObstacle(view: view)
            }
        }
    }
    
    func repeatAnimatedObstacle(view: UIImageView) {
        increaseScore(view: view)
        intersectsCheker(view: view)
        let timer = Timer.scheduledTimer(withTimeInterval: self.roadSpeed, repeats: true) { timer in
            if self.gameOver {
                timer.invalidate()
            } else {
                self.createAnimatedObstacle(view: view)
            }
        }
        timer.fire()
    }
    
    
    func createAnimatedObstacle(view: UIImageView) {
        view.frame = CGRect(x: self.generateOriginX(), y: self.gameView.frame.origin.y, width: self.obstacleViewSide, height: self.obstacleViewSide)
        view.contentMode = .scaleToFill
        if let safeImage = self.obstacleImageArray.randomElement() {
            view.image = safeImage
        } else {
            view.image = UIImage(named: "fire")
        }
        self.gameView.addSubview(view)
        
        UIView.animate(withDuration: self.roadSpeed, delay: 0, options: .curveLinear) {
            view.frame.origin.y += self.gameView.frame.height
        } completion: {(_) in
        }
    }
    
    func generateOriginX() -> CGFloat {
        return CGFloat.random(in: 0...gameView.frame.width - obstacleViewSide)
    }
    
    
    func animateBackground() {
        UIView.animate(withDuration: roadSpeed, delay: 0, options: [.repeat, .curveLinear]) {
            self.roadImageView.frame.origin.y += self.view.frame.height
            self.leftRoadSideImageView.frame.origin.y += self.view.frame.height
            self.rightRoadSideImageView.frame.origin.y += self.view.frame.height
        }
    }
    
    func createCar() {
        let carImage = Car()
        let carViewWith: CGFloat = gameView.frame.width * 0.33
        let carViewHeight: CGFloat = carViewWith * 2
        
        carView.frame = CGRect(x: gameView.frame.width / 2, y: gameView.frame.height - buttonView.frame.height - carViewHeight , width: carViewWith, height: carViewHeight)
        carView.layer.zPosition = 1
        carView.image = carImage.imageArray[carIndex]
        carView.contentMode = .scaleToFill
        gameView.addSubview(carView)
    }
    
    func removeBackgroundAnimation() {
        roadImageView.layer.removeAllAnimations()
        leftRoadSideImageView.layer.removeAllAnimations()
        rightRoadSideImageView.layer.removeAllAnimations()
    }
    
    func removeObstacleAnimation() {
        gameView.subviews.forEach({$0.layer.removeAllAnimations()})
        
    }
    
    func blurEffectWithText(text: String) {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = view.bounds
        
        view.addSubview(blurredEffectView)
        
        fadeInView(blurredEffectView)
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = view.bounds
        vibrancyEffectView.contentView.addSubview(createTextLabelForBlur(text: text))
        blurredEffectView.contentView.addSubview(vibrancyEffectView)
    }
    
    func fadeInView(_ view: UIView) {
        view.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            view.alpha = 1
        } completion: { (_) in
            _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    func createTextLabelForBlur(text: String) -> UILabel {
        
        let height: CGFloat = view.frame.height / 4
        let width: CGFloat = view.frame.width - 50
        let textLabel = UILabel()
        textLabel.frame = CGRect(x: view.frame.width / 2 - width / 2, y: view.frame.height / 2 - height / 2, width: width, height: height)
        
        textLabel.font = .systemFont(ofSize: 150)
        textLabel.textAlignment = .center
        textLabel.adjustsFontSizeToFitWidth = true
        
        textLabel.text = text
        
        return textLabel
    }
    
    
}


