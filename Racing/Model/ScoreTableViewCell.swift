import UIKit

class ScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(nameLabelText: String, scoreLabelText: String, dateLabelText: String) {
        nameLabel.text = nameLabelText
        scoreLabel.text = "Score: " + scoreLabelText
        dateLabel.text = dateLabelText
    }

    

}
