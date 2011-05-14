$(function() {
  if ($("#episode").length > 0) {
    sublimevideo.ready(function() {
      if ($("#episode video").length > 0) {
        sublimevideo.prepareAndPlay($("#episode video")[0]);
        $("#episode video.sublimed").attr("poster", $("#episode video.sublimed").data("poster"));
      } else {
        $("#watch_button").click(function(e) {
          var video = $('<div id="video_wrapper"></div>').hide().html($("#video_template").html());
          $("#video_template").before(video);
          sublimevideo.prepareAndPlay($("#episode video")[0]);
          $("#episode video.sublimed").attr("poster", $("#episode video.sublimed").data("poster"));
          setTimeout(function() {
            $("#watch_button").hide();
            $("#video_wrapper").show();
          }, 200);
          e.preventDefault();
        });
      }
    });
    sublimevideo.load();

    $("#episode .nav a.tab").click(function(e) {
      $("#episode .nav li a").removeClass("selected");
      $(this).addClass("selected");
      $("#episode .nav_section").append('<div class="progress"><img src="/images/progress_large.gif" width="32" height="32" alt="" /></div>');
      $.getScript(this.href);
      if (history && history.replaceState) {
        history.replaceState(null, document.title, this.href);
      }
      e.preventDefault();
    });

    $(".markdown_link").live("click", function(e) {
      $(this).next(".markdown_examples").slideToggle();
    });

    $(".clippy").live({
      'clippycopy': function(e, data) {
        data.text = $(this).children(".clippy_code").text();
      },
      'clippyover': function() {
        $(this).children(".clippy_label").text("copy to clipboard");
      },
      'clippyout': function() {
        $(this).children(".clippy_label").text("");
      },
      'clippycopied': function() {
        $(this).children(".clippy_label").text("copied");
      }
    });
  }
});
