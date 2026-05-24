import { AxiosError } from "@ohos/axios"
import { apiQuestionList, apiQuestionRecommends } from "../../api/HttpRequtsts"
import { navStack, EmptyParam } from "../../comments/router/NavigationService"
import { QuestionItem, InterviewDetailParam, QuestionRecommendsDetail } from "../../model/Model"

@Builder
export function InterviewBuilder() {
  Interview()
}

@Component
export struct Interview {
  @State clickIndex: '最新'|'推荐' = '最新'
  @State newQuestionItem: QuestionItem[] = [{
    id: '',
    stem: '', //题干
    difficulty: 0, //难度
    likeCount: 0, //点赞数
    views: 0, //浏览数
    readFlag: 0 //是否已看
  }]
  @State recommendQuestionItem: QuestionRecommendsDetail[] = []
  @StorageProp('isLogin') @Watch('onLoginStateChange') isLogin: boolean = false

  aboutToAppear(): void {

    this.loadData()
  }

  onLoginStateChange(): void {
    if (this.isLogin) {
      this.loadData()
    }
  }//回调，在检测到登录后再用

  loadData(): void {
    apiQuestionList(9).then((res)=>{
      this.newQuestionItem = res.rows
      console.log('yan','成功获取到最新面经列表:' + this.newQuestionItem[0].id);
    }).catch((err:AxiosError)=>{
      console.log('yan','获取面经最新列表失败' + err);
      console.log('yan','获取面经最新列表错误码' + err.code);
      console.log('yan','获取面经最新列表详细信息' + err.message);
    })

    apiQuestionRecommends().then((res)=> {
      this.recommendQuestionItem = res.rows
      console.log('yan','成功获取到推荐面经列表:' + JSON.stringify(res));
    }).catch((err:AxiosError)=>{
      console.log('yan','获取面经推荐列表失败' + err);
      console.log('yan','获取面经推荐列表错误码' + err.code);
    })
  }

  build() {
    Column({space:10}) {
      //搜索行
      Row() {
        Stack({ alignContent: Alignment.Start }) {
          Image($r('app.media.ic_common_search'))
            .width(16)
            .margin({left:10})

          TextInput({ placeholder: '  请输入内容' })
            .width('90%')
            .margin({left:10})

        }.width('90%')

        Image($r('app.media.home_sign'))
          .width(24)
      }.width('100%')

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
              .width('50%')
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
              .width('50%')
              .margin({ top: 4 });
          }
        }.width('50%')
        .onClick(()=>{
          this.clickIndex = '推荐'
        })
      }

      // 列表区域 —— 根据 tab 和登录状态切换
      if (this.clickIndex == '最新') {
        List() {
          ForEach(this.newQuestionItem, (item: QuestionItem) => {
            ListItem() {
              this.renderItem(item)
            }.onClick(() => {
              const param: InterviewDetailParam = { id: item.id, stem: item.stem }
              navStack.pushPathByName('InterviewDetails', param)
            })
          })
        }
        .layoutWeight(1)
      } else if (this.clickIndex == '推荐' && !this.isLogin) {
        // 未登录 → 显示登录引导占位
        Column() {
          Image($r('app.media.ic_mine_logo'))
            .width(80)
            .height(80)
            .margin({ bottom: 20 })

          Text('登录后查看更多推荐面经')
            .fontSize(16)
            .fontColor($r('app.color.common_gray_03'))

          Button('去登录')
            .height(44)
            .width(160)
            .borderRadius(22)
            .backgroundColor($r('app.color.common_main_color'))
            .fontColor(Color.White)
            .fontSize(16)
            .margin({ top: 24 })
            .onClick(() => {
              navStack.pushPathByName('Login', new EmptyParam())
            })
        }
        .layoutWeight(1)
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else {
        List() {
          ForEach(this.recommendQuestionItem, (item: QuestionRecommendsDetail) => {
            ListItem() {
              this.renderRecommendItem(item)
            }.onClick(() => {
              const param: InterviewDetailParam = { id: String(item.id), stem: item.stem }
              navStack.pushPathByName('InterviewDetails', param)
            })
          })
        }
        .layoutWeight(1)
      }

    }
    .height('100%')
    .width('100%')
  }
  // 最新面经 Item
  @Builder
  renderItem(item: QuestionItem) {
    Column() {
      Row() {
        Image($r('app.media.ic_interview_logo')).width(18)
        Text('  面经 | ' + item.stem).fontSize(16).fontWeight(FontWeight.Bold)
      }
      Row() {
        Text(`点赞 ${item.likeCount} | 浏览 ${item.views} | `)
          .fontColor($r('app.color.common_gray_01'))
          .fontSize(14)
        Image($r('app.media.share')).width(20)
      }
    }
    .width('100%')
    .margin(10)
    .alignItems(HorizontalAlign.Start)
  }

  // 推荐面经 Item（字段完全兼容，所以可以一样）
  @Builder
  renderRecommendItem(item: QuestionRecommendsDetail) {
    Column() {
      Row() {
        Image($r('app.media.ic_interview_logo')).width(18)
        Text('  面经 | ' + item.stem).fontSize(16).fontWeight(FontWeight.Bold)
      }
      Row() {
        Text(`点赞 ${item.likeCount} | 浏览 ${item.views} | `)
          .fontColor($r('app.color.common_gray_01'))
          .fontSize(14)
        Image($r('app.media.share')).width(20)
      }
    }
    .width('100%')
    .margin(10)
    .alignItems(HorizontalAlign.Start)
  }
}
