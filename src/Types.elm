module Types exposing (..)


type Msg
    = MsgDataFromPort String
    | Unmount ()


type alias Flags =
    { virtualDomTesting : Maybe String
    , webComponentType : String
    }


type alias Model =
    { attr : String
    , flags : Flags
    , replicateTheIssue : Bool
    }
