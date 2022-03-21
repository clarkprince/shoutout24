import { UsersService } from 'app/services/users.service';

import { NgxSpinnerService } from 'ngx-spinner';
import { ToastrService } from 'ngx-toastr';
import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
  signInForm: FormGroup;
  submitted: boolean = false;

  constructor(
    private fb: FormBuilder,
    private toast: ToastrService,
    private router: Router,
      private spinner: NgxSpinnerService,
      private userService:UsersService
  ) { }

  ngOnInit(): void {
    this.initializeForm();
  }
  initializeForm() {
    this.signInForm = this.fb.group({
      email: ["", Validators.required],
      password: ["", Validators.required]
    });
  }
  get f_data() {
    return this.signInForm.controls;
  }
  onLogin(){
    console.log('login');
    this.spinner.show();
    this.userService.SignIn(this.f_data.email.value, this.f_data.password.value);
      this.spinner.hide();
    
  }

}
