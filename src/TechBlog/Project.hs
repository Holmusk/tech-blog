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
        , pImg  = "project_placeholder.svg"
        , pDesc = "🌳 Crossing the road between Haskell and Elm "
        }
    ]

mkProjectCtx :: Context a
mkProjectCtx = listField "projects" projectCtx allProjects
