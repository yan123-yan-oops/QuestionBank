
@Builder
export function InterviewBuilder() {
  Interview()
}

export interface interviewListItem{
  title:string
  commentContext:string
  likeCount:number
  lookCount:number
}

@Component
export struct Interview {
  @State clickIndex: '最新'|'推荐' = '最新'
 @State InterviewList:interviewListItem[] = [{title:'21美团3面经验总结',
   commentContext:'挨打的那我i腐败俄方败坏了我发发吧无尽你',
   likeCount:99,
   lookCount:99999}]


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

      List(){
        ListItem(){
          Column(){
            ForEach(this.InterviewList,(item:interviewListItem)=>{
              Column(){
                Row(){
                  Image($r('app.media.ic_interview_logo'))
                    .width('18')

                  Text('  面经 | '+item.title)
                }

                Text(item.commentContext).fontWeight(FontWeight.Normal).fontColor($r('app.color.common_gray_01')).fontSize(16)

                Row(){
                  Text('点赞' + item.likeCount + "|" + '浏览' + item.lookCount + '|' )
                  Image($r('app.media.icon')).width('10')
                }
              }
            })
          }.layoutWeight(1)

        }

      }.layoutWeight(1)





    }
    .height('100%')
    .width('100%')
  }
}