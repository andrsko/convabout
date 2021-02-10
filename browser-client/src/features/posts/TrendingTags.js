import React, { useEffect } from "react";
import { useSelector, useDispatch } from "react-redux";

import { fetchTrendingTags } from "./postsSlice";

import { Tag } from "./Tag";

import styles from "./TrendingTags.module.css";

export const TrendingTags = () => {
  const dispatch = useDispatch();
  const trendingTags = useSelector((state) => state.posts.trendingTags);

  const trendingTagsStatus = useSelector(
    (state) => state.posts.trendingTagsStatus
  );

  useEffect(() => {
    if (trendingTagsStatus === "idle") {
      dispatch(fetchTrendingTags());
    }
  }, [trendingTagsStatus, dispatch]);

  let content;

  if (trendingTagsStatus === "succeeded")
    content = trendingTags.map((tag) => (
      <Tag key={tag.id} tag={tag} type="trending" />
    ));

  return <div className={styles.trendingTags}>{content}</div>;
};
