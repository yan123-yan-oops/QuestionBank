import { router } from '@kit.ArkUI';
import { apiQuestionType } from '../api/HttpRequtsts';

@Entry
@Component
struct Index {
  build() {

      Column() {
        Image($r('app.media.boot'))
          .width(400)
      }
      .height('100%')
      .width('100%')
      .onClick(()=>{
        router.pushUrl({url:'pages/TabsPage'})
      })

    // .linearGradient({
    //   direction: GradientDirection.Bottom,
    //   colors: [
    //     [$r('app.color.common_main_color'), 0.0],
    //     [$r('app.color.white'), 1.0]
    //   ],
    //   repeating: false
    // })
  }
}
