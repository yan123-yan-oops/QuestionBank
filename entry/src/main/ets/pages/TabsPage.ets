import { HomePage } from './HomePage'
import { InterviewPage } from './InterviewPage'
import { MinePage } from './MinePage'
import { ProjectPage } from './ProjectPage'

@Entry
@Component
struct TabsPage {
  @State currentIndex:number = 0

@Builder
BarsType(img:Resource,str:string){
  Column(){
    Image(img)
      .width(20)
      .height(20)
    Text(str)
  }
}

  build() {
    Column() {

      Tabs({
        barPosition:BarPosition.End,
        index:this.currentIndex
      }){
        TabContent(){
          HomePage()
        }.tabBar(this.currentIndex == 0? this.BarsType($r('app.media.tabbar_home_fill'),'首页'):
          this.BarsType($r('app.media.tabbar_home'),'首页'))

        TabContent(){
          ProjectPage()
        }.tabBar(this.currentIndex == 1? this.BarsType($r('app.media.tabbar_project_fill'),'项目'):
          this.BarsType($r('app.media.tabbar_project'),'项目'))

        TabContent(){
          InterviewPage()
        }.tabBar(this.currentIndex == 2? this.BarsType($r('app.media.tabbar_interview_fill'),'面经'):
          this.BarsType($r('app.media.tabbar_interview'),'面经'))

        TabContent(){
          MinePage()
        }.tabBar(this.currentIndex == 3? this.BarsType($r('app.media.tabbar_mine_fill'),'我的'):
          this.BarsType($r('app.media.tabbar_mine'),'我的'))

      }.onChange((index)=>{
        this.currentIndex = index
      })

    }
    .height('100%')
    .width('100%')
  }
}


