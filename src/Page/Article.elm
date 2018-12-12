module Page.Article
    exposing
        ( Model
        , Msg
        , init
        , update
        , subscriptions
        , toSession
        , view
        )

import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (attribute, class, disabled, href, id, placeholder)
import Html.Events exposing (onClick, onInput, onSubmit)
import Page
import Task exposing (Task)
import Session exposing (Session)


-- MODEL


type alias Model =
    { message : String
    , session : Session
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { message = "this is without a doubt the mostest illest article page"
      , session = session
      }
    , Cmd.none
    )



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = model.message
    , content = Html.text model.message
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
