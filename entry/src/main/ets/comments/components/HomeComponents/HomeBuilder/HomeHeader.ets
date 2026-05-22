import { ClockIn } from "../../../../model/Model"
import { navStack } from "../../../router/NavigationService"
import { auth } from "../../../utils/Auth"

@Component
export struct HomeHeader {
  @Prop isClock: boolean
  @Prop ClockInDetails: ClockIn

  build() {
    Column(){
      Row() {
        Image($r('app.media.line_scanfinder')).fillColor($r('app.color.common_gray_01')).width(22)

        Stack({ alignContent: Alignment.Start }) {
          Image($r('app.media.ic_common_search'))
            .width(18)
            .margin({ left: 20 })

          TextInput({ placeholder: '   请输入内容' })
            .width('86%')
            .margin({ left: 18 })


        }.width('80%')

        Stack({ alignContent: Alignment.Start }) {
          if (this.isClock == false) {
            Image($r('app.media.ic_common_unclock'))
              .width(52)

            Text('打卡').fontSize(18).margin({left:20})
          } else {
            Image($r('app.media.ic_common_clocked'))
              .width(72)

            Text('连续打卡' + auth.getUser().clockinNumbers + '天').fontSize(12)
          }
        }.margin({left:-10})
        .onClick(() => {
          navStack.pushPathByName("ClockInfoDetails",this.ClockInDetails)
          // console.log('yan','加载数据：'+this.ClockInDetails.nickName);
        })

      }.width('96%')
      .margin({left:10,right:10})

    }.width('100%')
  }
}
