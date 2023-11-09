import "./assets/main.css";
import "@/assets/css/tailwind.css";

import { createApp } from "vue";
import store from './store'; // Assurez-vous du chemin correct vers votre fichier store Vuex

import App from "./App.vue";
import router from "./router";
import network from "./tools/NetworkManager";

const app = createApp(App);

app.config.globalProperties.$network = network;

app.use(router).use(store);

app.mount("#app");
