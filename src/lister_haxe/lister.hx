import haxe.io.Path;
using StringTools;

class Lister {
  static public function get(url:String):Array<String> {
    var http = new haxe.Http(url);
    var hits = [];

    http.onData = function(resp) {
      hits = Lister.findImgs(resp, url);
    }

    http.onError = function(err) {
      trace('ERROR: $err');

      throw err;
    };

    http.request();

    return hits;
  }

  static public function findImgs(html:String, url:String):Array<String> {
    var hits = [];
    var rgx = ~/<img[^>]+src=([^ >]+)/s;

    while (rgx.match(html)) {
      hits.push(clean(rgx.matched(1), url));
      html = rgx.matchedRight();
    }

    return hits;
  }

  static function clean(hit:String, url:String):String {
    hit = hit.replace('"', '').replace("'", "").trim();

    if (!hit.startsWith(url))
      hit = Path.join([url, hit]);

    return hit;
  }
}
