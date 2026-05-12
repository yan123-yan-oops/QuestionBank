import { router } from "@kit.ArkUI"

@Entry
@Component
export struct HomePage {


  build() {
    Column() {
      Row({space:32}){
        Stack({ alignContent: Alignment.Start }) {
          Image($r('app.media.ic_common_search'))
            .width(20)

          TextInput({placeholder:'请输入内容'})
            .width('90%')
        }
        .width('100%')

        Image($r('app.media.ic_mine_logo'))
          .width(10)
      }
      .width('100%')

      Image($r('app.media.banner_pj'))
        .width(360)
        .borderRadius(14)
        .margin({top:18})

      Row(){
        Text('训练专区')
          .fontWeight(FontWeight.Bold)
          .fontSize(28)

        Blank()
      }
      .width('100%')

      Row(){ //前端鸿蒙的两个方形卡没找到资源
        Button('前端')
          .onClick(()=>{
            router.pushUrl({url:'pages/FrontendPage'})
          })


        Button('鸿蒙')
          .onClick(()=>{
            router.pushUrl({url:'pages/HarmonyOS'})
          })
      }.width('100%')
      .margin({top:18})

      Row(){
        Text('辅助工具')
          .fontWeight(FontWeight.Bold)
          .fontSize(28)

        Blank()
      }.width("100%")

      Row(){
        Button('ai')
          .backgroundColor($r('app.color.common_gray_01'))

        Button('前端常用词')
          .backgroundColor($r('app.color.common_gray_01'))
      }

    }
    .height('100%')
    .width('100%')
  }
}