import { navStack, EmptyParam } from '../comments/router/NavigationService';
import { setupRouterInterceptor } from '../comments/router/RouterInterceptor';

@Entry
@Component
struct Index {
  aboutToAppear(): void {
    setupRouterInterceptor(navStack)
  }

  build() {
    Navigation(navStack) {
      Column() {
        Image($r('app.media.boot'))
          .width(400)
      }
      .height('100%')
      .width('100%')
      .onClick(() => {
        navStack.replacePathByName('TabsPage', new EmptyParam())
      })
    }
    .hideTitleBar(true)
  }
}
