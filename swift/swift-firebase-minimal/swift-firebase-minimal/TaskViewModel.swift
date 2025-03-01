//
//  TaskViewModel.swift
//  swift-firebase-minimal
//
//  Created by Paul Goldschmidt on 01.03.25.
//


import Foundation
import FirebaseFirestore
import FirebaseFunctions

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var errorMessage: String = ""
    @Published var functionResponse: String = ""
    @Published var isLoading: Bool = false
    
    private let db = Firestore.firestore()
    private let functions = Functions.functions()
    private var listenerRegistration: ListenerRegistration?
    
    init() {
        fetchTasks()
    }
    
    deinit {
        // Detach listener when ViewModel is deallocated
        listenerRegistration?.remove()
    }
    
    func fetchTasks() {
        isLoading = true
        
        // Create a reference to the tasks collection
        let tasksRef = db.collection("tasks")
        
        // Set up a snapshot listener for real-time updates
        listenerRegistration = tasksRef
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "Error fetching tasks: \(error.localizedDescription)"
                    return
                }
                
                self.tasks = querySnapshot?.documents.compactMap { document in
                    return Task(document: document)
                } ?? []
            }
    }
    
    func addTask(title: String) {
        let newTask = Task(title: title)
        
        // Add to Firestore
        db.collection("tasks").document(newTask.id).setData(newTask.dictionary) { [weak self] error in
            if let error = error {
                self?.errorMessage = "Error adding task: \(error.localizedDescription)"
            }
        }
    }
    
    func toggleTaskCompletion(_ task: Task) {
        // Update in Firestore
        let updatedData: [String: Any] = ["isCompleted": !task.isCompleted]
        
        db.collection("tasks").document(task.id).updateData(updatedData) { [weak self] error in
            if let error = error {
                self?.errorMessage = "Error updating task: \(error.localizedDescription)"
            }
        }
    }
    
    func deleteTask(_ task: Task) {
        // Delete from Firestore
        db.collection("tasks").document(task.id).delete { [weak self] error in
            if let error = error {
                self?.errorMessage = "Error deleting task: \(error.localizedDescription)"
            }
        }
    }
    
    // Call demo Cloud Function
    func callHelloWorldFunction() {
        self.functionResponse = "Calling function..."
        self.isLoading = true
        
        // Create data to send to the function
        let data: [String: Any] = ["message": "Hello from Swift app"]
        
        functions.httpsCallable("helloWorld").call(data) { [weak self] result, error in
            guard let self = self else { return }
            
            self.isLoading = false
            
            if let error = error as NSError? {
                self.functionResponse = "Error: \(error.localizedDescription)"
                return
            }
            
            if let resultData = result?.data as? [String: Any] {
                var responseText = ""
                
                // Handle message field
                if let message = resultData["message"] as? String {
                    responseText += message
                }
                
                // Handle timestamp field
                if let timestamp = resultData["timestamp"] as? String {
                    responseText += "\nReceived at: \(timestamp)"
                }
                
                if !responseText.isEmpty {
                    self.functionResponse = responseText
                } else {
                    self.functionResponse = "Function returned: \(resultData)"
                }
            } else if let resultString = result?.data as? String {
                self.functionResponse = resultString
            } else {
                self.functionResponse = "Function returned successfully but with unknown response format"
            }
        }
    }
}
