
@Builder
export function ProjectBuilder() {
  Project()
}


@Component
export struct Project {

  build() {
    Column() {
      Row(){
        Text('项目')
          .fontWeight(FontWeight.Bold)
          .fontSize(30)

        Blank()
      }
    }
    .height('100%')
    .width('100%')
  }
}