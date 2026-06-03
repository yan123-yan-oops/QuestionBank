import { media } from "@kit.MediaKit"
import { abilityAccessCtrl, Permissions, common } from "@kit.AbilityKit"
import { fileIo } from "@kit.CoreFileKit"
import { BusinessError } from "@kit.BasicServicesKit"

export interface RecordState {
  isRecording: boolean
  recordTime: number
  fileList: string[]
  playingFile: string
}

export class AVRecord {
  // ===== 录音相关 =====
  private static avRecorder: media.AVRecorder | null = null
  private static filePath: string = ''
  private static timerId: number = -1
  private static audioDir: string = ''

  // ===== 播放相关 =====
  private static avPlayer: media.AVPlayer | null = null
  private static playingFile: string = ''

  // ===== 回调 =====
  private static onStateChange: ((state: RecordState) => void) | null = null

  static init(audioDir: string): void {
    AVRecord.audioDir = audioDir
  }

  static setStateCallback(callback: (state: RecordState) => void): void {
    AVRecord.onStateChange = callback
  }

  private static emit(): void {
    AVRecord.onStateChange?.({
      isRecording: AVRecord.avRecorder !== null,
      recordTime: 0, // 页面自己用 timer 维护
      fileList: [],  // 页面自己维护
      playingFile: AVRecord.playingFile
    })
  }

  // ===== 权限 =====
  static async requestPermission(): Promise<boolean> {
    const context = getContext() as common.UIAbilityContext
    try {
      const result = await abilityAccessCtrl.createAtManager()
        .requestPermissionsFromUser(context, ['ohos.permission.MICROPHONE'] as Permissions[])
      return result.authResults[0] === 0
    } catch (err) {
      console.log('yan', '权限异常：' + JSON.stringify(err))
      return false
    }
  }

  // ===== 录音 =====
  static async startRecording(onTimerTick: () => void): Promise<string | null> {
    if (!await AVRecord.requestPermission()) return null

    try {
      AVRecord.filePath = `${AVRecord.audioDir}/record_${Date.now()}.m4a`
      const file = fileIo.openSync(AVRecord.filePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)

      AVRecord.avRecorder = await media.createAVRecorder()
      AVRecord.avRecorder.on('error', (err: BusinessError) => {
        console.log('yan', '录音错误：' + JSON.stringify(err))
        AVRecord.avRecorder = null
        AVRecord.emit()
      })

      await AVRecord.avRecorder.prepare({
        audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC,
        profile: {
          audioBitrate: 64000,
          audioChannels: 1,
          audioCodec: media.CodecMimeType.AUDIO_AAC,
          fileFormat: media.ContainerFormatType.CFT_MPEG_4A,
          audioSampleRate: 44100
        },
        url: 'fd://' + file.fd
      })

      await AVRecord.avRecorder.start()
      AVRecord.timerId = setInterval(onTimerTick, 1000)
      AVRecord.emit()
      return AVRecord.filePath
    } catch (err) {
      console.log('yan', '开始录音失败：' + JSON.stringify(err))
      return null
    }
  }

  static async stopRecording(): Promise<void> {
    clearInterval(AVRecord.timerId)
    AVRecord.timerId = -1
    try {
      await AVRecord.avRecorder?.stop()
      await AVRecord.avRecorder?.release()
    } catch (err) {
      console.log('yan', '停止录音失败：' + JSON.stringify(err))
    }
    AVRecord.avRecorder = null
    AVRecord.emit()
  }

  // ===== 文件管理 =====
  static async loadFiles(dir: string): Promise<string[]> {
    try {
      await fileIo.stat(dir)
      const files: string[] = await fileIo.listFile(dir)
      return files.filter(f => f.endsWith('.m4a')).reverse()
    } catch {
      return []
    }
  }

  static async ensureDir(dir: string): Promise<void> {
    try {
      await fileIo.stat(dir)
    } catch {
      await fileIo.mkdir(dir, true)
    }
  }

  static async deleteFile(dir: string, fileName: string): Promise<void> {
    try {
      if (AVRecord.playingFile === fileName) {
        await AVRecord.stopPlayback()
      }
      await fileIo.unlink(dir + '/' + fileName)
    } catch (err) {
      console.log('yan', '删除失败：' + JSON.stringify(err))
    }
  }

  // ===== 播放 =====
  static getPlayingFile(): string {
    return AVRecord.playingFile
  }

  static async playOrStop(filePath: string, fileName: string): Promise<void> {
    if (AVRecord.playingFile === fileName) {
      await AVRecord.stopPlayback()
    } else {
      await AVRecord.stopPlayback()
      await AVRecord.play(filePath, fileName)
    }
  }

  private static async play(filePath: string, fileName: string): Promise<void> {
    try {
      const file = fileIo.openSync(filePath, fileIo.OpenMode.READ_ONLY)
      AVRecord.avPlayer = await media.createAVPlayer()

      AVRecord.avPlayer.on('error', (err: BusinessError) => {
        console.log('yan', '播放错误：' + JSON.stringify(err))
        AVRecord.playingFile = ''
        AVRecord.emit()
      })

      AVRecord.avPlayer.on('stateChange', (state: media.AVPlayerState) => {
        if (state === 'initialized') {
          AVRecord.avPlayer?.prepare()
        } else if (state === 'prepared') {
          AVRecord.avPlayer?.play()
        } else if (state === 'stopped' || state === 'error') {
          AVRecord.playingFile = ''
          AVRecord.emit()
        }
      })

      AVRecord.avPlayer.url = 'fd://' + file.fd
      AVRecord.playingFile = fileName
      AVRecord.emit()
    } catch (err) {
      console.log('yan', '播放失败：' + JSON.stringify(err))
      AVRecord.playingFile = ''
      AVRecord.emit()
    }
  }

  private static async stopPlayback(): Promise<void> {
    if (!AVRecord.avPlayer) return
    try {
      AVRecord.avPlayer.stop()
      AVRecord.avPlayer.release()
    } catch (err) {
      console.log('yan', '停止播放失败：' + JSON.stringify(err))
    }
    AVRecord.avPlayer = null
    AVRecord.playingFile = ''
    AVRecord.emit()
  }

  // ===== 生命周期 =====
  static release(): void {
    clearInterval(AVRecord.timerId)
    AVRecord.timerId = -1
    AVRecord.stopPlayback()
    AVRecord.avRecorder = null
    AVRecord.onStateChange = null
  }
}
