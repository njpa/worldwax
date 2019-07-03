port module Ports exposing (audioPause, audioPlay)


port audioPause : { player : String, time : Float } -> Cmd msg


port audioPlay : { player : String, time : Float } -> Cmd msg
