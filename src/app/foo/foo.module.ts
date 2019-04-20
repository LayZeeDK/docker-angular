import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { FooRoutingModule } from './foo-routing.module';
import { FooComponent } from './foo/foo.component';

@NgModule({
  declarations: [FooComponent],
  imports: [
    CommonModule,
    FooRoutingModule
  ]
})
export class FooModule { }
