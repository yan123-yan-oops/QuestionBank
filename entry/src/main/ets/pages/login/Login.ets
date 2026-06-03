import { navStack, EmptyParam } from '../../comments/router/NavigationService';
import { promptAction } from '@kit.ArkUI';
import {  apiLogin } from '../../api/HttpRequtsts';
import { auth } from '../../comments/utils/Auth';
import { AxiosError } from '@ohos/axios';
import { preferences } from '@kit.ArkData';

@Builder
export function LoginBuilder() {
  Login()
}

@Component
export struct Login {
  @State userName: string = ''
  @State passWord: string = ''
  @State rememberPwd: boolean = false

  aboutToAppear(): void {
    const ctx = getContext(this)
    try {
      preferences.getPreferences(ctx, 'login_config').then((pref) => {//用户首选项--轻量级、不保密 -->一般保存用户设置偏好和应用配置参数
        const savedUsername = pref.getSync('username', '') as string
        const savedPassword = pref.getSync('password', '') as string
        const savedRemember = pref.getSync('rememberPwd', false) as boolean
        if (savedRemember && savedUsername && savedPassword) {
          this.userName = savedUsername
          this.passWord = savedPassword
          this.rememberPwd = true
        }
      }).catch((err:BusinessError) => {
        console.log('yan', '读取保存的密码失败：' + JSON.stringify(err))
      })
    }catch (err){
      console.log('yan',err);
    }
  }

  saveCredentials(): void {
    const ctx = getContext(this)
    try {
      preferences.getPreferences(ctx, 'login_config').then((pref) => {
        pref.putSync('username', this.userName)
        pref.putSync('password', this.passWord)
        pref.putSync('rememberPwd', this.rememberPwd)
        pref.flushSync()
      }).catch((err: BusinessError) => {
        console.log('yan', '保存密码失败：' + JSON.stringify(err))
      })
    }catch (err){
      console.log('yan',err);
    }
  }

  clearCredentials(): void {
    const ctx = getContext(this)
    try {
      preferences.getPreferences(ctx, 'login_config').then((pref) => {
        pref.putSync('username', '')
        pref.putSync('password', '')
        pref.putSync('rememberPwd', false)
        pref.flushSync()
      }).catch((err: BusinessError) => {
        console.log('yan', '清除密码失败：' + JSON.stringify(err))
      })
    }catch (err){
      console.log('yan',err);
    }

  }

  build() {
    NavDestination() {

      Column({ space: 10 }) {

        Image($r('app.media.ic_interview_logo'))
          .width(100)

        Text('面试通')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)

        Text('搞定企业面试，就用面试通')
          .fontSize(14)
          .fontColor($r('app.color.common_gray_01'))

        TextInput({ placeholder: '请输入账号', text: this.userName })
          .onChange((value: string) => {
            this.userName = value
          })
        TextInput({ placeholder: '请输入密码', text: this.passWord }).type(InputType.Password)
          .onChange((value: string) => {
            this.passWord = value
          })

        Row({ space: 6 }) {
          Checkbox({ name: "rememberPwd", group: "loginGroup" })
            .select(this.rememberPwd)
            .onChange((val: boolean) => {
              this.rememberPwd = val
            })

          Text("记住密码")
            .fontSize(14)
            .fontColor("#666")
            .onClick(() => {
              this.rememberPwd = !this.rememberPwd
            })
        }
        .width("100%")
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Start)

        Button('登录')
          .width('80%')
          .borderRadius(0)
          .onClick(() => {

            apiLogin(this.userName, this.passWord)
              .then((res) => {
                console.log('yan', '登录成功'  + '打卡天数:' + res.clockInNumbers)
                promptAction.showToast({ message: '登录成功！' })
                auth.setUser(res)

                if (this.rememberPwd) {
                  this.saveCredentials()
                } else {
                  this.clearCredentials()
                }

                console.log('yan','当前用户的token是：'+auth.getToken());

                AppStorage.setOrCreate('isLogin', true)

                const pendingTarget = AppStorage.get<string>('pendingTargetName')
                if (pendingTarget) {
                  AppStorage.setOrCreate<string>('pendingTargetName', '')
                  navStack.replacePathByName(pendingTarget, new EmptyParam())
                } else {
                  navStack.pop()
                }
              }).catch((err: AxiosError) => {
              AlertDialog.show({ message: '用户名或密码不正确' })
              console.log('yan', '登录失败：' + JSON.stringify(err))
            })

          })

      }.width('90%')
      .height('100%')

    }.hideTitleBar(true)
  }
}
