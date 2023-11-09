<template>
    <div class="flex flex-col p-4 items-center">
        <RouterLink :to="'/workingTimes/' + user.id" class="sm:w-full">
            <div class="bg-red rounded-full p-3 flex items-center justify-center w-fit absolute left-3 sm:hidden">
                <img src="@/assets/icons/back.svg" class="w-6 h-6">
            </div>
            <p class="text-left hidden sm:block underline text-gray-500 hover:text-gray-600 active:text-gray-600">Back</p>
        </RouterLink>
        <div class="flex flex-col items-center p-2 rounded sm:shadow mt-20 sm:mt-6 w-full sm:w-auto">
            <h1 class="text-2xl font-medium">Details of working time {{ workingTimeId }}</h1>
            <div class="flex flex-col w-full items-start mt-8 sm:w-80">
                <p>From: <input type="datetime-local" v-model="updatedWorkingTime.start"></p>
                <p>To: <input type="datetime-local" v-model="updatedWorkingTime.end"></p>
                <div class="flex flex-row justify-between w-full mt-4">
                    <button @click="deleteWorkingTime" class="rounded bg-red hover:brightness-90 active:brightness-90 text-white py-1 px-12">Delete</button>
                    <button @click="updateWorkingTime" class="rounded bg-green-200 hover:brightness-90 active:brightness-90 text-black py-1 px-12">Update</button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { toRaw } from 'vue';
export default {
    name: 'WorkingTime',
    data() {
        return {
            workingTimeId: this.$route.params.workingTimeId,
            updatedWorkingTime: {},
        }
    },
    mounted() {
        this.getWorkingTime()
    },
    methods: {
        async getWorkingTime() {
            try {
                const response = await this.$network.get(`/api/workingtimes/${this.user.id}/${this.workingTimeId}`)
                const workingtime = await response.json();

                const startDate = new Date(workingtime.data.start);
                const endDate = new Date(workingtime.data.end);
                this.updatedWorkingTime.start = new Date(startDate.getTime() - (startDate.getTimezoneOffset() * 60000)).toISOString().replace('T', ' ').replace(/\.000Z$/, '');
                this.updatedWorkingTime.end = new Date(endDate.getTime() - (endDate.getTimezoneOffset() * 60000)).toISOString().replace('T', ' ').replace(/\.000Z$/, '');
            }
            catch (error) {
                console.log("error :", error)
            }
        },
        async deleteWorkingTime() {
            try {
                const response = await this.$network.delete(`/api/workingtimes/${this.workingTimeId}`)
                    .then(() => {
                        this.$router.push('/workingTimes/' + this.user.id)
                    });

            }
            catch (error) {
                console.log('error', error)
            }
        },
        async updateWorkingTime() {
            const updatedWorkingTime = {
                ...toRaw(this.updatedWorkingTime),
                start: new Date(this.updatedWorkingTime.start).toISOString(),
                end: new Date(this.updatedWorkingTime.end).toISOString()
            };
            const updatedTimes = { "workingtime": updatedWorkingTime };
            try {
                const response = await this.$network.put(`/api/workingtimes/${this.workingTimeId}`, updatedTimes)
                    .then(() => {
                        this.$router.push('/workingTimes/' + this.user.id)
                    });
            }
            catch (error) {
                console.log('error ', error)
            }
        },
    },
    computed: {
        user() {
            return this.$store.getters['auth/user'];
        }
    }
}
</script>
