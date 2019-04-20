import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { BarRoutingModule } from './bar-routing.module';
import { BarComponent } from './bar/bar.component';

@NgModule({
  declarations: [BarComponent],
  imports: [
    CommonModule,
    BarRoutingModule
  ]
})
export class BarModule { }
