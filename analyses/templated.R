#!env Rscript

usage <- "
Compile a templated analysis:

    Rscript templated.R (output filename) [ names of .R files to source before knitting analysis-template.R ]

The scripts to source should define a population and a demography object.  Example:

    Rscript templated.R tests/template_test/test.html habitats/random_landscape.R demographies/gaussian-weibull.R
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
run_template <- function ( template,
                           output,
                           html=grepl("html$",output),
                           md.file=gsub("html$","md",output),
                           resource.dir="../resources",
                           macros="macros.tex"
                       ) {
    thisdir <- getwd()
    md.dir <- dirname(md.file)
    dir.create(dirname(md.file),showWarnings=FALSE,recursive=TRUE)
    outbase <- gsub("[.][^.]*$","",basename(md.file))
	knitr::opts_chunk$set(fig.path=file.path(md.dir,"figure",outbase,""),cache.path=file.path(md.dir,"cache",outbase,""))
    cat("## templated.R:\n")
    cat(paste("knitr::knit('",template,"',output='",md.file,"')\n",sep=''))
    knitr::knit(template,output=md.file)
    if (html) {
        dir.create(dirname(output),showWarnings=FALSE,recursive=TRUE)
        cat("Using pandoc to write html output to", output, "\n")
        cat("pandoc", args=c( md.file, .pandoc.opts(resource.dir,macros=macros), paste("--output", output) ),"\n" )
        system2( "pandoc", args=c( md.file, .pandoc.opts(resource.dir,macros=macros), paste("--output", output) ) )
    }
    return(output)
}

args <- if (interactive()) { args } else { commandArgs(TRUE) }
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
