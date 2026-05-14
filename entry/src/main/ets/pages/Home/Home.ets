// 必须用 @Builder 暴露，供 route_map 引用
@Builder
export function HomeBuilder() {
  Home()
}

@Component
export struct Home {
  @Consume("navStack") pageStack: NavPathStack
  @State context:string[] =['HTML5','CSS','移动端布局','各种各样的知识','还能滑动吗','123','456','567']

  build() {
    Column() {
      Row({ space: 22 }) {
        Stack({ alignContent: Alignment.Start }) {
          Image($r('app.media.ic_common_search'))
            .width(20)

          TextInput({ placeholder: '  请输入内容' })
            .width('90%')
            .margin({ left: 18 })
        }
        .width('100%')

        Image($r('app.media.home_sign'))
          .width(10)
      }
      .width('100%')

      Image($r('app.media.banner_pj'))
        .width(360)
        .borderRadius(14)
        .margin({ top: 18 })

      Row() {
        Text('训练专区')
          .fontWeight(FontWeight.Bold)
          .fontSize(28)
          .margin({ left: 18 })

        Blank()
      }
      .width('100%')

      //训练专区行
      Row() {

        Image($r('app.media.ic_frontend'))
          .width(176)
          .onClick(() => {
            this.pageStack.pushPathByName('Frontend', Param)
          })

        Image($r('app.media.ic_hongmeng'))
          .width(176)
          .onClick(() => {
            this.pageStack.pushPathByName('HarmonyOS', Param)
          })

      }.width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
      .margin({ top: 12, left: 20, right: 20 })

      //辅助工具行
      Row() {
        Text('辅助工具')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)

        Blank()
      }.width('100%')
      .margin({ top: 18, left: 18 })

      Row({ space: 10 }) {
        Row({ space: 8 }) {
          Text('小面AI')
            .fontSize(16)

          Image($r('app.media.home_aiPic'))
            .width(28)

        }.width(176)
        .borderRadius(12)
        .justifyContent(FlexAlign.SpaceAround)
        .height('68')
        .backgroundColor($r('app.color.diy_little_gray'))

        Row({ space: 8 }) {
          Text('前端常用词')
            .fontSize(16)

          Image($r('app.media.home_frontendPic'))
            .width(28)
        }.width(176)
        .justifyContent(FlexAlign.SpaceAround)
        .borderRadius(12)
        .height('68')
        .backgroundColor($r('app.color.diy_little_gray'))

      }.width("100%")
      .justifyContent(FlexAlign.SpaceEvenly)
      .margin({ top: 12, left: 20, right: 20 })

      Row() {
        Text('知识点学习')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)

        Blank()
      }.width('100%')
      .margin({ top: 18, left: 18 })

      List() {
          ForEach( this.context , (item:string)=>{
            ListItem(){
              Row(){

                Text(item)
                  .fontSize(20)
                  .fontStyle(FontStyle.Italic)
                  .fontWeight(FontWeight.Normal)

                Blank()

                Image($r('app.media.arrow_right'))
                  .width(20)
                  .colorFilter(Color.White)

              }.width('100%')
              .height(38)
              .borderRadius(12)
              .margin({top : 10})
              .backgroundColor($r('app.color.diy_little_gray'))
            }
          })
      }.margin({top:18,left:20,right:20})
      .width('360')
      .layoutWeight(1)

    }
    .height('100%')
    .width('100%')
  }
}