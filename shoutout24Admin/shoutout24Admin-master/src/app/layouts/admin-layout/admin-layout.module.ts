import { DataTablesModule } from 'angular-datatables';
import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

import { AdminLayoutRoutes } from './admin-layout.routing';

import { DashboardComponent }       from '../../pages/dashboard/dashboard.component';
import { UserComponent }            from '../../pages/user/user.component';
import { MapsComponent }            from '../../pages/maps/maps.component';

import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { AgmCoreModule } from '@agm/core';
import { UsersService } from 'app/services/users.service';
import { UsersListComponent } from 'app/pages/users-list/users-list.component';
import { GroupsListComponent } from 'app/pages/groups-list/groups-list.component';
import { ConfirmationDialogService } from 'app/shared/confirmation-dialog/confirmation-dialog.service';

@NgModule({
  imports: [
    CommonModule,
    RouterModule.forChild(AdminLayoutRoutes),
    FormsModule,
    NgbModule,
    AgmCoreModule.forRoot({
      apiKey:'AIzaSyAKX-AIZuNagTkkq75acwM0qjVlTxzm-U4',
      libraries: ['places']

    }),
    DataTablesModule
  ],
  declarations: [
    DashboardComponent,
    UserComponent,
    
    MapsComponent,
    UsersListComponent,
    GroupsListComponent,

  ],
  providers: [UsersService,ConfirmationDialogService]
})

export class AdminLayoutModule {}
