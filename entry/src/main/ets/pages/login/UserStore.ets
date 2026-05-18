import { PersistenceV2 } from "@kit.ArkUI";

@ObservedV2
export class UserModel {
  // 必须带默认值！！！
  @Trace isLogin: 0 | 1 = 0;
  @Trace username: string = '';
  @Trace password: string = '';
  @Trace rememberPwd: boolean = false;
}

// 🔥 低版本 API 正确写法（3 个参数）
export const userStore = PersistenceV2.connect(
  UserModel,                // 1. 构造函数
  'USER_DATA',              // 2. 存储 key
  () => new UserModel()     // 3. 工厂函数（必须）
);