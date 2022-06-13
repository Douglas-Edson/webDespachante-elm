module Service.Models exposing (StateToCreateService)

-- Create Service


type alias StateToCreateService =
    { selectService : Maybe Service
    }


type alias Service =
    { name : String
    , code : Int
    , price : Float
    }
