import Vue from 'vue'
import Tests from '@/components/Tests'

describe('Tests.vue', () => {
  it('should render correct contents', () => {
    const Constructor = Vue.extend(Tests)
    const vm = new Constructor().$mount()
    expect(vm.$el.querySelector('#createBtn').textContent)
      .to.equal('Создать тест')
  })
})
