import { Type } from "@kit.ArkUI";

export class SaveContext {
  context:Context;
  constructor(context:Context) {
    this.context = context;
  }
}
@ObservedV2
export class AreaHeight{
  @Trace topHeight:number;
  @Trace bottomHeight:number
  constructor(topHeight:number,bottomHeight:number) {
    this.topHeight = topHeight;
    this.bottomHeight = bottomHeight;
  }
}
//tab的数据结构
export interface TabItem {
  icon:Resource
  activeIcon:Resource
  name:string
}
//首页-题目分类列表项
export interface QuestionType {
  id:number
  name:string
  displayNewestFlag:0|1
}

// 接口返回的分页包裹对象
export interface QuestionListResult {
  total: number        // 总条数
  pageTotal: number    // 总页数
  rows: QuestionItem[] // 试题数组 ← 这里放题目
}

//试题数据类型
export interface QuestionItem{
  id:string
  stem:string//题干
  difficulty:number//难度
  likeCount:number//点赞数
  views:number//浏览数
  readFlag:0|1 //是否已看
}

export interface QuestionDetail extends QuestionItem {
  answer:string
  stage:string[]
  likeFlag:0|1  //是否点赞
  collectFlag:0|1 //是否收藏
}
export interface QuestionPageParams {
  item:QuestionItem
  list:QuestionItem[]
}


// 定义查询试题列表 -  请求参数类型
export interface QuestionListParams {
  type:number //取的是id
  sort?:SortType
  pageSize:number
  page:number
  questionBankType: 9|10
  keyword?:string
}

export enum SortType {
  Default = 0,
  DifficultyLow = 10,//难易程度 从小到大
  DifficultyHigh =11,//难易程度 从大到小
  ViewsLow = 20,//浏览量  从低到高
  ViewsHigh = 21,//浏览量  从高到低
  Commend = 30 //推荐
}

export interface  PageData<T>{
  total:number
  pageTotal:number
  rows:T[]
}

export interface WebPageParams {
  title:string
  src:string
}

//为了给持久化保存数据添加的属性
@ObservedV2
export class UserClass {
  @Trace id:string=''
  @Trace username:string=''
  @Trace avatar:string=''
  @Trace token:string=''
  @Trace nickname:string=''
  @Trace totalTime:number = 0
  @Trace clockinNumbers:number = 0//打卡次数
}

@ObservedV2
export class AppUser{
  @Type(UserClass)
  @Trace user:UserClass = new UserClass()
}

export interface LoginParams{
  username:string
  password:string
}

export interface QuestionOptParams {
  id:string
  /**  0 面试 1 面经 */
  type: 0 | 1
  /**  1 点赞 2 收藏*/
  optType: 1 | 2
}

export interface TimeItem{
  questionId:string
  startTime:number
  endTime:number
}

export interface WordItem {
  zh:string
  en:string
  code:string
}

export type Words = Record<string,WordItem[]>


export interface ClockInItem {
  id:string
  createdAt:string
}
export interface ClockInfo {
  flag:boolean
  clockinNumbers:number
  totalClockinNumber:number
  clockins:ClockInItem[]
}

export interface ClockInfoParams {
  year:string
  month:string
}

export class Message {
  role:'system'|'user' = 'system'
  content:string = ''
}

@ObservedV2
export class MessageItem extends Message {
  id:string = ''
  @Trace
  content: string=''
}

export interface StudyTimeItem {
  id:string
  name:string
  total:number
  done:number
  undone:number
}

export interface StudyTimeCate {
  type:string
  list:StudyTimeItem[]
}

export interface StudyTimeData{
  totalTime:number
  studyData:StudyTimeCate[]
}






export interface targetPageInfo{
  pageName:string
  pageParam:string
}
