-module(baray).
-author('chan sisowath').
-include("baray.hrl").

-export([ll2qs/1]).
-export([ll2qs/2]).
-export([qs2ll/1]).
-export([qs2bbox/1]).
-export([bbox_in_qs/2]).
-export([qs_root/2]).
-export([bbox/4]).
-export([incr_qs/1]).
-export([overlap/2]).
-export([zoom/1]).
-export([store/1]).
-export([deg2num/3]).
-export([num2deg/3]).


deg2num(Lat,Lon,Zoom)->
    X=math:pow(2, Zoom) * ((Lon + 180) / 360),
    Sec=1/math:cos(deg2rad(Lat)),
    R = math:log(math:tan(deg2rad(Lat)) + Sec)/math:pi(),
    Y=math:pow(2, Zoom) * (1 - R) / 2,
    {round(X),round(Y)}.
 
num2deg(X,Y,Zoom)->
    N=math:pow(2, Zoom),
    Lon=X/N*360-180,
    Lat_rad=math:atan(math:sinh(math:pi()*(1-2*Y/N))),
    Lat=Lat_rad*180/math:pi(),
    {Lon,Lat}.
 
deg2rad(C)->
    C*math:pi()/180.

zoom(L) -> zoom(L, 0, []).
zoom(L, N, Acc) when N>15 -> lists:reverse(Acc);
zoom(L, N, Acc) -> zoom(L/2, N+1, [L/2|Acc]).


%% quad string
-define(A,$0).
-define(B,$1).
-define(C,$2).
-define(D,$3).
ll2qs({Lat, Lon}) -> ll2qs(Lat, Lon).
ll2qs(Lat, Lon) -> ll2qs(Lat, Lon, 90/2, 180/2, 1, []).
ll2qs(_Lat, _Lon, _LatIncrement, _LonIncrement, Zoom, Qs) when Zoom > 17 -> Qs;
ll2qs(Lat, Lon, LatIncrement, LonIncrement, Zoom, Qs) when Lat<0, Lon<0 -> 
    ll2qs(Lat + LatIncrement, Lon + LonIncrement, LatIncrement/2, LonIncrement/2, Zoom+1, Qs ++ [?C] );
ll2qs(Lat, Lon, LatIncrement, LonIncrement, Zoom, Qs) when Lat<0 -> 
    ll2qs(Lat + LatIncrement, Lon - LonIncrement, LatIncrement/2, LonIncrement/2, Zoom+1, Qs ++ [?D]);
ll2qs(Lat, Lon, LatIncrement, LonIncrement, Zoom, Qs) when Lon<0 -> 
    ll2qs(Lat - LatIncrement, Lon + LonIncrement, LatIncrement/2, LonIncrement/2, Zoom+1, Qs ++ [?A]);
ll2qs(Lat, Lon, LatIncrement, LonIncrement, Zoom, Qs) -> 
    ll2qs(Lat - LatIncrement, Lon - LonIncrement, LatIncrement/2, LonIncrement/2, Zoom+1, Qs ++ [?B]).

qs2ll(Qs) -> qs2ll(Qs, 0.0 , 0.0 , 90/2, 180/2).
qs2ll([], Lat, Lon, _, _) -> {Lat,Lon};
qs2ll([?A|T], Lat, Lon, LatIncr, LonIncr) -> qs2ll(T, Lat+LatIncr, Lon-LonIncr, LatIncr/2, LonIncr/2);
qs2ll([?B|T], Lat, Lon, LatIncr, LonIncr) -> qs2ll(T, Lat+LatIncr, Lon+LonIncr, LatIncr/2, LonIncr/2);
qs2ll([?C|T], Lat, Lon, LatIncr, LonIncr) -> qs2ll(T, Lat-LatIncr, Lon-LonIncr, LatIncr/2, LonIncr/2);
qs2ll([?D|T], Lat, Lon, LatIncr, LonIncr) -> qs2ll(T, Lat-LatIncr, Lon+LonIncr, LatIncr/2, LonIncr/2).

qs2bbox(Qs) ->
    qs2bbox(Qs, -90, -180, 90, 180, 90, 180).

qs2bbox(    [], BlLat, BlLon, TrLat, TrLon, Lat, Lon) -> {BlLat, BlLon, TrLat, TrLon};
qs2bbox([$a|T], BlLat, BlLon, TrLat, TrLon, Lat, Lon) -> qs2bbox(T, BlLat+Lat,     BlLon,     TrLat, TrLon-Lon, Lat/2, Lon/2);
qs2bbox([$b|T], BlLat, BlLon, TrLat, TrLon, Lat, Lon) -> qs2bbox(T, BlLat+Lat, BlLon+Lon,     TrLat,     TrLon, Lat/2, Lon/2);
qs2bbox([$c|T], BlLat, BlLon, TrLat, TrLon, Lat, Lon) -> qs2bbox(T,     BlLat,     BlLon, TrLat-Lat, TrLon-Lon, Lat/2, Lon/2);
qs2bbox([$d|T], BlLat, BlLon, TrLat, TrLon, Lat, Lon) -> qs2bbox(T,     BlLat,     BlLon, TrLat-Lat, TrLon+Lon, Lat/2, Lon/2).

qs_root(Qs1, Qs2) -> qs_root(Qs1, Qs2, []).
qs_root([], _, Qs) -> Qs;
qs_root(_, [], Qs) -> Qs; 
qs_root([H|T1],[H|T2], Qs) -> qs_root(T1,T2, Qs ++ [H]); 
qs_root([_|T1],[_|T2], Qs) -> Qs.
    
bbox(BlLat,BlLon,TrLat,TrLon) ->
    QsBl = ll2qs(BlLat, BlLon),
    QsTl = ll2qs(TrLat, BlLon),
    QsBr = ll2qs(BlLat, TrLon),
    QsTr = ll2qs(TrLat, TrLon),
    Qs1  = qs_root(QsBl, QsTl),
    Qs2  = qs_root(Qs1, QsBr),
    qs_root(Qs2, QsTr).

overlap({BlLat1,BlLon1,TrLat1,TrLon1}, {BlLat2,BlLon2,TrLat2,TrLon2}) ->
 (((TrLat1 - BlLat2) < 0) /= ((BlLat1 - TrLat2) < 0)) 
 and (((BlLon1 - TrLon2) < 0) /= ((TrLon1 - BlLon2) <0 )).

bbox_in_qs({BlLat1,BlLon1,TrLat1,TrLon1}, Qs) ->
    Bbox = qs2bbox(Qs),
    overlap(Bbox, {BlLat1,BlLon1,TrLat1,TrLon1}).

incr_qs(Qs) -> 
    integer_to_list(list_to_integer(Qs,4) + 1, 4).

%% incr_qs(Qs) ->
%%     incr_qs(Qs, Qs).

%% incr_qs([], _) -> [];
%% incr_qs([$d|T], Qs) -> incr_qs(T, Qs);
%% incr_qs(_, Qs) -> incr_qs2(Qs).   
    
%% incr_qs2(Qs) ->    
%%     Len = length(Qs),
%%     Rest = string:substr(Qs,1, Len-1),
%%     Last = lists:last(Qs),
%%     incr_qs2(Rest, Last).

%% incr_qs2(Rest, $d) -> 
%%     case incr_qs(Rest) of
%%         "" -> "";
%%         Else -> Else ++ "a"
%%     end;
%% incr_qs2(Rest, $c) -> Rest ++ "d";
%% incr_qs2(Rest, $b) -> Rest ++ "c";
%% incr_qs2(Rest, $a) -> Rest ++ "b".       