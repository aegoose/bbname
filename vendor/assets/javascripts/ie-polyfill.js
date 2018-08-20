if (!Array.prototype.indexOf) {
  Array.prototype.indexOf = function(item) {
    return _(this).indexOf(item)
  }
}

if (!String.prototype.trim) {
  String.prototype.trim = function() {
    return this.replace(/(^\s*)|(\s*$)/g, "");
  }
}

if (!document.head) {
  document.head = document.getElementsByTagName('head')[0]
}


