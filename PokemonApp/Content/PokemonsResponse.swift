import Foundation
import SDWebImage


struct PokemonsResponse: Codable {
    let results: [Pokemon]
}

struct Pokemon: Codable {
    let name: String
    let url: String    
}

struct PokemonDetailsResponse: Codable {
    let abilities: [Ability]
}

struct Ability: Codable {
    let ability: AbilityDetails
}

struct AbilityDetails: Codable {
    let name: String
    let url: String
}
