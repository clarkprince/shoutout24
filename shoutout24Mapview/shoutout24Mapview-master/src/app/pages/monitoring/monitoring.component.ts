import { ThrowStmt } from '@angular/compiler';
import { Component, ElementRef, OnInit, ViewChild } from '@angular/core';
import { AngularFirestore } from '@angular/fire/firestore';
import {ActivatedRoute} from '@angular/router';
@Component({
  selector: 'app-monitoring',
  templateUrl: './monitoring.component.html',
  styleUrls: ['./monitoring.component.css']
})
export class MonitoringComponent implements OnInit { 
  lat;
  long;
  zoom=16;
  location = [];

  
  
  

  constructor(private route:ActivatedRoute, private fireStore:AngularFirestore) { }

  ngOnInit(): void {
    this.route.paramMap.subscribe((res)=> {
      console.log(res.get('id'))
      this.fireStore.collection('locationLogs').doc(res.get('id')).collection('userLocation').valueChanges().subscribe((data)=>{
        this.location = data;
        this.lat = this.location[this.location.length - 1].latitude;
        this.long = this.location[this.location.length - 1].longitude;
      })
    })
  }
  

   ngAfterViewInit() {

  }

}
