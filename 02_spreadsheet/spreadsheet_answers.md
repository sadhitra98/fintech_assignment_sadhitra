## I created main folder called fintech-assignment

## Inside that folder, I created these sub-folders:
01_data (with two sub-folders inside: raw and processed)
02_spreadsheet
03_sql
04_python
05_visualization

## I then standardised the columns transaction_date	,merchant_name	,raw_amount, status	risk_score	,gateway_region,



## Then I Used VLOOKUP or XLOOKUP to bring in exchange rates from exchange_rates.csv and merchant details from merchant_master.csv.

Flags: * High Value: =IF(OR(AND(gateway_region
="APAC", raw_amount
>5000), AND(gateway_region
="EU", raw_amount
>6000), AND(gateway_region
="US", raw_amount
>7000)), 1, 0)

High Risk: =IF(OR(Risk_Score>=70, ISNUMBER(SEARCH("chargeback", Status))), 1, 0)

## Final Answers
Total raw rows - 30
Total cleaned rows - 30
Invalid or missing rows handled - 9
Top region by GMV - APAC 
Number of high value transactions - 25 (APAC Above 5000, EU Above 6000 and US above 7000)
Number of high risk transactions - 7
Top merchant by captured GMV - Beta Stores