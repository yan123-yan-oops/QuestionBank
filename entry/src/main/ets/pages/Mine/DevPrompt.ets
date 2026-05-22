import { navStack } from "../../comments/router/NavigationService"
import { PromptItem } from "../../model/Model"

@Builder
export function DevPromptBuilder() {
  DevPrompt()
}


@Component
export struct DevPrompt {
  @State PromptList: PromptItem[] = [
    {
      prompt: 'Write clean and standard ArkTS code, follow Huawei HarmonyOS coding specification',
      annotation: '编写整洁规范的 ArkTS 代码，遵循鸿蒙官方编码规范'
    },
    {
      prompt: 'Implement this function with complete logic, add necessary comment',
      annotation: '完整实现该功能逻辑，补充必要代码注释'
    },
    {
      prompt: 'Write optimized code, reduce redundant code and avoid performance waste',
      annotation: '编写优化级代码，精简冗余逻辑，规避性能损耗'
    },
    {
      prompt: 'Develop cross-version compatible code, adapt ArkUI V1 and V2',
      annotation: '编写多版本兼容代码，适配 ArkUI V1/V2 语法'
    },
    {
      prompt: 'Encapsulate common business logic into reusable utility functions',
      annotation: '将通用业务逻辑封装为可复用工具方法'
    },
    {
      prompt: 'Analyze runtime error logs, locate bug position and give repair solution',
      annotation: '分析运行报错日志，定位 bug 位置并给出修复方案'
    },
    {
      prompt: 'Write clean and standard ArkTS code, follow Huawei HarmonyOS coding specification',
      annotation: '编写整洁规范的 ArkTS 代码，遵循鸿蒙官方编码规范'
    },
    {
      prompt: 'Implement this function with complete logic, add necessary comment',
      annotation: '完整实现该功能逻辑，补充必要代码注释'
    },
    {
      prompt: 'Write optimized code, reduce redundant code and avoid performance waste',
      annotation: '编写优化级代码，精简冗余逻辑，规避性能损耗'
    },
    {
      prompt: 'Develop cross-version compatible code, adapt ArkUI V1 and V2',
      annotation: '编写多版本兼容代码，适配 ArkUI V1/V2 语法'
    },
    {
      prompt: 'Encapsulate common business logic into reusable utility functions',
      annotation: '将通用业务逻辑封装为可复用工具方法'
    },
    {
      prompt: 'Analyze runtime error logs, locate bug position and give repair solution',
      annotation: '分析运行报错日志，定位 bug 位置并给出修复方案'
    },
  ]
  @State isExpand: boolean = false

  build() {
    NavDestination() {
      Column() {
        Row() {
          Image($r('app.media.ic_common_back')).width(28).onClick(()=>{
            navStack.pop()
          })
          Text('常用提示词').fontSize(26)
          Text().width(28)
        }.width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding(18)

        Column() {
          Row() {
            Text('常用提示词')
            Blank()
            Text('HTML5')
            Image(this.isExpand ? $r('app.media.ic_common_up') : $r('app.media.ic_common_down'))
              .fillColor($r('app.color.common_gray_01')).width(20)
          }.width('100%')

          Text('共' + this.PromptList.length + "个提示词")
        }.width('100%').padding(18)
        .alignItems(HorizontalAlign.Start)
        .onClick(() => {
          this.isExpand = !this.isExpand
        })

        Divider().height(10).width('100%')


        if (this.isExpand) {
          List() {
            ForEach(this.PromptList, (item: PromptItem) => {
              ListItem() {
                Column({ space: 10 }) {
                  Row() {
                    Text(item.prompt)
                      .fontWeight(FontWeight.Medium)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }

                  Row() {
                    Text(item.annotation).fontWeight(FontWeight.Normal).maxLines(1)
                  }
                }.width('100%')
                .padding(18)
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.SpaceBetween)
              }
            })
          }
        }
      }.width('100%')
      .height('100%')
    }.hideTitleBar(true)
    .hideToolBar(true)
  }
}