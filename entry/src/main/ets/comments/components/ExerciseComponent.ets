@Component
export struct ExerciseComponent {
  @Consume("navStack") pageStack: NavPathStack
  @Prop text1:string
  build() {
    NavDestination() {
      //当使用 Navigation + pushPathByName + 系统路由表（ route_map.json ）跳转时，
      //跳转到的目标页面 必须 使用 NavDestination 组件作为根容器。
      Column() {

        //上半部分
        Column({ space: 20 }) {

          Row() {
            Image($r('app.media.ic_common_back'))
              .width(18)
              .onClick(() => {
                this.pageStack.pop()
              })

            Text().width(200)

            TextInput({ placeholder: '搜索题目' })

          }.width('100%')

          Row({ space: 18 }) {

            Image($r('app.media.project03'))
              .width(120)
              .margin({ left: 12 })

            Column() {
              Text(this.text1)
                .fontSize(28)
              Text('知识点描述以vue技术栈为例的后台管理系统面试题整理')
                .fontSize(20)
              Text('学习进度' + '10%')
                .fontSize(16)
            }.height('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(HorizontalAlign.Start)

          }.width('100%')
          .layoutWeight(1)

        }.width('100%')
        .height('32%')
        .backgroundColor($r('app.color.common_main_color'))

        //下半部分
        Column() {

          Row() {
            Scroll(){
               Row(){
                 Button()
                 Button()
                 Button()
                 Button()
                 Button()
                 Button()
               }

            }.scrollable(ScrollDirection.Horizontal)
            .scrollBar(BarState.Off)
          }

        }
        .borderRadius({ topLeft: 12, topRight: 12 })
        .backgroundColor(Color.White)
        .layoutWeight(1)

      }
      .height('100%')
      .width('100%')
    }
  }
}
