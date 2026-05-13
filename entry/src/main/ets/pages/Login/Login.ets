@Builder
export function LoginBuilder() {
  Login()
}

@Component
export struct Login{
  build() {
    NavDestination() {

      Column(){

        Text('登录界面')

        Image($r('app.media.ic_interview_logo'))
          .width(100)


      }.width('100%')
      .height('100%')








    }
  }
}