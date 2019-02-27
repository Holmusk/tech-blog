module TechBlog.Context
       ( stripExtension
       , postCtx
       , postCtxWithTags
       , pageCtx
       ) where

import Hakyll (Context, dateField, defaultContext, field, functionField, getMetadata, itemBody,
               itemIdentifier, listField, lookupString, makeItem)

import qualified Data.Text as T


-- | Removes the @.html@ suffix in the post URLs.
stripExtension :: Context a
stripExtension = functionField "stripExtension" $ \args _ -> case args of
    [k] -> pure $ maybe k toString (T.stripSuffix ".html" $ toText k)
    _   -> error "relativizeUrl only needs a single argument"

-- | Context to use in posts
postCtx :: Context String
postCtx = stripExtension
    <> dateField "date" "%B %e, %Y"
    <> defaultContext

-- | Context with tags and dates.
postCtxWithTags :: [String] -> Context String
postCtxWithTags tags =
    listField "tagsList" (field "tag" $ pure . itemBody) (traverse makeItem tags)
    <> postCtx

-- | @page@ name context for posts.
pageCtx :: Context a
pageCtx = field "page" $ \item -> do
    metadata <- getMetadata (itemIdentifier item)
    pure $ fromMaybe "No title" $ lookupString "title" metadata
