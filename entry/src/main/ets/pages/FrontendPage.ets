@Entry
@Component
struct FrontendPage {
  @State message: string = 'Hello World';

  build() {
    Column() {

      Column({space:20}) {

        Row() {
          Image($r('app.media.ic_common_back'))
            .width(18)

          Text().width(200)

          TextInput({placeholder:'搜索题目'})

        }.width('100%')

        Row({space:18}){

          Image($r('app.media.project03'))
            .width(120)
            .margin({left:12})

          Column(){
            Text('前端知识点')
              .fontSize(28)
            Text('知识点描述以vue技术栈为例的后台管理系统面试题整理')
              .fontSize(20)
            Text('学习进度'+'10%')
              .fontSize(16)
          }.height('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(HorizontalAlign.Start)

        }.width('100%')
        .layoutWeight(1)

      }.width('100%')
      .height('32%')
      .backgroundColor($r('app.color.common_main_color'))

      Column() {

        Row() {

        }

      }
      .borderRadius({ topLeft:12 ,topRight:12})
      .backgroundColor(Color.White)
      .layoutWeight(1)

    }
    .height('100%')
    .width('100%')
  }
}