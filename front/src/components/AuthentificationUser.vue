<template>
    <div class="w-screen h-screen bg-gradient-to-b from-red from-40% sm:bg-backgroundLogin bg-no-repeat bg-cover bg-center">
        <div class="w-full flex justify-center items-center h-96">
            <h1 class="text-3xl font-medium shadow sm:text-white sm:text-6xl md:text-7xl lg:text-8xl sm:font-extrabold sm:shadow-none bg-white sm:bg-opacity-10 rounded-sm sm:rounded-xl sm:p-3 sm:backdrop-blur-sm">TimeMachine</h1>
        </div>
        <form @submit.prevent="getUser">
            <div class="flex flex-col h-24 sm:h-36 w-screen justify-center items-center p-5">
                <div class="w-full flex flex-col justify-center sm:p-4 bg-white rounded sm:max-w-[401px] shadow-md p-1">
                    <div class="w-full flex flex-col justify-start mb-4">
                        <h2 class="text-3xl">Hello</h2>
                        <h1 v-if="username" class="text-5xl font-semibold w-full truncate h-14">{{ username }}</h1>
                    </div>
                    <div class="grid grid-cols-3 gap-y-1 w-full">
                        <p class="col-span-1">Username:</p>
                        <input class="border rounded col-span-2" type="text" v-model="username">
                        <p class="col-span-1">Password:</p>
                        <input class="border rounded col-span-2" type="password" v-model="password">
                    </div>
                    <div class="w-full flex justify-end">
                        <button type="submit" class="rounded bg-red hover:brightness-90 active:brightness-90 text-white py-1 px-12 mt-2">Login</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</template>

<script>
import { jwtDecode } from 'jwt-decode';

export default {
    data() {
        return {
            username: '',
            password: ''
        }
    },
    methods: {
        getUser() {
            const url = '/api/login';
            this.$network.post(url, {
                credentials: {
                    username: this.username,
                    password: this.password //TODO: Chiffrer le mot de passe
                }
            })
                .then(response => response.json())
                .then(data => {
                    localStorage.setItem('token', data.bearer);

                    const user = jwtDecode(data.bearer).user;
                    this.$store.commit('auth/loginSuccess', user);

                    const csrfToken = data._csrf_token;
                    this.$store.commit('auth/setCsrfToken', csrfToken);

                    this.$router.push('/');
                })
                .catch(error => {
                    console.error('There was a problem with the fetch operation:', error);
                });
        }
    }
}
</script>
