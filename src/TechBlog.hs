module TechBlog
       ( runBlog
       ) where

import Hakyll (applyAsTemplate, compile, compressCssCompiler, constField, copyFileCompiler, create,
               defaultContext, hakyll, idRoute, loadAndApplyTemplate, makeItem, match, route,
               templateBodyCompiler, (.||.))

import TechBlog.Blog (createBlog, createTags, matchBlogPosts)
import TechBlog.Context (stripExtension)


-- | Main function that runs the website.
runBlog :: IO ()
runBlog = hakyll $ do
    match ("images/**" .||. "fonts/**" .||. "js/*" .||. "favicon.ico") $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    -- post pages
    matchBlogPosts
    -- All posts page
    createBlog
    -- build up tags
    createTags

    -- Render the 404 page, we don't relativize URL's here.
    create ["404.html"] $ do
        route idRoute
        compile $ do
            let ctx = stripExtension <> defaultContext <> constField "page" "Not found"
            makeItem ""
                >>= applyAsTemplate ctx
                >>= loadAndApplyTemplate "templates/404.html" ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx

    match "templates/*" $ compile templateBodyCompiler
