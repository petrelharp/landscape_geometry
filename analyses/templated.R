#!/usr/bin/Rscript

usage <- "
Compile a templated analysis:

    Rscript templated.R (output filename) [ names of .R files to source before knitting analysis-template.R ]

The scripts to source should define a population and a demography object.  Example:

    Rscript templated.R tests/template_test/test.html habitats/test_habitat.R demographies/test_demography.R
"

.pandoc.opts <-  function (resource.dir, 
                           .local.mathjax = "/usr/share/javascript/mathjax/MathJax.js",
                           macros = "macros.tex" ) {
        .mathjax <- if (file.exists(.local.mathjax)) { .local.mathjax } else { "https://cdn.mathjax.org/mathjax/latest/MathJax.js" }
        opts <- c("--to html", 
                   "--from markdown",
                   "--self-contained", 
                   "--standalone", 
                   "--section-divs", 
                   paste("--template", file.path(resource.dir,"rmarkdown-template.html")), 
                   "--variable 'theme:bootstrap'", 
                   paste("--include-in-header ", file.path(resource.dir,"header-scripts.html")), 
                   "--mathjax", 
                   paste("--variable 'mathjax-url:",.mathjax,"?config=TeX-AMS-MML_HTMLorMML'",sep=''), 
                   paste("--variable 'libraries-url:",resource.dir,"'",sep=''), 
                   "--no-highlight", 
                   paste("--variable highlightjs=",file.path(resource.dir,"highlight"),sep=''), 
                   paste("--include-in-header ", file.path(resource.dir,"mathjax-config.js"))
               )
        if (file.exists(macros)) {
            temp.macros <- tempfile()
            cat("\\[", temp.macros)
            file.append(temp.macros,macros)
            cat("\\]", temp.macros, append=TRUE)
            opts <- c( opts, 
                   paste("--include-in-header ", temp.macros) )
        }
        return(opts)
}


#' Safely Compile a R/markdown Template
#'
#' Calls "knit()" on the template given,
#' directing output to the given output name,
#' and doing this in a way that doesn't cause collisions 
#' between parallel instances of this script.
#'
#' @param template Name of .Rmd file.
#' @param output Name of output .md or .html file.
#' @param html Run pandoc to compile html from the .md?
#' @param md.file Name of the .md output file.
#' @param resource.dir Directory that files referenced in pandoc options are in.
#' @param macros Name of a file with LaTeX macros.
#' @export
#' @return The name of the output file.
#' Note that by default, both knitr and pandoc look for figures relative to the *current directory*,
#' not the directory that the markdown file lives in.  
#' This makes subsequent parseing of the markdown file infeasable more difficult.
#' To avoid this, here we switch to the directory of the markdown file before running either.
run_template <- function ( template,
                           output,
                           html=grepl("html$",output),
                           md.file=gsub("html$","md",output),
                           resource.dir="../resources",
                           macros="macros.tex"
                       ) {
    thisdir <- getwd()
    .fullpath <- function (x) { file.path(normalizePath("."),x) }
    template.loc <- .fullpath(template)
    output.loc <- .fullpath(output)
    resource.dir.loc <- .fullpath(resource.dir)
    macros.loc <- .fullpath(macros)
    md.dir <- dirname(md.file)
    dir.create(dirname(md.file),showWarnings=FALSE,recursive=TRUE)
    outbase <- gsub("[.][^.]*$","",basename(md.file))
    # change directory so that paths are correct relative to where the markdown file is
    cat("## templated.R:\n")
    cat(paste("setwd('",md.dir,"')\n"),sep='')
    cat(paste("knitr::opts_chunk$set( fig.path=file.path('figure','",outbase,",''), cache.path=file.path('cache',",outbase,",'') )",sep=''))
    cat(paste("knitr::knit('",template.loc,"',output='",basename(md.file),"')\n",sep=''))
    setwd(md.dir)
	knitr::opts_chunk$set( fig.path=file.path("figure",outbase,""),
                           cache.path=file.path("cache",outbase,"") )
    knitr::knit(template.loc,output=basename(md.file))
    if (html) {
        dir.create(dirname(output),showWarnings=FALSE,recursive=TRUE)
        cat("Using pandoc to write html output to", output, "\n")
        cat("pandoc", c( basename(md.file), .pandoc.opts(resource.dir.loc,macros=macros.loc), paste("--output", output.loc) ),"\n" )
        system2( "pandoc", args=c( basename(md.file), .pandoc.opts(resource.dir.loc,macros=macros.loc), paste("--output", output.loc) ) )
    }
    # change back
    setwd(thisdir)
    return(output.loc)
}

args <- if (interactive()) { args } else { commandArgs(TRUE) }
if (length(args)<2) { stop(usage) }

output.file <- args[1]

for (scr in args[-1]) {
    if (!file.exists(scr)) {
        stop(paste("File ", scr, " does not exist."))
    }
    cat("## templated.R:\n")
    cat(paste("source('",scr,"',chdir=TRUE)\n",sep=''))
    source(scr,chdir=TRUE)
}

run_template( "analysis-template.Rmd", output=output.file )
