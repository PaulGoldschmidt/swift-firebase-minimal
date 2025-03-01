//
//  ContentView.swift
//  swift-firebase-minimal
//
//  Created by Paul Goldschmidt on 01.03.25.
//

import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var newTaskTitle = ""
    
    var body: some View {
        VStack {
            // Header and Add Task Section
            VStack(spacing: 12) {
                Text("Firebase Tasks")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                HStack {
                    TextField("New task", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button {
                        if !newTaskTitle.isEmpty {
                            viewModel.addTask(title: newTaskTitle)
                            newTaskTitle = ""
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
            
            // Task List
            if viewModel.isLoading && viewModel.tasks.isEmpty {
                ProgressView("Loading tasks...")
                    .padding()
            } else if viewModel.tasks.isEmpty {
                VStack {
                    Spacer()
                    Text("No tasks yet. Add one!")
                        .foregroundColor(.secondary)
                    Spacer()
                }
            } else {
                List {
                    ForEach(viewModel.tasks) { task in
                        HStack {
                            Button {
                                viewModel.toggleTaskCompletion(task)
                            } label: {
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(task.isCompleted ? .green : .gray)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
                            Text(task.title)
                                .strikethrough(task.isCompleted)
                                .foregroundColor(task.isCompleted ? .secondary : .primary)
                            
                            Spacer()
                            
                            Button {
                                viewModel.deleteTask(task)
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            
            // Cloud Function Demo Section
            VStack(spacing: 12) {
                Divider()
                
                Button {
                    viewModel.callHelloWorldFunction()
                } label: {
                    Text("Call Cloud Function")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                if !viewModel.functionResponse.isEmpty {
                    Text(viewModel.functionResponse)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding(.bottom)
        }
    }
}

#Preview {
    NavigationView {
        ContentView()
    }
}
