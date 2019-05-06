module TechBlog
       ( runBlog
       ) where

import Hakyll (applyAsTemplate, compile, compressCss, constField, copyFileCompiler, create,
               defaultContext, hakyll, idRoute, loadAndApplyTemplate, makeItem, match, route,
               setExtension, templateBodyCompiler, (.||.))
import Hakyll.Web.Sass (sassCompiler)

import TechBlog.Blog (createBlog, createMain, createTags, matchBlogPosts)
import TechBlog.Context (stripExtension)


-- | Main function that runs the website.
runBlog :: IO ()
runBlog = hakyll $ do
    match ("images/**" .||. "fonts/**" .||. "js/*" .||. "favicon.ico") $ do
        route   idRoute
        compile copyFileCompiler

    match "css/main.sass" $ do
        route $ setExtension "css"
        let compressCssItem = fmap compressCss
        compile (compressCssItem <$> sassCompiler)

    -- Main pages
    createMain

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
