$(function() {
  $(".jcarousel").jcarousel({
    wrap: 'circular'
  })
  .jcarouselAutoscroll({
    interval: 3000,
    target: '+=1',
    autostart: true
  });

  $(".jcarousel-pagination")
  .on('jcarouselpagination:active', 'a', function() {
    $(this).addClass('active');
  })
  .on('jcarouselpagination:inactive', 'a', function() {
    $(this).removeClass('active');
  })
  .jcarouselPagination({
    item: function(page) {
      return '<a href="#' + page + '">&nbsp;</a>';
    }
  });

  function replace_font_css(newfile) {
    var target_element = 'link';
    var target_attr = 'href';
    var all_suspects = document.getElementsByTagName(target_element);
    for (var i = all_suspects.length - 1; i >= 0; i --) {
      if (all_suspects[i] && all_suspects[i].getAttribute(target_attr) != null &&
          all_suspects[i].getAttribute(target_attr).indexOf("font") >= 0) {
        var newelem = document.createElement("link");
        newelem.setAttribute('rel', 'stylesheet');
        newelem.setAttribute('type', 'text/css');
        newelem.setAttribute('href', newfile);
        all_suspects[i].parentNode.replaceChild(newelem, all_suspects[i]);
        return;
      }
    }
  }

  function i18n(lang) {
    //load font css
    if (lang === 'en') {
      replace_font_css("css/font_ko.css");
    } else {
      replace_font_css("css/font_"+lang+".css");
    }

    var msg_ids = [
  "msg_drive",
  "msg_help",
  "msg_current_lang",
  "msg_download",
  "msg_howitworks",
  "msg_pickup",
  "msg_crossingborder",
  "msg_dropoff",
  "msg_pickup_detail",
  "msg_crossingborder_detail",
  "msg_dropoff_detail",
  "msg_carousel_title_1",
  "msg_carousel_title_2",
  "msg_carousel_title_3",
  "msg_carousel_detail_1",
  "msg_carousel_detail_2",
  "msg_carousel_detail_3",
  "msg_howitworks_detail",
  "msg_fare_warning",
  "msg_fare_table"]

    $.get("/js/messages_" + lang + ".json", function(obj) {
      for (var i = 0; i < msg_ids.length; i++) {
        var msg_id = msg_ids[i];
        console.log("msg[" + msg_id + "] = " + obj[msg_id]);
        if (msg_id == "msg_download") {
          $("." + msg_id).html(obj[msg_id]);
        } else {
          $("#" + msg_id).html(obj[msg_id]);
        }
      }
    }).fail(function (err) {
      alert("error");
    });
  }

  $(".i18n").click(function () {
    var lang = $(this).attr("href").substring(1);
    i18n(lang);
  });

  var userLang = navigator.language || navigator.userLanguage;
  i18n(simplify(userLang));

  function simplify(langcode) {
    regex_arr = [/en/, /ko/, /zh[-_]Hans/, /zh[-_]Hant/];
    for (var i = 0; i < regex_arr.length; i++) {
      var regex = regex_arr[i];
      var match = langcode.match(regex);
      if (match) {
        var m = match[0];
        return m.replace("-","_");
      }
    }

    return "en";
  }

  $(".fare-button").click(function() {
    var url = $(this).attr("href");
    window.open(url, "", "resizable=no, status=no, width=870, height=1500");
    return false;
  });

});

function detectcountry(data)
{
  var $iframe = $("<iframe></iframe");

  $iframe.attr("width", 960);
  $iframe.attr("height", 540);
  $iframe.attr("frameborder", 0);
  $iframe.attr("allowfullscreen", true);


  if (data.address.country_code === 'CN' || data.address.country_code === 'HK') {
    //youku please
    $iframe.attr("src", "http://player.youku.com/embed/XMTI0OTA4NzQ5Mg==?autoPlay=1");
  } else {
    //replace to youtube
    $iframe.attr("src", "https://www.youtube.com/embed/TYrjMTTpSys?autoplay=1");
  }

  $(".loader-wrapper").hide();
  $("#drive").append($iframe);
}

