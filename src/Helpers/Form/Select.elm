module Helpers.Form.Select exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Material.Select as Select
import Material.Select.Item as SelectItem


type alias Options msg =
    { labelSelect : String
    , disabled : Bool
    , errors : List String
    , selected : Maybe String
    , items : List ( String, String )
    , onSelect : Maybe (Maybe String -> msg)
    }


view : Options msg -> Html msg
view options =
    Select.filled
        (Select.config
            |> Select.setLabel (Just options.labelSelect)
            |> Select.setSelected options.selected
            |> Select.setAttributes [ style "width" "100%" ]
            |> (case options.onSelect of
                    Just onSelect ->
                        Select.setOnChange <|
                            (onSelect
                                << (\str ->
                                        if String.isEmpty str then
                                            Nothing

                                        else
                                            Just str
                                   )
                            )

                    Nothing ->
                        Select.setDisabled True
               )
        )
        (SelectItem.selectItem
            (SelectItem.config { value = "" })
            ""
        )
        (List.map
            (\( value, name ) ->
                SelectItem.selectItem
                    (SelectItem.config { value = value })
                    name
            )
            options.items
        )
