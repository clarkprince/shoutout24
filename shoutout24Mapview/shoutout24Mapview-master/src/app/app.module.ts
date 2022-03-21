import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import {environment} from 'src/environments/environment';
import { AngularFireModule } from '@angular/fire';
import { AngularFirestoreModule } from "@angular/fire/firestore";
import { MonitoringComponent } from './pages/monitoring/monitoring.component';
import { ErrorComponent } from './pages/error/error.component';
import { AgmCoreModule } from '@agm/core';

@NgModule({
  declarations: [
    AppComponent,
    MonitoringComponent,
    ErrorComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    AngularFireModule.initializeApp(environment.firebaseConfig),
    AgmCoreModule.forRoot({
      apiKey:'AIzaSyAKX-AIZuNagTkkq75acwM0qjVlTxzm-U4',
      libraries: ['places']

    }),
    AngularFirestoreModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
