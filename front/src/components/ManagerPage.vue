<template>
  <div class="container mx-auto p-6 pb-[106px] sm:px-0">
    <div class="mb-5">
      <div class="flex gap-6 items-center mb-8 justify-between">
        <h1 class="text-3xl font-medium">Data for Team n° {{teamSelected}}</h1>
        <div>
          <button @click="togglePopup" class="rounded bg-green-400 p-2 mr-6">Add a member</button>
          <button @click="togglePopupTeam" class="rounded bg-green-300 p-2">Add a team</button>
        </div>
      </div>

      <div v-if="showPopupAddUser" class="fixed w-full h-full top-0 left-0  flex items-center justify-center bg-white/50 z-50">
        <div class="w-1/2 rounded shadow-md p-6 bg-white relative">
          <button @click="togglePopup" class="absolute right-3 top-3"><img src="@/assets/icons/close-circle.svg" alt=""></button>
          <h2 class="text-2xl mb-6">Add team members</h2>
          <select v-model="newMember" class="w-full h-10 mb-6">
            <option v-for="user in users.data" :value="user.id">{{user.username}}</option>
          </select>
          <button @click="addMember" class="rounded bg-green-300 p-2 w-full">Add user to team</button>
        </div>
      </div>
      <div v-if="showPopupAddTeam"  class="fixed w-full h-full top-0 left-0  flex items-center justify-center bg-white/50 z-50">
        <div class="w-1/2 rounded shadow-md p-6 bg-white relative">
          <button @click="togglePopupTeam" class="absolute right-3 top-3"><img src="@/assets/icons/close-circle.svg" alt=""></button>
          <h2 class="text-2xl mb-6">Add new team</h2>
          <input class="w-full h-10 mb-6 border" v-model="newTeamName">
          <button @click="createTeam" class="rounded bg-green-300 p-2 w-full">Add new team</button>
        </div>
      </div>
      <select class="h-10 border border-gray-300 w-full" v-model="teamSelected" @change="handleTeamSelect()">
        <option disabled selected value="">Please select one</option>
        <option v-for="team in teams" :value="team.id">{{team.name}}</option>
      </select>
    </div>
    <div>
      <div class="flex justify-between gap-6 mb-6">
        <div class="w-1/2 rounded shadow-md p-6 flex flex-col items-center justify-center" :class="clockIn ? 'bg-gradient-to-b from-green-200 from-20%': 'bg-gradient-to-b from-rose-200 from-20%'">
          <h2 class="text-2xl">Clock {{clockIn ? "out" : "in"}} for the team</h2>
          <p class="mb-6">{{clockIn ? "Your team is currently working": "Your team isn't working"}}</p>
          <p class="text-center mb-6 text-3xl font-medium">{{currentTime}}</p>
          <button class="bg-white text-3xl p-2 rounded-md shadow-md mb-20 sm:text-xl sm:shadow-lg" @click="createClockTeam">Clock {{clockIn ? "out" : "in"}}</button>
        </div>
        <div class="w-1/2 rounded shadow-md p-6 bg-white">
          <h2 class="text-2xl mb-6">List of team members</h2>
          <div class="max-h-[200px] overflow-auto">
            <div v-for="member in membersList" class="odd:bg-rose-50 py-2 pl-1">
              {{member.username}}
            </div>
          </div>
        </div>
      </div>
      <div class="flex justify-between gap-6 mb-6">
      </div>
      <div class="flex justify-between gap-6">
        <div class="w-1/2 form-add-worktime rounded shadow-md p-6">
          <h2 class="text-3xl mb-4 font-medium">Create a working time for the team</h2>
          <p class="mb-2">Start : <input class="ml-2 px-3 py-1 border rounded" type="datetime-local"></p>
          <p class="mb-2">End : <input class="ml-2 px-3 py-1 border rounded" type="datetime-local"></p>
          <button class="rounded bg-white p-2 mt-2 mb-8">Create a working time</button>
          <p>Norm hours per day : <input type="number" v-model="normHoursData"></p>
          <p>Limit of night hours per day : <input type="number" v-model="limitHoursData"></p>
        </div>
        <div class="w-1/2 bg-white rounded shadow-md p-6">
          <h2 class="text-3xl mb-4 font-medium">Create a working time for a member</h2>
          <select class="h-10 border border-gray-300 w-full mb-6" v-model="selectedUserWorkingtime">
            <option v-for="member in membersList" :value="member.id">{{member.username}}</option>
          </select>
          <p class="mb-2">Start : <input class="ml-2 px-3 py-1 border rounded" v-model="newWorkingTimeMember.start" type="datetime-local"></p>
          <p class="mb-2">End : <input class="ml-2 px-3 py-1 border rounded" v-model="newWorkingTimeMember.end" type="datetime-local"></p>
          <button class="rounded bg-rose-200 p-2 mt-2 mb-8" @click="getWorkingTimeByTeam(selectedUserWorkingtime)">Create a working time</button>
          <p>Norm hours per day : <input type="number" v-model="normHoursData"></p>
          <p>Limit of night hours per day : <input type="number" v-model="limitHoursData"></p>
        </div>
      </div>
      <div class="bg-white rounded shadow-md p-6 mt-6 mb-6">
        <vue-cal
            :time-from="8 * 60"
            :time-to="19 * 60"
            :time-step="30"
            hide-weekends
            :events="filteredData">
        </vue-cal>
      </div>
    </div>
  </div>
</template>

<script>
import store from "@/store";
import { mapGetters } from "vuex";
import VueCal from 'vue-cal'
import 'vue-cal/dist/vuecal.css'
import {toRaw} from "vue";
import RegistrationUser from "@/components/RegistrationUser.vue";
import network from "@/tools/NetworkManager";

export default {
  name: 'managerPage',
  data() {
    return {
      teamSelected: null,
      normHours: 0, // Initialiser à 0 par défaut, la valeur sera mise à jour dans mounted
      limitNightHours: 0,
      currentTime: new Date().toLocaleString(),
      startTime: new Date().toLocaleString(),
      clockIn: false,
      showPopupAddUser: false,
      showPopupAddTeam: false,
      dataTable: [
        {
          start: '2023-11-08 08:00:00',
          end: '2023-11-08 12:00:00',
          title: 'Working Time 1',
          team: 1
        },
        {
          start: '2023-11-07 14:00:00',
          end: '2023-11-07 18:00:00',
          title: 'Working Time 2',
          team: 2
        },
        {
          start: '2023-11-09 9:00:00',
          end: '2023-11-09 14:00:00',
          title: 'Working Time 3',
          team: 3
        }
      ],
      filteredData: [],
      membersList: [],
      selectedUserWorkingtime: null,
      teams: null,
      newWorkingTimeMember: {
        start: "",
        end: ""
      },
      newWorkingTimeTeam: {
        start: "",
        end: ""
      },
      users: {
        "data":
            [
                {"id":1,"username":"macron","email":"admin@macron-demission.org","teams":[]},
                {"id":2,"username":"test","email":"admin@macron-demission.org","teams":[]}
            ]
      },
      newMember: null,
      newTeamName: "",
    };
  },
  components: {
    VueCal,
    RegistrationUser,
  },
  computed: {
    ...mapGetters(['getNormHoursPerDay', 'getLimitHours', 'getTeamsManager']),
    normHoursData: {
      get() {
        return this.getNormHoursPerDay;
      },
      set(value) {
        console.log(value)
        store.commit('setNormHoursPerDay', parseInt(value, 10));
      }
    },
    limitHoursData: {
      get(){
        return this.getLimitHours;
      },
      set(value){
        store.commit('setLimit', value)
      }
    }
  },

  methods: {
    getNormHours() {
      return this.getNormHoursPerDay;
    },
    getLimitNightHours(){
      return this.getLimitHours
    },
    handleTeamSelect() {

      const selectedTeam = this.teams.find((team) => team.id === this.teamSelected);
      if (selectedTeam) {
        this.membersList = selectedTeam.users;
      }
      console.log(selectedTeam)
    },
    togglePopup() {
      this.showPopupAddUser = !this.showPopupAddUser;
    },
    togglePopupTeam() {
      this.showPopupAddTeam = !this.showPopupAddTeam;
    },
    async getTeams(){
      try {
        // const userId = context.rootState.auth.user.id;
        const response = await this.$network.get(`/api/teams/`);
        const data =  await response.json();
        this.teams = data.data
        console.log("req", this.teams);
      }
      catch (e) {
        console.log(e);
      }
    },
    async createTeam(){
      console.log(this.newTeamName)
      try{
        const body = {
          "team": {
            "name": toRaw(this.newTeamName)
          }
        };
        const response = await this.$network.post(`/api/teams/`, body)
      }
      catch (e) {
        console.log("error :", e)
      }
    },
    async getWorkingTimeByTeam(){
      try{
        const response  = await this.$network.get(`/api/workingtimes/teams/${this.teamSelected}`);
        const data =  await response.json();
        console.log(data)
        this.dataTable = data.data
      }
      catch(e){
        console.log(e)
      }
    },
    async addMember(){
      try {
        const response = await this.$network.post(`/api/users/${this.newMember}/teams/${this.teamSelected}/`);
        console.log(response)
        this.showPopupAddUser = false
      }
      catch(e){
        console.log(e)
      }
    },
    async getUsers(){
      try{
        const response = await this.$network.get('/api/users/');
        console.log("users : ", response.json())
      }
      catch(e){
        console.log(e)
      }
    },
    async createWorkingTimeUser(user_id){
      try {
        const body = {
          workingtime: {
            start: new Date(this.newWorkingTimeMember.start).toISOString(),
            end: new Date(this.newWorkingTimeMember.end).toISOString()
          }
        }
        const response = await this.$network.post(`/api/workingtimes/${user_id}`, body)
      }
      catch(e){
        console.log(e)
      }
    },
    async createWorkingTimeTeam(){
      try {
        const body = {
          workingtime: {
            start: new Date(this.newWorkingTimeTeam.start).toISOString(),
            end: new Date(this.newWorkingTimeTeam.end).toISOString()
          }
        }
        const response = await this.$network.post(`/api/workingtimes/teams/${this.teamSelected}`, body)
        console.log(response);
      }
      catch(e){
        console.log(e)
      }
    },
    async createClockTeam(){
      try {
        const body = {
          clock: {
            status: this.clockIn,
            time: new Date().toISOString()
          }
        }
        const response = await this.$network.post(`/api/clocks/teams/${this.teamSelected}`, body);
        console.log(response)

        this.clockIn != this.clockIn
      }
      catch(e){
        console.log(e)
      }
    }
  },
  mounted() {
    this.normHours = this.getNormHours();
    this.limitNightHours =  this.getLimitNightHours()
    store.commit('setTeamSelected', this.teamSelected);
    // this.createTeam();
    this.getTeams();
    this.getWorkingTimeByTeam();
    this.getUsers();
    // this.addUserToTeam()
    // console.log("teams : ",toRaw(this.teams).data.map((e) => console.log(e.id)))
    // this.teams = toRaw(this.teams).data
  }
}
</script>


<style>
select option {
  height: 2em;
}
.form-add-worktime{
  background: linear-gradient(248deg, rgba(206, 90, 103, 0.77) 0%, rgba(255, 202, 142, 0.66) 100%)
}
</style>
