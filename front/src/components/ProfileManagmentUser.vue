<template>
    <div class="w-full sm:w-96 h-5/6 sm:h-fit bg-white rounded-t-lg sm:rounded-t-none sm:rounded-b-lg flex flex-col items-center px-3 sm:py-3 sm:border-t sm:border-gray-300">
        <div class="w-64 h-64 rounded-full bg-gray-400 mt-10 flex items-center justify-center sm:hidden">
            <img src="@/assets/icons/user.svg" class="w-36 h-36 icon-white">
        </div>
        <div class="flex flex-row justify-center items-center mt-4 sm:hidden" @click="edit">
            <input
                v-if="isEditing"
                ref="usernameInput"
                class="appearance-none text-center rounded text-3xl w-full"
                type="text"
                v-model="updatedUser.username"
                @blur="isEditing = false">
            <div v-else class="flex flex-row items-center">
                <p class="text-3xl mr-2">{{ updatedUser.username }}</p>
                <img src="@/assets/icons/edit.svg" class="w-5 h-5">
            </div>
        </div>
        <div class="hidden sm:grid grid-cols-3 gap-y-1 items-center">
            <p class="text-sm col-span-1 text-left">New username: </p>
            <input
                class="border border-gray-500 text-left rounded text-xl w-full col-span-2"
                type="text"
                v-model="updatedUser.username">
        </div>
        <div class="mt-4 sm:mt-2 grid grid-cols-3 gap-y-1">
            <p class="text-lg col-span-1 text-left">New email: </p>
            <input
                class="border border-gray-500 text-left rounded text-xl w-full col-span-2"
                type="text"
                v-model="updatedUser.email">
        </div>
        <div class="mt-2 grid grid-cols-3 gap-y-1 items-center">
            <p class="text-sm col-span-1 text-left">New password: </p>
            <input
                class="border border-gray-500 rounded text-xl w-full col-span-2 text-left"
                type="password"
                v-model="updatedUser.password">
        </div>
        <button class="rounded-lg bg-rose-300 hover:bg-rose-400 active:bg-rose-400 w-full p-3 mt-4" @click="disconnect">Disconnect</button>
        <div class="w-full flex flex-row">
            <button class="rounded-lg bg-gray-300 hover:bg-gray-400 active:bg-gray-400 w-full p-3 mt-2 mr-2" @click="cancel">Cancel</button>
            <button class="rounded-lg bg-green-300 hover:bg-green-400 active:bg-green-400 w-full p-3 mt-2 ml-2" @click="updateUser">Save</button>
        </div>
    </div>
</template>

<script>
    export default {
        name: "ProfileManagmentUser",
        data() {
            return {
                updatedUser: {
                    username: this.$store.getters['auth/user'].username,
                    email: this.$store.getters['auth/user'].email,
                    password: ''},
                isEditing: false
            };
        },
        methods: {
            edit() {
                this.isEditing = true;
                this.$nextTick(() => this.$refs.usernameInput.focus());
            },
            cancel() {
                this.$emit('cancel');
            },
            async updateUser() {
                const updatedUser = { "user": this.updatedUser };
                try {
                    const response = await fetch("http://localhost:4000/api/users/" + this.user.id, {
                        method: "PUT",
                        headers: {
                            'Accept': 'application/json',
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer ' + localStorage.getItem('token')
                        },
                        body: JSON.stringify(updatedUser)
                    });
                    const updated = await response.json();
                    this.$store.commit('auth/loginSuccess', updated.data);
                }
                catch (error) {
                    console.log("error :", error)
                }
            },
            async deleteUser() {
                try {
                    const response = await fetch("http://localhost:4000/api/users/" + this.user.id, {
                        method: "DELETE",
                        headers: {
                            'Autorization': 'Bearer ' + localStorage.getItem('token'),
                        }
                    });
                    const deleted = await response.json();
                    this.disconnect();
                }
                catch (error) {
                    console.log("error", error);
                }
            },
            disconnect() {
                this.$store.commit('auth/logout');
                this.$router.push('/login');
            }
        },
        computed: {
            user() {
                return this.$store.getters['auth/user'];
            }
        },
    }
</script>

<style>
.icon-white{
    filter: brightness(0) saturate(100%) invert(99%) sepia(2%) saturate(452%) hue-rotate(91deg) brightness(113%) contrast(100%);
}
</style>
