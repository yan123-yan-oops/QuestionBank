import { navStack, EmptyParam } from '../../comments/router/NavigationService';
import { promptAction, PromptAction } from '@kit.ArkUI';
import { apiHasClockIn, apiLogin } from '../../api/HttpRequtsts';
import { auth } from '../../comments/utils/Auth';
import { AxiosError } from '@ohos/axios';
import { preferences } from '@kit.ArkData';

interface PageParam {}

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
    preferences.getPreferences(ctx, 'login_config').then((pref) => {
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
  }

  saveCredentials(): void {
    const ctx = getContext(this)
    preferences.getPreferences(ctx, 'login_config').then((pref) => {
      pref.putSync('username', this.userName)
      pref.putSync('password', this.passWord)
      pref.putSync('rememberPwd', this.rememberPwd)
      pref.flushSync()
    }).catch((err: BusinessError) => {
      console.log('yan', '保存密码失败：' + JSON.stringify(err))
    })
  }

  clearCredentials(): void {
    const ctx = getContext(this)
    preferences.getPreferences(ctx, 'login_config').then((pref) => {
      pref.putSync('username', '')
      pref.putSync('password', '')
      pref.putSync('rememberPwd', false)
      pref.flushSync()
    }).catch((err: BusinessError) => {
      console.log('yan', '清除密码失败：' + JSON.stringify(err))
    })
  }

  build() {
    NavDestination() {

      Column({ space: 10 }) {

        Text('登录界面')

        Image($r('app.media.ic_interview_logo'))
          .width(100)

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

        Row({ space: 8 }) {
          Button('登录')
            .onClick(() => {

              apiLogin(this.userName, this.passWord)
                .then((res) => {
                  console.log('yan', '登录成功'  + '打卡天数:' + res.clockinNumbers)
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
                    navStack.clear()
                  }
                }).catch((err: AxiosError) => {
                AlertDialog.show({ message: '用户名或密码不正确' })
                console.log('yan', '登录失败：' + JSON.stringify(err))
              })

            })

          Button('注册')
            .onClick(() => {
              navStack.pushPath({ name: 'RegisterPage' })
            })
        }

      }.width('90%')
      .height('100%')

    }.hideTitleBar(true)
  }
}
