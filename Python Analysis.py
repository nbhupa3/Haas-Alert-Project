import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import pygwalker as pyg

# 1. Load Data
df = pd.read_csv("Motor_Vehicle_Collisions.csv")  # or your cleaned CSV

# 2. Example: Collisions By Borough
collisions_by_borough = df.groupby("BOROUGH").size().reset_index(name="COLLISION COUNT")
collisions_by_borough = collisions_by_borough.sort_values(by="COLLISION COUNT", ascending=False)
print(collisions_by_borough)

# 3. Simple Bar Chart
plt.bar(collisions_by_borough["BOROUGH"], collisions_by_borough["COLLISION COUNT"])
plt.xlabel("Borough")
plt.ylabel("Number of Collisions")
plt.title("Collisions by Borough")
plt.show()

# 4. Example: Contributing Factor Frequency
factors_cols = ["CONTRIBUTING FACTOR VEHICLE 1", "CONTRIBUTING FACTOR VEHICLE 2"]

# Melt the factor columns into a single column
factor_data = pd.melt(df, value_vars=factors_cols, var_name="factor_col", value_name="factor")

# Drop rows with missing or "Unspecified" factor values
factor_data = factor_data.dropna(subset=["factor"])
factor_data = factor_data[factor_data["factor"] != "Unspecified"]

top_factors = factor_data["factor"].value_counts().head(10)

x_positions = np.arange(len(top_factors))

# Creating the bar chart
plt.bar(x_positions, top_factors.values, color='orange')

plt.xticks(x_positions, top_factors.index, rotation=45, ha="right")
plt.xlabel("Contributing Factor")
plt.ylabel("Count")
plt.title("Top 10 Contributing Factors for Collisions")

plt.tight_layout()
plt.show()


# Just do a basic PygWalker without referencing a pre-defined spec
walker = pyg.walk(df, use_kernel_calc=True)


