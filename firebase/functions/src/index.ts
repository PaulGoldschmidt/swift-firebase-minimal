/**
 * 
 * By Paul Goldschmidt
 * 
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {onCall, onRequest} from "firebase-functions/v2/https";
import {onDocumentCreated} from "firebase-functions/v2/firestore";
import {initializeApp} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";

// Initialize Firebase Admin SDK
initializeApp();

// Hello World; callable function
export const helloWorld = onCall({
  maxInstances: 10,
}, (request) => {
  // You can access auth state via request.auth
  const userMessage = request.data?.message || "No message provided";

  return {
    message: `Hello from Firebase! I received: "${userMessage}"`,
    timestamp: new Date().toISOString(),
  };
});

// Trigger function when a new task is created
export const onTaskCreated = onDocumentCreated("tasks/{taskId}", (event) => {
  // Get the document after the write
  const snapshot = event.data;

  if (!snapshot) {
    console.log("No data associated with the event");
    return;
  }

  const taskData = snapshot.data();
  const taskId = event.params.taskId;

  console.log(`New task created with ID: ${taskId}`);
  console.log(`Task title: ${taskData.title}`);

  if (taskData.createdAt) {
    const createdAtDate = taskData.createdAt.toDate ?
      taskData.createdAt.toDate() :
      new Date(taskData.createdAt);
    console.log(`Task created at: ${createdAtDate}`);
  }
});

// Optional: Get all tasks (HTTP function example)
export const getAllTasks = onRequest({
  maxInstances: 10,
}, async (req, res) => {
  try {
    const db = getFirestore();
    const tasksSnapshot = await db
      .collection("tasks")
      .orderBy("createdAt", "desc")
      .get();

    const tasks = tasksSnapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.status(200).json({tasks});
  } catch (error) {
    console.error("Error getting tasks:", error);
    res.status(500).json({error: "Something went wrong"});
  }
});
