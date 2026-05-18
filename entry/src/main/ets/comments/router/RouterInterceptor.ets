import { LoginStateManager } from '../utils/LoginStateManagerUtil';

export function setupRouterInterceptor(stack: NavPathStack): void {
  stack.setInterception({
    willShow: (from: NavDestinationContext | 'navBar', to: NavDestinationContext | 'navBar'): void => {
      if (typeof to !== 'object') {
        return
      }
      const targetPageConfig = to.getConfigInRouteMap()
      if (targetPageConfig?.data?.['needLogin'] === '1' && !LoginStateManager.isLogin()) {
        const nameObj = targetPageConfig['name']
        const targetName = typeof nameObj === 'string' ? nameObj : ''
        if (targetName) {
          AppStorage.setOrCreate<string>('pendingTargetName', targetName)
        }
        to.pathStack.pop()
        to.pathStack.pushPath({ name: 'Login' })
        AlertDialog.show({message:'请先登录！'})
      }
    }
  })
}
