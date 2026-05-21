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
        Stack({ alignContent: Alignment.Start }) {
          Image($r('app.media.ic_common_search'))
            .width(16)
            .margin({ left: 6 })

          TextInput({ placeholder: '   请输入内容' })
            .width('90%')
            .margin({ left: 6 })


        }.width('85%')

        Stack({ alignContent: Alignment.Start }) {
          if (this.isClock == false) {
            Image($r('app.media.ic_common_unclock'))
              .width(34)

            Text('打卡').fontSize(18)
          } else {
            Image($r('app.media.ic_common_clocked'))
              .width(34)

            Text('已连续打卡' + auth.getUser().clockinNumbers + '天').fontSize(10)
          }
        }.onClick(() => {
          navStack.pushPathByName("ClockInfoDetails",this.ClockInDetails)
          // console.log('yan','加载数据：'+this.ClockInDetails.nickName);
        })

      }.width('100%')

    }.width('100%')
  }
}
