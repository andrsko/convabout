import React from "react";
import { useDispatch } from "react-redux";
import { useHistory } from "react-router-dom";

import { activateTag, fetchPosts } from "./postsSlice";

import styles from "./Tag.module.css";

export const Tag = (props) => {
  const history = useHistory();
  const dispatch = useDispatch();

  return (
    <button
      className={
        styles.tag + (props.type === "trending" ? " " + styles.trending : "")
      }
      onClick={(e) => {
        // prevent redirecting to chat
        e.preventDefault();
        e.stopPropagation();
        e.nativeEvent.stopImmediatePropagation();

        history.push(`/tag/${props.tag.name}`);
        dispatch(activateTag(props.tag));
        dispatch(fetchPosts(props.tag));
      }}
    >
      {props.tag.name}
    </button>
  );
};
