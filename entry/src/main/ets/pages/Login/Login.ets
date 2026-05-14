@Builder
export function LoginBuilder() {
  Login()
}

@Component
export struct Login {
  @State userName: string = ''
  @State passWord: string = ''
  @Consume("navStack") pageStack:NavPathStack

  build() {
    NavDestination() {

      Column() {

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

        Row(){
          Button('登录')
            .onClick(()=>{

            })

          Button('注册')
            .onClick(()=>{
              this.pageStack.pushPathByName('Register',Param)
            })
        }

      }.width('100%')
      .height('100%')

    }
  }
}