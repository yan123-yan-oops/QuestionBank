import { QuestionItem } from "../../model/Model"

@Component
export struct QuestionListComponent{
  @Prop item: QuestionItem
  build() {

    Column() {
      Row({ space: 10 }) {
        Column() {
          Row() {
            if (this.item.difficulty == 1) {
              Text('简单').fontColor($r('app.color.common_green')).width(40)
                .textAlign(TextAlign.Center)
            } else if (this.item.difficulty == 2 || this.item.difficulty == 3) {
              Text('一般').fontColor($r('app.color.common_blue')).width(40)
                .textAlign(TextAlign.Center)
            } else {
              Text('困难').fontColor(Color.Red).width(40)
                .textAlign(TextAlign.Center)
            }
            Text('  ' + this.item.stem).fontWeight(FontWeight.Bold)
              .layoutWeight(1)

          }.width('100%')
          .alignItems(VerticalAlign.Top)

          Row() {
            Text('点赞:' + this.item.likeCount + '  |  ' + "浏览:" + this.item.views + '  |  ')
              .fontColor($r('app.color.common_gray_02'))
            if (this.item.readFlag == 0) {
              Text('没看过').fontColor($r('app.color.common_gray_02'))
            } else {
              Text('已看过').fontColor($r('app.color.common_gray_02'))
            }
          }.width('100%').margin({ top: 4 })
        }
        .layoutWeight(1)

        Image($r('app.media.dot_grid_1x2'))
          .bindMenu([{
            value: '收藏题目',
            action: () => {
            }
          }, {
            value: '加入错题库',
            action: () => {
            }
          }
          ])
          .width(28)
          .margin({ right: 6 })

      }.justifyContent(FlexAlign.Start).alignItems(VerticalAlign.Center)
      .width('100%')
      .margin({ bottom: 14 })

      Divider()
        .width('100%')
        .height(1)
        .color($r('app.color.diy_little_gray'))
    }
  }
}