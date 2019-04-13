import Vue from 'vue'
import Router from 'vue-router'
import Tests from '@/components/Tests'
import TestUI from '@/components/TestUI'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'tests',
      component: Tests
    },
    {
      path: '/test/:id',
      component: TestUI,
      props: true,
      name: 'edit-test'
    }
  ]
})
