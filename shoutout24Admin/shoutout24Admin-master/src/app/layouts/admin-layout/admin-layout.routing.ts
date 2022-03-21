import { AuthenticationGuard } from 'app/services/authentication.guard';
import { Routes } from '@angular/router';
import { DashboardComponent } from '../../pages/dashboard/dashboard.component';
import { UserComponent } from '../../pages/user/user.component';
import { MapsComponent } from '../../pages/maps/maps.component';
import { UsersComponent } from 'app/pages/users/users.component';
import { GroupsComponent } from 'app/pages/groups/groups.component';

export const AdminLayoutRoutes: Routes = [
    { path: 'dashboard',      component: DashboardComponent, canActivate: [AuthenticationGuard] },
    { path: 'profile',           component: UserComponent },
    { path: 'users',           component: UsersComponent },
    { path: 'groups',           component: GroupsComponent },    
    { path: 'maps',           component: MapsComponent },
];
