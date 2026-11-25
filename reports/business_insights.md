# Airline Passenger & Flight Delay Analysis — Business Insights & Recommendations

## Dataset & Scope Note
- **Source:** U.S. DOT 2015 Flight Delays and Cancellations (`5,819,079` flight records across 14 airlines and `flights.csv` / `airlines.csv` / `airports.csv`).
- **Scope Limitations:** Historical 2015 U.S. domestic flight operations (not current Indian airline operations) and flight-level records rather than direct passenger headcounts; `486,165` rows contain numeric DOT airport IDs rather than 3-letter IATA codes, so IATA-joined airport tables reflect IATA-matched records without dropping rows from overall counts.

## Executive KPIs (Full Dataset)
- **Total Flights:** `5,819,079` (`5,714,008` completed / `98.19%`, `89,884` cancelled / `1.54%`, `15,187` diverted / `0.26%`)
- **Average Departure Delay:** `9.29` minutes (median `-2.0` minutes on completed flights)
- **Average Arrival Delay:** `4.41` minutes (median `-5.0` minutes on completed flights)
- **On-Time Performance (< 15 min arrival delay):** `81.39%` (`18.61%` late / `1,063,439` completed flights)
- **Cancellation Rate:** `1.54%` (`89,884` cancelled flights)

## Key Business Insights
1. **Departure Delays Strongly Drive Arrival Delays, Yet Time Recovery Is Common:** `DEPARTURE_DELAY` and `ARRIVAL_DELAY` show a strong positive correlation (`r = 0.945`), while `70.33%` (`4,018,409`) of completed flights recorded `ARRIVAL_DELAY < DEPARTURE_DELAY`, pulling average arrival delay (`4.41` min) well below average departure delay (`9.29` min).
2. **Cascading Aircraft & Airline Operations Dominate 15+ Min Delay Minutes:** Across completed flights delayed `15+` minutes, **Late Aircraft (`39.84%`, `24,961,931` min)** and **Airline / Carrier (`32.20%`, `20,172,956` min)** account for over `72%` of recorded delay minutes, ahead of **Air System (`22.88%`)**, **Weather (`4.95%`)**, and **Security (`0.13%`)**.
3. **Weather Drives Cancellations, While Carrier Issues Are a Major Secondary Lever:** **Weather (`54.35%`, `48,851` flights)** is the top cancellation cause, followed by **Airline / Carrier (`28.11%`, `25,262` flights)** and **National Air System (`17.52%`, `15,749` flights)**.
4. **Wide Performance Gaps Across Airlines & Hubs:** On-time performance spans from **Hawaiian Airlines (`88.67%`)**, **Alaska Airlines (`86.96%`)**, and **Delta Air Lines (`86.44%`)** down to **Spirit Air Lines (`70.29%`)**, while **American Eagle (`5.10%`)** shows a notably high cancellation rate. Among major IATA airports, **ATL** leads volume (`346,836` flights) with low cancellations (`0.74%`), whereas congested hubs like **ORD**, **EWR**, **DFW**, and **BOS** experience elevated cancellation rates and/or departure delays.

## Actionable Operational Recommendations
1. **Protect Turnaround Buffers & Reserve Aircraft on High-Cascade Routes:** Because `LATE_AIRCRAFT_DELAY` (`39.84%`) and `AIRLINE_DELAY` (`32.20%`) drive most late minutes, target tight turnaround banks and place standby/spare aircraft at high-volume hubs to stop early delays from rolling across multiple legs.
2. **Audit Controllable Carrier Cancellations & Hub Turnarounds:** Focus operational reviews on carrier-driven cancellations (`28.11%` of cancellations) and high-cancellation carriers/hubs (such as `MQ`, `EWR`, `ORD`, and `DFW`), pairing crew/maintenance readiness with realistic schedule buffers.
3. **Use Median + Percentile Delay Tracking Alongside Mean & OTP:** Because extreme multi-hour delays skew averages (`max = 1,988` min departure / `1,971` min arrival), pair average delay and `< 15` min OTP with median and 90th/95th percentile delay tracking in operational reviews.
