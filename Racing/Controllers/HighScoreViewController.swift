import UIKit

class HighScoreViewController: UIViewController {
    
    
    
    @IBOutlet weak var scoreTableView: UITableView!
    
    var raceResult = [RaceResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let loadedRaceResult = UserDefaults.standard.value([RaceResult].self, forKey: "raceResult") {
            self.raceResult = loadedRaceResult
        } else {
            print("Some problems with loading RaceResult array from FileManager")
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        UserDefaults.standard.set(encodable: self.raceResult, forKey: "raceResult")
        navigationController?.popToRootViewController(animated: true)
    }
    
}

extension HighScoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return raceResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreTableViewCell") as? ScoreTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(nameLabelText: raceResult[indexPath.row].userName, scoreLabelText: String(raceResult[indexPath.row].score), dateLabelText: raceResult[indexPath.row].gameDateAndTime)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = self.deleteAction(forRowAtIndexPath: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        return swipe
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func deleteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, _) in
            self.raceResult.remove(at: indexPath.row)
            self.scoreTableView.reloadData()
        }
        return action
    }
    
}
