import Foundation

class PokemonDetailViewModel {
    private let networkingManager = NetworkingManager.shared
    
    var selectedPokemon: Pokemon?
    var abilityDetails: [AbilityDetails] = []
    
    func getPokemonName() -> String {
        return selectedPokemon?.name.capitalized ?? ""
    }
    
    func getPokemonImageUrl() -> URL? {
        guard let selectedPokemon = selectedPokemon,
              let idString = selectedPokemon.url.split(separator: "/").last,
              let pokemonId = Int(idString) else {
            return nil
        }
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemonId).png")
    }
    
    func getAbilityDetails(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let urlString = selectedPokemon?.url ?? ""
        networkingManager.fetchData(from: urlString) { (result: Result<PokemonDetailsResponse, NetworkError>) in
            switch result {
            case .success(let response):
                self.abilityDetails = response.abilities.map { $0.ability }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
