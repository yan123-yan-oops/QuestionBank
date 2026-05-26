import { AIChatMessage, apiAIChat } from "../../api/HttpRequtsts"
import { navStack } from "../../comments/router/NavigationService"

@Builder
export function AIConversationBuilder() {
  AIConversation()
}

@Component
export struct AIConversation {
  @State messages: AIChatMessage[] = [
    { role: 'assistant', content: '你好！我是小面AI，有什么可以帮你的？' }
  ]
  @State inputText: string = ''
  @State isLoading: boolean = false
  private scroller: Scroller = new Scroller()

  sendMessage(): void {
    const text = this.inputText.trim()
    if (!text || this.isLoading) {
      return
    }

    const userMsg: AIChatMessage = { role: 'user', content: text }
    this.messages.push(userMsg)
    this.inputText = ''

    // 滚动到底部
    setTimeout(() => {
      this.scroller.scrollToIndex(this.messages.length - 1)
    }, 100)

    // 调用 AI API
    this.isLoading = true

    apiAIChat(this.messages).then((reply: string) => {
      const aiMsg: AIChatMessage = { role: 'assistant', content: reply }
      this.messages.push(aiMsg)
      this.isLoading = false

      setTimeout(() => {
        this.scroller.scrollToIndex(this.messages.length - 1)
      }, 100)
    }).catch((err: Error) => {
      const errMsg: AIChatMessage = {
        role: 'assistant',
        content: '抱歉，我暂时无法回答，请稍后再试。'
      }
      this.messages.push(errMsg)
      this.isLoading = false
      console.log('yan', 'AI对话失败：' + JSON.stringify(err))
    })
  }

  build() {
    NavDestination() {
      Column() {
        //顶部导航栏
        Row() {
          Image($r('app.media.ic_common_back'))
            .width(28)
            .height(28)
            .onClick(() => {
              navStack.pop()
            })

          Text('小面AI')
            .fontSize(22)
            .fontWeight(FontWeight.Bold)

          Text('  ')
            .width(28)
        }
        .width('100%')
        .padding(16)
        .justifyContent(FlexAlign.SpaceBetween)
        .backgroundColor(Color.White)

        //消息列表
        List({ scroller: this.scroller }) {
          ForEach(this.messages, (msg: AIChatMessage) => {
            ListItem() {
              if (msg.role === 'user') {
                // 用户消息（右对齐）
                Row() {
                  Blank()
                  Column() {
                    Text(msg.content)
                      .fontSize(16)
                      .fontColor(Color.White)
                      .padding(14)
                  }
                  .backgroundColor($r('app.color.common_main_color'))
                  .borderRadius({ topLeft: 16, topRight: 16, bottomLeft: 16, bottomRight: 4 })
                  .constraintSize({ maxWidth: '80%' })
                }
                .padding({ left: 60, bottom: 12, right: 16 })
              } else {
                // AI 消息（左对齐）
                Row({ space: 8 }) {
                  Image($r('app.media.ic_mine_ai'))
                    .width(32)
                    .height(32)
                    .borderRadius(16)

                  Column() {
                    Text(msg.content)
                      .fontSize(16)
                      .fontColor($r('app.color.black'))
                      .padding(14)
                  }
                  .backgroundColor(Color.White)
                  .borderRadius({ topLeft: 16, topRight: 16, bottomRight: 16, bottomLeft: 4 })
                  .constraintSize({ maxWidth: '70%' })

                  Blank()
                }
                .padding({ right: 60, bottom: 12, left: 16 })
                .alignItems(VerticalAlign.Top)
              }
            }
          })

          //加载中指示器
          if (this.isLoading) {
            ListItem() {
              Row({ space: 8 }) {
                Image($r('app.media.ic_mine_ai'))
                  .width(32)
                  .height(32)
                  .borderRadius(16)

                Column() {
                  Text('正在输入...')
                    .fontSize(14)
                    .fontColor($r('app.color.common_gray_03'))
                    .padding(14)
                }
                .backgroundColor(Color.White)
                .borderRadius({ topLeft: 16, topRight: 16, bottomRight: 16, bottomLeft: 4 })

                Blank()
              }
              .padding({ right: 60, bottom: 12, left: 16 })
              .alignItems(VerticalAlign.Top)
            }
          }
        }
        .layoutWeight(1)
        .width('100%')
        .backgroundColor($r('app.color.diy_little_gray'))

        //底部输入栏
        Row({ space: 8 }) {
          TextInput({ placeholder: '输入问题...', text: this.inputText })
            .layoutWeight(1)
            .height(44)
            .fontSize(16)
            .backgroundColor($r('app.color.diy_little_gray'))
            .borderRadius(22)
            .padding({ left: 16 })
            .onChange((val: string) => {
              this.inputText = val
            })
            .onSubmit(() => {
              this.sendMessage()
            })

          Button('发送')
            .height(44)
            .width(70)
            .backgroundColor(this.isLoading ? $r('app.color.common_gray_03') : $r('app.color.common_main_color'))
            .fontColor(Color.White)
            .fontSize(16)
            .borderRadius(22)
            .onClick(() => {
              this.sendMessage()
            })
            .enabled(!this.isLoading)
        }
        .width('100%')
        .padding(12)
        .backgroundColor(Color.White)
        .border({ width: { top: 1 }, color: $r('app.color.diy_little_gray') })
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .hideToolBar(true)
  }
}
