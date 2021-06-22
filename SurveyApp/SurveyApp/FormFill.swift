//
//  Questions.swift
//  SurveyApp
//
//  Created by Ramesh Guddala on 14/06/21.
//

import Foundation

// MARK: - Welcome
struct FormFill: Codable {
    let id, formStatus: String
    let questions: [Question]
}

// MARK: - Question
struct Question: Codable {
    let answers: [String]
    let question: String
}
