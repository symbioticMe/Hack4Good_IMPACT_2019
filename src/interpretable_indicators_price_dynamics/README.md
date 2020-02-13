This is a workflow to execute the pipeline for price time-series characterization (to understand the volatility and the price change direction). 

The example of the workflow can be found in `notebooks/interpretable_indicators_price_dynamics`

The example of the workflow in the script form can be found in `_main.R`

The arguments, shared by most of the functions (including some of the plotting functions), can be found in `function_parameters.R`

# User input required:
*	Set the geographical level at which the data should be analyzed (i.e., region, governorate, district, subdistrict, town) /argument called **geo_level**/
*	Set the price type to be analyzed /argument called **commodity_type**/
    *	Can be a SMEB value (i.e., smeb\_total\_float)
    *	Can be a commodity (i.e., q\_bread\_price\_per\_8pieces)
*	Set the final month for the data to be analyzed (i.e., set as most recent month) /argument called **final_month**/
*	Set the time window (in months) for the data to be analyzed on (in months) /argument called **time_window**/

# Output:
The data frame, with the following columns:
*	The label for the specified geographical level (i.e., q\_district, q_sbd) (the one specified above in **geo\_level**)
*	**sd_der** – the standard deviation of the derivative (i.e., price difference) for the specified time window
*	**mean_der** – the mean of the derivative for the specified time window
*	**n\_missing\_der** – how many missing derivative pointes there are
    * minimum is 1, so for a time window of `t` months, we have `t-1` derivatives
    * maximum is the number of months in the specified time window (i.e., `t`)
*	**frac\_missing\_der** – (n\_missing\_der/length of time window)
*	**n_der** – number of derivatives (equal to length of time window)
    * This will not be equal to the length of the time window if for the given geographical level label, the labels for a higher geographical level are not equal (i.e., if a certain subdistrict belongs to numerous districts in the data). There were two to three such instances at the district level, so due to priorities this error was not handled
*	**mean_price** – the average price for the value (i.e., SMEB or commodity) to be analyzed
*	**indicator** – “stable”, “volatile constant”, “stable trend”, “volatile trend” (implemented only partially in `extra_functions`)
	

# Workflow details (with function description):

Appendix A – More Model Details
Supporting functions
IntInd_Model.R calls on numerous functions.
Functions 1 – 4 are used to transform the data in a form that is useful for analysis.
1.	`get_aggregated_table.R`
    *	Outputs a table with data only for the months of the time window to be analyzed, with data grouped at the geographical level specified by the user (taking median of prices)
    *	Takes in as input the data frame from reading in `data/processed/aggregated_monthly_1.csv`
    *	Calls on functions:
        *	`aggregate_price_geogr` (#2)
        *	`complete_data`(#3)
        * `filter_on_time_window`(#4)
2.	`aggregate_price_geogr`
    *	Outputs a table with each row reflecting one month of data for each unique name at the specified geographical level (i.e. prices for August 2019 for subdistrict SYXXXXXX)
    *	Groups prices by taking the median
    *	If the price type to be analyzed is a SMEB value (i.e., `smeb_total_float`), the IMPACT function `syrmm_smeb_old.R` will be run and the corresponding SMEB columns will be added to the table
    *	The input is the output from code #1 (`get_aggregated_table`)
3.	`complete_data`
    *	A table with a record for each month and each unique record for the specified geographical level (i.e., say the subdistrict level is to be analyzed. Since there are 114 unique subdistricts, the output table will have 22 (num unique months) * 114 = 2508 rows). Price data will be filled in if the data exists for that month
    *	The input is the output from code #2 (`aggregate_price_geogr`)
4.	`filter_on_time_window`
    *	Outputs data only filtered to include the months desired for analysis
    *	Input is the output from code #3 (`complete_data.R`)
Functions 5 – 9 calculate summary statistics and assign the labels (i.e., the indicators).
5.	`get_label` (contained in `get_label_function.R`)
    *	Outputs a table with summary statistics (i.e. mean/standard deviation of the mean and derivative), for each unique geographical level (i.e., for each subdistrict)
    *	Input is the output from code#1 (`get_aggregated_table.R`)
    c.	Calls on function get_label_per_location (#6)
6.	`get_label_per_location` (contained in `get_label_function.R`)
    *	Calculates the summary statistics for the function `get_label` (#5)
    *	Calls on functions:
        *	`get_derivative` (#7)
        *	`aggregate_quantity` (#8)
        *	**TO BE COMPLETED** `assign_label` (from `extra_functions/assign_label.R`)
        *   **TO BE COMPLETED** `confidence_interval` (from `extra_functions/confidence_interval.R`)
7.	`get_derivative.R`
    *	Input is a price vector of length of the specified time window, already filtered at the geographical level to be analyzed (i.e., filtered on a specific subdistrict)
    *	Output is a derivative vector (same length as the price vector, so there will be at least one NA)
    *	Note that currently (to have more complete data) the derivative (i.e., the difference in price) is taken between values even if the months are not subsequent
8.	`aggregate_quantity.R`. Calculates the statistics (i.e., mean, standard deviation) for a price vector that is passed in

These functions  add extra information that adds other use cases of these indicators (DRAFTED, BUT NOT COMPLETED, stubs available in `extra_functions`):
1.	`assign_label.R`. Assigns label: "volatile/stable/trend" according to the thresholds (potentially for joining with external factor information)
2.	`confidence_interval.R` adds expected min and expected max of the price (potentially useful for fundraising and prediction for multi-month case)
	
These functions are used to generate the two plots to illustrate the workflow.
1.	`plot_trend` (contained in `plotting_functions/plot_trends.R`): 
	    plot the time series (for the specified time window) for the value (i.e. SMEB or commodity) to be analyzed
1.	`plot_fluctuation_characteristics` (contained in `plotting_functions/plot_derivative_characteristics.R`): 
    plot the CV (standard_deviation_derivative/mean_price) vs. the relative mean (mean_derivative/mean_price)


