@Component
export struct QuestionSortComponent{
  @Prop showPop:boolean
  @State hardIndex:number = 0
  @State sortIndex:number = 0
  close:(()=>void) = (()=>{})

  build() {
    Column(){
      Blank()
        .width("100%")
        .height("25%")
        .onClick(() => {
          this.close()
        })

    Column({space:8}){

        Blank().width('100%').height(30)

      Row(){
        Text('重置').fontWeight(FontWeight.Medium)
        Text('筛选题目').fontWeight(FontWeight.Medium)
        Text('完成').fontWeight(FontWeight.Medium).fontColor($r('app.color.common_green'))
      }.width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Text('题目排序').fontWeight(FontWeight.Medium)

      Row({space:8}){
        Button('默认',{ type: ButtonType.Normal })
          .fontWeight(FontWeight.Normal)
          .fontColor(this.sortIndex == 0?$r('app.color.common_green'):$r('app.color.black'))
          .borderRadius(2)
          .backgroundColor($r('app.color.diy_little_gray'))
          .onClick(()=>{this.sortIndex = 0})

        Button('浏览量',{ type: ButtonType.Normal })
          .fontWeight(FontWeight.Normal)
          .fontColor(this.sortIndex == 1?$r('app.color.common_green'):$r('app.color.black'))
          .borderRadius(2).backgroundColor($r('app.color.diy_little_gray'))
          .onClick(()=>{this.sortIndex = 1})
      }.width("100%")
      .justifyContent(FlexAlign.Start)

      Text('题目难度').fontWeight(FontWeight.Medium)

      Row({space:8}){
        Button('全部',{ type: ButtonType.Normal })
          .fontWeight(FontWeight.Normal)
          .borderRadius(2)
          .fontColor(this.hardIndex == 0?$r('app.color.common_green'):$r('app.color.black'))
          .backgroundColor($r('app.color.diy_little_gray'))
          .onClick(()=>{this.hardIndex = 0})

        Button('简单',{ type: ButtonType.Normal })
          .fontWeight(FontWeight.Normal).borderRadius(2)
          .fontColor(this.hardIndex == 1?$r('app.color.common_green'):$r('app.color.black'))
          .backgroundColor($r('app.color.diy_little_gray'))
          .onClick(()=>{this.hardIndex = 1})

        Button('一般',{ type: ButtonType.Normal })
          .fontWeight(FontWeight.Normal).borderRadius(2)
          .fontColor(this.hardIndex == 2?$r('app.color.common_green'):$r('app.color.black'))
          .backgroundColor($r('app.color.diy_little_gray'))
          .onClick(()=>{this.hardIndex = 2})

        Button('困难',{ type: ButtonType.Normal })
          .fontWeight(FontWeight.Normal).borderRadius(2)
          .fontColor(this.hardIndex == 3?$r('app.color.common_green'):$r('app.color.black'))
          .backgroundColor($r('app.color.diy_little_gray'))
          .onClick(()=>{this.hardIndex = 3})
      }.width('100%')

    }.backgroundColor(Color.White).layoutWeight(1).borderRadius({topLeft:18,topRight:18}).alignItems(HorizontalAlign.Start)

    }.width('100%').height('100%')
    .translate({ y: this.showPop ? 0 : '100%' })
    .animation({ duration: 280, curve: Curve.EaseOut })
  }
}