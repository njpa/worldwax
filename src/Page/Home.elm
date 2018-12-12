module Page.Home
    exposing
        ( Model
        , Msg
        , init
        , subscriptions
        , toSession
        , update
        , view
        )

import Author exposing (Author(..), FollowedAuthor, UnfollowedAuthor)
import Browser.Dom as Dom
import Html exposing (..)
import Html.Attributes exposing (attribute, class, classList, href, id, placeholder)
import Html.Events exposing (onClick)
import Http
import Log
import Page
import Task exposing (Task)
import Route exposing (Route)
import Session exposing (Session)
import Username exposing (Username)
import Viewer.Cred as Cred exposing (Cred)


-- MODEL


type alias Model =
    { message : String
    , session : Session
    }


init : Session -> ( Model, Cmd Msg )
init session =
    let
        maybeCred =
            Session.cred session
    in
        ( { message = "home page"
          , session = session
          }
        , Cmd.none
        )



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = model.message
    , content =
        div []
            [ div []
                [ Html.text model.message ]
            , a [ Route.href Route.Article ] [ text "article" ]
            ]
    }



-- UPDATE


type Msg
    = GotSession Session


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session
