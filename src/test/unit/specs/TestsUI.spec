import Vue from 'vue'
import TestUI from '@/components/TestsUI'

describe('TestUI.vue', () => {
  it('should render correct contents', () => {
    const Constructor = Vue.extend(TestUI)
    const vm = new Constructor().$mount()
    expect(vm.$el.querySelector('#save').textContent)
      .to.equal('Сохранить')
  })
})
