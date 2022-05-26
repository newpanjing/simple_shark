 String getAvatar(String url) {
  if (!url.contains("http")) {
    return "https://simpleui.72wo.com/${url}";
  } else {
    return url;
  }
}
