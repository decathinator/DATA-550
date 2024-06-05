# Project Description

The HIV report has been broken into two subprojects.

- `subproject1/` contains all code and output related to the descriptive analysis
	- `subproject1/code/01_make_table1.R` produces Table 1
		- table 1 output should be saved to `subproject1/output/`
	- `subproject1/code/02_make_scatter.R` produces the scatter plot
		- scatter plot should be saved to `subproject1/output/`
	- `subproject1/report.Rmd` reads in output from `subproject1/output/` and creates the report for the descriptive analysis
- `subproject2/` contains all code and output related to the regression analysis
	- `subproject2/code/01_models.R` fits regression models
		- summary tables should be saved to `subproject2/output/`
	- `subproject2/report.Rmd` reads in output from `subproject2/output/` and creates the report for the regression analysis

The subprojects are combined in `combined_report.Rmd`.

- [child](https://bookdown.org/yihui/rmarkdown-cookbook/child-document.html) documents are used to stitch together a final report

`render_combined_report.R` is used for rendering the combined report from the command line