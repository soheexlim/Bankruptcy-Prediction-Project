# City of Chelsea Water Usage Analysis

## Project Overview

This project investigates the water billing system in the City of Chelsea, MA, to assess whether pricing structures are equitable and efficient. We analyze relationships between water charges, meter sizes, usage tiers, and property types. The study uncovers potential evidence of tiered pricing, non-linear billing behavior, and property-type-specific discrepancies in charges, with recommendations for optimization.

---

## Goals and Objectives

- Detect Tiered Pricing: Identify whether higher water usage is charged disproportionately more.
- Assess Meter Size Impact: Examine the linear and non-linear effects of meter size on water charges.
- Evaluate Property Categories: Determine whether commercial vs. residential properties face unequal billing practices.
- Optimize Fairness and Efficiency: Recommend improvements to ensure fair water billing.

---

## Data Description

### Source

The dataset includes 4,966 account records from Chelsea's water billing system, containing:

- Meter characteristics (`MeterSize`, `MeterType`)
- Property descriptors (`PropertyType`, account categories)
- Water usage (`Usage21`, `Usage32`, `Usage43`, `CurrentMonthUsage`)
- Billing outcomes (`CurrentWaterCharge`, `CurrentTotalDue`)
- Discounts (`SeniorDiscount`)

### Cleaning & Feature Engineering

- Converted string-based `MeterSize` to numeric, replaced 0s with `NaN`
- Created a `NewSeniorDiscount` binary indicator
- Binned usage into `UsageCategory` (Low/Med/High) for tiered pricing analysis
- Built `AccountTypeNum` for regression (Residential = 0, Commercial = 1)
- Created usage difference variables for anomaly detection (`UsageDifference43`)
- Generated scatterplot matrix across usage time periods

---

## Key Visualizations

Recommended visualizations to include in your notebook and portfolio:

- Quadratic Regression Plot: `CurrentWaterCharge ~ MeterSize + MeterSize²`
- Boxplot: `CurrentTotalDue` across `UsageCategory` (tiered pricing visualization)
- Scatterplot Matrix: `Usage21`, `Usage32`, `Usage43` (identify seasonal anomalies)
- Bar Plot: Average `CurrentWaterCharge` by `PropertyType`
- Histogram: Distribution of `MeterSize` with color by `UsageCategory`

---

## Modeling & Analysis

### Regression Model (Stata)

```stata
reg CurrentWaterCharge MeterSize c.MeterSize#c.MeterSize
