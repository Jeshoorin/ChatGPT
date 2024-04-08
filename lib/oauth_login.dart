import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'profile_screen.dart';

class OAuthLoginPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<void> _handleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;
        if (user != null) {
          // Navigate to the profile screen after successful login
          Navigator.pushReplacementNamed(context, '/profile');
        } else {
          throw FirebaseAuthException(
            code: 'user-signin-failed',
            message: 'Failed to sign in with Google',
          );
        }
      } else {
        throw FirebaseAuthException(
          code: 'user-signin-failed',
          message: 'Failed to sign in with Google',
        );
      }
    } catch (error) {
      print('Error signing in with Google: $error');
      // Handle sign-in errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _handleSignIn(context),
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}
