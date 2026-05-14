
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
      }.width('80%')
      .margin({right:20})

      Row(){

        Image($r('app.media.project01'))
          .height(180)

      }.width('100%')
      .height('200')

      Row(){
        Image($r('app.media.project02'))
          .height(180)

      }.width('100%')
      .height('200')
    }
    .height('100%')
    .width('100%')
  }
}