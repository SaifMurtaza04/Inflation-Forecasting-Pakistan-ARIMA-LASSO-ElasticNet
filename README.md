# 📈 Inflation Forecasting in Pakistan (Advanced Statistics Project)

This project presents a comprehensive **econometric analysis of inflation forecasting in Pakistan**, comparing traditional time-series methods with modern regularized regression techniques.

---

## 🎯 Objective

To develop and evaluate multiple forecasting models for predicting inflation in Pakistan using macroeconomic indicators, and identify the most accurate and reliable approach for policy and economic analysis.

---

## 📁 Project Structure

```id="l9d3kf"
.
├── report.pdf   # Final report (detailed analysis)
├── code.R     # R code (model implementation)
├── README.md
```

---

## 📊 Dataset & Variables

### 📌 Dependent Variable

* **Inflation Rate (CPI-based)**

### 📌 Key Independent Variables

* Tariff Rate
* Unemployment Rate
* Exchange Rate (PKR/USD)
* Brent Crude Oil Prices
* External Debt (% of GNI)

These variables were selected based on **economic theory and statistical significance**. 

---

## 🧠 Methodology

### 1️⃣ Data Analysis

* Time-series data (1990–2023)
* Summary statistics and distribution analysis
* Box plots and scatter matrix analysis

---

### 2️⃣ Models Implemented

#### 📉 ARIMA (Time-Series Model)

* Captures temporal patterns in inflation
* Suitable for univariate forecasting

#### 📊 Ridge Regression (L2 Regularization)

* Handles multicollinearity
* Reduces overfitting

#### ✂️ LASSO Regression (L1 Regularization)

* Performs feature selection
* Shrinks irrelevant coefficients to zero

#### ⚖️ Elastic Net

* Combines Ridge + LASSO
* Balances feature selection and stability

---

## 📈 Results & Model Comparison

| Model       | MSE   | Performance   |
| ----------- | ----- | ------------- |
| LASSO       | 12.78 | 🥇 Best       |
| Elastic Net | 12.79 | 🥈 Very close |
| Ridge       | 13.90 | 🥉 Moderate   |
| ARIMA       | 20.00 | ❌ Weakest     |

📌 Regularized models outperformed ARIMA by **~35–40%**. 

---

## 🔍 Key Insights

* Inflation in Pakistan is strongly influenced by:

  * Exchange rate fluctuations
  * Oil prices
  * Tariff policies
* Regularization improves prediction by:

  * Handling multicollinearity
  * Selecting relevant features
* ARIMA struggles due to:

  * Lack of external variables
  * Inability to capture structural changes

---

## 📊 Forecast Findings

* Inflation expected to **stabilize around ~10%**
* High uncertainty due to economic volatility
* Wide confidence intervals highlight risk in predictions

---

## 🏛️ Policy Implications

* Policymakers should prefer:

  * **LASSO / Elastic Net** for better accuracy
* Important for:

  * Interest rate decisions
  * Inflation targeting
  * Economic planning

---

## 🛠️ Technologies Used

* **R**
* **Time Series Analysis (ARIMA)**
* **Regularized Regression (glmnet)**
* **Statistical Modeling & Visualization**

---

## 🚧 Limitations

* Limited dataset scope
* External shocks (e.g., COVID, geopolitics) not fully modeled
* ARIMA lacks exogenous variables

---

## 🚀 Future Improvements

* Use **SARIMAX (ARIMA + external variables)**
* Implement **hybrid models (ML + time series)**
* Add more macroeconomic indicators
* Perform rolling window validation

---

## 👨‍💻 Authors

* **Muhammad Saif Murtaza (23i-2588)**
* **Shilok Kumar (23i-2502)**

FAST-NUCES

---

## 📜 License

This project is open-source and available under the MIT License.
