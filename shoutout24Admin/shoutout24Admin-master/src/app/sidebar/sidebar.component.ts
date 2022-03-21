import { Component, OnInit } from '@angular/core';


export interface RouteInfo {
    path: string;
    title: string;
    icon: string;
    class: string;
}

export const ROUTES: RouteInfo[] = [
    { path: '/dashboard',     title: 'Dashboard',         icon:'nc-bank',       class: '' },
    // { path: '/users',          title: 'All users',      icon:'nc-single-02',  class: '' },
    // { path: '/groups',          title: 'Groups',      icon:'nc-single-02',  class: '' },
    { path: '/maps',          title: 'Emergency Alerts',              icon:'nc-pin-3',      class: '' },
    // { path: '/profile',          title: 'Profile',      icon:'nc-single-02',  class: '' },
    
];

@Component({
    moduleId: module.id,
    selector: 'sidebar-cmp',
    templateUrl: 'sidebar.component.html',
    styleUrls: ['./sidebar.component.css']
})

export class SidebarComponent implements OnInit {
    public menuItems: any[];
    ngOnInit() {
        this.menuItems = ROUTES.filter(menuItem => menuItem);
    }
}
