module TechBlog.Blog
       ( matchBlogPosts
       , createBlog
       , createTags

       , compilePosts
       ) where

import Hakyll (Pattern, Rules, buildTags, compile, constField, create, defaultContext,
               defaultHakyllReaderOptions, defaultHakyllWriterOptions, fromCapture,
               getResourceString, getTags, idRoute, itemBody, itemIdentifier, listField, loadAll,
               loadAndApplyTemplate, makeItem, match, pandocCompiler, recentFirst, relativizeUrls,
               renderPandocWith, route, setExtension, tagsRules)
import Text.Pandoc.Options (WriterOptions (..))

import TechBlog.Context (pageCtx, postCtx, postCtxWithTags)


-- | Creates each post page.
matchBlogPosts :: Rules ()
matchBlogPosts = match "blog/*" $ do
    route $ setExtension "html"
    compile $ do
        i   <- getResourceString
        pandoc <- renderPandocWith defaultHakyllReaderOptions withToc i
        let toc = itemBody pandoc
        tgs <- getTags (itemIdentifier i)
        let postTagsCtx = postCtxWithTags tgs
                       <> constField "toc" toc
                       <> pageCtx
        pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html" postTagsCtx
            >>= loadAndApplyTemplate "templates/default.html" postTagsCtx
            >>= relativizeUrls

-- | Creates "Blog" page with all tags.
createBlog :: Rules ()
createBlog = create ["index.html"] $ compilePosts "Blog Posts" "blog/*"

createTags :: Rules ()
createTags = do
    tags <- buildTags "blog/*" (fromCapture "tags/*.html")
    tagsRules tags $ \tag ptrn -> do
        let title = "Tag " ++ tag
        compilePosts title ptrn

-- | Compiles all posts for the blog pages with the tags context
compilePosts :: String -> Pattern -> Rules ()
compilePosts title ptrn = do
    route idRoute
    compile $ do
        posts <- recentFirst =<< loadAll ptrn
        let ids = map itemIdentifier posts
        tagsList <- ordNub . concat <$> traverse getTags ids
        let ctx = postCtxWithTags tagsList
               <> listField "posts" postCtx (pure posts)
               <> defaultContext
               <> constField "page" title

        makeItem ""
            >>= loadAndApplyTemplate "templates/blog.html" ctx
            >>= loadAndApplyTemplate "templates/default.html" ctx
            >>= relativizeUrls

-- | Compose TOC from the markdown.
withToc :: WriterOptions
withToc = defaultHakyllWriterOptions
    { writerTableOfContents = True
    , writerTOCDepth = 4
    , writerTemplate = Just "$toc$"
    }
