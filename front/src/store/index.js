import { createApp, toRaw } from "vue";
import {createStore} from "vuex";
import App from "@/App.vue";
import moment, {min} from "moment/moment";
import { auth } from "./auth.module";
import network from '../tools/NetworkManager';
const store = createStore(
    {
        modules: {
            auth,
        },
        state(){
            return{
                limit: 60,
                nightHours: 0,
                left: 0,
                chartNightHours: {
                    labels: ["Accomplished", "Left"],
                    datasets: []
                },
                workingTimesData: null,
                chartData: {
                    labels: [],
                    datasets: []
                },
                chartOvertimeData: {
                    labels: [],
                    datasets: []
                },
                hoursWorkedWeek: 0,
                hoursOfRTT: 0,
                workingTimesCurrentMonth: [],
                passedNightHours: 0,
                plannedNightHours: 0,
                workingTimesByUser: [],
                maxHour: 0,
                minHour: 24,
                management: {
                    teamSelected: "",
                    normHoursPerDay: 7,
                    teams: [
                        {
                            id: 1,
                            members: ['user1', 'user2', 'user3', 'toto', 'super', 'admin', 'user7', 'test'],
                        },
                        {
                            id: 2,
                            members: ['user4', 'user5', 'user6', 'test1', 'johndoe'],
                        },
                        {
                            id: 3,
                            members: ['user7', 'user8', 'user9'],
                        }
                    ]
                },
            }
        },
        getters: {
          getCount (state) {
              return state.count
          },
          getWorkingTimes(state){
              return state.workingTimesData
          },
            getRTTHours(state){
              return state.hoursOfRTT
            },
            getNightHoursMonth(state){
              return state.nightHours
            },
            getChartData(state){
              return state.chartData
            },
            getChartOvertimeData(state){
              return state.chartOvertimeData
            },
            getChartNightHours(state){
              console.log(state.limit, state.nightHours)
              return state.chartNightHours
            },
            getLimitHours(state){
              return state.limit
            },
            getHoursWorkedWeek(state){
              return Math.floor(state.hoursWorkedWeek)
            },
            getPassedNightHours(state){
              return state.passedNightHours
            },
            getPlannedNightHours(state){
              return state.plannedNightHours
            },
            getWorkingTimesByUser(state){
              return state.workingTimesByUser
            },
            getMaxHour(state){
                console.log(state.maxHour)
              return state.maxHour
            },
            getMinHour(state){
              console.log(state.minHour)
              return state.minHour
            },
            getTeamSelectedManager (state){
              return state.management.teamSelected
            },
            getNormHoursPerDay (state){
              return state.management.normHoursPerDay
            },
            getTeamsManager (state){
              return state.management.teams
            }
        },
        mutations: {
            //Workingtimes
            setWorkingTimesPerDay(state) {
                const totalHoursByDay = {};

                state.workingTimesData.forEach(record => {
                    const startDate = new Date(record.start);
                    const endDate = new Date(record.end);

                    const year = startDate.getFullYear();
                    const month = startDate.getMonth() + 1;
                    const day = startDate.getDate();

                    const dayKey = `${year}-${month}-${day}`;

                    if (!totalHoursByDay[dayKey]) {
                        totalHoursByDay[dayKey] = 0;
                    }

                    const durationInMillis = endDate - startDate;
                    const durationInHours = durationInMillis / 3600000; // Convertir en heures

                    totalHoursByDay[dayKey] += durationInHours;
                });

                const chartDataByDay = {
                    labels: [],
                    datasets: [{ data: [] }]
                };

                Object.keys(totalHoursByDay).forEach(dayKey => {
                    const [year, month, day] = dayKey.split('-');
                    chartDataByDay.labels.push(`${year}-${month}-${day}`);
                    chartDataByDay.datasets[0].data.push(Math.abs(totalHoursByDay[dayKey]));
                    chartDataByDay.datasets[0].label = "Number worked hours per day";
                });

                state.chartData = chartDataByDay
            },
            setWorkingTimesPerYear(state) {
                const totalHoursByYear = {};

                store.state.workingTimesData.forEach(record => {
                    const startDate = new Date(record.start);
                    const endDate = new Date(record.end);

                    const year = startDate.getFullYear();

                    if (!totalHoursByYear[year]) {
                        totalHoursByYear[year] = 0;
                    }

                    const durationInMillis = endDate - startDate;
                    const durationInHours = durationInMillis / 3600000;

                    totalHoursByYear[year] += durationInHours;
                });

                const chartDataByYear = {
                    labels: [],
                    datasets: [{ data: [] }]
                };

                Object.keys(totalHoursByYear).forEach(year => {
                    chartDataByYear.labels.push(year);
                    chartDataByYear.datasets[0].data.push(Math.abs(totalHoursByYear[year]));
                    chartDataByYear.datasets[0].label = "Number of worked hours by year";
                });

                state.chartData = chartDataByYear
            },
            setWorkingTimesPerMonth(state) {
                const totalHoursByMonth = {};
                state.workingTimesCurrentMonth = [];

                state.workingTimesData.forEach(record => {
                    const startDate = new Date(record.start);
                    const endDate = new Date(record.end);
                    const monthDate = startDate.getMonth();
                    const durationInMillis = endDate - startDate;
                    const durationInHours = durationInMillis / 3600000; // Convertir en heures

                    const monthYearKey = `${startDate.getMonth() + 1}-${startDate.getFullYear()}`;

                    if (!totalHoursByMonth[monthYearKey]) {
                        totalHoursByMonth[monthYearKey] = 0;
                    }
                    const nowTimestamp = Date.now();
                    const nowDate = new Date(nowTimestamp);
                    const currentMonth = nowDate.getMonth();
                    const startHour = startDate.getHours();

                    if(monthDate === currentMonth){
                        if (startHour >= 19 || startHour < 6) {
                            state.workingTimesCurrentMonth.push(record)
                        }
                    }

                    totalHoursByMonth[monthYearKey] += durationInHours;

                });
                const chartData = {
                    labels: [],
                    datasets: [{ data: [] }]
                };

                Object.keys(totalHoursByMonth).forEach(monthYearKey => {
                    const [month, year] = monthYearKey.split('-');
                    const monthNames = [
                        'Jan', 'Feb', 'Mar', 'Ap', 'May', 'June',
                        'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'
                    ];
                    chartData.labels.push(`${monthNames[parseInt(month) - 1]} ${year}`);
                    chartData.datasets[0].data.push(Math.abs(totalHoursByMonth[monthYearKey]));
                    chartData.datasets[0].label = "Number of worked hours per month";
                });
                state.chartData = chartData;
            },
            setWorkingTimesByUser(state, data) {
                const currentDate = new Date();
                //Pour formatter les dates sous forme de : JJ/MM/YYYY HH:mm:ss
                state.workingTimesByUser = data.map(workingtime => ({
                    start: new Date(workingtime.start),
                    end: new Date(workingtime.end),
                    title: `Working time ${workingtime.id}`,
                }));

                state.workingTimesByUser.forEach((record) => {
                    if (currentDate < record.start) {
                        record.class = "futur"
                    } else if (currentDate >= record.start && currentDate <= record.end) {
                        record.class = "current"
                    } else {
                        record.class = "passed"
                    }
                })
            },
            //Overtimes
            setOvertimeHoursPerMonth(state) {
                const hoursWorkedData = state.chartData.datasets[0].data;
                const labels = state.chartData.labels;
                let numberOfDaysPerMonth = [];

                //Return le nombre de jours dans le mois
                labels.map((lab) => {
                    numberOfDaysPerMonth.push(moment(lab, "MMMM YYYY").daysInMonth());
                })
                const overtimeHours = hoursWorkedData.map((hours, index) => {
                    const normalHoursInMonth = numberOfDaysPerMonth[index] * state.management.normHoursPerDay;
                    const overtime = hours - normalHoursInMonth;

                    return overtime < 0 ? 0 : overtime; // Les heures supplémentaires ne sont pas négatives
                });

                // Formater les données pour chartData
                state.chartOvertimeData = {
                    labels: labels,
                    datasets: [{ data: overtimeHours, label: "Number of overtime hours per month" }]
                };
            },
            setOvertimeHoursPerYear(state) {
                const hoursWorkedData = state.chartData.datasets[0].data;
                const labels = state.chartData.labels;
                let overtimeHoursPerYear = {};

                // Pour chaque mois, calculer les heures supplémentaires
                labels.forEach((month, index) => {
                    const year = month.split(" ")[1]; // Obtenir l'année du libellé du mois
                    const normalHoursInMonth = moment(month, "MMMM YYYY").daysInMonth() * state.management.normHoursPerDay;
                    if (!overtimeHoursPerYear[year]) {
                        overtimeHoursPerYear[year] = 0;
                    }

                    const overtime = hoursWorkedData[index] - normalHoursInMonth;
                    overtimeHoursPerYear[year] += overtime < 0 ? 0 : overtime; // Les heures supplémentaires ne sont pas négatives
                });

                const dateNow = Date.now();
                const nowDate = new Date(dateNow);
                const currentYear = nowDate.getFullYear();
                state.hoursOfRTT = Math.floor(overtimeHoursPerYear[`${currentYear}`])
                console.log("ici", overtimeHoursPerYear['2023']);
                state.chartOvertimeData = {
                    labels: Object.keys(overtimeHoursPerYear),
                    datasets: [{
                        data: Object.values(overtimeHoursPerYear),
                        label: "Number of overtime hours by year"
                    }]
                };
            },
            setChartNightHours(state) {
                state.left = state.limit - state.nightHours
                state.chartNightHours = {
                    labels: ["Accomplished", "Left"],
                    datasets: [
                        {
                            backgroundColor: ['#41B883', '#E46651'],
                            data: [state.nightHours, state.left]
                        }
                    ]
                }
            },
            setLimit(state, limit){
                state.limit = limit
            },
            setPassedNightHours(state) {
                let plannedNightHours = 0;
                let passedNightHours = 0;

                state.plannedNightHours = 0;
                state.passedNightHours = 0;
                console.log("avant init", state.plannedNightHours, state.passedNightHours,state.workingTimesCurrentMonth)
                state.workingTimesCurrentMonth.forEach((time) => {
                    // ... votre code pour obtenir startDateTime, endDateTime et duration
                    const startDateTime = new Date(time.start);
                    const endDateTime = new Date(time.end);

                    const currentDate = new Date();
                    const duration = (endDateTime.getTime() - startDateTime.getTime())  / 3600000;
                    if (currentDate < startDateTime) {
                        if (duration > 1) {
                            plannedNightHours += Math.floor(duration);
                        }
                    } else {
                        if (duration > 1) {
                            passedNightHours += Math.floor(duration);
                            state.nightHours = Math.floor(duration);
                        }
                    }
                });

                // Mettez à jour les propriétés state seulement une fois après avoir calculé les heures de nuit
                state.plannedNightHours = plannedNightHours;
                state.passedNightHours = passedNightHours;
                console.log("après init", state.plannedNightHours, state.passedNightHours,state.workingTimesCurrentMonth)
            },

            setData(state, workingTimes){
                state.workingTimesData = workingTimes
            },
            setHoursWorkedWeek(state){
                const today = new Date();
                const startOfWeek = new Date(
                    today.getFullYear(),
                    today.getMonth(),
                    today.getDate() - today.getDay()
                );
                const endOfWeek = new Date(startOfWeek);
                endOfWeek.setDate(endOfWeek.getDate() + 7);

                state.hoursWorkedWeek = state.workingTimesData
                    .filter((worktime) => {
                        const startWork = new Date(worktime.start);
                        if (today < new Date(worktime.start)) {
                            console.log('future')
                        } else if (today >= new Date(worktime.start) && today <= new Date(worktime.end)) {
                            console.log("L'événement est en cours.");
                        } else {
                            console.log('passé')
                            return startWork >= startOfWeek && startWork < endOfWeek;
                        }

                    })
                    .reduce((total, worktime) => {
                        const startWork = new Date(worktime.start);
                        const endWork = new Date(worktime.end);
                        const workingTime = (endWork - startWork) / (1000 * 60 * 60); // Convertir la différence en heures
                        // Update minHours if the current working hours is smaller
                        if (new Date(worktime.start).getHours() < state.minHour) {
                            state.minHour = new Date(worktime.start).getHours();
                            console.log('min',state.minHour)
                        }

                        // Update maxHours if the current working hours is larger
                        if (new Date(worktime.end).getHours() > state.maxHour) {
                            state.maxHour = new Date(worktime.end).getHours();
                            console.log('max',state.maxHour)
                        }
                        return total + workingTime;
                    }, 0);
            },

            //Manager
            setTeamSelected(state, select){
                state.management.teamSelected = select
            },
            setNormHoursPerDay(state, hour){
                state.management.normHoursPerDay = hour
            },
            setTeamMembers (state, teams){
                state.management.teams = teams
            }
        },
        actions: {
            async getData(context) {
                try {
                    const userId = context.rootState.auth.user.id;
                    const response = await network.get(`/api/workingtimes/${userId}`);
                    const workingTimesData = await response.json();
                    console.log("request : ",workingTimesData)
                    context.commit('setData', workingTimesData.data);
                    context.commit('setWorkingTimesPerMonth');
                    context.commit('setOvertimeHoursPerMonth');
                    //context.commit('setNightHours');
                    context.commit('setHoursWorkedWeek');
                    context.commit('setPassedNightHours');
                    context.commit('setOvertimeHoursPerYear');
                    context.commit('setWorkingTimesByUser', workingTimesData.data);
                    context.commit('setChartNightHours')
                } catch (error) {
                    console.error(error);
                }
            },
            async managerData(context){
                try {
                    // const userId = context.rootState.auth.user.id;
                    const response = await network.get(`/api/teams/`);
                    const data = await response.json();
                    console.log("req", data);
                }
                catch (e) {
                    console.log(e);
                }
            }
        }
    }
);

export default store;
