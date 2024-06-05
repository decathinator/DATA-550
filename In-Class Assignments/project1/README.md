# Code Description

`code/00_clean_data.R`
- read raw data from `raw_data/` folder
- save clean data in `derived_data/` folder

`code/01_make_table1.R`
- read clean data from `derived_data/` folder
- save table 1 in `tables/` folder

`code/02_make_scatter.R`
- read clean data from `derived_data/` folder
- save scatter plot in `figures/` folder

`code/03_models.R`
- read clean data from `derived_data/` folder
- fit two regression models
- save two summary tables to `tables/` folder

`code/04_render_report.R`
- render `code/hiv_report.Rmd` 
- save compiled report in `reports/` folder

`code/hiv_report.Rmd`
- read data, tables, and figures from respective locations
- display results for production report