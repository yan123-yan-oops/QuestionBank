import { Home } from './Home/Home'
import { Interview } from './Interview/Interview'
import { Mine } from './Mine/Mine'
import { Project } from './Project/Project'
import { setupRouterInterceptor } from '../comments/router/RouterInterceptor';

@Entry
@Component
struct TabsPage {
  @Provide("navStack") pageStack: NavPathStack = new NavPathStack();
  @State currentIndex: number = 0

  aboutToAppear(): void {
    setupRouterInterceptor(this.pageStack)
    //设置登录监听
  }

  @Builder
  BarsType(img: Resource, str: string) {
    Column() {
      Image(img)
        .width(20)
        .height(20)
      Text(str)
    }
  }

  build() {
      Navigation(this.pageStack) {
        Column() {

          Tabs({
            barPosition: BarPosition.End,
            index: this.currentIndex
          }) {
            TabContent() {
              Home()
            }.tabBar(this.currentIndex == 0 ? this.BarsType($r('app.media.tabbar_home_fill'), '首页') :
              this.BarsType($r('app.media.tabbar_home'), '首页'))

            TabContent() {
              Project()
            }.tabBar(this.currentIndex == 1 ? this.BarsType($r('app.media.tabbar_project_fill'), '项目') :
              this.BarsType($r('app.media.tabbar_project'), '项目'))

            TabContent() {
              Interview()
            }.tabBar(this.currentIndex == 2 ? this.BarsType($r('app.media.tabbar_interview_fill'), '面经') :
              this.BarsType($r('app.media.tabbar_interview'), '面经'))

            TabContent() {
              Mine()
            }.tabBar(this.currentIndex == 3 ? this.BarsType($r('app.media.tabbar_mine_fill'), '我的') :
              this.BarsType($r('app.media.tabbar_mine'), '我的'))

          }.onChange((index) => {
            this.currentIndex = index
          })

        }
        .height('100%')
        .width('100%')

      }.hideNavBar(false)
      .title('title栏')
      .hideTitleBar(true)//隐藏导航栏
      .mode(NavigationMode.Stack)
    }

}