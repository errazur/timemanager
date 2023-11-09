<template>
    <main>
        <div class="container m-auto mt-10 px-6 md:px-0 mb-[96px] sm:mb-0 sm:mt-[150px]">
            <h1 class="text-3xl mb-4 font-medium">WorkingTimes for user n°{{ user.id }}</h1>
            <vue-cal
                :time-from="8 * 60"
                :time-to="19 * 60"
                :time-step="30"
                hide-weekends
                :events="workingTimesByUser"
                @event-click="goToEventDetails">
            </vue-cal>
          <div class="mt-4">
              <h2 class="text-3xl mb-4 mt-8 font-medium">Create a new working time</h2>
              <p class="mb-2">Start : <input class="ml-2 px-3 py-1 border rounded" type="datetime-local" v-model="newWorkingTime.start"></p>
              <p class="mb-2">End : <input class="ml-2 px-3 py-1 border rounded" type="datetime-local" v-model="newWorkingTime.end"></p>
              <button class="rounded bg-rose-200 p-3 mt-3 mb-3" @click="createWorkingTime()">Create a working time</button>
          </div>
        </div>
    </main>
</template>

<script>
import VueCal from 'vue-cal'
import 'vue-cal/dist/vuecal.css'

export default {
    name: 'WorkingTimes',
    components: {
        VueCal
    },
    data() {
        return {
            workingTimesByUser: [],
            newWorkingTime: {
                start: "",
                end: ""
            },
            events: []
        }
    },
    mounted() {
        this.getWorkingTimes()
    },
    methods: {
        async getWorkingTimes() {
            try {
                const response = await this.$network.get(`/api/workingtimes/${this.user.id}`)
                const workingtimes = await response.json();
                this.workingTimesByUser = workingtimes.data;

                //Pour formatter les dates sous forme de : JJ/MM/YYYY HH:mm:ss
                this.workingTimesByUser = workingtimes.data.map(workingtime => ({
                    start: new Date(workingtime.start),
                    end: new Date(workingtime.end),
                    title: `Working time ${workingtime.id}`,
                    user: workingtime.user,
                    id: workingtime.id
                }));
                console.log(this.workingTimesByUser)
            }
            catch (error) {
                console.log("error :", error)
            }
        },
        async createWorkingTime() {
            try {
                //Formattage des dates : JJ/MM/YYYY HH:mm:ss
                const body = {
                    workingtime: {
                        start: new Date(this.newWorkingTime.start).toISOString(),
                        end: new Date(this.newWorkingTime.end).toISOString()
                    }
                }
                const response = await this.$network.post(`/api/workingtimes/${this.user.id}`, body)
                this.getWorkingTimes()
            }
            catch (error) {
                console.log("Error : ", error)
            }
        },
        goToEventDetails(event) {
            // Naviguez vers la route des détails de l'événement
            this.$router.push(`/workingTime/${event.user.id}/${event.id}`);
        }
    },
    computed: {
        user() {
            return this.$store.getters['auth/user'];
        }
    }
}
</script>
<style>
.vuecal {
    height: 70vh;
}

.vuecal__menu {
    background-color: #CE5A67;
    color: #ffffff;
}

.vuecal__title-bar {
    border: 2px solid #CE5A67;
    background: rgba(206, 90, 103, 0.21);
}

.vuecal__event {
    background-color: #CE5A67;
    color: #ffffff;
    padding: 16px;
    border-radius: 12px;
    border: 1px solid #ffffff;
}
</style>
