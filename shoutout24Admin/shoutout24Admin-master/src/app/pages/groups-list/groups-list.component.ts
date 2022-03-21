import { Group } from './../../interfaces/groups';
import { UsersService } from 'app/services/users.service';
import { Component, EventEmitter, OnInit, Output } from '@angular/core';
import { Subject } from 'rxjs';

@Component({
  selector: 'app-groups-list',
  templateUrl: './groups-list.component.html',
  styleUrls: ['./groups-list.component.css']
})
export class GroupsListComponent implements OnInit {
  groups: Group[];
  dtOptions: DataTables.Settings = {};
  dtTrigger: Subject<any> = new Subject();
  @Output() groupsEvent = new EventEmitter<string>();

  constructor(private userService: UsersService) { }

  ngOnInit(): void {
    this.dtOptions = {
      pagingType: 'full_numbers',
      pageLength: 10,
      processing: true

    };
    this.userService.getAllGroups().subscribe(data => {
      this.groups = data.map(e => {
        return {
          id: e.payload.doc.id,
          ...e.payload.doc.data() as Group
        }

      });
      this.onGroupChange()

    });


  }
  onGroupChange() {
    this.groupsEvent.emit(`${this.groups.length
      }`);
  }



}
