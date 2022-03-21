import { ErrorComponent } from './pages/error/error.component';
import { MonitoringComponent } from './pages/monitoring/monitoring.component';
import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';


const routes: Routes = [
  {path:':id',component:MonitoringComponent},
  {path:'**', component:ErrorComponent}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
