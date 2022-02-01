import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rider_app/core/auth_provider/auth_states.dart';
import 'package:rider_app/helper/components.dart';
import 'package:rider_app/helper/constants.dart';
import 'package:rider_app/models/user_model.dart';
import 'package:rider_app/view/screens/home_screen.dart';

class AuthProvider extends Cubit<AuthStates> {
  AuthProvider() : super(AuthInitialState());

  final FirebaseAuth firebaseAuthRef = FirebaseAuth.instance;
  final DatabaseReference usersRef =
      FirebaseDatabase.instance.reference().child(fireBaseUsersPath);



  void register(
    BuildContext context, {
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      emit(AuthLoadingState());

      final UserCredential userCredential =
          await firebaseAuthRef.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        UserModel userModel = UserModel(
          id: userCredential.user!.uid,
          name: name,
          email: email,
          phone: phone,
        );

        await usersRef.child(userCredential.user!.uid).set(userModel.toJson());

        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.screenId,
          (route) => false,
        );
      }

      emit(AuthSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast("The password provided is too weak.", error: true);
      } else if (e.code == 'email-already-in-use') {
        showToast(
          "The account already exists for that email.",
          error: true,
        );
      }
      emit(AuthFailureState());
    } catch (e) {
      print(e.toString());
      showToast(e.toString(), error: true);
      emit(AuthFailureState());
    }
  }

  void login(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoadingState());

      UserCredential userCredential =
          await firebaseAuthRef.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        DataSnapshot snap =
            await usersRef.child(userCredential.user!.uid).once();

        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomeScreen.screenId,
            (route) => false,
          );
        }
      }

      emit(AuthSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast(
          "No user found for that email.",
          error: true,
        );
      } else if (e.code == 'wrong-password') {
        showToast(
          "Wrong password provided for that user.",
          error: true,
        );
      }
      emit(AuthFailureState());
    } catch (e) {
      print(e);
      showToast(e.toString(), error: true);
      emit(AuthFailureState());
    }
  }
}
