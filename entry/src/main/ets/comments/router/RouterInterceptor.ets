import { LoginStateManager } from '../utils/LoginStateManagerUtil';

export function setupRouterInterceptor(stack: NavPathStack): void {
  stack.setInterception({
    willShow: (from: NavDestinationContext | 'navBar', to: NavDestinationContext | 'navBar'): void => {
      if (typeof to !== 'object') {
        return
      }
      const targetPageConfig = to.getConfigInRouteMap()
      if (targetPageConfig?.data?.['needLogin'] === '1' && !LoginStateManager.isLogin()) {
        to.pathStack.pop()
        to.pathStack.pushPath({ name: 'Login' })
      }
    }
  })
}
