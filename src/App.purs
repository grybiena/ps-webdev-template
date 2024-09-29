module App where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.VDom.Driver (runUI)

app :: Effect Unit
app = do
  HA.runHalogenAff do
     body <- HA.awaitBody
     void $ runUI component unit body

component :: forall q i o . H.Component q i o Aff
component =
  H.mkComponent
    { initialState: const unit 
    , render
    , eval: H.mkEval $ H.defaultEval { handleAction = handleAction
                                     , initialize = Just Initialize
                                     }
    }

data Action = Initialize

handleAction :: forall m. Applicative m => Action -> m Unit 
handleAction _ = pure unit

type Slots :: forall k. Row k
type Slots = ()

render :: Unit -> H.ComponentHTML Action Slots Aff
render _ = HH.div [] [ HH.p [] [ HH.text "Hello, world!" ] ]

