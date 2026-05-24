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
  @State bannerList: Resource[] = [$r('app.media.banner_ai'), $r('app.media.banner_pj'), $r('app.media.banner_qa')]
  @State isClock: boolean = false
  //监听登录状态是否发生变化，如果变化就获取打卡信息
  @StorageProp('isLogin') @Watch('onLoginStateChange') isLogin: boolean = false

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
      HomeHeader({isClock:this.isClock})
      //轮播图
      HomeBanner({bannerList:this.bannerList})

      HomeFunction().layoutWeight(1)

    }
    .height('100%')
    .width('100%')
  }
}
