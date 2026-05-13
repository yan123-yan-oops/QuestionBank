
@Builder
export function InterviewBuilder() {
  Interview()
}


@Component
export struct Interview {
  @State message: string = 'Hello World';

  build() {
    Column() {
    }
    .height('100%')
    .width('100%')
  }
}