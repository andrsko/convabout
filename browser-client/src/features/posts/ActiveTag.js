import React from "react";
import { useSelector, useDispatch } from "react-redux";
import { useHistory } from "react-router-dom";

import { deactivateTag, fetchPosts } from "./postsSlice";

import styles from "./ActiveTag.module.css";

import removeTag from "./removeTag.svg";

export const ActiveTag = () => {
  const history = useHistory();
  const dispatch = useDispatch();

  const activeTag = useSelector((state) => state.posts.activeTag);

  let content;

  if (activeTag)
    content = (
      <div className={styles.activeTag}>
        <p className={styles.tagName}>{activeTag.name}</p>
        <button
          className={styles.removeTag}
          onClick={(e) => {
            history.push("/");
            dispatch(deactivateTag());
            dispatch(fetchPosts());
          }}
        >
          <img
            className={styles.removeTagIcon}
            src={removeTag}
            alt="remove-tag"
          />
        </button>
        {/*draft <button className={styles.follow}>{"Follow"}</button>*/}
      </div>
    );

  return <div>{content}</div>;
};
