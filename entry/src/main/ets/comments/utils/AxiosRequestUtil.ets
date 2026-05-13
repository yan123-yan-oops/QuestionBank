import axios from "@ohos/axios"

export class AxiosRequestUtil{

  getAxiosRequest(url:string,params?:object){
    axios.get(url,{params})
      .then((res:object)=>{
        console.log('yan','GET请求成功，返回参数：'+res);
        return res
      })
      .catch((err:string)=>{
        AlertDialog.show({message:err+''})
      })
  }

  postAxiosRequest(url:string,data:object){
    axios.post(url,data)
      .then((res:object)=>{
        console.log('yan','GET请求成功，返回参数：'+res);
        return res
      })
      .catch((err:string)=>{
        AlertDialog.show({message:err+''})
      })
  }
}