import { Router } from '@angular/router';
import { Injectable, NgZone } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';
import {AngularFireAuth} from '@angular/fire/auth';
import { ToastrService } from 'ngx-toastr';



@Injectable({
  providedIn: 'root'
})
export class UsersService {
  userData:any;

  constructor(private toast:ToastrService, private firestore:AngularFirestore,public  afAuth:  AngularFireAuth, public  router:  Router,public ngZone: NgZone) {
    this.afAuth.authState.subscribe(user => {
      if (user){
        this.userData = user;
        localStorage.setItem('user', JSON.stringify(this.userData));
      } else {
        localStorage.setItem('user', null);
      }
    })

   }
   getAllUser(){
     return this.firestore.collection('users').snapshotChanges();
   }
   getAllGroups(){
    return this.firestore.collection('groups').snapshotChanges();
  }
  getLiveLocations(){
    return this.firestore.collection('liveLocation').snapshotChanges();
  }
 async deleteUser(userId){
    return await this.firestore.collection('users').doc(userId).delete();

  }
  SignIn(email, password) {
    return this.afAuth.signInWithEmailAndPassword(email, password)
      .then((result) => {
        this.router.navigate(['dashboard']);
        this.toast.success("Authenticated successfully");
      
      }).catch((error) => {
        window.alert(error.message)
        this.toast.error(error.message);
      })
  }
   // Sign out 
   SignOut() {
    return this.afAuth.signOut().then(() => {
      localStorage.removeItem('user');
      this.router.navigate(['login']);
    })
  }
  
  
   // Returns true when user is looged in and email is verified
   get isLoggedIn(): boolean {
    const user = JSON.parse(localStorage.getItem('user'));
    return user !== null ? true : false;
  }}
