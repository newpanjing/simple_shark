getProcessHtml(String htmlStr) {
  var regex = "src\\s*=\\s*\"?(.*?)(\"|>|\\s+)";
  var exp = RegExp(regex);
  Iterable<Match> tags = exp.allMatches(htmlStr);
  for (Match m in tags) {
    var str = m.group(0);
    var oldPic = m.group(1);
    var pic = m.group(1);
    if (pic?.indexOf("http") != 0) {
      if (pic?.indexOf("/") != 0) {
        pic = "/$pic";
      }
      pic = "https://simpleui.72wo.com$pic";
    }
    var newStr = str?.replaceAll(oldPic!, pic!);
    htmlStr = htmlStr.replaceAll(str!, newStr!);
  }
  return htmlStr;
}
