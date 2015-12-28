#!/bin/bash

#########
echo "testing 'templated.R'"
cd .. && Rscript templated.R tests/template_test/test.html habitats/test_habitat.R demographies/test-demography.R

