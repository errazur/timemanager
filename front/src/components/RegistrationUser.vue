<template>
    <form @submit.prevent="createUser">
        <div class="flex flex-col">
            <p>Username: <input class="border rounded" type="text" v-model="username"></p>
            <p>Email: <input class="border rounded" type="email" v-model="email"></p>
            <p>Password: <input class="border rounded" type="password" v-model="password"></p>
            <button type="submit" class="rounded bg-slate-200 hover:bg-slate-300 p-3 m-1">Register</button>
        </div>
    </form>
</template>

<script>
export default {
    data() {
        return {
            username: '',
            email: '',
            password: ''
        }
    },
    methods: {
        createUser() {
            const url = 'http://localhost:4000/api/users/'; // FIXME: Replace API URL
            const data = {
                username: this.username,
                email: this.email,
                //password: this.password //TODO: Chiiffrer le mot de passe
            };
            fetch(url, {
                method: 'POST',
                body: JSON.stringify(data),
                headers: {
                    'Content-Type': 'application/json'
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                console.log(data);
            })
            .catch(error => {
                console.error('There was a problem with the fetch operation:', error);
            });
        }
    }
}
</script>
