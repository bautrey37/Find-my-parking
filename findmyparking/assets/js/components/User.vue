<template>
    <div id="userdetails-app">
        <div class="userdetailsmessage">
         {{message}}
        </div>
            <div class="userinfo">
                <table class="vue-table">
                    <thead>
                        <tr>
                            <th class="text-left">No</th>
                            <th class="text-left">Parking Lot</th>
                            <th class="text-left">Start Time</th>
                            <th class="text-left">End Time</th>
                            <th class="text-left">Payment Status</th>
                            <th class="text-left">Payment</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="allocation in adetails" :key="allocation.id">
                            <td>{{ allocation.id }}</td>
                            <td>{{ allocation.parking_lot_id }}</td>
                            <td>{{ allocation.start_time }}</td>
                            <td>{{ allocation.end_time }}</td>
                            <td>{{ allocation.payment_status }}</td>
                            <td>
                                <button v-on:click="updateAllocationTable(allocation.id)">Pay Now</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <form action="/">
                    <input type="submit" value="Go Home" />
                </form>
                <form action="/monthlypayment">
                    <input type="submit" value="Pay at the end of the month" />
                </form>
            </div>
        </div>    
</template>


<script>
import socket from "../socket";
import axios from "axios";

    export default {
        data() {
            return {
                message: "Real Time Parking Details",
                adetails:[]
            }
        },
         methods: {
             updateAllocationTable: function (allocationId) {
                 console.log("Inside fetch details");
                 console.log("AID is" +allocationId);
                axios.patch("/api/user", {aid: allocationId})
                        .then(response => {
                          this.adetails = response.data;
                          console.log(this.adetails);
                          this.fetchDetails();
                        }).catch(error => {
                    console.log(error);
                });
            },
            fetchDetails: function() {
                axios.get("/api/user")
                    .then(response => {
                        console.log(response);
                        this.adetails = response.data;
                    }).catch(error => {
                    console.log(error);
                });
            },
         },
         mounted: function () {
             this.fetchDetails();
            //  this.updateAllocationTable();
         }
    }
</script>


<style>
    .userdetailsmessage {
        text-align: center;
        font-size: 2em;
    }
    
</style>
