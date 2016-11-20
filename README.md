# HMDA_Data_Analysis
Technical Specifications:
	Scripting Language: R 
	Version: R for Windows 3.3.1
	Platform: RStudio
	Version: 0.99.903

There are 3 files in this folder "data analysis".
	contents:
		HMDA_data_analysis.R
		loan_amount'12-14.Jpeg
		loan_count'12-14.jpeg
		Readme.txt
		HMDA_homeLoan_report.doc


HMDA_data_analysis.R
	This the process that was used for wrangling and visualization of the data:
-data munging
-Different libraries being used for the analysis
-setting the working directory
-reading the institution_data and storing it in another object
-Padding the values of respondant_id to match it with the loan_data and create a "KEY" by appending
-the Agency_code and the Respondant ID.
-reading the loan_data and storing it in the object and creating the "KEY" 
-Merging the 2 datasets in order to have the corresponding institution name for each loan_amount entered
-Data visualization
-melted the data in order to group it and summarize to get the count and sum of the total loans by state and year.
-created subsets for each year to plot the data
-plotting 1
-this is the plot for the Total loan amount by each state and year
-plotting 2
-this is the plot for the Total no. of loans by each state and year
