import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser({required String email, required String uid}) async {
    final userRef = _firestore.collection('users').doc(uid);
    final docSnapshot = await userRef.get();
    if (!docSnapshot.exists) {
      await userRef.set({
        'email': email,
        'created_at': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> createTask({
    required String uid,
    required String title,
    required String notes,
    required DateTime dueDate,
    required String priority,
  }) async {
    await _firestore.collection('tasks').add({
      'userId': uid,
      'title': title,
      'notes': notes,
      'dueDate': dueDate,
      'priority': priority,
      'completed': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> getTasks(String uid) {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: uid)
        .orderBy('dueDate')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> updateTask(String taskId, Map<String, dynamic> updatedData) async {
    await _firestore.collection('tasks').doc(taskId).update(updatedData);
  }

  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }
}
