import { navStack, EmptyParam } from '../../comments/router/NavigationService';
import { promptAction, PromptAction } from '@kit.ArkUI';
import { apiLogin } from '../../api/HttpRequtsts';
import { auth } from '../../comments/utils/Auth';
import { AxiosError } from '@ohos/axios';
import { userStore } from './UserStore';

interface PageParam {}

const Param: PageParam = {}

@Builder
export function LoginBuilder() {
  Login()
}

@Component
export struct Login {
  @State userName: string = ''
  @State passWord: string = ''
  private Store = userStore!

  build() {
    NavDestination() {

      Column({ space: 10 }) {

        Text('登录界面')

        Image($r('app.media.ic_interview_logo'))
          .width(100)

        TextInput({ placeholder: '请输入账号' })
          .onChange((username) => {
            this.userName = username
          })
        TextInput({ placeholder: '请输入密码' })
          .onChange((password) => {
            this.passWord = password
          })

        //记住密码行(未实现)
        Row({ space: 6 }) {
          Checkbox({ name: "rememberPwd", group: "loginGroup" })
            .select(this.Store.rememberPwd)   // API16 用 select，不是 checked
            .onChange((val: boolean) => {
              this.Store.rememberPwd = val;
            })

          Text("记住密码")
            .fontSize(14)
            .fontColor("#666")
            .onClick(() => {
              // 点文字也能切换
              this.Store.rememberPwd = !this.Store.rememberPwd;
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
                  console.log('yan', '登录成功' + res.token + '后的用户id:' + res.id)
                  promptAction.showToast({ message: '登录成功！' })
                  //更新当前用户状态
                  auth.setUser(res)
                  AppStorage.setOrCreate('isLogin', true)

                  const pendingTarget = AppStorage.get<string>('pendingTargetName')
                  if (pendingTarget) {
                    AppStorage.setOrCreate<string>('pendingTargetName', '')
                    //清空拦截器中暂存的目标页面
                    navStack.replacePathByName(pendingTarget, new EmptyParam())
                  } else {
                    navStack.clear()
                  }
                }).catch((err: AxiosError) => {
                AlertDialog.show({ message: '用户名或密码不正确' })
                console.log('yan', '登录失败：' + JSON.stringify(err)) // ← 看具体错误
              })

            })

          Button('注册')
            .onClick(() => {
              navStack.pushPath({ name: 'RegisterPage' })
            })
        }

      }.width('100%')
      .height('100%')

    }.hideTitleBar(true)
  }
}