import { Component, ElementRef, ViewChild } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})

export class AppComponent {
  @ViewChild('mapContainer', {static: false}) gmap: ElementRef;
map: google.maps.Map;
  title = 's-out-location-tracker';
  lat = 40.730610;
  lng = -73.935242;

  coordinates = new google.maps.LatLng(this.lat, this.lng);

  mapOptions: google.maps.MapOptions = {
    center: this.coordinates,
    zoom: 20,
  };
 

   ngAfterViewInit() {

  }
}
