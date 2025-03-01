//
//  Task.swift
//  swift-firebase-minimal
//
//  Created by Paul Goldschmidt on 01.03.25.
//

import Foundation
import FirebaseFirestore

struct Task: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var isCompleted: Bool = false
    var createdAt: Date = Date()
    
    // Neuen Task lokal erstellen
    init(title: String, isCompleted: Bool = false) {
        self.title = title
        self.isCompleted = isCompleted
    }
    
    // Firestore document
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        self.id = document.documentID
        self.title = data["title"] as? String ?? ""
        self.isCompleted = data["isCompleted"] as? Bool ?? false
        
        if let timestamp = data["createdAt"] as? Timestamp {
            self.createdAt = timestamp.dateValue()
        }
    }
    
    // toDict Firestore
    var dictionary: [String: Any] {
        return [
            "title": title,
            "isCompleted": isCompleted,
            "createdAt": Timestamp(date: createdAt)
        ]
    }
}
