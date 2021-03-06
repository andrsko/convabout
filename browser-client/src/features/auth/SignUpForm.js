import React, { useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { useHistory } from "react-router-dom";
import { unwrapResult } from "@reduxjs/toolkit";

import { signUp } from "./authSlice";
import { usernameMaxLength } from "../auth/inputConstraints";

import styles from "./AuthForm.module.css";

export const SignUpForm = () => {
  const [username, setUsername] = useState("");
  const onUsernameChanged = (e) => setUsername(e.target.value);

  const [password, setPassword] = useState("");
  const onPasswordChanged = (e) => setPassword(e.target.value);

  const dispatch = useDispatch();
  let history = useHistory();

  const requestStatus = useSelector((state) => state.auth.signUpStatus);
  const error = useSelector((state) => state.auth.signUpError);

  const canSave = username && password && requestStatus !== "loading";
  const onSignUpClick = async () => {
    if (canSave) {
      try {
        const signUpResultAction = await dispatch(
          signUp({ username, password })
        );
        unwrapResult(signUpResultAction);
        history.push("/");
      } catch (err) {
        console.error("Failed to sign up: ", err);
      }
    }
  };

  const requestStatusMessageOptions = {
    pending: "Loading...",
    error: error,
  };
  const requestStatusMessage = (
    <p>{requestStatusMessageOptions[requestStatus]}</p>
  );

  return (
    <section className={styles.formWrapper}>
      <div className={styles.form}>
        <h2>Sign up</h2>
        <form>
          <label htmlFor="username" className={styles.label}>
            Username:
          </label>
          <br />
          <input
            type="text"
            id="username"
            name="username"
            maxLength={usernameMaxLength}
            value={username}
            onChange={onUsernameChanged}
          />
          <br />
          <br />
          <label htmlFor="password" className={styles.label}>
            Password:
          </label>
          <br />
          <input
            type="password"
            id="password"
            name="password"
            value={password}
            onChange={onPasswordChanged}
          />
          <br />
          <button
            type="button"
            onClick={onSignUpClick}
            className={styles.button}
          >
            Sign Up
          </button>
        </form>
        {requestStatusMessage}
      </div>
    </section>
  );
};
