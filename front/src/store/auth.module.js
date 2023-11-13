import { jwtDecode } from "jwt-decode";

let user = {
  id: 0,
  username: 'Not Connected',
};
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
  ? { status: { loggedIn: true }, user, csrfToken: null }
  : { status: { loggedIn: false }, user: { id: 0, username: 'Not Connected' }, csrfToken: null };

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
    csrfToken(state) {
      return state.csrfToken;
    },
    role(state){
      return state.role
    }
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
      state.csrfToken = null;
      localStorage.removeItem("token");
    },
    setCsrfToken(state, token) {
      state.csrfToken = token;
    },
    setRole(state,role){
      state.role = role
    }
  },
};
