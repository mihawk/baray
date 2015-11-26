-ifndef(BARAY_HRL).
-define(BARAY_HRL, true).

-record(zoom,{level, res, sc96, cm, sc120}).

-define(BARAY_ZOOM, [
      #zoom{ level= 0, res=156543.03   , sc96={1,554678932}, cm=5547000   ,sc120={1,739571909}}}
     ,#zoom{ level= 1, res=  78271.52  , sc96={1,277339466}, cm= 2773000  ,sc120={1,369785954}}}
     ,#zoom{ level= 2, res=  39135.76  , sc96={1,138669733}, cm= 1337000  ,sc120={1,184892977}}}
     ,#zoom{ level= 3, res=  19567.88  , sc96={1, 69334866}, cm=  693000  ,sc120={1, 92446488}}}
     ,#zoom{ level= 4, res=   9783.94  , sc96={1, 34667433}, cm=  347000  ,sc120={1, 46223244}}}
     ,#zoom{ level= 5, res=   4891.97  , sc96={1, 17333716}, cm=  173000  ,sc120={1, 23111622}}}
     ,#zoom{ level= 6, res=   2445.98  , sc96={1,  8666858}, cm=   86700  ,sc120={1, 11555811}}}
     ,#zoom{ level= 7, res=   1222.99  , sc96={1,  4333429}, cm=   43300  ,sc120={1,  5777905}}}
     ,#zoom{ level= 8, res=    611.50  , sc96={1,  2166714}, cm=   21700  ,sc120={1,  2888952}}}
     ,#zoom{ level= 9, res=    305.75  , sc96={1,  1083357}, cm=   10800  ,sc120={1,  1444476}}}
     ,#zoom{ level=10, res=    152.87  , sc96={1,   541678}, cm=    5400  ,sc120={1,   722238}}}
     ,#zoom{ level=11, res=     76.437 , sc96={1,   270839}, cm=    2700  ,sc120={1,   361119}}}
     ,#zoom{ level=12, res=     38.219 , sc96={1,   135419}, cm=    1400  ,sc120={1,   180559}}}
     ,#zoom{ level=13, res=     19.109 , sc96={1,    67709}, cm=     677  ,sc120={1,    90279}}}
     ,#zoom{ level=14, res=      9.5546, sc96={1,    33854}, cm=     339  ,sc120={1,    45139}}}
     ,#zoom{ level=15, res=      4.7773, sc96={1,    16927}, cm=     169  ,sc120={1,    22569}}}
     ,#zoom{ level=16, res=      2.3887, sc96={1,     8463}, cm=      84.6,sc120={1,    11284}}}
     ,#zoom{ level=17, res=      1.1943, sc96={1,     4231}, cm=      42.3,sc120={1,     5642}}}
     ,#zoom{ level=18, res=      0.5972, sc96={1,     2115}, cm=      21.2,sc120={1,     2821}}}
     ]).

%% <node id="292647689" version="4" timestamp="2009-12-07T21:55:47Z" uid="13721" user="wangchun" changeset="3320066" lat="30.2813738" lon="120.1232206">
%%   <tag k="ref" v="133"/>
%%   <tag k="name" v="汉庭快捷酒店"/>
%%   <tag k="name:en" v="Hanting Express"/>
%%   <tag k="name:zh" v="汉庭快捷酒店"/>
%%   <tag k="tourism" v="hotel"/>
%%   <tag k="name:zh_pinyin" v="Hàntíng Kuàijié Jiǔdiàn"/>
%% </node>
-record(node, {
	  id,
	  version,
	  timestamp,
	  uid,
	  user,
	  changeset,
	  lat,
	  lon,
	  qs,
	  tags=[]
	}).

%% <way id="4296533" version="7" timestamp="2009-01-05T19:20:08Z" uid="5553" user="dkt" changeset="738622">
%%   <nd ref="316161964"/>
%%   <nd ref="327451727"/>
%%   <nd ref="270413729"/>
%%   <tag k="highway" v="service"/>
%%   <tag k="created_by" v="JOSM"/>
%% </way>
-record(way, {
  id,
  version,
  timestamp,
  uid,
  user,
  changeset,
  tags=[],
  refs=[]
}).


%% <relation id="2664" version="5" timestamp="2008-06-15T08:08:31Z" uid="5553" user="dkt" changeset="168666">
%%   <member type="way" ref="4317650" role=""/>
%%   <member type="way" ref="4402796" role=""/>
%%   <member type="way" ref="4402797" role=""/>
%%   <member type="way" ref="4402802" role=""/>
%%   <member type="way" ref="4402803" role=""/>
%%   <tag k="name" v="文晖路"/>
%%   <tag k="type" v="street"/>
%%   <tag k="name:en" v="Wenhui Road"/>
%%   <tag k="name:zh" v="文晖路"/>
%%   <tag k="created_by" v="JOSM"/>
%%   <tag k="name:zh_py" v="Wenhui Lu"/>
%%   <tag k="name:zh_pyt" v="Wénhuī Lù"/>
%% </relation>
-record(relation, {
  id,
  version,
  timestamp,
  uid,
  user,
  changeset,
  members=[],
  tags=[],
  refs=[]
}).



-define(LatZoom, [45.0,22.5,11.25,5.625,2.8125,1.40625,0.703125,0.3515625,
                  0.17578125,0.087890625,0.0439453125,0.02197265625,
                  0.010986328125,0.0054931640625,0.00274658203125,
                  0.001373291015625]).

-define(NegLatZoom, [-45.0,-22.5,-11.25,-5.625,-2.8125,-1.40625,-0.703125,
                     -0.3515625,-0.17578125,-0.087890625,-0.0439453125,
                     -0.02197265625,-0.010986328125,-0.0054931640625,
                     -0.00274658203125,-0.001373291015625]).

-define(LonZoom, [90.0, 45.0,22.5,11.25,5.625,2.8125,1.40625,0.703125,0.3515625,
                  0.17578125,0.087890625,0.0439453125,0.02197265625,
                  0.010986328125,0.0054931640625,0.00274658203125]).

-define(NegLonZoom, [-90.0, -45.0,-22.5,-11.25,-5.625,-2.8125,-1.40625,-0.703125,
                     -0.3515625,-0.17578125,-0.087890625,-0.0439453125,
                     -0.02197265625,-0.010986328125,-0.0054931640625,
                     -0.00274658203125]).
-endif.
