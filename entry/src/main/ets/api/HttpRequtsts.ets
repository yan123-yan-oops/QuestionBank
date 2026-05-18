import { httpClient } from "../comments/utils/HttpClient"
import { LoginParams,  QuestionItem, QuestionListResult, QuestionType, UserClass } from "../model/Model"

// @Local mobile: string = 'hmheima'
// @Local code: string = 'Hmheima%123'
export const apiLogin = (username:string,password:string):Promise<UserClass>=>{
  return httpClient.request<UserClass,LoginParams>({
    method:'post',
    url:'login',
    data:{
      username,password
    }
  })
}

export const apiQuestionType = ():Promise<QuestionType[]>=>{
  return httpClient.request<QuestionType[]>({
    method:'get',
    url:'question/type'
  })
}

//传参9为面经试题，10为小程序试题
//!!axios 中 GET 请求的参数必须通过 params 传递，否则参数不会拼接到 URL 上!!
export const apiQuestionList = (questionBankType:number):Promise<QuestionListResult>=>{
  return httpClient.request<QuestionListResult>({
    method:'get',
    url:'question/list',
    params:{
      questionBankType
    }
  })
}

// https://api-harmony-teach.itheima.net/hm/question/list
