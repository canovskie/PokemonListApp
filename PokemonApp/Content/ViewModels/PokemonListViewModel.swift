import Foundation

class PokemonListViewModel {
    private let networkingManager = NetworkingManager.shared
    private var pokemons: [Pokemon] = []
    
    var numberOfPokemons: Int {
        return pokemons.count
    }
    
    func getPokemon(at index: Int) -> Pokemon {
        return pokemons[index]
    }
    
    func fetchData(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=40&offset=0"
        networkingManager.fetchData(from: urlString) { (result: Result<PokemonsResponse, NetworkError>) in
            switch result {
            case .success(let response):
                self.pokemons = response.results
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
