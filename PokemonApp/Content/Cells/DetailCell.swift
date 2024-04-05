import UIKit

class DetailCell: UITableViewCell {
    @IBOutlet weak var abilityName: UILabel!
 
    func configure(abilityDetails: AbilityDetails) {
        abilityName.text = abilityDetails.name.capitalized
    }
}
