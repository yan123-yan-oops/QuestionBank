import { apiFeedBack } from "../../api/HttpRequtsts"
import { navStack } from "../../comments/router/NavigationService"
import { errorType, QuestionItem } from "../../model/Model"
import { promptAction, PromptAction } from "@kit.ArkUI"
import { AxiosError } from "@ohos/axios"
import { JSON } from "@kit.ArkTS"

@Builder
export function QuestionFeedBackBuilder() {
  QuestionFeedBack()
}

@Component
struct QuestionFeedBack {
  @State errorInfo:string = ''
  @State errorList:errorType[] = [
    { name:'cb1',reason:'内容不准或错误',isClicked:false},
    { name:'cb2',reason:'知识点不准确',isClicked:false },
    { name: 'cb3',reason:'题目重复' ,isClicked:false},
    { name:'cb4',reason:'其他',isClicked:false }]
  @State currentID:string = ''
  @State chooseError:Array<string> = []
  build() {
    NavDestination() {
      Stack() {
        Column({space:16}) {
          Row() {
            Image($r('app.media.ic_common_back')).width(28).onClick(()=>{
              navStack.pop()
            })

            Text('意见反馈').fontWeight(FontWeight.Medium).fontSize(26)

            Text().width(28)
          }.width('94%')
          .justifyContent(FlexAlign.SpaceBetween)

          Row(){
            Text('错误类型(可多选)').fontSize(18)
          }.width('94%')

          Column(){
            ForEach(this.errorList,(item:errorType)=>{
              Row({space:8}){
                Checkbox({name:item.name,group:'g'})
                  .shape(CheckBoxShape.CIRCLE)
                  .unselectedColor($r('app.color.common_green'))
                  .selectedColor($r('app.color.common_green'))
                  .onChange((state:boolean)=>{
                    item.isClicked = state
                  })
                Text(item.reason)
              }.width('100%')
              .justifyContent(FlexAlign.Start)

              Divider().height(2).color($r('app.color.common_gray_01'))
            })
          }.width('94%')
          // Divider().height(10).color($r('app.color.common_gray_01'))

          Column({space:10}){
            Row(){
              Text('问题描述(可选项)')
              Blank()
            }.width('94%')

            TextInput({placeholder:'请输入问题描述(可选项)'})
              .width('94%').borderRadius(12).height(200)
              .onChange((info:string)=>{
                this.errorInfo = info
              })
          }.width('100%')


          Button('提交反馈').width('94%').backgroundColor($r('app.color.common_green')).type(ButtonType.Normal).fontColor(Color.White)
            .onClick(()=>{
              if(this.errorList[0].isClicked){
                this.chooseError.push('1')
              }
              if(this.errorList[1].isClicked){
                this.chooseError.push('2')
              }
              if(this.errorList[2].isClicked){
                this.chooseError.push('3')
              }
              if(this.errorList[3].isClicked){
                this.chooseError.push('4')
              }

              apiFeedBack(this.currentID,this.chooseError,this.errorInfo).then((res)=>{
                promptAction.showToast({message:'反馈成功,反馈ID为' + res.id})
                navStack.pop()
              }).catch((err:AxiosError)=>{
                console.log('yan','反馈失败！返回错误' + JSON.stringify(err));
                console.log('yan','反馈失败！返回错误码' + err.code);
                console.log('yan','反馈失败！返回错误信息' + err.message);
              })
            })

        }.padding(10)
        .width('100%')
        .height('100%')
      }
    }.onReady((context:NavDestinationContext)=>{
        const params = context.pathInfo.param as QuestionItem
        if(params){
          this.currentID = params.id
        }
    })
    .hideTitleBar(true)
    .hideToolBar(true)
  }
}