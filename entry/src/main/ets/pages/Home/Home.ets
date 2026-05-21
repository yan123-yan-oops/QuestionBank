import { AxiosError } from '@ohos/axios';
import { apiHasClockIn } from '../../api/HttpRequtsts';
import { HomeBanner } from '../../comments/components/HomeComponents/HomeBuilder/HomeBanner';
import { HomeFunction } from '../../comments/components/HomeComponents/HomeBuilder/HomeFunction';
import { HomeHeader } from '../../comments/components/HomeComponents/HomeBuilder/HomeHeader';
import { auth } from '../../comments/utils/Auth';
import { ClockIn, HasFlagIn} from '../../model/Model';

// 必须用 @Builder 暴露，供 route_map 引用
@Builder
export function HomeBuilder() {
  Home()
}

@Component
export struct Home {
  @State context: string[] = ['HTML5', 'CSS', '移动端布局', '各种各样的知识', '还能滑动吗', 'VUE', '456', '567']
  @State bannerList: Resource[] = [$r('app.media.banner_ai'), $r('app.media.banner_pj'), $r('app.media.banner_qa')]
  @State isClock: boolean = false
  //监听登录状态是否发生变化，如果变化就获取打卡信息
  @StorageProp('isLogin') @Watch('onLoginStateChange') isLogin: boolean = false
  @State ClockInDetails: ClockIn = {
    nickName: '',
    avatar: '',
    miniAppPicture:'', //小程序二维码
    clockinNumbers: 0,
    clockinTotal: 0,
    miniAppName:'', //小程序名
    miniAppLogo:''//小程序Logo
  }

  aboutToAppear(): void {
    this.fetchClockInStatus()
  }

  onLoginStateChange(): void {
    if (this.isLogin) {
      this.fetchClockInStatus()
    }
  }

  fetchClockInStatus(): void {
    if (!auth.getUser().token) {
      console.log('yan', '用户未登录，跳过打卡状态获取')
      return
    }

    // apiClockIn().then((res: ClockIn) => {
    //   this.ClockInDetails = res
    //   console.log('yan','获取打卡信息成功:' + JSON.stringify(res))
    // }).catch((err:AxiosError)=>{
    //   console.log('yan','获取打卡信息错误码:' + err.code)
    //   console.log('yan','获取打卡信息错误信息' + err.message);
    // })

    apiHasClockIn().then((res: HasFlagIn) => {
      this.isClock = res.flag
      console.log('yan', '获取打卡状态成功：' + JSON.stringify(res))
    }).catch((err: AxiosError) => {
      console.log('yan', '获取打卡状态错误码：' + err.code)
      console.log('yan', '获取打卡状态错误信息：' + err.message)
    })
  }

  build() {
    Column() {
      //顶行
      HomeHeader({isClock:this.isClock,ClockInDetails:this.ClockInDetails})
      //轮播图
      HomeBanner({bannerList:this.bannerList})

      HomeFunction({context:this.context})

    }
    .height('100%')
    .width('100%')
  }
}
