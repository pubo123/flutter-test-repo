import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Stream<List<Map<String, dynamic>>> getUserTasks() {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => {
              ...doc.data(),
              'id': doc.id,
            }).toList());
  }

  Future<void> addTask(Map<String, dynamic> taskData) async {
    await _firestore.collection('tasks').add({
      ...taskData,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }

  Future<void> updateTask(String taskId, Map<String, dynamic> updatedData) async {
    await _firestore.collection('tasks').doc(taskId).update(updatedData);
  }
}
