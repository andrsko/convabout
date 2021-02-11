import { createSlice, createAsyncThunk } from "@reduxjs/toolkit";
import { apiClient } from "../../api";

const initialState = {
  token: "",
  username: "",
  signUpStatus: "idle",
  signUpError: "",
  signInStatus: "idle",
  signInError: "",
  changePasswordStatus: "idle",
  changePasswordError: "",
};

export const signUp = createAsyncThunk("auth/signUp", async (user) => {
  const response = await apiClient.post("/sign_up", undefined, {
    user: user,
  });
  return response.data;
});

export const signIn = createAsyncThunk("auth/signIn", async (session) => {
  const response = await apiClient.post("/sign_in", undefined, {
    session: session,
  });
  return response.data;
});

export const changePassword = createAsyncThunk(
  "auth/changePassword",
  async (data) => {
    const response = await apiClient.post("/set_password", data.token, {
      password: data.password,
    });
    return response;
  }
);

const authSlice = createSlice({
  name: "auth",
  initialState,
  reducers: {
    signOut(state) {
      state.token = "";
      state.username = "";
    },
    resumeSignUp(state) {
      state.signUpStatus = "idle";
      state.signUpError = "";
    },
    resumeSignIn(state) {
      state.signInStatus = "idle";
      state.signInError = "";
    },
    resumeChangePassword(state) {
      state.changePasswordStatus = "idle";
      state.changePasswordError = "";
    },
  },
  extraReducers: {
    [signUp.pending]: (state, action) => {
      state.signUpStatus = "loading";
      state.signUperror = "";
    },
    [signUp.fulfilled]: (state, action) => {
      state.signUpStatus = "succeeded";
      state.token = action.payload.token;
      state.username = action.payload.username;
    },
    [signUp.rejected]: (state, action) => {
      state.signUpStatus = "failed";
      state.signUpError = action.payload;
    },

    [signIn.pending]: (state, action) => {
      state.signInStatus = "loading";
      state.signUperror = "";
    },
    [signIn.fulfilled]: (state, action) => {
      state.signInStatus = "succeeded";
      state.token = action.payload.token;
      state.username = action.payload.username;
    },
    [signIn.rejected]: (state, action) => {
      state.signInStatus = "failed";
      state.signInError = action.payload;
    },

    [changePassword.pending]: (state) => {
      state.changePasswordStatus = "loading";
      state.changePasswordError = "";
    },
    [changePassword.fulfilled]: (state) => {
      state.changePasswordStatus = "succeeded";
    },
    [changePassword.rejected]: (state, action) => {
      state.changePasswordStatus = "failed";
      state.changePasswordError = action.payload;
    },
  },
});

export const {
  signOut,
  resumeSignUp,
  resumeSignIn,
  resumeChangePassword,
} = authSlice.actions;

export default authSlice.reducer;
