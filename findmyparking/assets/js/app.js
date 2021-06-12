// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"
import Vue from "vue";

import VueBingMaps from 'vue-bing-maps';

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

//import "axios";
//import "../socket";
import App from "./components/App.vue";
import Reservation from "./components/Reservation.vue";
import ReservationMap from "./components/ReservationMap.vue";
import User from "./components/User.vue";
import MonthlyPayment from "./components/MonthlyPayment.vue";
//import Login from "./components/Login.vue";

//Vue.component("login", login);
//Vue.component("reservation", Reservation)

//Vue.component("message", Message)
// new Vue({}).$mount("#findmyparking-app");
//new Vue({}).$mount("#reservation");

Vue.use(VueBingMaps, { debug: true });

new Vue({
    el: '#findmyparking-app',
    render: h => h(App)
});

new Vue({
    el:'#reservation-app',
    render: h => h(Reservation)
});

new Vue({
    el:'#reservationmap-app',
    render: h => h(ReservationMap)
});

new Vue({
    el:'#userdetails-app',
    render: h => h(User)
});

new Vue({
    el:'#paymonthly-app',
    render: h => h(MonthlyPayment)
});


