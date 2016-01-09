#!/usr/bin/Rscript

usage <- "
Compile a templated analysis:

    Rscript templated.R (template name) (output filename) [ names of .R files to source before knitting analysis-template.R ]

The scripts to source should define a population and a demography object.  Example:

    Rscript templated.R analysis-template.Rmd tests/template_test/test.html habitats/test_habitat.R demographies/test_demography.R

This also defines the variable 'sourced.text', which is a list of character vectors containing the files sourced,
and can be used for reproducibility in the document itself.
"

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
