@Builder
export function RegisterBuilder() {
  Register()
}

@Component
export struct Register{
  build() {
    NavDestination(){
      Column(){
        Text('注册功能未开放')
      }
    }.hideTitleBar(true)
  }
}