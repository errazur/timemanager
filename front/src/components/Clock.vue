<template>
        <div v-if="clockIn" class="bg-gradient-to-b from-green-200 from-20% h-screen sm:mt-0 flex flex-col justify-center items-center">
            <h2 class="text-3xl font-light mb-20 sm:mb-0 sm:mt-20 sm:text-2xl">You're curently working</h2>
            <div class="flex flex-col items-center mb-20 sm:mb-10">
                <p class="text-xl sm:hidden">You started at:</p>
                <p class="text-5xl font-semibold sm:text-8xl">{{ startTimeHours }}</p>
                <p class="text-xl sm:hidden">on:</p>
                <p class="text-5xl font-semibold sm:text-3xl sm:font-normal sm:mt-2">{{ startTimeDay }}</p>
            </div>
            <button class="bg-white text-3xl p-1 rounded-md shadow-md mb-20 sm:text-xl sm:h-14 sm:w-96 sm:shadow-lg" @click="clockOutFunc">Finish?</button>
        </div>
        <div v-else class="bg-gradient-to-b from-rose-300 from-20% h-screen sm:mt-0 flex flex-col justify-center items-center">
            <h2 class="text-3xl font-light mb-20 sm:mb-0 sm:mt-20 sm:text-2xl">You're not working</h2>
            <div class="flex flex-col items-center mb-20 sm:mb-10">
                <p class="text-xl sm:hidden">It's:</p>
                <p class="text-5xl font-semibold sm:text-8xl">{{ currentTimeHours }}</p>
                <p class="text-xl sm:hidden">on:</p>
                <p class="text-5xl font-semibold sm:text-3xl sm:font-normal sm:mt-2">{{ currentTimeDay }}</p>
            </div>
            <button class="bg-white text-3xl p-1 rounded-md shadow-md mb-20 sm:text-xl sm:h-14 sm:w-96 sm:shadow-lg" @click="clockInFunc">Start?</button>
        </div>
</template>

<script>
import { ref } from 'vue'
import { useRoute } from 'vue-router'

export default {
    name: "Clock",
    data() {
        return {
            currentTime: new Date().toLocaleString(),
            currentTimeHours: new Date().toLocaleTimeString('en-US', { hour: 'numeric', minute: 'numeric', hour12: true }).toLowerCase(),
            currentTimeDay: new Date().toLocaleDateString('en-US', { year: 'numeric', month: '2-digit', day: '2-digit' }),

            startTime: new Date().toLocaleString(),
            startTimeHours: new Date().toLocaleTimeString('en-US', { hour: 'numeric', minute: 'numeric', hour12: true }).toLowerCase(),
            startTimeDay: new Date().toLocaleDateString('en-US', { year: 'numeric', month: '2-digit', day: '2-digit' }),
            clockIn: false,
        }
    },
    computed: {
        user() {
            return this.$store.getters['auth/user'];
        }
    },
    methods: {
        clockInFunc() {
            this.clockIn = true;
            this.updateStartedTime(new Date().toISOString())
            this.clock();
        },
        clockOutFunc() {
            this.clockIn = false;
            this.clock();
        },
        updateStartedTime(time) {
            this.startTime = new Date(time).toLocaleString()
            this.startTimeHours = new Date(time).toLocaleTimeString('en-US', { hour: 'numeric', minute: 'numeric', hour12: true }).toLowerCase()
            this.startTimeDay = new Date(time).toLocaleDateString('en-US', { year: 'numeric', month: '2-digit', day: '2-digit' })
        },
        updateCurrentTime() {
            this.currentTime = new Date().toLocaleString()
            this.currentTimeHours = new Date().toLocaleTimeString('en-US', { hour: 'numeric', minute: 'numeric', hour12: true }).toLowerCase()
            this.currentTimeDay = new Date().toLocaleDateString('en-US', { year: 'numeric', month: '2-digit', day: '2-digit' })
        },

        async clock() { // Test sans passer par le network 
            const url = `/api/clocks/${this.user.id}`;
            const data = {
                clock: {
                    status: this.clockIn,
                    time: new Date().toISOString()
                },
                _csrf_token: this.$store.getters['auth/csrfToken']
            };
            try {
                const response = await this.$network.post(url, data);
                const result = await response.json();
            } catch (error) {
                console.error(error);
            }
        },
        async refresh() {
            const url = `/api/clocks/${this.user.id}`;
            try {
                const response = await this.$network.get(url);
                const result = await response.json();
                if (result.data.length > 0) {
                    const lastClock = result.data[result.data.length - 1];
                    this.clockIn = lastClock.status;
                    this.updateStartedTime(lastClock.time);
                }
            } catch (error) {
                console.error(error);
            }
        }
    },
    mounted() {
        this.refresh();
        setInterval(() => {
            this.updateCurrentTime()
        }, 1000)
    }
}
</script>
