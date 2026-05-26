import axios, { AxiosResponse, InternalAxiosRequestConfig } from "@ohos/axios"
import { httpClient } from "../comments/utils/HttpClient"
import {
  ClockIn,
  feedBackID,
  HasFlagIn,
  LoginParams,
  QuestionDetail,
  QuestionItem,
  QuestionListResult,
  QuestionRecommends,
  QuestionType,
  UserClass
} from "../model/Model"

// @Local mobile: string = 'hmheima'
// @Local code: string = 'Hmheima%123'
export const apiLogin = (username: string, password: string): Promise<UserClass> => {
  return httpClient.request<UserClass, LoginParams>({
    method: 'post',
    url: 'login',
    data: {
      username, password
    }
  })
}

export const apiQuestionType = (): Promise<QuestionType[]> => {
  return httpClient.request<QuestionType[]>({
    method: 'get',
    url: 'question/type'
  })
}

//传参9为面经试题，10为小程序试题
//!!axios 中 GET 请求的参数必须通过 params 传递，否则参数不会拼接到 URL 上!!
//page=1第1页）
//pageSize=10（10条）
//sort=0 (默认权重排序）
//type=0     （全部分类）
export const apiQuestionList = (questionBankType: number, page?: number, pageSize?: number, sort?: number,
  type?: number): Promise<QuestionListResult> => {
  return httpClient.request<QuestionListResult>({
    method: 'get',
    url: 'question/list',
    params: {
      questionBankType,
      page,
      pageSize,
      sort,
      type
    }
  })
}

//面经的推荐内容
export const apiQuestionRecommends = (): Promise<QuestionRecommends> => {
  return httpClient.request<QuestionRecommends>({
    method: 'get',
    url: 'question/recommends'
  })
}

//试题/面经的详细内容
export const apiQuestionDetails = (id: string): Promise<QuestionDetail> => {
  return httpClient.request<QuestionDetail>({
    method: 'get',
    url: `question/${id}`
  })
}


//首页检查是否打卡接口
export const apiHasClockIn = (): Promise<HasFlagIn> => {
  return httpClient.request<HasFlagIn>({
    method: 'get',
    url: 'hasClockIn'
  })
}

//首页获取打卡信息(总天数)----暂时没有接口 404
export const apiClockIn = (): Promise<ClockIn> => {
  return httpClient.request<ClockIn>({
    method: 'post',
    url: 'clockIn'
  })
}

//收藏、点赞试题或者面经
export const apiOpt = (id: string, optType: number, type?: number): Promise<HasFlagIn> => {
  return httpClient.request<HasFlagIn>({
    method: 'post',
    url: 'opt',
    data: {
      id,
      optType,
      type
    }
  })
  // id:string -- 试题id -- 必需
  // type:number -- 0面试题1面经 -- 可选
  // optType:number -- 1点赞2收藏 -- 必需
}

//反馈提交
export const apiFeedBack = (questionId?:string,type?:Array<string>,feedBackInfo?:string): Promise<feedBackID> => {
  return httpClient.request<feedBackID>({
    method: 'post',
    url: 'question/feedback',
    data:{
      questionId,
      type,
      feedBackInfo
    }
  })
  //questionId:string -- 试题id -- 可选
  //type:array[string] -- 可选 -- 反馈类型,数组，1内容不准确2、知识点不准确3题目重复4其他
  //feedbackInfo:string -- 反馈记录 -- 可选
}

// ============================================================
// AI 对话接口（小米 MiMo v2.5-Pro 模型，兼容 OpenAI 格式）
// ============================================================
const AI_BASE_URL = 'https://token-plan-cn.xiaomimimo.com/v1'
const AI_API_KEY = 'tp-cimx8y5wgf5c00u6h65b1z3rnb689ejjyy7nocjv0ifuyhd8'
const AI_MODEL = 'mimo-v2.5-pro'

// 独立 axios 实例（不继承业务接口的 token/401 拦截器）
const aiAxios = axios.create({
  baseURL: AI_BASE_URL,
  timeout: 60000,
  headers: { 'Content-Type': 'application/json' }
})

aiAxios.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  config.headers.Authorization = `Bearer ${AI_API_KEY}`
  return config
})

// AI 对话请求体接口(使用openAI兼容模式)
interface AIChatRequestBody {
  model: string
  messages: AIChatMessage[]
  temperature: number
  max_tokens: number
}

// AI 对话响应结构接口
interface AIChatMessageContent {
  content: string
}

interface AIChatChoice {
  message: AIChatMessageContent
}

interface AIChatResponseBody {
  choices: AIChatChoice[]
}

export interface AIChatMessage {
  role: 'user' | 'assistant' | 'system'
  content: string
}

export const apiAIChat = (messages: AIChatMessage[]): Promise<string> => {
  const requestBody: AIChatRequestBody = {
    model: AI_MODEL,
    messages,
    temperature: 0.7,
    max_tokens: 4096
  }

  return aiAxios.post<AIChatResponseBody>('/chat/completions', requestBody)
    .then((res: AxiosResponse<AIChatResponseBody>) => {
      return res.data.choices[0].message.content
    })
}
