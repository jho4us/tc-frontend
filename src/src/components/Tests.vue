<template>
  <div>
    <b-form @submit.prevent @reset="onReset" v-if="show">
      <b-input-group class="mt-3">
        <b-form-input
          id="input-1"
          v-model="name"
          required
          placeholder="Введите название теста"
          :state="validName"
        ></b-form-input>
        <b-input-group-append>
          <b-button id="createBtn" variant="outline-primary" @click="createTest" :disabled="!validName">Создать тест</b-button>
        </b-input-group-append>
        <b-form-invalid-feedback :state="validName">
          Название теста не должно быть пустым а также не превышать 128 символов.
        </b-form-invalid-feedback>
      </b-input-group>
      <b-table id="tblTests" ref="tblTests"
        striped
        responsive
        hover
        show-empty
        :current-page="currentPage"
        :per-page="perPage"
        :busy="isBusy"
        :items="getTests"
        :fields="fields"
        primary-key="id"
        thead-class="d-none"
        :filter="name"
        @filtered="onFiltered"
        no-provider-filtering
        no-provider-paging
        no-provider-sorting
        caption-top>
        <template slot="table-caption"><h4>Мои тесты
          <b-button size="sm" variant="outline-primary" @click="refresh" class="mr-1" v-b-tooltip.hover title="Обновить">
            <refresh-icon />
          </b-button>
        </h4></template>
        <template slot="empty">Нет записей для показа</template>
        <template slot="actions" slot-scope="row">
          <b-button size="sm" @click="deleteTest( row )" variant="outline-danger" class="mr-1" v-b-tooltip.hover title="Удалить данный тест">
            <close-circle-icon />
          </b-button>
        </template>
        <template slot="name" slot-scope="data">
          <b-link :to="{ name: 'edit-test', params: { id: data.item.id }}">{{ data.item.name }}</b-link>
        </template>
      </b-table>
      <b-row>
        <b-col md="6" class="my-1">
          <b-pagination
            v-model="currentPage"
            :total-rows="totalRows"
            :per-page="perPage"
            class="my-0"
            v-show="totalRows > perPage"
          ></b-pagination>
        </b-col>
      </b-row>
    </b-form>
  </div>
</template>

<script>
  import CloseCircleIcon from 'vue-material-design-icons/CloseCircle.vue'
  import RefreshIcon from 'vue-material-design-icons/Refresh.vue'
  import {HTTP} from '../http-constants'

  export default {
    name: 'Tests',
    components: {
      CloseCircleIcon,
      RefreshIcon
    },
    data () {
      return {
        name: '',
        show: true,
        isBusy: false,
        totalRows: 0,
        currentPage: 1,
        perPage: 5,
        fields: {
          name: {
            sortable: true,
            class: 'text-left'
          },
          actions: {
            label: 'Actions',
            class: 'w-25 text-right'
          }
        }
      }
    },
    computed: {
      validName () {
        return this.name.length > 0 && this.name.length < 128
      }
    },
    methods: {
      onSubmit (evt) {
        evt.preventDefault()
      },
      onReset (evt) {
        evt.preventDefault()
        // Reset our form values
        this.form.name = ''
        // Trick to reset/clear native browser form validation state
        this.show = false
        this.$nextTick(() => {
          this.show = true
        })
      },
      onFiltered (filteredItems) {
        // Trigger pagination to update the number of buttons/pages due to filtering
        this.totalRows = filteredItems.length
        this.currentPage = 1
      },
      getTests (ctx) {
        let promise = HTTP.get('/tc/v1/tests')
        this.isBusy = true

        return promise.then((data) => {
          const items = data.data.tests
          this.isBusy = false
          if (items) {
            this.totalRows = items.length
          } else {
            this.totalRows = 0
          }
          return (items)
        }).catch(error => {
          console.error(error)
          this.isBusy = false
          // Returning an empty array, allows table to correctly handle
          // internal busy state in case of error
          return []
        })
      },
      refresh () {
        this.isBusy = false
        this.$refs.tblTests.refresh()
      },
      createTest () {
        let promise = HTTP.post('/tc/v1/tests', {
          name: this.name
        })
        return promise.then((data) => {
          this.$router.push({ path: `/test/${data.data.id}` })
        }).catch(error => {
          console.error(error)
        })
      },
      deleteTest (row) {
        const s = `Вы уверены что хотите удалить тест '${row.item.name}'?`
        const self = this
        this.$root.$dialog.modal({
          parentApp: this.$root,
          text: function (h) {
            return [
              h('p', {class: 'modal-question'}, [s])
            ]
          },
          options: {
            title: 'Удаление теста',
            okTitle: 'Да',
            cancelTitle: 'Нет',
            okVariant: 'secondary',
            cancelVariant: 'primary',
            centered: true,
            headerBgVariant: 'dark',
            headerTextVariant: 'light',
            bodyBgVariant: 'warning'
          }
        }).then((app) => {
          return HTTP.delete(`/tc/v1/tests/${row.item.id}`).then((data) => {
            self.refresh()
          }).catch(error => {
            console.error(error)
            self.refresh()
          })
        }, (err) => {
          err = null
        })
      }
    }
  }
</script>

<style scoped>
</style>
