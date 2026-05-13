
@Builder
export function MineBuilder() {
  Mine()
}


@Component
export struct Mine {
  @State message: string = 'Hello World';

  build() {
    Column() {


    }
    .height('100%')
    .width('100%')
  }
}