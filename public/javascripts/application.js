jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

$(document).ready(function() {
  // remove the inline javascript stuff
  $("#comments .spam_report").removeAttr("onclick").click(function () {
    $.post(this.href, null, null, "script");
    return false;
  });
})
