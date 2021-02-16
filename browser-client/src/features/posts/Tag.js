import React from "react";
import { useDispatch } from "react-redux";
import { Link } from "react-router-dom";

import { activateTag, fetchPosts } from "./postsSlice";

import styles from "./Tag.module.css";

export const Tag = (props) => {
  const dispatch = useDispatch();

  return (
    <Link to={`/tag/${props.tag.name}`}>
      <button
        className={
          styles.tag + (props.type === "trending" ? " " + styles.trending : "")
        }
        onClick={(e) => {
          dispatch(activateTag(props.tag));
          dispatch(fetchPosts(props.tag));
        }}
      >
        {props.tag.name}
      </button>
    </Link>
  );
};
