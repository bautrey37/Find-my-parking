<template>
    <div id="findmyparking-app">
        <div class="vue-message">
            {{greeting}}
            <form action="/reservation">
                <div class="home-fields">
                    <label class="control-label col-sm-3" for="address">Address:</label>
                    <div class="col-sm-9">
                        <input type="text" class="form-control" id="address" v-model="address" required>
                    </div>
                    <!-- <label class="control-label col-sm-3" for="starting_time">Starting time</label>
                    <input type="time" name="starting_time" required><br>
                    <label class="control-label col-sm-3" for="ending_time">Ending time</label>
                    <input type="time" name="ending_time" required><br> -->
                    <label class="control-label col-sm-3" for="startTime">Start Time:</label>
                    <div class="col-sm-9">
                        <input type="datetime-local" class="form-control" id="startTime" v-model="startTime" required>
                    </div>
                    <label class="control-label col-sm-3" for="endTime">End Time:</label>
                    <div class="col-sm-9">
                        <input type="datetime-local" class="form-control" id="endTime" v-model="endTime" required>
                    </div>

                    <div class="col-sm-9">
                        <label class="control-label col-sm-3">Payment type</label>
                        <label class="col-sm-3">
                            <input type="radio" name="paymentType" value="hourly" v-model="paymentType" required>
                            Hourly
                        </label>
                        <label class="col-sm-3">
                            <input type="radio" name="paymentType" value="real" v-model="paymentType">
                            Real-time
                        </label>
                    </div>
                </div>
                <!--<div class="col-sm-offset-3 col-sm-9">
                    <button class="btn btn-default" v-on:click="submitSearchRequest">Search nearby</button>
                </div>-->

                <button class="btn btn-default" @click="storeParams()">Search for a nearby parking location</button>
                <!--<input type="submit" value="Search nearby parking location"/>-->
            </form>
            <form action="/user">
                <input type="submit" value="View your booking details" />
            </form>
        </div>
    </div>
</template>

<script>
    import axios from "axios";
    import auth from "../auth";
    // import { EventBus } from "../event-bus.js";

    export default {
        data() {
            return {
                greeting: "Enter Details",
                address: "Juhan Liivi 2, Tartu, Tartumaa 50409, Estonia",
                startTime: "",
                endTime:"",
                paymentType:""
            }
        },
        created() {
            console.log("App Vue component created");
            this.getNow();
            console.log(this.startTime);
        },
        methods: {
            storeParams: function () {
                axios.patch("/api/params",
                    {
                        address: this.address,
                        start_time: this.startTime,
                        end_time: this.endTime,
                        paymentType: this.paymentType,
                        // TODO: hardcoded username
                        username: "shaggy"
                    })
                    .then(response => {
                        this.messages = response.data.msg;
                        console.log(this.messages);
                    }).catch(error => {
                    console.log(error);
                });
            },
            addTrailingZeroIfNeeded: function(n) {
                return (n < 10 ? '0' : '') + n;
            },
            getNow: function() {
                const today = new Date();
                const date = this.addTrailingZeroIfNeeded(today.getFullYear()) + '-' + this.addTrailingZeroIfNeeded((today.getMonth() + 1)) + '-' + this.addTrailingZeroIfNeeded(today.getDate());
                const start = this.addTrailingZeroIfNeeded(today.getHours()) + ":" + this.addTrailingZeroIfNeeded(today.getMinutes());
                const end = this.addTrailingZeroIfNeeded(today.getHours() + 1) + ":" + this.addTrailingZeroIfNeeded(today.getMinutes());
                this.startTime = date + 'T' + start;
                this.endTime = date + 'T' + end;
            }
        }, 
    }
    
</script>


<style>
    .vue-message {
        text-align: center;
        font-size: 2em;
    }
    .home-fields {
        text-align: left;
        font-size: 1em;
    }
    
</style>