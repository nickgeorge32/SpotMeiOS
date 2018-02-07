//
//  Constants.swift
//  SpotMe
//
//  Created by Nick George on 1/17/18.
//  Copyright © 2018 Nicholas George. All rights reserved.
//

import Foundation
import Firebase

// Firebase
let FIRESTORE_DB = Firestore.firestore()
let FIRESTORE_DB_USERS = Firestore.firestore().collection("users")
let FIRESTORE_DB_TRAINERSS = Firestore.firestore().collection("trainers")
let FIRESTORE_DB_DISTRIBUTORS = Firestore.firestore().collection("distributors")

