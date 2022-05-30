module Pages.Sessions.CreateService exposing (Model, Msg, page)

import Effect exposing (Effect)
import Gen.Params.Sessions.CreateService exposing (Params)
import Gen.Route as Route
import Html.Attributes
import Page
import Request
import Shared exposing (User)
import UI exposing (pageConfig)
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.protected.advanced
        (\user ->
            { init = init
            , update = update
            , view = view user
            , subscriptions = subscriptions
            }
        )



-- INIT


type alias Model =
    {}


init : ( Model, Effect Msg )
init =
    ( {}, Effect.none )



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : User -> Model -> View Msg
view user model =
    { title = "Revex - Home"
    , body =
        UI.layout
            { pageConfig
                | route = Route.Sessions__CreateService
                , mainAttrs = [ Html.Attributes.class "flex flex-col gap-8 justify-center items-center" ]
                , mainContent = []
            }
    }
