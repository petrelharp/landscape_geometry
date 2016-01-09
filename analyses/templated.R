#!/usr/bin/Rscript

usage <- "
Compile a templated analysis:

    Rscript templated.R (template name) (output filename) [ names of .R files to source before knitting analysis-template.R ]

The scripts to source should define a population and a demography object.  Example:

    Rscript templated.R analysis-template.Rmd tests/template_test/test.html habitats/test_habitat.R demographies/test_demography.R

This also defines the variable 'sourced.text', which is a list of character vectors containing the files sourced,
and can be used for reproducibility in the document itself.
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

cat(paste(commandArgs(),collapse=" "),"\n")

# if debugging interactively, define 'args'
args <- if (interactive()) { args } else { commandArgs(TRUE) }
if (length(args)<2) { stop(usage) }

template.file <- args[1]
output.file <- args[2]
source.these <- args[-(1:2)]

for (scr in source.these) {
    if (!file.exists(scr)) {
        stop(paste("File ", scr, " does not exist."))
    }
    cat("## templated.R:\n")
    cat(paste("source('",scr,"',chdir=TRUE)\n",sep=''))
    source(scr,chdir=TRUE)
}

# this can be used to invalidate caches in knitr:
cat("## templated.R:\n")
cat(paste("sourced.text <- lapply( c('", paste(source.these,collapse="', '"), "'), scan, what='char', sep='\n' )", sep=''),"\n")
sourced.text <- lapply( source.these, scan, what="char", sep='\n' )

source("run_template.R")  # provides run_template function
run_template( template.file, output=output.file )

## save everything
# save( list=ls(), file=paste(output.file,".RData",sep='') )
