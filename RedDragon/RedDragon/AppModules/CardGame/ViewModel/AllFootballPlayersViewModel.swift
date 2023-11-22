//
//  AllFootballPlayersViewModel.swift
//  RedDragon
//
//  Created by QASR02 on 20/11/2023.
//

import Foundation
import RealmSwift

class AllFootballPlayersViewModel: ObservableObject {
    
    static let shared = AllFootballPlayersViewModel() ///shared singleton instance
    @Published private(set) var allPlayers: FootballPlayers?
    @Published private var searchText: String = ""
    @Published private(set) var isDataLoadedFromAPI: Bool = false ///Flag to track if data is fetched from the API and stored in Realm
    
    let realm: Realm ///initialize Realm
    let network: HTTPSClientProtocol
    private var realmAllPlayers: RealmAllPlayers? ///Keep a reference to the stored RealmAllPlayers object
    
    init(allPlayers: FootballPlayers? = nil, realm: Realm = try! Realm(), network: HTTPSClientProtocol = HTTPSClient()) {
        self.allPlayers = allPlayers
        self.realm = realm
        self.network = network
        self.realmAllPlayers = realm.objects(RealmAllPlayers.self).first ///Retrieve the stored RealmAllPlayers object
    }
    
    var filteredPlayers: [PlayerData] {
        guard !searchText.isEmpty else {
            return allPlayers?.data ?? []
        }
        return allPlayers?.data.filter { $0.name.lowercased().contains(searchText.lowercased()) } ?? []
    }
    
    var showError: ((String) -> ())?
    var displayLoader: ((Bool) -> ())?
    
    private func markDataAsLoadedFromAPI() {
        isDataLoadedFromAPI = true
    }
    
    func performInitialAPICallIfNeeded() {
        let lastAPICallDate = UserDefaults.standard.object(forKey: UserDefaultString.lastAPICallDateKey) as? Date
        let currentDate = Date()
        
        if let lastDate = lastAPICallDate, currentDate.timeIntervalSince(lastDate) < 7 * 24 * 60 * 60 {
            /// Less than a week has passed, retrieve data from Realm
            allPlayers = retrieveAllPlayersFromRealm()
        } else {
            /// More than a week has passed, perform API call and store data in Realm
            allPlayersAsyncCall(language: "en", page: 1, sort: "desc", value: 20000000, limit: 1000, lowerBound: 1)
            UserDefaults.standard.set(currentDate, forKey: UserDefaultString.lastAPICallDateKey)
        }
    }
    
    ///Store AllPlayer data into realm database
    private func storeAllPlayersInRealm(allPlayers: FootballPlayers) {
        try? realm.write {
            /// Store data in Realm using RealmAllPlayers model
            let realmAllPlayers = RealmAllPlayers()
            realmAllPlayers.id = "1" ///Use a single primary key value to update the object in the Realm database
            
            allPlayers.data.forEach { playerData in
                let realmPlayerData = RealmPlayerData()
                realmPlayerData.id = playerData.id
                realmPlayerData.slug = playerData.slug
                realmPlayerData.name = playerData.name
                realmPlayerData.photo = playerData.photo
                realmPlayerData.positionName = playerData.positionName
                realmPlayerData.marketValue = playerData.marketValue
                realmPlayerData.rating = playerData.rating
                
                playerData.ability?.forEach { ability in
                    let realmAbility = RealmAbility()
                    realmAbility.name = ability.name
                    realmAbility.value = ability.value
                    realmAbility.fullAverage = ability.fullAverage
                    realmPlayerData.ability.append(realmAbility)
                }
                realmAllPlayers.players.append(realmPlayerData)
            }
            realm.add(realmAllPlayers)
            /// Update the reference to the stored RealmAllPlayers object
            self.realmAllPlayers = realmAllPlayers
        }
    }
    
    ///retrive allPlayer data from realm database
    private func retrieveAllPlayersFromRealm() -> FootballPlayers? {
        guard let allPlayersData = realmAllPlayers else { return nil }
        var allPlayersArray: [PlayerData] = []
        
        allPlayersData.players.forEach { realmPlayerData in
            var abilities: [Ability] = []
            realmPlayerData.ability.forEach { realmAbility in
                let ability = Ability(name: realmAbility.name, value: realmAbility.value ?? 0, fullAverage: realmAbility.fullAverage ?? 0)
                abilities.append(ability)
            }

            let playerData = PlayerData(id: realmPlayerData.id,
                                        slug: realmPlayerData.slug,
                                        name: realmPlayerData.name,
                                        photo: realmPlayerData.photo,
                                        positionName: realmPlayerData.positionName,
                                        marketValue: realmPlayerData.marketValue,
                                        rating: realmPlayerData.rating,
                                        ability: abilities)
            allPlayersArray.append(playerData)
        }
        let allPlayers = FootballPlayers(status: 200, message: "Success", data: allPlayersArray)
        return allPlayers
    }
    
    ///delete all the existing data when API get hit
    private func clearExistingData() {
        try? realm.write {
            realm.delete(realm.objects(RealmAllPlayers.self))
        }
    }
    
    ///Func to get data of specific players from their IDs
    func getPlayerDataForIDs(_ playerIDs: [Int]) -> [RealmPlayerData] {
        let realm = try! Realm()
        //convert players ID to string
        let playersIDString = playerIDs.map { String( $0 ) }
        // Use 'IN' operator to filter by the converted player ID strings
        let playerData = realm.objects(RealmPlayerData.self).filter("id IN %@", playersIDString)
        return Array(playerData)
    }
    
    private func allPlayersListRequest(language: String,
                                       page: Int,
                                       sort: String,
                                       value: Int,
                                       limit: Int,
                                       lowerBound: Int) -> URLRequest? {
        guard let url = URL(string: URLConstants.cardGame_allPlayersList) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = RequestType.post.rawValue
        let parameters: [String: Any] = [
            "lang":         language,
            "page":         page,
            "value_sort":   sort,
            "market_value": value,
            "limit":        limit,
            "lower_bound":  lowerBound
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private func allPlayersList(language: String,
                                page: Int,
                                sort: String,
                                value: Int,
                                limit: Int,
                                lowerBound: Int) async throws -> FootballPlayers {
        guard let urlRequest = allPlayersListRequest(language: language, 
                                                     page: page,
                                                     sort: sort,
                                                     value: value,
                                                     limit: limit,
                                                     lowerBound: lowerBound) else {
            throw CustomErrors.invalidJSON
        }
        return try await network.executeAsync(with: urlRequest)
    }
    
    func allPlayersAsyncCall(language: String,
                             page: Int,
                             sort: String,
                             value: Int,
                             limit: Int,
                             lowerBound: Int) {
        Task { @MainActor in
            displayLoader?(true)
            do {
                if !isDataLoadedFromAPI && Reachability.isConnectedToNetwork() {
                    //print("Fetching data from the API...")
                    /// clear existing data before storeing new one
                    clearExistingData()
                    
                    let players = try await allPlayersList(language: language, page: page, sort: sort, value: value, limit: limit, lowerBound: lowerBound)
                    allPlayers = players
                    /// Store data in Realm on the first call
                    storeAllPlayersInRealm(allPlayers: players)
                    ///update the flag to indicate that data is stored in realm
                    markDataAsLoadedFromAPI()
                } else {
                    //print("Fetching data from Realm...")
                    /// Retrieve data from Realm if no internet connection or data already loaded
                    allPlayers = retrieveAllPlayersFromRealm()
                }
            } catch {
                showError?(error.localizedDescription)
            }
            displayLoader?(false)
        }
    }
    
    private func getDataCount() -> Int {
        let count = realm.objects(RealmPlayerData.self).count
        return count
    }
    
    func setSearchText(_ text: String) {
        searchText = text
    }
}
