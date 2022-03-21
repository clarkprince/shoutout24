import { Component, OnInit } from '@angular/core';
import Chart from 'chart.js';


@Component({
    selector: 'dashboard-cmp',
    moduleId: module.id,
    templateUrl: 'dashboard.component.html',
    styleUrls:['./dashboard.component.css']
})

export class DashboardComponent implements OnInit{
    public noOfUsers = '';
  public noOfGroups = '';


  

    ngOnInit(){
        
     

    }
    usersEventHander($event: any) {
        console.log(`No of users $noOfGroups`);
        this.noOfUsers = $event;
      }
    
      groupsEventHander($event: any) {
        console.log(`No of groups $noOfGroups`);

        this.noOfGroups = $event;
      }
      
} 
