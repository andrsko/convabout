import { createSlice, createAsyncThunk } from "@reduxjs/toolkit";
import { apiClient } from "../../api";

const initialState = {
  posts: [],
  postsStatus: "idle",
  postsError: null,
  post: {},
  postStatus: "idle",
  postError: null,
  trendingTags: [],
  trendingTagsStatus: "idle",
  trendingTagsError: null,
  activeTag: null,
};

export const fetchPosts = createAsyncThunk(
  "posts/fetchPosts",
  async (tag = null) => {
    let response;
    if (!tag) response = await apiClient.get("/posts");
    else if (tag.id) response = await apiClient.get("/posts_of_tag/" + tag.id);
    else response = await apiClient.get("/posts_of_tag_name/" + tag.name);
    return response.data;
  }
);

export const fetchPost = createAsyncThunk("posts/fetchPost", async (id) => {
  const response = await apiClient.get("/posts/" + id);
  return response.data;
});

export const addNewPost = createAsyncThunk("posts/addNewPost", async (data) => {
  const response = await apiClient.post("/posts", data.token, {
    post: data.post,
  });
  return response.post;
});

export const fetchTrendingTags = createAsyncThunk(
  "posts/fetchTrendingTags",
  async () => {
    const response = await apiClient.get("/trending_tags");
    return response.data;
  }
);

const postsSlice = createSlice({
  name: "posts",
  initialState,
  reducers: {
    activateTag(state, action) {
      state.activeTag = action.payload;
    },
    deactivateTag(state) {
      state.activeTag = null;
    },
  },
  extraReducers: {
    [fetchPosts.pending]: (state, action) => {
      state.postsStatus = "loading";
    },
    [fetchPosts.fulfilled]: (state, action) => {
      state.postsStatus = "succeeded";
      state.posts = action.payload;
    },
    [fetchPosts.rejected]: (state, action) => {
      state.postsStatus = "failed";
      state.postsError = action.payload;
    },

    [fetchPost.pending]: (state, action) => {
      state.postStatus = "loading";
    },
    [fetchPost.fulfilled]: (state, action) => {
      state.postStatus = "succeeded";
      state.post = action.payload;
    },
    [fetchPost.rejected]: (state, action) => {
      state.postStatus = "failed";
      state.postError = action.payload;
    },

    [fetchTrendingTags.pending]: (state, action) => {
      state.trendingTagsStatus = "loading";
    },
    [fetchTrendingTags.fulfilled]: (state, action) => {
      state.trendingTagsStatus = "succeeded";
      state.trendingTags = action.payload;
    },
    [fetchTrendingTags.rejected]: (state, action) => {
      state.trendingTagsStatus = "failed";
      state.trendingTagsError = action.payload;
    },
  },
});

export const { activateTag, deactivateTag } = postsSlice.actions;

export default postsSlice.reducer;
