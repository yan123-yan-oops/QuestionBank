import {  apiQuestionDetails } from "../../api/HttpRequtsts"
import { InterviewDetailParam, QuestionDetail } from "../../model/Model"
import { navStack, EmptyParam } from "../../comments/router/NavigationService"

@Builder
export function InterviewDetailsBuilder() {
  InterviewDetails()
}

@Component
export struct InterviewDetails{
  @State interviewId:string = ''
  @State interviewDetails: QuestionDetail = {
    id: '',
    stem: '',
    content: '',
    difficulty: 0,
    likeCount: 0,
    views: 0,
    readFlag: 0,
    answer: "",
    stage: "",
    collectFlag: 0,
    likeFlag: 0,
    questionBankType: 0,
    creatorName: "",
    creatorAvatar: "",
    createdAt: ""
  }

  build() {
    NavDestination() {
      Column(){
        Row(){
          Image($r('app.media.ic_common_back')).width('28')
            .onClick(() => {
              navStack.pop()
            })

          Text('面经详情').fontSize(26).fontWeight(FontWeight.Bold)

          Image($r('app.media.share')).width('28')
        }.width('90%')
        .justifyContent(FlexAlign.SpaceBetween)

        Text(this.interviewDetails.stem)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .width('90%')
          .margin(20)

        Divider().height(6).color($r('app.color.common_gray_01'))

        RichText(`<div style="font-size: 66px; line-height: 1;padding-left:38px;">${this.interviewDetails.content}</div>`)//用于解析富文本HTML内容
          .width('100%')
          .layoutWeight(1)

      }.width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      const param = context.pathInfo.param as InterviewDetailParam
      if (param) {
        this.interviewId = param.id
      }
      apiQuestionDetails(this.interviewId)
        .then((res)=>{
            this.interviewDetails = res

        })
    })
  }
}