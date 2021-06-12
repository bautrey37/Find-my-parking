<template>
    <div id="paymonthly-app">
        <div class="userdetailsmessage">
         {{message}}
        </div>
            <div class="paymonthly">
                <table class="vue-table">
                    <thead>
                        <tr>
                            <th class="text-left">No</th>
                            <th class="text-left">Parking Lot</th>
                            <th class="text-left">Start Time</th>
                            <th class="text-left">End Time</th>
                            <th class="text-left">Payment Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="allocation in adetails" :key="allocation.id">
                            <td>{{ allocation.id }}</td>
                            <td>{{ allocation.parking_lot_id }}</td>
                            <td>{{ allocation.start_time }}</td>
                            <td>{{ allocation.end_time }}</td>
                            <td>{{ allocation.payment_status }}</td>
                        </tr>
                        <button v-on:click="updateAllocationTable(adetails)">Pay</button>
                    </tbody>
                    
                       
                </table>
               
                <form action="/">
                    <input type="submit" value="Go Home" />
                </form>
            </div>
        </div>    
</template>


<script>
import axios from "axios";

    export default {
        data() {
            return {
                user: "",
                message: "Monthly Payment Details",
                adetails:[]
            }
        },
         methods: {
             updateAllocationTable: function (adetails) {
                let ids = adetails.map(a => a.id);

                axios.patch("/api/paymonthly", {a_ids: ids})
                        .then(response => {
                          this.adetails = response.data;
                          console.log(this.adetails);
                          this.fetchDetails();
                        }).catch(error => {
                    console.log(error);
                });
            },
            fetchDetails: function() {
                axios.get("/api/paymonthly")
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
