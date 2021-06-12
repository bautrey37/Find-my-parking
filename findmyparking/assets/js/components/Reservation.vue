<template>
    <div id="findmyparking">
        <table class="vue-table">
            <thead>
            <tr>
                <th class="text-left">Location Name</th>
                <th class="text-left">Available Spots</th>
                <th class="text-left">Price to Book (€)</th>
                <th class="text-left">Book</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="item in reservations" :key="item.name">
                <td>{{ item.name }}</td>
                <td>{{ item.total_spaces }}</td>
                <td>{{item.price}}</td>
                <td>
                    <button v-if="paymentType == 'hourly'" v-on:click="submitBookingRequest(item.name, 'Paid')">Pay</button>
                    <button v-else v-on:click="submitBookingRequest(item.name, 'Not Paid')">Book</button>
                </td>
            </tr>
            </tbody>
        </table>
        <form action="/">
            <input type="submit" value="Go Home" />
        </form>
    </div>
</template>

<script>
    // import socket from "../socket";
    import axios from "axios";
    // import auth from "../auth";
    // import { EventBus } from "../event-bus.js";

    export default {
        data() {
            return {
                data:"",
                reservations: [],
                paymentType: ""
            }
        },
        methods: {
            submitBookingRequest: function (selectedName, paymentStatus) {
                console.log("submit booking - " + selectedName);
                axios.patch("/api/reservation",
                    {name: selectedName, payment_status: paymentStatus})
                    .then(response => {
                        this.messages = response.data.msg;
                        console.log(this.messages);
                        this.updateTable();
                    }).catch(error => {
                    console.log(error);
                });
            },
            updateTable: function() {
                axios.get("/api/reservation")
                    .then(response => {
                        console.log(response);
                        this.reservations = response.data;
                    }).catch(error => {
                    console.log(error);
                });
            },
            isHourly: function() {
                axios.get("/api/params")
                    .then(response => {
                        console.log(response);
                        this.paymentType = response.data;
                    }).catch(error => {
                    console.log(error);
                });
            },
        },
        mounted: function () {
            this.updateTable()
            this.isHourly()
        }
    }
</script>

<style>
    .vue-table {
        text-align: center;
    }
</style>
