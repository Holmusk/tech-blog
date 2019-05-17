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
    , Project
        { pName = "Haskell FCM Client"
        , pLink = "fcm-client"
        , pImg  = "fcm_client.png"
        , pDesc = "A Haskell Client for Firebase Cloud Messaging"
        }
    , Project
        { pName = "Three Layer"
        , pLink = "three-layer"
        , pImg  = "three_layer.png"
        , pDesc = "Haskell application architecture based on the Three Layer Cake programming pattern"
        }
    , Project
        { pName = "Elm Timed Cache"
        , pLink = "timed-cache"
        , pImg  = "timed_cache.png"
        , pDesc = "A simple Elm module to manage remote data that is accessed more often than it is fetched"
        }
    , Project
        { pName = "Elmoji"
        , pLink = "elmoji"
        , pImg  = "elmoji.png"
        , pDesc = "An emoji picker written in Elm"
        }
    , Project
        { pName = "Flutter S3 Cache Image"
        , pLink = "s3_cache_image"
        , pImg  = "s3_cache_image.png"
        , pDesc = "A library to show images from S3 and keep them in the cache directory"
        }
    ]

mkProjectCtx :: Context a
mkProjectCtx = listField "projects" projectCtx allProjects
