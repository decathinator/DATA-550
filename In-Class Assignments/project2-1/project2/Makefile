
#! add a rule to build the report
report.html: report.Rmd code/04_render_report.R \
	output1/random_numbers1.rds \
	output2/random_numbers2.rds \
	output3/random_numbers3.rds
	Rscript code/04_render_report.R


#! add a rule to create the output of 
#! code/01_make_output1.R
output1/random_numbers1.rds: code/01_make_output1.R
	Rscript code/01_make_output1.R


#! add a rule to create the output of 
#! code/02_make_output2.R
output2/random_numbers2.rds: code/02_make_output2.R output1/random_numbers1.rds
	Rscript code/02_make_output2.R


#! add a rule to create the output of 
#! code/03_make_output3.R
output3/random_numbers3.rds: code/03_make_output3.R output2/random_numbers2.rds
	Rscript code/03_make_output3.R


#! add a PHONY target for removing .rds files
#! from the output1/2/3 directories
.PHONY: clean
clean:
	rm -rf output1/* output2/* output3/*
