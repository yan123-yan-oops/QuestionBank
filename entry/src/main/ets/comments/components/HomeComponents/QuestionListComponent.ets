import { QuestionItem, QuestionPageParams } from "../../../model/Model"
import { navStack } from "../../router/NavigationService"

@Component
export struct QuestionListComponent{
  @Prop item: QuestionItem
  @Prop questionList: QuestionItem[]
  build() {

    Column() {
      Row({ space: 10 }) {
        Column() {
          Row() {
            if (this.item.difficulty == 1) {
              Text('简单').fontColor($r('app.color.common_green')).fontSize(12)
                .textAlign(TextAlign.Center).backgroundColor($r('app.color.diy_little_gray')).borderRadius(18)
            } else if (this.item.difficulty == 2 || this.item.difficulty == 3) {
              Text('一般').fontColor($r('app.color.common_blue')).fontSize(12)
                .textAlign(TextAlign.Center).backgroundColor($r('app.color.diy_little_gray')).borderRadius(18)
            } else {
              Text('困难').fontColor(Color.Red).fontSize(12)
                .textAlign(TextAlign.Center).backgroundColor($r('app.color.diy_little_gray')).borderRadius(18)
            }
            Text('  ' + this.item.stem).fontWeight(FontWeight.Normal)
              .fontSize(18)
              .maxLines(1)// 强制最多1行
              .textOverflow({overflow: TextOverflow.Ellipsis}) // 超出显示省略号...
              .layoutWeight(1)

          }.width('100%')
          .alignItems(VerticalAlign.Top)

          Row() {
            Text('点赞:' + this.item.likeCount + '  |  ' + "浏览:" + this.item.views + '  |  ')
              .fontColor($r('app.color.common_gray_02')).fontSize(14)
            if (this.item.readFlag == 0) {
              Text('没看过').fontColor($r('app.color.common_gray_02')).fontSize(14)
            } else {
              Text('已看过').fontColor($r('app.color.common_gray_02')).fontSize(14)
            }
          }.width('100%').margin({ top: 4 })
        }
        .layoutWeight(1)

        Image($r('app.media.dot_grid_1x3'))
          .bindMenu([{
            value: '收藏题目',
            action: () => {
              //收藏题目逻辑
            }
          }, {
            value: '加入错题库',
            action: () => {
              //加入错题库逻辑
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
    }.margin({left:12})
    .onClick(()=>{
      navStack.pushPathByName('QuestionDetails', { item: this.item, list: this.questionList } as QuestionPageParams)
    })
  }
}