import GameKit

enum GameCreatorError: Error {
    case noMatchCreated
    case failedToCreateDeepLink
    case invalidDeepLink
    case noMatchFound
}

class GameCreator {
    static let shared = GameCreator()
    
    private let scheme = "balda-game"
    private let host = "play"
    
    private var activeMatches: [String: GKMatch] = [:]
    
    var viewController: UIViewController?
    
    func authenticatePlayer() {
        GKLocalPlayer.local.authenticateHandler = { gcAuthVC, error in
            if GKLocalPlayer.local.isAuthenticated {
              print("Authenticated to Game Center!")
            } else if let vc = gcAuthVC {
                
              self.viewController?.present(vc, animated: true)
            }
            else {
              print("Error authentication to GameCenter: " +
                "\(error?.localizedDescription ?? "none")")
            }
          }
    }
    
    func createGameAndGenerateLink(completion: @escaping (URL?, Error?) -> Void) {
        authenticatePlayer()
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        
        
        GKMatchmaker.shared().findMatch(for: request) { match, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let match = match else {
                completion(nil, GameCreatorError.noMatchCreated)
                return
            }
            
            
            let gameId = UUID().uuidString
            self.activeMatches[gameId] = match
            
            // Create the deep link URL
            var urlComponents = URLComponents()
            urlComponents.scheme = self.scheme
            urlComponents.host = self.host
            urlComponents.path = "/\(gameId)"
            
            guard let deepLink = urlComponents.url else {
                completion(nil, GameCreatorError.failedToCreateDeepLink)
                return
            }
            
            completion(deepLink, nil)
        }
    }
    
    func handleIncomingLink(_ url: URL, completion: @escaping (GKMatch?, Error?) -> Void) {
        if (GKLocalPlayer.local.isAuthenticated) {
            var d: Int = 0
            d += 1
        }
        
        guard url.scheme == scheme, url.host == host else {
            completion(nil, GameCreatorError.invalidDeepLink)
            return
        }
        
        let gameId = url.lastPathComponent
        
        if let existingMatch = activeMatches[gameId] {
            completion(existingMatch, nil)
        } else {
            // Create a new match request
            let request = GKMatchRequest()
            request.minPlayers = 2
            request.maxPlayers = 2
            
            GKMatchmaker.shared().findMatch(for: request) { match, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let match = match else {
                    completion(nil, GameCreatorError.noMatchFound)
                    return
                }
                
                self.activeMatches[gameId] = match
                completion(match, nil)
            }
        }
    }
}
