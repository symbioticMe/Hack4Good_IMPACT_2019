 This is the **Hack4Good2019** code, created by team "Interpretable Indicators" ("wonderwoman").

The repository is organized as follows:
1. **data** /ignored by git/ contains the data frames, raw (provided by IMPACT) and processed (created within the project and used in scripts); 
2. **notebooks** contains Jupyter notebooks with data tranformation (`cleanup`), demonstration of the main pipeline (`interpretable_indicators_price_dynamics`), other exploratory notebooks (`exploratory_other`) and `archive`.
3. **src** contains source code with functions for various stages of the analysis. In particular:
    * `interpretable_indicators_price_dynamics` contains code for price dynamics characterization (volatility, trend, etc). See `README` in the corresponding folder for more details. **_NB: this is the key contribution of the team "Interpretable indicators"_**.
    * `plotting_functions` contains code to create plots of price dynamics
    * `code_archive` contains code created in the process but not used in the ultimate solution.
4. **reports** contains the resulting report and presentation\
5. **plots** /ignored by git/ contains plots, created in processed and used in the presentation and report.


