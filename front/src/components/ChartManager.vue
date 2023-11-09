<template>
    <div class="container mx-auto p-6 pb-[106px] sm:px-0">
        <h1 class="text-3xl font-medium mb-3">ChartManager</h1>
        <div class="wrapper">
            <div class="flex flex-col mb-12 bg-white shadow-md rounded-3xl p-6">
              <div class="flex gap-4">
                <div class="relative" >
                  <input type="radio" class="absolute w-full h-full opacity-0" name="month" id="month-working" value="Per Month" v-model="displayModeWorkingtimes" @change="getDisplayModeWorkingTimes()" />
                  <label for="month-working" :class="{ 'text-red font-medium': displayModeWorkingtimes === 'Per Month' }">Per Month</label>
                </div>
                <div class="relative">
                  <input type="radio" class="absolute w-full h-full opacity-0" name="day" id="day-working" value="Per Day" v-model="displayModeWorkingtimes" @change="getDisplayModeWorkingTimes()" />
                  <label for="day-working"  :class="{ 'text-red font-medium': displayModeWorkingtimes === 'Per Day' }">Per Day</label>
                </div>
                <div class="relative" >
                  <input type="radio" class="absolute w-full h-full opacity-0" name="year" id="year-working" value="Per Year" v-model="displayModeWorkingtimes" @change="getDisplayModeWorkingTimes()" />
                  <label for="year-working" :class="{ 'text-red font-medium': displayModeWorkingtimes === 'Per Year' }">Per Year</label>
                </div>
              </div>

              <Line id="my-chart-id" :options="chartOptions" v-bind:data="getChartData" />
            </div>
            <div class="flex flex-col lg:flex-row justify-between gap-12 bg-white shadow-md rounded-3xl p-6">
              <div class="flex flex-col w-full">
                <div class="flex gap-4">
                  <div class="relative">
                    <input type="radio" class="absolute w-full h-full opacity-0" name="overtime" id="month-overtime" value="Per Month" v-model="displayModeOvertime" @change="getDisplayModeOvertime()" />
                    <label for="month-overtime" :class="{ 'text-red font-medium': displayModeOvertime === 'Per Month' }">Per Month</label>
                  </div>
                  <div class="relative">
                    <input type="radio" class="absolute w-full h-full opacity-0" name="overtime" id="year-overtime" value="Per Year" v-model="displayModeOvertime" @change="getDisplayModeOvertime()" />
                    <label for="year-overtime" :class="{ 'text-red font-medium': displayModeOvertime === 'Per Year' }">Per Year</label>
                  </div>
                </div>

                <Bar id="overtime" :options="chartOptions" v-bind:data="getChartOvertimeData" />
              </div>
              <div class="max-w-[300px] lg:max-w-none mx-auto">
                <div class="flex flex-col items-center gap-4">
                  <input type="range" v-model="limit" @change="getChartNightHoursLimit()"> Limit of hours : {{getLimitHours}}
                </div>
                <Doughnut :data="getChartNightHours" :options="chartOptions" />
              </div>
            </div>
        </div>
    </div>
</template>

<script>
import { Bar, Line, Doughnut } from 'vue-chartjs';
import {
    Chart as ChartJS, LineElement, ArcElement,
    PointElement, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale
} from 'chart.js';
import moment from 'moment';
import { toRaw } from 'vue';
ChartJS.register(Title, Tooltip, LineElement,
    PointElement, Legend, BarElement, CategoryScale, LinearScale, ArcElement)
import store from "@/store"
import {mapGetters} from "vuex";
export default {
    name: 'ChartManager',
    props: ['userId'],
    components: { Bar, Line, Doughnut },
    data() {
        return {
            chartOptions: {
                backgroundColor: '#f87979',
                responsive: true,
                maintainAspectRatio: true
            },
            limit: 60,
            displayModeWorkingtimes: "Per Month",
            displayModeOvertime: "Per Month"
        }
    },
    methods: {
        getDisplayModeWorkingTimes() {
            switch (toRaw(this.displayModeWorkingtimes)) {
                case 'Per Month':
                    store.commit('setWorkingTimesPerMonth');
                    break;
                case 'Per Year':
                    store.commit('setWorkingTimesPerYear');
                    break;
                case 'Per Day':
                    store.commit('setWorkingTimesPerDay')
                    break;
                default:
                  store.commit('setWorkingTimesPerMonth');
            }
        },
        getDisplayModeOvertime() {
            switch (toRaw(this.displayModeOvertime)) {
                case 'Per Month':
                    store.commit('setOvertimeHoursPerMonth');
                    break;
                case 'Per Year':
                    store.commit('setOvertimeHoursPerYear')
                    break;
                default:
                    store.commit('setOvertimeHoursPerMonth')
            }
        },
        getChartNightHoursLimit(){
            store.commit('setLimit', this.limit)
          // store.commit('setChartNightHours')
        }
    },
    computed: {
      ...mapGetters(['getChartData']),
      ...mapGetters(['getChartOvertimeData']),
      ...mapGetters(['getChartNightHours']),
      ...mapGetters(['getLimitHours'])
    },
    mounted() {
      store.dispatch('getData')
    }
}
</script>
