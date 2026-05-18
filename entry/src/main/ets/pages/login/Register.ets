@Builder
export function RegisterBuilder() {
  Register()
}

@Component
export struct Register{
  build() {
    NavDestination(){
      Column(){

      }
    }.hideTitleBar(true)
  }
}