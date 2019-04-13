<template>
  <div>
    <h1>Редактирование теста</h1>
    <b-form @submit.prevent>
      <b-form-group class="mt-3" label="Название теста:">
        <b-form-input
          id="input-1"
          v-model="name"
          required
          placeholder="Введите название теста"
          :state="validName"
        ></b-form-input>
        <b-form-invalid-feedback :state="validName">
          Имя теста не должно быть пустым.
        </b-form-invalid-feedback>
      </b-form-group>
      <b-form-textarea
        id="content"
        v-model="content"
        placeholder="Введите содержимое теста.."
        rows="15"
      ></b-form-textarea>
      <div class="mt-3">
        <b-button variant="outline-primary" :to="{ name: 'tests'}">Вернуться к списку тестов</b-button>
        <b-button id="save" variant="outline-primary" @click="save" :disabled="!validName">Сохранить</b-button>
      </div>

    </b-form>
  </div>
</template>

<script>
  import {HTTP} from '../http-constants'

  export default {
    name: 'TestUI',
    props: {
      id: {
        type: String,
        required: false
      }
    },
    data () {
      return {
        name: '',
        content: ''
      }
    },
    computed: {
      validName () {
        return this.name.length > 0 && this.name.length < 128
      }
    },
    created () {
      this.getTest()
    },
    methods: {
      getTest () {
        if (!this.id) {
          return
        }
        let promise = HTTP.get(`/tc/v1/tests/${this.id}`)
        return promise.then((data) => {
          const t = data.data.test
          if (t) {
            this.name = t.name
            this.content = t.content
          }
        }).catch(error => {
          console.error(error)
        })
      },
      save () {
        if (!this.id) {
          return
        }
        let promise = HTTP.post(`/tc/v1/tests/${this.id}`, {
          id: this.id,
          name: this.name,
          content: this.content
        })
        promise.then((data) => {
          this.$router.push({ name: 'tests' })
        }).catch(error => {
          console.error(error)
        })
      }
    }
  }
</script>

<style scoped>

</style>
