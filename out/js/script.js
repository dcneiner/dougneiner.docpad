(function() {

  (function() {
    var className, comment_container, comments_enabled, dsqLoad, index;
    className = document.body.className;
    index = /^page-(coding|learning)-index/.test(className);
    comments_enabled = !index && /^page-(coding|learning)/.test(className);
    window.disqus_developer = 0;
    window.disqus_shortname = 'dougneiner';
    if (!index) {
      comment_container = document.getElementById("disqus_thread");
      if (!comment_container) return;
      dsqLoad = function() {
        var dsq;
        dsq = document.createElement('script');
        dsq.type = 'text/javascript';
        dsq.async = true;
        dsq.src = "http://" + window.disqus_shortname + ".disqus.com/embed.js";
        return (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
      };
      return dsqLoad();
    }
  })();

}).call(this);
