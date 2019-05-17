module TechBlog.Project
       ( Project (..)
       , mkProjectCtx
       ) where

import Hakyll (Compiler, Context, Item, field, itemBody, listField, makeItem)

data Project = Project
    { pName :: String
    , pLink :: String
    , pImg  :: String
    , pDesc :: String
    }

projectCtx :: Context Project
projectCtx =
    field "pName" (pure . pName . itemBody)
 <> field "pLink" (pure . pLink . itemBody)
 <> field "pImg"  (pure . pImg  . itemBody)
 <> field "pDesc" (pure . pDesc . itemBody)

allProjects :: Compiler [Item Project]
allProjects = traverse makeItem
    [ Project
        { pName = "Elm Street"
        , pLink = "elm-street"
        , pImg  = "elm_street.png"
        , pDesc = "Crossing the road between Haskell and Elm"
        }
    , Project
        { pName = "Servant HMAC Authentication"
        , pLink = "servant-hmac-auth"
        , pImg  = "servant_hmac_auth.png"
        , pDesc = "Providing protection for all servant endpoints with HMAC"
        }
    ]

mkProjectCtx :: Context a
mkProjectCtx = listField "projects" projectCtx allProjects
