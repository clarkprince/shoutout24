import { UsersService } from './services/users.service';
import { environment } from './../environments/environment';
import { BrowserAnimationsModule } from "@angular/platform-browser/animations";
import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';
import { ToastrModule } from "ngx-toastr";

import { SidebarModule } from './sidebar/sidebar.module';
import { FooterModule } from './shared/footer/footer.module';
import { NavbarModule} from './shared/navbar/navbar.module';
import { FixedPluginModule} from './shared/fixedplugin/fixedplugin.module';

import { AppComponent } from './app.component';
import { AppRoutes } from './app.routing';

import { AdminLayoutComponent } from './layouts/admin-layout/admin-layout.component';
import { UsersComponent } from './pages/users/users.component';
import { GroupsComponent } from './pages/groups/groups.component';
import { GroupsListComponent } from './pages/groups-list/groups-list.component';
import { UsersListComponent } from './pages/users-list/users-list.component';
import { AngularFireModule } from "@angular/fire";
import { AgmCoreModule } from '@agm/core';
import { AngularFirestoreModule } from "@angular/fire/firestore";
import { DataTablesModule } from 'angular-datatables';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { LoginComponent } from './pages/login/login.component';
import { NgxSpinnerModule } from "ngx-spinner";
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { AuthenticationGuard } from './services/authentication.guard';



@NgModule({
  declarations: [
    AppComponent,
    AdminLayoutComponent,
    UsersComponent,
    GroupsComponent,
    LoginComponent
    // GroupsListComponent,
    // UsersListComponent

  ],
  imports: [  
    BrowserAnimationsModule,
    
    ToastrModule.forRoot(),
    RouterModule.forRoot(AppRoutes,{
      useHash: true
    }),
    AngularFireModule.initializeApp(environment.firebaseConfig),
   
    AngularFirestoreModule,

    SidebarModule,
    NavbarModule,
    ToastrModule.forRoot(),
    FooterModule,
    FixedPluginModule,
    DataTablesModule,
    NgbModule,
    NgxSpinnerModule,
    FormsModule,
    ReactiveFormsModule, 
  ],
  providers: [UsersService,AuthenticationGuard],
  bootstrap: [AppComponent]
})
export class AppModule { }
