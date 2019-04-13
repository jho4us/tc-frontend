'use strict'

const cloneObj = function (obj) {
  return Object.assign({}, obj)
}

const mergeObjs = function () {
  let values = []
  for (let i = 0; i < arguments.length; i++) {
    values.push(arguments[i])
  }
  return Object.assign(...(values.map(cloneObj)))
}

let Plugin = function (Vue, globalOptions = {}) {
  this.Vue = Vue
  this.mounted = false
  this.$root = {} // The root component
}

Plugin.prototype.modal = function ({parentApp, text, icon, options}) {
  const el = document.querySelector('body').appendChild(document.createElement('div'))
  const self = this

  let props = mergeObjs({ visible: true }, options)

  return new Promise((resolve, reject) => {
    const isFn = !!(text && text.constructor && text.call && text.apply)
    this.$root = new this.Vue({
      parent: parentApp,
      el: el,
      render (h) {
        return h('b-modal', {
          props: props,
          on: {
            hidden: (evt) => {
              self.destroy()
            },
            ok: (evt) => {
              resolve(self.$root)
            },
            cancel: (evt) => {
              return reject(new Error('Canceled'))
            }
          }
        }, isFn ? [...text(h)]
          : [h('i', {class: ['material-icons', 'dialog-icon']}, [`${icon}`]), text])
      }
    })
    this.mounted = true
  })
}

Plugin.prototype.destroy = function () {
  if (this.mounted === true) {
    let elem = this.$root.$el
    this.$root.$destroy()
    this.$root.$off()
    elem.remove()
    this.mounted = false
  }
}

Plugin.install = function (Vue, options) {
  Vue.dialog = new Plugin(Vue, options)

  Object.defineProperties(Vue.prototype, {
    $dialog: {
      get () {
        return Vue.dialog
      }
    }
  })
}

export default Plugin
