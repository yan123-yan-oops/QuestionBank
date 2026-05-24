import { auth } from "../../comments/utils/Auth";
import { navStack } from "../../comments/router/NavigationService";

@Builder
export function ClockInfoDetailsBuilder() {
  ClockInfoDetails()
}

@Component
export struct ClockInfoDetails {
  @State isClock: boolean = false
  @State userName: string = ''
  @State userAvatar: ResourceStr = ''
  @State clockinNumbers: number = 0
  @State totalTime: number = 0

  aboutToAppear(): void {
    console.log('yan', '到达打卡详情界面');

    // 从本地用户数据获取信息
    const user = auth.getUser()
    this.userName = user.nickname || user.username
    this.userAvatar = user.avatar
    this.clockinNumbers = user.clockinNumbers
    this.totalTime = user.totalTime
  }

  /**
   * 格式化学习时长：将秒数转为 "X小时Y分钟"
   */
  formatTime(seconds: number): string {
    if (seconds <= 0) return '0分钟'
    const hours = Math.floor(seconds / 3600)
    const mins = Math.floor((seconds % 3600) / 60)
    if (hours > 0) {
      return `${hours}小时${mins > 0 ? mins + '分钟' : ''}`
    }
    return `${mins}分钟`
  }

  build() {
    NavDestination() {
      Column() {
        // 上半部分用户打卡信息
        Stack() {
          // 背景图
          Image($r('app.media.clocked_bg'))
            .width('100%')
            .height(300)
            .objectFit(ImageFit.Cover)

          // 覆盖在背景上的内容
          Column() {
            // 顶部导航栏
            Row() {
              Image($r('app.media.ic_common_back'))
                .width(28)
                .height(28)
                .onClick(() => {
                  navStack.pop()
                })

              Blank()

              Image($r('app.media.ic_home_more'))
                .width(28)
                .height(28)
            }
            .width('90%')

            // 用户打卡信息区
            Column({ space: 10 }) {
              // 头像
              Image(this.userAvatar || $r('app.media.startIcon'))
                .width(72)
                .height(72)
                .borderRadius(36)
                .border({ width: 3, color: Color.White })

              // 昵称
              Text(this.userName || '未知用户')
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.Black)

              // 打卡状态
              Row({ space: 6 }) {
                Image(this.isClock ? $r('app.media.ic_mine_like') : $r('app.media.ic_common_unclock'))
                  .width(22)
                  .height(22)
                Text(this.isClock ? '今日已打卡' : '今日未打卡')
                  .fontSize(16)
                  .fontColor(Color.Black)
              }
              .alignItems(VerticalAlign.Center)
            }
            .margin({ top: 16 })
            .alignItems(HorizontalAlign.Center)
          }
          .alignItems(HorizontalAlign.Center)
          .width('100%')
        }
        .width('100%')
        .height(300)
        .clip(true)

        // 数据卡片（负 margin 产生重叠效果）
        Row({ space: 16 }) {
          // 连续打卡
          Column({ space: 8 }) {
            Text(String(this.clockinNumbers))
              .fontSize(34)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.common_main_color'))
            Text('连续打卡天数')
              .fontSize(14)
              .fontColor($r('app.color.common_gray_03'))
          }
          .layoutWeight(1)
          .padding({ top: 20, bottom: 20 })
          .backgroundColor(Color.White)
          .borderRadius(14)

          // 累计学习时长
          Column({ space: 12 }) {
            Text(String(Math.floor(this.totalTime / 60)))
              .fontSize(34)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.common_green'))
            Text('累计学习时长')
              .fontSize(14)
              .fontColor($r('app.color.common_gray_03'))
          }
          .layoutWeight(1)
          .padding({ top: 20, bottom: 20 })
          .backgroundColor(Color.White)
          .borderRadius(14)
        }
        .width('90%')
        .margin({ top: -36 })
        .shadow({
          radius: 10,
          color: '#1A000000',
          offsetY: 6
        })

        // 打卡激励语
        Row({ space: 8 }) {
          Image($r('app.media.ic_mine_like'))
            .width(20)
            .height(20)
            .fillColor($r('app.color.common_main_color'))
          Text('坚持打卡，每天进步一点点！')
            .fontSize(16)
            .fontColor($r('app.color.common_gray_03'))
        }
        .width('90%')
        .padding(18)
        .backgroundColor(Color.White)
        .borderRadius(14)
        .margin({ top: 16 })
        .shadow({
          radius: 6,
          color: '#0D000000',
          offsetY: 3
        })

        // 打卡记录摘要
        Column() {
          Row({ space: 8 }) {
            Image($r('app.media.ic_public_calendar_filled'))
              .width(20)
              .height(20)
              .fillColor($r('app.color.common_main_color'))
            Text('打卡记录')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
          }

          Divider()
            .height(1)
            .color($r('app.color.diy_little_gray'))
            .margin({ top: 12, bottom: 12 })

          Row({ space: 12 }) {
            // 今日状态
            Column({ space: 4 }) {
              Text('今日')
                .fontSize(14)
                .fontColor($r('app.color.common_gray_03'))
              Image(this.isClock ? $r('app.media.ic_common_clocked') : $r('app.media.ic_common_unclock'))
                .width(28)
                .height(28)
              Text(this.isClock ? '已打卡' : '未打卡')
                .fontSize(12)
                .fontColor(this.isClock ? $r('app.color.common_green') : $r('app.color.common_gray_03'))
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Center)

            // 连续打卡
            Column({ space: 4 }) {
              Text('连续')
                .fontSize(14)
                .fontColor($r('app.color.common_gray_03'))
              Text(String(this.clockinNumbers))
                .fontSize(28)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.common_main_color'))
              Text('天')
                .fontSize(12)
                .fontColor($r('app.color.common_gray_03'))
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Center)

            // 学习时长
            Column({ space: 4 }) {
              Text('学时')
                .fontSize(14)
                .fontColor($r('app.color.common_gray_03'))
              Text(this.formatTime(this.totalTime))
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.common_green'))
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Center)
          }
        }
        .width('90%')
        .padding(18)
        .backgroundColor(Color.White)
        .borderRadius(14)
        .margin({ top: 16 })
        .shadow({
          radius: 6,
          color: '#0D000000',
          offsetY: 3
        })
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.diy_little_gray'))
    }
    .onReady((context: NavDestinationContext) => {
      console.log('yan', 'ClockInfoDetails onReady, param:' + JSON.stringify(context.pathInfo.param))
      // Mine.ets 传入的是 boolean (isClock)
      const param = context.pathInfo.param as boolean
      if (typeof param === 'boolean') {
        this.isClock = param
      }
    })
    .hideTitleBar(true)
    .hideToolBar(true)
  }
}
