import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasebloc/model/user_model.dart';
import 'package:firebasebloc/services/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  final CurrentLocation currentLocation = CurrentLocation();
  AuthBloc() : super(AuthInitial()) {
    on<CheckLoginStatusEvent>((event, emit) async {
      User? user;

      try {
        await Future.delayed(const Duration(seconds: 2), () {
          user = _auth.currentUser;
        });

        if (user != null) {
          emit(Authenticated(user!));
        } else {
          emit(UnAuthenticated());
        }
      } catch (e) {
        emit(AuthenticatedError(message: e.toString()));
      }
    });

    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: event.user.email.toString(),
          password: event.user.password.toString(),
        );

        final user = userCredential.user;

        if (user != null) {
          FirebaseFirestore.instance.collection("users").doc(user.uid).set({
            'uid': user.uid,
            'email': user.email,
            'name': event.user.name,
            'phone': event.user.phone,
            'age': event.user.age,
            'createdAt': DateTime.now(),
          });
          emit(Authenticated(user));
        } else {
          emit(UnAuthenticated());
        }
      } catch (e) {
        emit(AuthenticatedError(message: e.toString()));
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        final userCredential = await _auth.signInWithEmailAndPassword(
            email: event.email, password: event.password);

        final user = userCredential.user;

        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(UnAuthenticated());
        }
        Position position = await currentLocation.determinePosition();
        print(position.latitude);
      } catch (e) {
        emit(AuthenticatedError(message: e.toString()));
      }
    });

    on<LogOutEvent>((event, emit) async {
      try {
        await _auth.signOut();
        emit(UnAuthenticated());
      } catch (e) {
        emit(AuthenticatedError(message: e.toString()));
      }
    });

    on<DeleteAccountEvent>((event, emit) async {
      User? user = await _auth.currentUser;
      AuthCredential credential = EmailAuthProvider.credential(
          email: event.email, password: event.password);
      try {
        await user!.reauthenticateWithCredential(credential).then((value) {
          value.user!.delete().then((value) async {
            await _store.runTransaction((transaction) async {
              QuerySnapshot querySnapshot = await _store
                  .collection('users')
                  .where('email', isEqualTo: event.email)
                  .get();
              if (querySnapshot.docs.isNotEmpty) {
                await transaction.delete(querySnapshot.docs.first.reference);
              } else {
                print('${event.email} not found in firestore');
                print('did not delete frome firestore');
              }
            });
          });
          print("deleted ${event.email} from authentication");

          emit(DeleteState());
        });
      } catch (e) {
        emit(DeleteErrorState(msg: e.toString()));
      }
    });

    on<UpdateFieldEvent>((event, emit) async {
      final userCollection = _store.collection('users');
      final docRef = userCollection.doc(event.user.uid);
      print('processing');
      final newUser = UserModel(
        email: event.user.email,
        name: event.user.name,
        uid: event.user.uid,
        phone: event.user.phone,
        age: event.user.age,
        location: event.user.location,
      ).toJson();
      try {
        await docRef.update(newUser);
        print('updated details');
        emit(UpdateFieldState());
      } catch (e) {
        emit(UpdationError(msg: e.toString()));
      }
    });
  }
}
