//
//  StudentDetails.swift
//  test
//
//  Created by Tobi Ayeni on 2025-05-08.
//

import SwiftUI

struct StudentDetails: Codable {
    var fullName: String
    var levelOfEducation: String
    var highSchoolName: String
    var universityName: String
    var yearOfStudy: String
    var major: String
    
    // Convert to dictionary for storage
    var dictionary: [String: String] {
        return [
            "fullName": fullName,
            "levelOfEducation": levelOfEducation,
            "highSchoolName": highSchoolName,
            "universityName": universityName,
            "yearOfStudy": yearOfStudy,
            "major": major
        ]
    }
    
    // Initialize from dictionary
    init(from dictionary: [String: String]) {
        self.fullName = dictionary["fullName"] ?? ""
        self.levelOfEducation = dictionary["levelOfEducation"] ?? ""
        self.highSchoolName = dictionary["highSchoolName"] ?? ""
        self.universityName = dictionary["universityName"] ?? ""
        self.yearOfStudy = dictionary["yearOfStudy"] ?? ""
        self.major = dictionary["major"] ?? ""
    }
    
    // Default initializer
    init(fullName: String = "", levelOfEducation: String = "", highSchoolName: String = "", universityName: String = "", yearOfStudy: String = "", major: String = "") {
        self.fullName = fullName
        self.levelOfEducation = levelOfEducation
        self.highSchoolName = highSchoolName
        self.universityName = universityName
        self.yearOfStudy = yearOfStudy
        self.major = major
    }
}
