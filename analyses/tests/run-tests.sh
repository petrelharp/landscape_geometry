#!/bin/bash

#########
echo "testing 'templated.R analysis-template.Rmd'"
( cd .. && Rscript templated.R analysis-template.Rmd tests/template_test/test-analysis.html habitats/test_habitat.R demographies/test_demography.R )

#########
echo "testing 'templated.R drift-template.Rmd'"
( cd .. && Rscript templated.R drift-template.Rmd tests/template_test/test-drift.html habitats/test_habitat.R demographies/neutral_test_demography.R )

