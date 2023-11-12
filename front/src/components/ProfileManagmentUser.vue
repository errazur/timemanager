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
                @input="saveButtonText"
                @blur="isEditing = false">
            <div v-else class="flex flex-row items-center">
                <p class="text-3xl mr-2">{{ updatedUser.username }}</p>
                <img src="@/assets/icons/edit.svg" class="w-5 h-5">
            </div>
        </div>
        <div class="hidden sm:grid grid-cols-3 gap-y-1 items-center">
            <p class="text-sm col-span-1 text-center">Username: </p>
            <input
                class="border border-gray-500 text-left rounded text-xl w-full col-span-2"
                type="text"
                @input="saveButtonText"
                v-model="updatedUser.username">
        </div>
        <div class="mt-4 sm:mt-2 grid grid-cols-3 gap-y-1">
            <p class="text-lg col-span-1 text-center">Email: </p>
            <input
                class="border border-gray-500 text-left rounded text-xl w-full col-span-2"
                type="text"
                @input="saveButtonText"
                v-model="updatedUser.email">
        </div>
        <div class="mt-3 sm:mt-5 grid grid-cols-3 gap-y-1 items-center">
            <p class="text-sm col-span-1 text-center">Old password: </p>
            <input
                class="border border-gray-500 rounded text-xl w-full col-span-2 text-left"
                type="password"
                @input="saveButtonText"
                v-model="updatedUser.oldPassword">
        </div>
        <div class="mt-1 grid grid-cols-3 gap-y-1 items-center">
            <p class="text-sm col-span-1 text-center">New password: </p>
            <input
                class="border border-gray-500 rounded text-xl w-full col-span-2 text-left"
                type="password"
                @input="saveButtonText"
                v-model="updatedUser.password">
        </div>
        <button class="rounded-lg bg-rose-300 hover:bg-rose-400 active:bg-rose-400 w-full p-3 mt-4" @click="disconnect">Disconnect</button>
        <div class="w-full flex flex-row">
            <button class="rounded-lg bg-gray-300 hover:bg-gray-400 active:bg-gray-400 w-full p-3 mt-2 mr-2" @click="cancel">Cancel</button>
            <button disabled ref="saveButton" class="rounded-lg bg-green-300 disabled:bg-green-200 disabled:text-gray-500 hover:bg-green-400 active:bg-green-400 w-full p-3 mt-2 ml-2" @click="updateUser">{{ buttonText }}</button>
        </div>
    </div>
</template>

<script>
import { jwtDecode } from 'jwt-decode';

    export default {
        name: "ProfileManagmentUser",
        data() {
            return {
                updatedUser: {
                    username: this.$store.getters['auth/user'].username,
                    email: this.$store.getters['auth/user'].email,
                    password: '',
                    oldPassword: ''
                },
                isEditing: false,
                buttonText: 'Save',
                usernameOrEmailChanged: false,
                passwordChanged: false  
            };
        },
        methods: {
            edit() {
                this.isEditing = true;
                this.$nextTick(() => this.$refs.usernameInput.focus());
            },
            cancel() {
                this.$emit('details');
            },
            saveButtonText() {
                this.usernameOrEmailChanged = this.updatedUser.username !== this.user.username || this.updatedUser.email !== this.user.email;
                this.passwordChanged = this.updatedUser.password !== '';

                if (this.usernameOrEmailChanged && this.passwordChanged) {
                    this.buttonText = 'Save All';
                    this.$refs.saveButton.disabled = false;
                } else if (this.usernameOrEmailChanged) {
                    this.buttonText = 'Save User Info';
                    this.$refs.saveButton.disabled = false;
                } else if (this.passwordChanged) {
                    this.buttonText = 'Save Password';
                    this.$refs.saveButton.disabled = false;
                } else {
                    this.buttonText = 'Save';
                    this.$refs.saveButton.disabled = true;
                }
            },
            updateUser() {
                if (this.usernameOrEmailChanged) {
                    this.updateUserInfo().then(() => {
                        if (this.passwordChanged) {
                            this.updatePassword();
                        }
                    });
                } else if (this.passwordChanged) {
                    this.updatePassword();
                }
            },
            async updateUserInfo() {
                const updatedUser = { "user": {
                        "username": this.updatedUser.username,
                        "email": this.updatedUser.email,
                    }};
                try {
                    const response = await this.$network.put("/api/users/" + this.user.id, updatedUser);
                    if (response.ok) {
                        const data = await response.json();
                        localStorage.setItem('token', data.bearer);

                        const user = jwtDecode(data.bearer).user;
                        this.$store.commit('auth/loginSuccess', user);

                        const csrfToken = data._csrf_token;
                        this.$store.commit('auth/setCsrfToken', csrfToken);

                        this.$emit('details');
                    }
                    else {
                        throw new Error(`Error: ${response.status}`);
                    }
                }
                catch (error) {
                    console.log("error :", error)
                }
            },
            async updatePassword() {
                const updatedUser = {
                    "new_password": this.updatedUser.password,
                    "password": this.updatedUser.oldPassword
                };
                try {
                    const response = await this.$network.put("/api/users/password/"  + this.user.id, updatedUser);
                    if (response.ok) {
                        const data = await response.json();
                        localStorage.setItem('token', data.bearer);

                        const user = jwtDecode(data.bearer).user;
                        this.$store.commit('auth/loginSuccess', user);

                        const csrfToken = data._csrf_token;
                        this.$store.commit('auth/setCsrfToken', csrfToken);

                        this.$emit('details');
                    }
                    else {
                        throw new Error(`Error: ${response.status}`);
                    }
                }
                catch (error) {
                    console.log("error :", error)
                }
            },
            async deleteUser() {
                try {
                    const response = await this.$network.delete("/api/users/" + this.user.id);
                    const deleted = await response.json();
                    this.$emit('details');
                    this.disconnect();
                }
                catch (error) {
                    console.log("error", error);
                }
            },
            disconnect() {
                this.$store.commit('auth/logout');
                this.$emit('details');
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
