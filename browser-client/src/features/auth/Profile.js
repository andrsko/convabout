import React, { useState, useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import { unwrapResult } from "@reduxjs/toolkit";

import store from "../../app/store";

import { changePassword, resumeChangePassword } from "./authSlice";

import styles from "./Profile.module.css";

export const Profile = () => {
  const dispatch = useDispatch();

  useEffect(() => {
    dispatch(resumeChangePassword());
  }, [dispatch]);

  const token = store.getState().auth.token;

  const [password, setPassword] = useState("");
  const onPasswordChanged = (e) => setPassword(e.target.value);

  const username = useSelector((state) => state.auth.username);
  const requestStatus = useSelector((state) => state.auth.changePasswordStatus);
  const error = useSelector((state) => state.auth.changePasswordError);

  const canSave = password && requestStatus !== "loading";
  const onSaveClick = async () => {
    if (canSave) {
      try {
        const changePasswordResultAction = await dispatch(
          changePassword({ password, token })
        );
        unwrapResult(changePasswordResultAction);
      } catch (err) {
        console.error("Failed to change password: ", err);
      }
    }
  };

  const requestStatusMessageOptions = {
    idle: "",
    loading: "Saving...",
    succeeded: "Successfully saved",
    error: error,
  };

  const requestStatusMessage = (
    <p>{requestStatusMessageOptions[requestStatus]}</p>
  );

  return (
    <section className={styles.profileWrapper}>
      <h1 className={styles.header}>Profile</h1>
      <form className={styles.profile}>
        <p className={styles.username}> {username} </p>
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
          className={styles.input}
        />
        <br />
        <button type="button" onClick={onSaveClick} className={styles.button}>
          SAVE
        </button>
      </form>
      {requestStatusMessage}
    </section>
  );
};
