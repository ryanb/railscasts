jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

$(document).ready(function() {
  $("#comments .spam_report").removeAttr("onclick").click(function () {
    $.post(this.href, null, null, "script");
    return false;
  });
  $("#comments .destroy").removeAttr("onclick").click(function () {
    if (confirm("Are you sure you want to destroy this comment?")) {
      $.post(this.href, "_method=delete", null, "script");
    }
    return false;
  });
})
