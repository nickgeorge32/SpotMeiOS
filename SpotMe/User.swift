//
//  User.swift
//  SpotMe
//
//  Created by Nick George on 1/17/18.
//  Copyright © 2018 Nicholas George. All rights reserved.
//

import Foundation

struct User {
    public private(set) var fullName: String!
    public private(set) var email: String!
    public private(set) var provider: String!
    public private(set) var accountType: String!
    public private(set) var profileImage: UIImage!
    public private(set) var username: String!
    public private(set) var gender: String!
    public private(set) var dob: String!
    public private(set) var currentWeight: String!
    public private(set) var height: String!
    public private(set) var goal: String?
    public private(set) var goalWeight: String!
    public private(set) var weeklyGoal: String?
    public private(set) var desiredOutcome: String!
    public private(set) var receiveEmails: Bool!
    public private(set) var fcmToken: String?
}
