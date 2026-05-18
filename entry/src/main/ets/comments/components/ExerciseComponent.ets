import { AxiosError } from '@ohos/axios';
import { apiQuestionList, apiQuestionType } from '../../api/HttpRequtsts';
import { QuestionItem, QuestionType } from '../../model/Model';
import { navStack } from '../router/NavigationService';
import { QuestionListComponent } from './QuestionListComponent';

@Component
export struct ExerciseComponent {
  @Prop text1: string
  @State QT: QuestionType[] = []
  @State questionItem: QuestionItem[] = [{
    id: '',
    stem: '', //题干
    difficulty: 0, //难度
    likeCount: 0, //点赞数
    views: 0, //浏览数
    readFlag: 0 //是否已看
  }]

  aboutToAppear(): void {
    //请求数据
    apiQuestionType().then((res) => {
      this.QT = res
    }).catch((err: AxiosError) => {
      console.log('yan', '获取题目类型失败：' + JSON.stringify(err))
    })

    apiQuestionList(10).then((res) => {
      this.questionItem = res.rows
    })
  }

  build() {
    NavDestination() {
      Column() {

        //上半部分
        Column({ space: 20 }) {

          Row() {
            Image($r('app.media.ic_common_back'))
              .width(18)
              .onClick(() => {
                navStack.pop()
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

          }
          .width('100%')
          .layoutWeight(1)

        }.width('100%')
        .height('32%')
        .backgroundColor($r('app.color.common_main_color'))

        //下半部分
        //按钮行
        Column() {

          Row() {
            Scroll() {
              Row() {

                Button('全部')
                  .backgroundColor(Color.White)
                  .fontColor(Color.Black)
                  .fontWeight(FontWeight.Normal)

                ForEach(this.QT, (item: QuestionType) => {
                  Button('' + item.name)
                    .backgroundColor(Color.White)
                    .fontColor(Color.Black)
                }, (item: QuestionType) => '' + item.id)
              }
            }.scrollable(ScrollDirection.Horizontal)
            .scrollBar(BarState.Off)
          }

          //题目列表
          Column() {
            List() {
              ForEach(this.questionItem, (item: QuestionItem) => {
                ListItem() {
                  QuestionListComponent({ item })
                }
              })
            }
          }.layoutWeight(1)

        }
        .borderRadius({ topLeft: 12, topRight: 12 })
        .backgroundColor(Color.White)
        .layoutWeight(1)

      }
      .height('100%')
      .width('100%')
    }
    .hideTitleBar(true)
  }
}