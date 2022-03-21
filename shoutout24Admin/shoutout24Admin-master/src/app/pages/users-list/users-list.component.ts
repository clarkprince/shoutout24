import { User } from './../../interfaces/users';
import { UsersService } from './../../services/users.service';
import { Component, EventEmitter, OnInit, Output, ViewChild } from '@angular/core';
import { Subject } from 'rxjs';
import { ConfirmationDialogService } from 'app/shared/confirmation-dialog/confirmation-dialog.service';
import { ToastrService } from 'ngx-toastr';
declare var $;

@Component({
  selector: 'app-users-list',
  templateUrl: './users-list.component.html',
  styleUrls: ['./users-list.component.css']
})
export class UsersListComponent implements OnInit {
  users:User[];
  dtOptions: DataTables.Settings = {};
  dtTrigger: Subject<any> = new Subject();
  @Output() usersEvent = new EventEmitter<string>();


  constructor(private toast:ToastrService,private userService:UsersService,private confirmationService:ConfirmationDialogService) { }

  ngOnInit(): void {
    this.dtOptions = {
      pagingType: 'full_numbers',
      pageLength: 10,
      processing: true,
     
    };
    
    this.userService.getAllUser().subscribe(data=> {
      this.users = data.map(e => {
        this.dtTrigger.next();
        return {
          id: e.payload.doc.id,
          ...e.payload.doc.data() as User
        };

      });
      this.onUserChange();
    })
  }
  ngAfterViewInit(){ 

  }
  ngOnDestroy(): void {
    this.dtTrigger.unsubscribe();
  }
  onUserChange() {
    this.usersEvent.emit(`${this.users.length
      }`);
  }
  deleteUser(user:User){
    this.confirmationService.confirm("Delete",`Are you  sure you want to delete ${user.name} `).then((confirmation)=> {
      if(confirmation){
        this.userService.deleteUser(user.id).then(()=> {
          this.toast.success("User Data cleared successfully", "Success");

        }).catch(error => {
          this.toast.error("Unable to delete user Please try again later","error");
        })

      }else{
       
      }
    })  
    console.log(user.id);   
  }

}
