<script>
import { mapGetters } from "vuex";
import { Doughnut } from "vue-chartjs";
import {
  Chart as ChartJS, ArcElement,
  Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale
} from 'chart.js';
ChartJS.register(Title, Tooltip,
  Legend, BarElement, CategoryScale, LinearScale, ArcElement)
import store from "@/store";
import VueCal from 'vue-cal'
import 'vue-cal/dist/vuecal.css'
import workingTimes from "@/components/WorkingTimes.vue";

export default {
  name: 'Dashboard',
  components: { Doughnut, VueCal },
  data() {
    return {
      chartOptions: {
        backgroundColor: '#f87979',
        responsive: true,
        maintainAspectRatio: true,
      },
    }
  },
  computed: {
    workingTimes() {
      return workingTimes
    },
    ...mapGetters(['getChartNightHours']),
    ...mapGetters(['getHoursWorkedWeek']),
    ...mapGetters(['getNightHoursMonth']),
    ...mapGetters(['getRTTHours']),
    ...mapGetters(['getPassedNightHours']),
    ...mapGetters(['getPlannedNightHours']),
    ...mapGetters(['getWorkingTimesByUser']),
    ...mapGetters(['getMinHour']),
    ...mapGetters(['getMaxHour']),
    user() {
      return this.$store.getters['auth/user'];
    },
  },
  // methods:{
  //   async getWorkingTimes() {
  //     try {
  //       const response = await this.$network.get(`/api/workingtimes/${this.user.id}`)
  //       const workingtimes = await response.json();
  //       this.workingTimesByUser = workingtimes.data;
  //
  //       //Pour formatter les dates sous forme de : JJ/MM/YYYY HH:mm:ss
  //       this.workingTimesByUser = workingtimes.data.map(workingtime => ({
  //         start: new Date(workingtime.start),
  //         end: new Date(workingtime.end),
  //         title: `Working time ${workingtime.id}`
  //       }));
  //       console.log(this.workingTimesByUser)
  //     }
  //     catch (error) {
  //       console.log("error :", error)
  //     }
  //   },
  // },
  mounted() {
    store.dispatch('getData');
    // this.getWorkingTimes();
  }
}
</script>

<template>
  <div class="container m-auto px-6 md:px-0 pb-[96px] sm:pb-0 pt-6 sm:pt-6">
    <p class="font-medium text-2xl mb-6">Hello {{ user.username }}</p>
    <div class="dashboard grid grid-cols-2 sm:grid-cols-3 grid-rows-3 sm:grid-rows-[1fr,auto] w-full gap-[20px] h-auto sm:h-[75vh]">
      <div class="shadow-md rounded-3xl col-span-full sm:col-span-2 p-4 bg-white flex flex-col">
        <!-- Emploi du temps -->
        <vue-cal style="height: 250px" :time-from="
        getMinHour * 60" hide-view-selector
                 hide-title-bar :disable-views="['day']" :showAllDayEvents="true" :time-to="getMaxHour * 60" :time-step="30"  hide-weekends xsmall :events="getWorkingTimesByUser">
        </vue-cal>
        <router-link :to="{name: 'workingTimes', params: {userId: user.id }}" class="self-end">See working times</router-link>
      </div>
      <div class="hidden sm:block shadow-md  rounded-3xl p-4 bg-white flex flex-col">
        <!-- chartManager -->
        <h2 class="text-xl font-medium">Graphic of Night Hours</h2>
        <div class="h-5/6">
          <Doughnut v-bind:data="getChartNightHours" :options="chartOptions" class="mx-auto" />
        </div>
        <router-link :to="{name: 'chartManager', params: {userId: user.id }}" class="self-end mt-4 block text-end">See chart Manager</router-link>
      </div>
      <div class="p-6 rounded-3xl second-row  pt-[80px]">
        <h2 class="text-xl mb-6 font-medium">Hours worked this week</h2>
        <p class="text-center text-8xl leading-10 font-medium">{{ getHoursWorkedWeek }}</p>
      </div>
      <div class="p-6 rounded-3xl second-row  col-span-1 sm:col-span-auto row-start-3 sm:row-start-2 pt-[80px]">
        <h2 class="text-xl mb-6 font-medium">Hours of RTT to ask</h2>
        <p class="text-center text-8xl font-medium">{{ getRTTHours }}</p>
      </div>
      <div class="p-6 rounded-3xl second-row row-span-2 sm:row-auto pt-[80px]">
        <h2 class="text-xl mb-8 font-medium">Night hours</h2>
        <div class="flex justify-between items-center flex-col sm:flex-row gap-8 sm:gap-0">
          <span class="text-center">
            <p class="text-3xl">{{ getPassedNightHours }}</p>
            <p>night hours done this month</p>
          </span>
          <span class="text-center">
            <p class="text-3xl">{{ getPlannedNightHours }}</p>
            <p>night hours planned this month</p>
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<style>
.dashboard .selected {
  filter: invert(47%) sepia(67%) saturate(536%) hue-rotate(305deg) brightness(85%) contrast(88%);
}

.dashboard .first-row {
  filter: drop-shadow(0px 4px 15px rgba(0, 0, 0, 0.15));
  border-radius: 24px;
}

.dashboard .second-row {
  background: linear-gradient(248deg, rgba(206, 90, 103, 0.77) 0%, rgba(255, 202, 142, 0.66) 100%);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: relative;
}

.dashboard .second-row h2 {
  position: absolute;
  top: 24px;
  left: 24px;
}
.dashboard .vuecal__event.futur{
  background-color: #F4BF96;
}
.dashboard .vuecal__event.current{
  background: linear-gradient(180deg, rgba(206, 90, 103, 0.26) 0%, #CE5A67 9.9%, #CE5A67 34.38%, #F4BF96 57.81%, #F4BF96 90.62%, rgba(244, 191, 150, 0.26) 100%);
}
</style>
