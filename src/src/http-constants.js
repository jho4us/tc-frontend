import axios from 'axios'

let baсkendURL

if (!process.env.NODE_ENV) {
  baсkendURL = 'http://127.0.0.1:8081/'
} else {
  baсkendURL = process.env.BACKEND_URL
}

export const HTTP = axios.create(
  {
    baseURL: baсkendURL
  })
