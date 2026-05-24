import { AxiosError } from "@ohos/axios";
import { apiHasClockIn } from "../../api/HttpRequtsts";
import { navStack, EmptyParam } from "../../comments/router/NavigationService";
import { auth } from "../../comments/utils/Auth";
import { LoginStateManager } from "../../comments/utils/LoginStateManagerUtil";
import { HasFlagIn } from "../../model/Model";

@Builder
export function MineBuilder() {
  Mine()
}

@Component
export struct Mine {
  @StorageProp('isLogin') @Watch('onLoginStateChange') isLogin: boolean = false
  @State isClock : boolean = false
  @State userName: string = '';
  @State avatar: ResourceStr = ''
  @State settingTitle:string[] = ['推荐分享','意见反馈','关于我们','开发提示词']

  aboutToAppear(): void {
    this.loadUserInfo()
  }

  onLoginStateChange(): void {
    this.loadUserInfo()
  }

  loadUserInfo(): void {
    if (auth.getToken()) {
      this.userName = auth.getUser().nickname || auth.getUser().username
      this.avatar = auth.getUser().avatar
      apiHasClockIn().then((res:HasFlagIn)=>{
        this.isClock = res.flag
      }).catch((err:AxiosError)=>{
        console.log('yan','获取是否登录错误' + err);
      })
    } else {
      this.userName = ''
      this.avatar = ''
      this.isClock = false
    }
  }

  build() {
    Column({space:20}) {
      //用户信息行：头像 + 用户名（可点击跳转登录）
      Row() {
        Column({ space: 8 }) {
          // 头像
          Image(this.isLogin ? this.avatar : $r('app.media.startIcon'))
            .width(64)
            .height(64)
            .borderRadius(32)
            .border({ width: 2, color: $r('app.color.common_main_color') })

          // 用户名（未登录时点击跳转登录）
          if (this.isLogin) {
            Text(this.userName)
              .fontWeight(FontWeight.Medium)
              .fontSize(20)
          } else {
            Text('点击登录')
              .fontWeight(FontWeight.Medium)
              .fontSize(20)
              .fontColor($r('app.color.common_main_color'))
              .onClick(() => {
                navStack.pushPathByName('Login', new EmptyParam())
              })
          }
        }

        Text(this.isClock ? '已打卡' : '未打卡')
          .onClick(() => {
            navStack.pushPathByName("ClockInfoDetails", this.isClock)
          })
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .width('86%')
      .height('160')
      .margin({top:20})
      .backgroundColor('argb(0.0,0,0,0)')

      //工具行
      Row({ space: 12 }) {
        Column({space:6}) {
          Image($r('app.media.ic_collect')).width(24)
          Text('历史记录').fontWeight(FontWeight.Normal).fontSize(17)
        }

        Column({space:6}) {
          Image($r('app.media.ic_history')).width(24)
          Text('我的收藏').fontWeight(FontWeight.Normal).fontSize(17)
        }

        Column({space:6}) {
          Image($r('app.media.ic_like')).width(24)
          Text('我的点赞').fontWeight(FontWeight.Normal).fontSize(17)
        }

        Column({space:6}) {
          Image($r('app.media.ic_study')).width(24)
          Text('累计学时').fontWeight(FontWeight.Normal).fontSize(17)
          Column() {
            Text('')
          }
        }
      }.backgroundColor(Color.White)
      .borderRadius(8)
      .padding(12)
      .width('86%')

      Row({space:10}){
        Row(){
         Text('小面AI').fontSize(17)
         Image($r('app.media.home_aiPic')).width(24)
        }.layoutWeight(1)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .padding(12)
        .justifyContent(FlexAlign.SpaceBetween)

        Row(){
          Text("前端常用词").fontSize(17)
          Image($r('app.media.home_frontendPic')).width(24)
        }.layoutWeight(1)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .padding(12)
        .justifyContent(FlexAlign.SpaceBetween)
      }.width('86%')

      //设置栏
      Column({space:18}){
        ForEach(this.settingTitle,(item:string)=>{
          Row(){
            Text(item)
            Image($r('app.media.arrow_right')).width(20).fillColor($r('app.color.common_gray_01'))
          }.width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .onClick(()=>{
            if(item=='开发提示词'){
              navStack.pushPathByName('DevPrompt',Param)
            }
          })
        })

      }.width('86%')
      .backgroundColor(Color.White)
      .borderRadius(8)
      .padding(12)

    }.height('100%')
    .width('100%')
      .linearGradient({
        direction: GradientDirection.Left,
        colors: [
          ['#F0F9F2', 0.0],
          ['#D8F3DC', 0.5],
          ['#F0F9F2', 1.0]
        ]
      });

  }
}
