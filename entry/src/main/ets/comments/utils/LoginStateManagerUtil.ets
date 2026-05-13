
AppStorage.setOrCreate('isLogin',false)
//全应用共享的、！！响应式!!全局数据状态
//static是非响应式的
export class LoginStateManager{

  //检查登录状态
  static isLogin():boolean{

    return AppStorage.get<boolean>('isLogin')??false
    //等价于：return AppStorage.get<boolean>('isLogin')?AppStorage.get<boolean>('isLogin')：false
    //??空值合并符，若前面值为undefined或空则用后面的false，若非空则为前值
  }


}