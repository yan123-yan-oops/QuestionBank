import { AxiosError } from '@ohos/axios';
import { apiQuestionList, apiQuestionType } from '../../../api/HttpRequtsts';
import { QuestionItem, QuestionType } from '../../../model/Model';
import { navStack } from '../../router/NavigationService';
import { QuestionListComponent } from './QuestionListComponent';
import { QuestionSortComponent } from './QuestionSortComponent';

@Component
export struct ExerciseComponent {
  @Prop text1: string
  @State questionTypeCurrentIndex: number = 0
  @State QT: QuestionType[] = []
  @State questionItem: QuestionItem[] = [{
    id: '',
    stem: '',
    difficulty: 0,
    likeCount: 0,
    views: 0,
    readFlag: 0
  }]
  @State isSearch: boolean = false

  aboutToAppear(): void {
    apiQuestionType().then((res) => {
      this.QT = res
    }).catch((err: AxiosError) => {
      console.log('yan', '获取题目类型失败：' + JSON.stringify(err))
    })

    this.fetchQuestions(0)
  }

  fetchQuestions(typeIndex: number): void {
    apiQuestionList(10, undefined, undefined, undefined, typeIndex).then((res) => {
      this.questionItem = res.rows
    }).catch((err: AxiosError) => {
      console.log('yan', '请求题目失败' + JSON.stringify(err))
    })
  }

  build() {
    NavDestination() {
      Stack() {
        Column() {
          Column({ space: 12 }) {
            Row() {
              Image($r('app.media.ic_common_back'))
                .width(18)
                .onClick(() => {
                  navStack.pop()
                })

              Blank().width(200)

              TextInput({ placeholder: '搜索题目' })
                .height(32)
                .onClick(() => {})
            }
            .width('100%')
            .margin({ bottom: 2 })

            Row({ space: 12 }) {
              Image($r('app.media.project03'))
                .width(64).height(82).borderRadius(12)
                .margin({ left: 12 })

              Column() {
                Text(this.text1).fontSize(22).fontColor($r('app.color.diy_little_gray')).margin({bottom:6})

                Text('知识点描述以vue技术栈为例的后台管理系统面试题整理').fontSize(16).width('280').fontColor($r('app.color.diy_little_gray')).margin({bottom:6})
                Text('学习进度' + '10%').fontSize(12).fontColor($r('app.color.diy_little_gray'))

              }.layoutWeight(1)
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(HorizontalAlign.Start)

            }.margin({ bottom: 12 })
            .alignItems(VerticalAlign.Top)
            .width('100%')

          }.width('100%')
          .margin({bottom:20})

          Column() {
            Row() {
              Scroll() {
                Row() {
                  Column() {
                    Text('全部')
                      .fontWeight(this.questionTypeCurrentIndex == 0 ? FontWeight.Bold : FontWeight.Normal)
                    if (this.questionTypeCurrentIndex == 0) {
                      Divider().strokeWidth(2).color('#0078FF').width('16%').margin({ top: 4 })
                    }
                  }
                  .padding({ left: 12, right: 12 })
                  .onClick(() => {
                    this.questionTypeCurrentIndex = 0
                    this.fetchQuestions(0)
                  })

                  ForEach(this.QT, (item: QuestionType) => {
                    Column() {
                      Text('' + item.name)
                        .fontColor(this.questionTypeCurrentIndex == item.id ? Color.Black : $r('app.color.common_gray_01'))
                        .fontWeight(this.questionTypeCurrentIndex == item.id ? FontWeight.Bold : FontWeight.Normal)
                      if (this.questionTypeCurrentIndex == item.id) {
                        Divider().strokeWidth(2).color('#0078FF').width('16%').margin({ top: 4 })
                      }
                    }
                    .padding({ left: 12, right: 12 })
                    .onClick(() => {
                      this.questionTypeCurrentIndex = item.id
                      this.fetchQuestions(item.id)
                    })
                  }, (item: QuestionType) => '' + item.id)

                }.borderRadius(12)

              }.height('28')
              .scrollable(ScrollDirection.Horizontal)
              .scrollBar(BarState.Off)
              .layoutWeight(1)
              .borderRadius(12)

              Blank().width(8)

              Image($r('app.media.more'))
                .width('24')
                .backgroundColor(Color.White)
                .onClick(() => {
                  this.isSearch = true
                })

            }.borderRadius(12)
            .clip(true)
            .width('100%')

            Divider()
              .width('100%').height(1)
              .color($r('app.color.diy_little_gray'))
              .margin({ top: 8, bottom: 4 })

            Column() {
              List() {
                ForEach(this.questionItem, (item: QuestionItem) => {
                  ListItem() {
                    QuestionListComponent({ item, questionList: this.questionItem })
                      .margin({bottom:8})
                  }
                })
              }
            }
            .layoutWeight(1)
          }
          .width('100%')
          .layoutWeight(1)
          .margin({ top: -12 })
          .backgroundColor(Color.White)
          .borderRadius({ topLeft: 12, topRight: 12 })
          .clip(true)
        }
        .width('100%')
        .height('100%')

        if (this.isSearch) {
          QuestionSortComponent({
            showPop: this.isSearch,
            close: () => {
              this.isSearch = false
            }
          })
        }
      }.backgroundColor("#9F663E")
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
  }
}
