//
//  RealmPlayerData.swift
//  RedDragon
//
//  Created by QASR02 on 20/11/2023.
//

import RealmSwift

class RealmAllPlayers: Object {
    @Persisted var id: String = "1" // Use a single primary key value to update the object in the Realm database
    @Persisted var players = List<RealmPlayerData>()
}

class RealmPlayerData: Object {
    @Persisted var id: String
    @Persisted var slug: String
    @Persisted var name: String
    @Persisted var photo: String
    @Persisted var positionName: String
    @Persisted var marketValue: String
    @Persisted var rating: String
    @Persisted var ability = List<RealmAbility>()
}

class RealmAbility: Object {
    @Persisted var name: String
    @Persisted var value: Int?
    @Persisted var fullAverage: Int?
}
