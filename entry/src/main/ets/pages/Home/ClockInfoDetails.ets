import { ClockIn } from "../../model/Model"

@Builder
export function ClockInfoDetailsBuilder() {
  ClockInfoDetails()
}

@Component
export struct ClockInfoDetails{
  @State ClockParams:ClockIn = {nickName:'',//昵称
    avatar:'',//头像
    miniAppPicture:'', //小程序二维码
    miniAppName:'', //小程序名
    miniAppLogo:'', //小程序Logo
    clockinNumbers:0,//连续打卡的天数
    clockinTotal:0//打卡总天数
     }

  aboutToAppear(): void {
    console.log('yan','到达打卡详情界面');
  }

  build() {
    NavDestination(){
      Column(){
        Text(this.ClockParams.nickName)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
        Text('连续打卡' + this.ClockParams.clockinNumbers + '天')
          .fontSize(18)
        Text('总打卡' + this.ClockParams.clockinTotal + '天')
          .fontSize(18)
      }
      .width('100%')
      .height('100%')
      .padding(20)
      .alignItems(HorizontalAlign.Center)
    }
    .onReady((context: NavDestinationContext) => {
      console.log('yan', 'onReady触发, param:' + JSON.stringify(context.pathInfo.param))
      const param = context.pathInfo.param as ClockIn
      if (param) {
        this.ClockParams = param
        console.log('yan', '设置数据成功:' + param.nickName + ', 连续:' + param.clockinNumbers)
      }
    }).hideTitleBar(true)
  }
}
