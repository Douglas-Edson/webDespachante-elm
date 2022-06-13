module Pages.Sessions.CreateService exposing (Model, Msg, page)

import Effect exposing (Effect)
import Gen.Params.Sessions.CreateService exposing (Params)
import Gen.Route as Route
import Helpers.Form.Select as HelpersForm
import Html
import Html.Attributes
import Page
import Request
import Service.Models as Models
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
    { state : Models.StateToCreateService
    }


init : ( Model, Effect Msg )
init =
    ( { state =
            { selectService = Nothing
            }
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = ServiceSelected (Maybe String)


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ServiceSelected service ->
            -- let
            --     state_ =
            --         model.state
            --             |> (\state__ -> { state__ | selectService = Nothing })
            -- in
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
                , mainAttrs = [ Html.Attributes.class "flex flex-col  justify-center items-center" ]
                , mainContent =
                    [ selectService ]
            }
    }


selectService : Html.Html Msg
selectService =
    Html.section
        [ Html.Attributes.class "CreateService_select" ]
        [ HelpersForm.view
            { labelSelect = "Selecione o Serviço"
            , disabled = False
            , errors = []
            , selected = Nothing
            , items = [ ( "id", "Primeiro  Emplacamento" ) ]
            , onSelect = Just ServiceSelected
            }
        ]
