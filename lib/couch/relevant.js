function (doc) {
  var re = /\bftpd\b|\bWindows\b/i;
  if (re.test(doc.summary)) {
    emit(doc.id, doc.summary)
  }
  
}