import { apiQuestionList } from './HttpRequtsts'


@Builder
export function apiTestBuilder() {
  apiTest()
}

@Component
struct apiTest{



  build() {
    Column(){

      Button()
        .onClick(()=>{
          apiQuestionList(10).then((res)=>{
            console.log("yan",'这是QuestionBankList类型的数据吗？：'+res.rows[0].id+'--'+res.rows[0].stem+'--'+res.rows[0].difficulty+'--'+res.rows[0].likeCount)
          })
        })

    }.width('100%')
    .height('100%')
  }
}

export { apiTest }
