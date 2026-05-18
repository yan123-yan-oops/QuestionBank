// commons/utils/Auth.ts
import { UserClass } from "../../model/Model";

export class Auth {
  // 保存用户（登录后调用）
  setUser(user: UserClass): void {
    // 直接赋值 → 自动持久化
    AppStorage.setOrCreate<UserClass>('user', user)
  }

  // 获取用户（任何地方拿）
  getUser(): UserClass {
    return AppStorage.get<UserClass>('user') ?? new UserClass()
  }

  // 获取 token（常用于请求头）
  getToken(): string {
    return this.getUser().token || ''
  }

  // 退出登录 → 清空
  clearUser(): void {
    AppStorage.setOrCreate<UserClass>('user', new UserClass())
  }
}

export const auth = new Auth();