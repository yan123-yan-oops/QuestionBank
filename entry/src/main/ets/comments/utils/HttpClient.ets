import axios, { AxiosError, AxiosInstance,
  AxiosRequestConfig,
  AxiosResponse, InternalAxiosRequestConfig } from "@ohos/axios"
import { auth } from "./Auth";
import { promptAction, Type } from "@kit.ArkUI";
import { navStack, EmptyParam } from '../router/NavigationService';
import { UserClass } from "../../model/Model";

export const baseURL = 'https://api-harmony-teach.itheima.net/hm/'

const axiosInstance : AxiosInstance = axios.create({
  baseURL
  ,timeout:10000
  ,headers:{'Content-Type':'application/json'}//只保留这个
})

axiosInstance.request({
  url:'',
  params:{username:'',
  password:''}
})

//request.use = 请求发出去之前，先做一件事->验证有没有token，有的话就随着请求头发出去
axiosInstance.interceptors.request.use((config:InternalAxiosRequestConfig)=>{
  const user = auth.getUser()
  if(user.token){
    config.headers.Authorization = `Bearer ${user.token}`
  }
  return config
},(err:AxiosError)=>{
  return Promise.reject(err)
})

// response.use = 数据回来之后，先做一件事->统一处理返回的数据(剥壳之类的操作)
axiosInstance.interceptors.response.use((res:AxiosResponse)=>{
  console.log('yan', '响应数据：' + JSON.stringify(res.data))//查看返回的成功的业务码
  if(res.data.code === 10000){
    return res.data.data
  }
  return Promise.reject(res.data)
},(error:AxiosError)=>{
  if(error.response?.status===401){
    auth.setUser({} as UserClass)
    //自动存储
    promptAction.showToast({
      message:'登录状态失效！'
    })
    navStack.pushPathByName('Login', new EmptyParam())
  }
  return Promise.reject(error)
})

//再次封装一层
class HttpClient {
  request<Res,Req=object>(config:AxiosRequestConfig<Req>){
    return axiosInstance.request<Res,Res,Req>(config)
  }
}

export const httpClient = new HttpClient()

//1.原始 axios.get () → 最原生，啥都自己写，麻烦
//2.axios.create() + request() → 抽离 baseURL、超时，简化一点
//3.httpClient 二次封装 → 统一拦截、token、错误处理，业务只关心数据
//4.api 接口封装（apiGetQuestionList /apiLogin） → 最终版，页面只传参数，拿结果，完全解耦