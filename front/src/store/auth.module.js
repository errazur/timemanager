import { jwtDecode } from "jwt-decode";

let user = null;
const token = localStorage.getItem("token");

if (token && typeof token === "string") {
  try {
    const decodedToken = jwtDecode(token);
    const expirationDate = new Date(decodedToken.exp * 1000);

    if (expirationDate < new Date()) {
      localStorage.removeItem("token");
    } else {
      user = decodedToken.user;
    }
  } catch (error) {
    console.log(error);
  }
}

const initialState = user
  ? { status: { loggedIn: true }, user }
  : { status: { loggedIn: false }, user: null };

export const auth = {
  namespaced: true,
  state: initialState,
  getters: {
    user(state) {
      return state.user;
    },
    loggedIn(state) {
      return state.status.loggedIn;
    },
  },
  mutations: {
    loginSuccess(state, user) {
      state.status.loggedIn = true;
      state.user = user;
    },
    loginFailure(state) {
      state.status.loggedIn = false;
      state.user = null;
    },
    logout(state) {
      state.status.loggedIn = false;
      state.user = null;
      localStorage.removeItem("token");
    },
  },
};
