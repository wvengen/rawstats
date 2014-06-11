// Monkey-patching Javascript for using JAwstats

// we want to prefix the urls
var oldXMLURL = XMLURL;
XMLURL = function(sPage, part) {
  return sAppPath + oldXMLURL(sPage, part);
}
