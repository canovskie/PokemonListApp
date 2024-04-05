import UIKit
import SDWebImage

class PokemonListCell: UITableViewCell {
    
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    
    func configure(with pokemon: Pokemon) {
        pokemonNameLabel.text = pokemon.name.capitalized
        if let idString = pokemon.url.split(separator: "/").last, let pokemonId = Int(idString) {
            let imageUrlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemonId).png"
            if let imageUrl = URL(string: imageUrlString) {
                pokemonImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
            }
        }
    }
}
