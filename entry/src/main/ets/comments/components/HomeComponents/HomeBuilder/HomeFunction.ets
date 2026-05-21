import { navStack } from "../../../router/NavigationService"

@Component
export struct HomeFunction {
  @Prop context: string[]
  @State toolList: ToolItem[] = [
    { name: '小面AI', icon: $r('app.media.home_aiPic') },
    { name: '前端常用词', icon: $r('app.media.home_frontendPic') }
  ]

  build() {
    Column() {
      this.sectionTitle('训练专区')
      this.trainingRow()

      this.sectionTitle('辅助工具')
      this.toolRow()

      this.sectionTitle('知识点学习')
      this.knowledgeList()
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  sectionTitle(title: string) {
    Row() {
      Text(title)
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ left: 18 })
      Blank()
    }
    .width('100%')
    .margin({ top: 18 })
  }

  @Builder
  trainingRow() {
    Row() {
      Image($r('app.media.ic_frontend'))
        .width(176)
        .onClick(() => { navStack.pushPath({ name: 'Frontend' }) })

      Image($r('app.media.ic_hongmeng'))
        .width(176)
        .onClick(() => { navStack.pushPath({ name: 'HarmonyOS' }) })
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceEvenly)
    .margin({ top: 12, left: 20, right: 20 })
  }

  @Builder
  toolRow() {
    Row({ space: 10 }) {
      ForEach(this.toolList, (item: ToolItem) => {
        Row({ space: 8 }) {
          Text(item.name).fontSize(16)
          Image(item.icon).width(28)
        }
        .width(176)
        .borderRadius(12)
        .justifyContent(FlexAlign.SpaceAround)
        .height('68')
        .backgroundColor($r('app.color.diy_little_gray'))
      })
    }
    .width("100%")
    .justifyContent(FlexAlign.SpaceEvenly)
    .margin({ top: 12, left: 20, right: 20 })
  }

  @Builder
  knowledgeList() {
    List() {
      ForEach(this.context, (item: string) => {
        ListItem() {
          Row() {
            Text(item)
              .fontSize(20)
              .fontStyle(FontStyle.Italic)
              .fontWeight(FontWeight.Normal)
            Blank()
            Image($r('app.media.arrow_right'))
              .width(20)
              .colorFilter(Color.White)
          }
          .width('100%')
          .height(38)
          .borderRadius(12)
          .margin({ top: 10 })
          .backgroundColor($r('app.color.diy_little_gray'))
        }
      })
    }
    .margin({ top: 18, left: 20, right: 20 })
    .width('360')
    .layoutWeight(1)
  }
}

interface ToolItem {
  name: string
  icon: Resource
}
