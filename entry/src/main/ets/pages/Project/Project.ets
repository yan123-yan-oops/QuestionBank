
@Builder
export function ProjectBuilder() {
  Project()
}

@Component
export struct Project {

  build() {

    Column({space:18}) {
      Blank().height(35)
      Row(){
        Text('项目')
          .fontWeight(FontWeight.Bold)
          .fontSize(30)

        Blank()
      }.width('90%')
      .padding(10)
      .margin({right:20})

      Row({space:10}){
        Image($r('app.media.project01'))
          .height(100)

        Column(){
          Text('后台管理系统')
          Blank()
          Column(){
            Text('10/12节 | 已学进度：10%')
            Progress({value:10,total:100,type:ProgressType.Linear}).width('90%')
          }.width('100%')
          .alignItems(HorizontalAlign.Start)

        }.layoutWeight(1)
        .height('100%')
        .alignItems(HorizontalAlign.Start)

      }.padding(10)
      .height(120)
      .backgroundColor($r('app.color.diy_little_gray'))
      .width('90%')

      Row({space:10}){
        Image($r('app.media.project02'))
          .height(100)

        Column(){
          Text('在线问诊项目')
          Blank()
          Column(){
            Text('10/12节 | 已学进度：10%')
            Progress({value:10,total:100,type:ProgressType.Linear}).width('90%')
          }.width('100%')
          .alignItems(HorizontalAlign.Start)

        }.layoutWeight(1)
        .height('100%')
        .alignItems(HorizontalAlign.Start)

      }.padding(10)
      .height(120)
      .backgroundColor($r('app.color.diy_little_gray'))
      .width('90%')
    }
    .height('100%')
    .width('100%')
  }
}