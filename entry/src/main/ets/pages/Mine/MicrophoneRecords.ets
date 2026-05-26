import { media } from "@kit.MediaKit"
import { abilityAccessCtrl, Permissions, common } from "@kit.AbilityKit"
import { promptAction } from "@kit.ArkUI"
import { fileIo } from "@kit.CoreFileKit"
import { BusinessError } from "@kit.BasicServicesKit"
import { navStack } from "../../comments/router/NavigationService"

@Builder
export function MicrophoneRecordsBuilder() {
  MicrophoneRecords()
}

@Component
export struct MicrophoneRecords {
  @State isRecording: boolean = false
  @State fileList: string[] = []
  @State recordTime: number = 0
  private avRecorder: media.AVRecorder | null = null
  private filePath: string = ''
  private timerId: number = -1
  private audioDir: string = ''

  async aboutToAppear(): Promise<void> {
    this.audioDir = getContext(this).filesDir + '/audio'
    try {
      await fileIo.stat(this.audioDir)
    } catch {
      await fileIo.mkdir(this.audioDir, true)
    }
    await this.loadFiles()
  }

  aboutToDisappear(): void {
    if (this.timerId > 0) {
      clearInterval(this.timerId)//资源回收！
    }
  }

  async requestPermission(): Promise<boolean> {
    const context = getContext(this) as common.UIAbilityContext
    try {
      const result = await abilityAccessCtrl.createAtManager()
        .requestPermissionsFromUser(context, ['ohos.permission.MICROPHONE'] as Permissions[])
      return result.authResults[0] === 0
    } catch (err) {
      console.log('yan', '权限异常：' + JSON.stringify(err))
      return false
    }
  }

  async startRecording(): Promise<void> {
    if (!await this.requestPermission()) {
      promptAction.showToast({ message: '需要麦克风权限' })
      return
    }

    try {
      this.filePath = `${this.audioDir}/record_${Date.now()}.m4a`

      // 必须用 fd:// 协议打开文件描述符，不能直接传路径
      const file = fileIo.openSync(this.filePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)
      const fd = file.fd

      this.avRecorder = await media.createAVRecorder()
      this.avRecorder.on('error', (err: BusinessError) => {
        console.log('yan', '录音错误：' + JSON.stringify(err))
        this.isRecording = false
      })

      await this.avRecorder.prepare({
        audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC,
        profile: {
          audioBitrate: 64000,
          audioChannels: 1,
          audioCodec: media.CodecMimeType.AUDIO_AAC,
          fileFormat: media.ContainerFormatType.CFT_MPEG_4A,
          audioSampleRate: 44100
        },
        url: 'fd://' + fd
      })

      await this.avRecorder.start()
      this.isRecording = true
      this.recordTime = 0
      this.timerId = setInterval(() => { this.recordTime++ }, 1000)
    } catch (err) {
      console.log('yan', '开始录音失败：' + JSON.stringify(err))
      promptAction.showToast({ message: '开始录音失败' })
    }
  }

  async stopRecording(): Promise<void> {
    clearInterval(this.timerId)
    this.timerId = -1
    try {
      await this.avRecorder?.stop()
      await this.avRecorder?.release()
    } catch (err) {
      console.log('yan', '停止录音失败：' + JSON.stringify(err))
    }
    this.avRecorder = null
    this.isRecording = false
    await this.loadFiles()
  }

  async loadFiles(): Promise<void> {
    try {
      await fileIo.stat(this.audioDir)
      const files: string[] = await fileIo.listFile(this.audioDir)
      this.fileList = files.filter(f => f.endsWith('.m4a')).reverse()
    } catch {
      this.fileList = []
    }
  }

  async deleteFile(fileName: string): Promise<void> {
    try {
      await fileIo.unlink(this.audioDir + '/' + fileName)
      await this.loadFiles()
    } catch (err) {
      console.log('yan', '删除失败：' + JSON.stringify(err))
    }
  }

  formatTime(s: number): string {
    return String(Math.floor(s / 60)).padStart(2, '0') + ':' + String(s % 60).padStart(2, '0')
  }

  build() {
    NavDestination() {
      Column() {
        // 顶部栏
        Row() {
          Image($r('app.media.ic_common_back')).width(28).onClick(() => navStack.pop())
          Text('面试录音').fontSize(26).fontWeight(FontWeight.Bold)
          Text().width(28)
        }
        .width('100%')
        .padding(16)
        .justifyContent(FlexAlign.SpaceBetween)

        // 录音控制
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

        // 录音列表
        if (this.fileList.length > 0) {
          List() {
            ForEach(this.fileList, (fileName: string) => {
              ListItem() {
                Row() {
                  Text(fileName)
                    .fontSize(15)
                    .layoutWeight(1)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  Image($r('app.media.ic_public_delete'))
                    .width(22)
                    .fillColor($r('app.color.common_gray_01'))
                    .onClick(() => this.deleteFile(fileName))
                }
                .width('90%')
                .padding(16)
                .backgroundColor(Color.White)
                .borderRadius(10)
                .margin({ top: 8 })
              }
            })
          }
          .layoutWeight(1)
          .width('100%')
          .alignListItem(ListItemAlign.Center)
        } else {
          Text('暂无录音，点击上方按钮开始')
            .fontSize(15)
            .fontColor($r('app.color.common_gray_03'))
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
        }
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .hideToolBar(true)
  }
}
