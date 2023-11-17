import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInGooogleService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Lưu thông tin người dùng vào Firestore
      await _userCollection.doc(userCredential.user!.uid).set({
        'uID': userCredential.user!.uid,
        'fullName': userCredential.user!.displayName ?? '',
        'email': userCredential.user!.email ?? '',
        'avartaURL': userCredential.user!.photoURL,
        'follower': [],
        'following': [],
        'age': '',
        'gender': '',
        'phone': '',
        // Thêm các thông tin khác nếu cần
      });

      return userCredential.user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  // Future<void> signOut() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('uid');
  //   await _auth.signOut();
  //   await _googleSignIn.signOut();
  // }
}
