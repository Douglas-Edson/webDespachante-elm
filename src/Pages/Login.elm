module Pages.Login exposing (Model, Msg, page)

import Effect exposing (Effect)
import Gen.Params.Login exposing (Params)
import Html
import Html.Attributes exposing (class, style)
import Material.Button as Button
import Material.Elevation as Elevation
import Material.LayoutGrid as LayoutGrid
import Material.TextField as TextField
import Material.Typography as Typography
import Page
import Request
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.advanced
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { email : String
    , password : String
    }


init : ( Model, Effect Msg )
init =
    ( { email = ""
      , password = ""
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = ClickedSignIn
    | ValueEmailChanged String
    | ValuePasswordChanged String


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ClickedSignIn ->
            ( model
            , Effect.fromShared (Shared.SignIn { name = "Douglas" })
            )

        ValueEmailChanged newEmail ->
            ( { model | email = newEmail }
            , Effect.none
            )

        ValuePasswordChanged newPassword ->
            ( { model | password = newPassword }
            , Effect.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Login"
    , body =
        [ Html.section
            [ class "login_content" ]
            [ Html.div
                [ Elevation.z24
                , class "login_elevation"
                ]
                [ LayoutGrid.layoutGrid
                    [ class "login_header"
                    ]
                    [ LayoutGrid.inner
                        [ class "login_header_grid" ]
                        [ LayoutGrid.cell
                            []
                            [ Html.h1
                                [ Typography.headline1
                                , class "login_title"
                                ]
                                [ Html.text "WebDespachante"
                                ]
                            ]
                        ]
                    , LayoutGrid.inner [ class "login_header_grid" ]
                        [ LayoutGrid.cell
                            []
                            [ Html.div
                                []
                                [ Html.img
                                    [ class "login_animation"
                                    , Html.Attributes.src
                                        "https://despachantepr.com/o/animation_300_kmana8xo.gif"
                                    ]
                                    []
                                ]
                            ]
                        ]
                    ]
                , LayoutGrid.layoutGrid
                    []
                    [ LayoutGrid.cell
                        []
                        [ Html.form
                            []
                            [ LayoutGrid.cell
                                []
                                [ TextField.filled
                                    (TextField.config
                                        |> TextField.setAttributes [ class "md_fullWidth" ]
                                        |> TextField.setLabel (Just "E-Mail")
                                        |> TextField.setType (Just "email")
                                        |> TextField.setOnInput ValueEmailChanged
                                    )
                                ]
                            , LayoutGrid.cell
                                []
                                [ TextField.filled
                                    (TextField.config
                                        |> TextField.setAttributes [ class "md_fullWidth" ]
                                        |> TextField.setLabel (Just "Senha")
                                        |> TextField.setType (Just "password")
                                        |> TextField.setOnInput ValuePasswordChanged
                                    )
                                ]
                            , LayoutGrid.cell
                                []
                                [ Button.raised
                                    (Button.config
                                        |> Button.setAttributes [ class "md_fullWidth" ]
                                        |> Button.setOnClick ClickedSignIn
                                        |> Button.setHref (Just "#")
                                    )
                                    "Entrar"
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    }
