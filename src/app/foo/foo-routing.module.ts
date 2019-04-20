import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { FooComponent } from './foo/foo.component';

const routes: Routes = [
  { path: '', component: FooComponent },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class FooRoutingModule { }
