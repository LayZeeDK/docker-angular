import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

const routes: Routes = [
  { path: 'foo', loadChildren: './foo/foo.module#FooModule' },
  { path: 'bar', loadChildren: './bar/bar.module#BarModule' },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
