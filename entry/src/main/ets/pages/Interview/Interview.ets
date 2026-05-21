import { apiQuestionList } from "../../api/HttpRequtsts"
import { navStack } from "../../comments/router/NavigationService"
import { QuestionItem ,InterviewDetailParam} from "../../model/Model"

@Builder
export function InterviewBuilder() {
  Interview()
}


@Component
export struct Interview {
  @State clickIndex: '最新'|'推荐' = '最新'
  @State questionItem: QuestionItem[] = [{
    id: '',
    stem: '', //题干
    difficulty: 0, //难度
    likeCount: 0, //点赞数
    views: 0, //浏览数
    readFlag: 0 //是否已看
  }]

  aboutToAppear(): void {
    apiQuestionList(9).then((res)=>{
      this.questionItem = res.rows //rows数组
    })


  }

  build() {
    Column() {
      //搜索行
      Row() {
        Stack({ alignContent: Alignment.Start }) {
          Image($r('app.media.ic_common_search'))
            .width(16)
            .margin({left:6})

          TextInput({ placeholder: '  请输入内容' })
            .width('90%')
            .margin({left:6})

        }
        .width('90%')

        Image($r('app.media.home_sign'))
          .width(24)
      }
      .width('100%')

      Row(){
        Column(){
          if (this.clickIndex == '最新'){
            Text('最新')
              .fontWeight(FontWeight.Bold)
          }else {
            Text('最新')
              .fontWeight(FontWeight.Normal)
          }

          if (this.clickIndex == '最新') {
            Divider()
              .strokeWidth(2)
              .color('#0078FF')
              .width('50%') // 宽度只占文字一半，不铺满
              .margin({ top: 4 });
          }
        }.width('50%')
        .onClick(()=>{
          this.clickIndex = '最新'
        })

        Column(){
          if (this.clickIndex == '推荐'){
            Text('推荐')
              .fontWeight(FontWeight.Bold)
          }else {
            Text('推荐')
              .fontWeight(FontWeight.Normal)
          }

          if (this.clickIndex == '推荐') {
            Divider()
              .strokeWidth(2)
              .color('#0078FF')
              .width('50%') // 宽度只占文字一半，不铺满
              .margin({ top: 4 });
          }
        }.width('50%')
        .onClick(()=>{
          this.clickIndex = '推荐'
        })
      }

      List() {
        ForEach(this.questionItem, (item: QuestionItem) => {
          ListItem() {
            Column() {
              Row() {
                Image($r('app.media.ic_interview_logo'))
                  .width(18)
                Text('  面经 | ' + item.stem)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
              }
              .width('100%')

              Row() {
                Text(`点赞 ${item.likeCount} | 浏览 ${item.views} | `)
                  .fontColor($r('app.color.common_gray_01'))
                  .fontSize(14)
                Image($r('app.media.share')).width(20)
              }
              .margin({ top: 8 })
            }
            .width('100%')
            .margin(10)
            .alignItems(HorizontalAlign.Start)

          }.onClick(()=>{
            const param:InterviewDetailParam  = {id:'',stem:''}
            param.id = item.id
            param.stem = item.stem
            navStack.pushPathByName('InterviewDetails', param)
          })
        })
      }
      .layoutWeight(1)



    }
    .height('100%')
    .width('100%')
  }
}