# Description of the data

1. **raw** folder contains two tables, provided by IMPACT:
    * geographical mapping information: **UNOCHA\_pcodes\_nocamps.xlsx**
    * commodity price for all months: **MM\_for\_nov17\_aug19.xlsx**
2. **processed** folder contains various intermediate tables, such as:
    * row-bound version of **MM\_for\_nov17\_aug19.xlsx**, with added column for month (from the sheet name), and geographical data added from **UNOCHA\_pcodes\_nocamps.xlsx**, and only commodity prices selected as required for SMEB calculation. For more details, see `Notebooks/cleanup/Merge_columns.ipynb`