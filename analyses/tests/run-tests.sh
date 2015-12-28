#!/bin/bash

#########
echo "testing 'templated.R'"
cd .. && Rscript templated.R tests/template_test/test2.html habitats/test_habitat.R demographies/test_demography.R

