<template>
  <div id="reservationmap">
    <div class="res-map">
      <bing-map credentials="ApB-6HM882leypxwisTb4DZqvP05ASq2R1jEIaplEzdGqojzFlz5DUR6Ssy8kXUN" :options="mapOptions">
        <bing-map-layer name="layer-1" :visible="layerVisible">
          <bing-map-pushpin v-for="item in pins" 
                            :key="item.name"
                            :location="item.location" 
                            :options="item.options">
          </bing-map-pushpin>
        </bing-map-layer>
      </bing-map>
    </div>
    <div>
        <button type="button" @click="updateMap">Refresh map</button>
    </div>
  </div>
</template>

<script>

import socket from "../socket";
import axios from "axios";
// import auth from "../auth";

export default {
  name: 'reservationmap',
  props: {
    msg: String
  },
  data: function(){
    return {
      layerVisible: true,
      mapOptions: {
        zoom: 12,
        center: {
            latitude: 58.383591,
            longitude: 26.719257
          }
      },
      pins: [
      ]
    };
  },
  methods: {
    updateMap: function() {
        axios.get("/api/reservation")
            .then(response => {
                console.log(response);
                var parkingLots = response.data;
                this.pins = [];
                for (var i = 0; i < parkingLots.length; i++) {
                    console.log(parkingLots[i]);
                    var pinColor = "red";
                    if (parkingLots[i].parking_zone === "B") {
                        pinColor = "blue";
                    }
                  this.pins.push({
                    key: parkingLots[i].name,
                    location: {latitude: parkingLots[i].latitude, longitude: parkingLots[i].longitude},
                    options: {title: parkingLots[i].name, color: pinColor, visible: true}
                  });
                }
            }).catch(error => {
            console.log(error);
        });
    }
  },
  mounted: function () {
      this.updateMap();
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.res-map {
  width: 100%;
  height: 500px;
}
</style>