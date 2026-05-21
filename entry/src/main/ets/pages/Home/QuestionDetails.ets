import { AxiosError } from "@ohos/axios"
import { apiOpt, apiQuestionDetails } from "../../api/HttpRequtsts"
import { navStack } from "../../comments/router/NavigationService"
import { QuestionPageParams, QuestionItem } from "../../model/Model"

@Builder
export function QuestionDetailsBuilder() {
  QuestionDetails()
}

@Component
export struct QuestionDetails {
  @State currentItem: QuestionItem = {
    id: '', stem: '', difficulty: 0, likeCount: 0, views: 0, readFlag: 0
  }
  @State questionList: QuestionItem[] = []
  @State currentIndex: number = 0
  @State stem: string = ''
  @State answer: string = ''
  @State stage: string = ''
  @State difficulty: number = 0

  aboutToAppear(): void {
  }

  loadQuestionDetail(id: string): void {
    apiQuestionDetails(id).then((res) => {
      console.log('yan','获取试题详情成功:'+ res.stem +'---'+ res.answer +'---'+ res.stage);
      this.stem = res.stem
      this.answer = res.answer
      this.difficulty = res.difficulty
      this.stage = res.stage[0]
    }).catch((err:AxiosError)=>{
      console.log('yan','获取试题详情错误' + err);
      console.log('yan', '获取试题详情错误码：' + err.code)
      console.log('yan', '获取试题详情错误信息：' + err.message)
    })
  }

  prevQuestion(): void {
    if (this.currentIndex > 0) {
      this.currentIndex--
      this.currentItem = this.questionList[this.currentIndex]
      this.loadQuestionDetail(this.currentItem.id)
    }
  }

  nextQuestion(): void {
    if (this.currentIndex < this.questionList.length - 1) {
      this.currentIndex++
      this.currentItem = this.questionList[this.currentIndex]
      this.loadQuestionDetail(this.currentItem.id)
    }
  }

  build() {
    NavDestination(){
      Column({space:10}) {
        Row(){
          Image($r('app.media.ic_common_back')).fillColor(Color.Black).width(28)
            .onClick(() => { navStack.pop() })
          Text('题目详情').fontSize(26).fontWeight(FontWeight.Regular)
          Image($r('app.media.share')).fillColor(Color.Green).width(28)
        }.width('90%')
        .margin(10)
        .justifyContent(FlexAlign.SpaceBetween)

        Column(){
          Row(){
            Text(this.stem)
              .maxLines(1)
              .textOverflow({overflow: TextOverflow.Ellipsis}) // 超出显示省略号...
          }.width('100%')
          .justifyContent(FlexAlign.Start)

          Row({space:10}){
            if (this.difficulty == 1) {
              Text('简单').fontColor($r('app.color.common_green')).fontSize(12)
                .textAlign(TextAlign.Center).backgroundColor($r('app.color.diy_little_gray')).borderRadius(8)
            } else if (this.difficulty == 2 || this.difficulty == 3) {
              Text('一般').fontColor($r('app.color.common_blue')).fontSize(12)
                .textAlign(TextAlign.Center).backgroundColor($r('app.color.diy_little_gray')).borderRadius(8)
            } else {
              Text('困难').fontColor(Color.Red).fontSize(12)
                .textAlign(TextAlign.Center).backgroundColor($r('app.color.diy_little_gray')).borderRadius(8)
            }

            Text(this.stage).fontSize(12).backgroundColor($r('app.color.common_blue_bg')).borderRadius(8)

            Blank()

            Image($r('app.media.dot_grid_1x3_heng')).width(22)
              .bindMenu([
                {value:'收藏',action:()=>{
                  // apiOpt()
                }},
                {value:'点赞',action:()=>{}},
                {value:'点我反馈',action:()=>{}},
                {value:'试题分享',action:()=>{}}
              ])

          }.width('100%')
        }.width('90%')

        Divider().height(50).color($r('app.color.common_gray_01'))

        Row(){
          Text('答案:').fontWeight(FontWeight.Medium).fontSize(18)
        }.width('90%')
        .justifyContent(FlexAlign.Start)

        Column(){
          RichText(`<div style="font-size: 58px; line-height: 1; padding-left:28px;">${this.answer}</div>`)
            .width('100%')
            .layoutWeight(1)

        }.margin(18)
        .alignItems(HorizontalAlign.Start)
        .width('100%')
        .layoutWeight(1)

        Row({space:18}){
          Row() {
            Image($r('app.media.ic_common_back')).fillColor($r('app.color.common_gray_01')).width('20')
            Text('上一题')
          }.onClick(() => {
            this.prevQuestion()
          })

          Divider().width(10).vertical(true).height(24)

          Row() {
            Text('下一题')
            Image($r('app.media.arrow_right')).fillColor($r('app.color.common_gray_01')).width('20')
          }.onClick(() => {
            this.nextQuestion()
          })
        }.width('100%')
        .justifyContent(FlexAlign.Center)

      }.width('100%')
      .height('100%')
    }
    .onReady((context: NavDestinationContext) => {
      const param = context.pathInfo.param as QuestionPageParams
      if (param) {
        this.currentItem = param.item
        this.questionList = param.list
        this.currentIndex = 0
        for (let i = 0; i < this.questionList.length; i++) {
          if (this.questionList[i].id === this.currentItem.id) {
            this.currentIndex = i
            break
          }
        }
        this.loadQuestionDetail(this.currentItem.id)
      }
    })
    .hideTitleBar(true)
    .hideToolBar(true)
  }
}
