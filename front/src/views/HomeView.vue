<template>
    <header v-if="this.$route.name !== 'login'" class="fixed bottom-0 sm:bottom-auto w-full z-10 sm:top-0">
        <div
            class="h-24 sm:h-28 bg-white w-full absolute bottom-0 sm:bottom-auto flex justify-center items-center sm:shadow-lg">
            <nav class="w-full z-10">
                <ul class="flex justify-around sm:justify-start sm:items-center sm:px-16 md:px-20 lg:px-24">
                    <li class="hidden sm:list-item mr-10 md:mr-16 lg:mr-24"><router-link to="/">
                            <p class="font-semibold">TimeMachine</p>
                        </router-link></li>
                    <li class="sm:hidden"><router-link to="/">
                            <div class="flex flex-col items-center">
                                <div class="bg-white border-2 rounded-full p-1.5 inline-flex items-center justify-center"
                                    :class="{ 'border-red': this.$route.name === 'home' }">
                                    <img :src="iconHome" class="w-6 h-6" :class="{ selected: this.$route.name === 'home' }">
                                </div>
                                <p>Home</p>
                            </div>
                        </router-link></li>
                    <li class="sm:mr-10 md:mr-16 lg:mr-24"><router-link :to="'/workingTimes/' + user.id">
                            <div class="flex flex-col items-center">
                                <div class="bg-white border-2 rounded-full p-1.5 inline-flex items-center justify-center sm:hidden"
                                    :class="{ 'border-red': this.$route.name === 'workingTimes' }">
                                    <img :src="iconWorkingTimes" class="w-6 h-6"
                                        :class="{ selected: this.$route.name === 'workingTimes' }">
                                </div>
                                <p>Working Times</p>
                            </div>
                        </router-link></li>
                    <li class="sm:mr-10 md:mr-16 lg:mr-24 hidden sm:list-item"><router-link :to="'/chartManager/' + user.id">
                            <p>Chart Manager</p>
                        </router-link></li>
                  <li v-if="user.role !== 'employee'" class="hidden sm:list-item">
                    <router-link :to="'/manager/' + user.id"><p>Manager page</p></router-link>
                  </li>
                    <li @click="userDetails = !userDetails">
                        <div class="flex flex-col items-center">
                            <div class="bg-white border-2 sm:border-0 rounded-full p-1.5 inline-flex items-center justify-center sm:absolute sm:right-16 md:right-20 lg:right-28 sm:-translate-y-6"
                                :class="{ 'border-red': this.$route.name === 'user' }">
                                <img :src="iconUser" class="w-6 h-6 sm:w-10 sm:h-10"
                                    :class="{ selected: this.$route.name === 'user' }">
                            </div>
                            <p class="sm:hidden">Profil</p>
                        </div>
                    </li>
                </ul>
            </nav>
        </div>
        <router-link :to="'/clock/' + encodeURIComponent(user.username)" v-if="this.$route.name !== 'clock'">
            <div class="bg-green-200 rounded-full p-5 flex items-center justify-center w-fit absolute sm:fixed -top-36 right-3 sm:right-4 -translate-y-1/2 sm:top-auto sm:-bottom-0">
                <img :src="iconClock" class="w-9 h-9">
            </div>
        </router-link>
    </header>
    <div v-if="userDetails" @click.self="userDetails = false" class="flex flex-col justify-end sm:flex-row fixed w-full h-screen bg-black bg-opacity-50 z-20">
        <ProfileManagmentUser @details="userDetails = false" />
    </div>
    <router-view :class="{ 'sm:mt-28 sm:mb-10': this.$route.name !== 'login'}"></router-view>
</template>

<script>
import { jwtDecode } from 'jwt-decode';
import { RouterLink, RouterView } from 'vue-router';
import ProfileManagmentUser from '../components/ProfileManagmentUser.vue';

import iconHome from '../assets/icons/home.svg';
import iconWorkingTimes from '../assets/icons/schedule.svg';
import iconUser from '../assets/icons/user.svg';
import iconClock from '../assets/icons/work.svg';
export default {
    name: "HomeView",
    data() {
        return {
            userDetails: false,

            iconHome: iconHome,
            iconWorkingTimes: iconWorkingTimes,
            iconUser: iconUser,
            iconClock: iconClock,
        };
    },
    computed: {
        user() {
            return this.$store.getters['auth/user'];
        }
    },
    mounted() {
        this.$network.get('/api/tokens')
            .then(response => response.json())
            .then(data => {
                localStorage.setItem('token', data.bearer);

                const user = jwtDecode(data.bearer).user;
                this.$store.commit('auth/loginSuccess', user);

                const csrfToken = data._csrf_token;
                this.$store.commit('auth/setCsrfToken', csrfToken);
            })
            .catch(error => {
                console.error('There was a problem with the fetch operation:', error);
            });
    },
    components: {
        ProfileManagmentUser,
    }
}
</script>

<style scoped>
.selected {
    filter: invert(47%) sepia(67%) saturate(536%) hue-rotate(305deg) brightness(85%) contrast(88%);
}

.first-row {
    filter: drop-shadow(0px 4px 15px rgba(0, 0, 0, 0.15));
    border-radius: 24px;
}

.second-row {
    background: linear-gradient(248deg, rgba(206, 90, 103, 0.77) 0%, rgba(255, 202, 142, 0.66) 100%);
}
</style>