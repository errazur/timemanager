import Dashboard from "@/components/Dashboard.vue";
import { createRouter, createWebHistory } from "vue-router";

import AuthentificationUser from "../components/AuthentificationUser.vue";
import ChartManager from "../components/ChartManager.vue";
import Clock from "../components/Clock.vue";
import WorkingTime from "../components/WorkingTime.vue";
import WorkingTimes from "../components/WorkingTimes.vue";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: "/", name: "home", component: Dashboard, props: true },
    {
      path: "/login",
      name: "login",
      component: AuthentificationUser,
    },
    {
      path: "/workingTimes/:userId",
      name: "workingTimes",
      component: WorkingTimes,
      props: true,
    },
    {
      path: "/workingTime/:userId/:workingTimeId",
      name: "workingTime",
      component: WorkingTime,
      props: true,
    },
    {
      path: "/clock/:username",
      name: "clock",
      component: Clock,
    },
    {
      path: "/chartManager/:userId",
      name: "chartManager",
      component: ChartManager,
      props: true,
    },
  ],
});

router.beforeEach((to, from, next) => {
  const publicPages = ["/login"];
  const authRequired = !publicPages.includes(to.path);
  const loggedIn = localStorage.getItem("token");

  if (authRequired && !loggedIn) {
    return next("/login");
  } else {
    next();
  }
});

export default router;
