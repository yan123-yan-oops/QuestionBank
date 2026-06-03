import { promptAction } from "@kit.ArkUI"
import { navStack } from "../../comments/router/NavigationService"
import { AVRecord } from "../../comments/utils/AVRecord"

@Builder
export function MicrophoneRecordsBuilder() {
  MicrophoneRecords()
}

@Component
export struct MicrophoneRecords {
  @State isRecording: boolean = false
  @State fileList: string[] = []
  @State recordTime: number = 0
  @State playingFile: string = ''
  private audioDir: string = ''

  async aboutToAppear(): Promise<void> {
    this.audioDir = getContext(this).filesDir + '/audio'
    AVRecord.init(this.audioDir)
    await AVRecord.ensureDir(this.audioDir)
    this.fileList = await AVRecord.loadFiles(this.audioDir)
    AVRecord.setStateCallback(() => {
      this.playingFile = AVRecord.getPlayingFile()
    })
  }

  aboutToDisappear(): void {
    AVRecord.release()
  }

  async startRecording(): Promise<void> {
    const filePath = await AVRecord.startRecording(() => { this.recordTime++ })
    if (filePath === null) {
      promptAction.showToast({ message: '需要麦克风权限' })
      return
    }
    this.isRecording = true
    this.recordTime = 0
  }

  async stopRecording(): Promise<void> {
    await AVRecord.stopRecording()
    this.isRecording = false
    this.fileList = await AVRecord.loadFiles(this.audioDir)
  }

  async deleteFile(fileName: string): Promise<void> {
    await AVRecord.deleteFile(this.audioDir, fileName)
    this.fileList = await AVRecord.loadFiles(this.audioDir)
  }

  playOrStop(fileName: string): void {
    AVRecord.playOrStop(this.audioDir + '/' + fileName, fileName)
  }

  formatTime(s: number): string {
    return String(Math.floor(s / 60)).padStart(2, '0') + ':' + String(s % 60).padStart(2, '0')
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Image($r('app.media.ic_common_back')).width(28).onClick(() => navStack.pop())
          Text('面试录音').fontSize(26).fontWeight(FontWeight.Bold)
          Text().width(28)
        }
        .width('100%')
        .padding(16)
        .justifyContent(FlexAlign.SpaceBetween)

        Column({ space: 12 }) {
          Text(this.formatTime(this.recordTime))
            .fontSize(48)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.isRecording ? $r('app.color.common_main_color') : $r('app.color.black'))

          Button(this.isRecording ? '停止录音' : '开始录音')
            .height(48)
            .width(180)
            .backgroundColor(this.isRecording ? $r('app.color.common_gray_03') : $r('app.color.common_main_color'))
            .fontSize(18)
            .fontColor(Color.White)
            .borderRadius(24)
            .onClick(() => {
              this.isRecording ? this.stopRecording() : this.startRecording()
            })
        }
        .width('100%')
        .padding({ top: 40, bottom: 24 })
        .alignItems(HorizontalAlign.Center)

        if (this.fileList.length > 0) {
          List() {
            ForEach(this.fileList, (fileName: string) => {
              ListItem() {
                Row() {
                  Image(this.playingFile === fileName ? $r('app.media.ic_public_forbid') : $r('app.media.play_fill'))
                    .width(22).height(22)
                    .fillColor(this.playingFile === fileName ? $r('app.color.common_main_color') : $r('app.color.common_gray_01'))
                    .margin({ right: 8 })

                  Text(fileName)
                    .fontSize(15).layoutWeight(1).maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  Image($r('app.media.ic_public_delete'))
                    .width(22)
                    .fillColor($r('app.color.common_gray_01'))
                    .onClick(() => this.deleteFile(fileName))
                }
                .width('90%')
                .padding(16)
                .backgroundColor(this.playingFile === fileName ? '#F0F9F2' : Color.White)
                .borderRadius(10)
                .margin({ top: 8 })
                .onClick(() => this.playOrStop(fileName))
              }
            })
          }
          .layoutWeight(1).width('100%').alignListItem(ListItemAlign.Center)
        } else {
          Text('暂无录音，点击上方按钮开始')
            .fontSize(15).fontColor($r('app.color.common_gray_03'))
            .layoutWeight(1).textAlign(TextAlign.Center)
        }
      }
      .width('100%').height('100%')
    }
    .hideTitleBar(true).hideToolBar(true)
  }
}
