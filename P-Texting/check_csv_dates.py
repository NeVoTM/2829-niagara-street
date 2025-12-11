import pandas as pd
from datetime import date

df = pd.read_csv('C:/Users/17274/Documents/HairColorNY/list_from_grok_CLEANED.csv')
df['Date'] = pd.to_datetime(df['Date'], errors='coerce')

today = date.today()
print(f'Today: {today}')
print(f'Total rows: {len(df)}')

today_df = df[df['Date'].dt.date == today]
print(f'Nov 24 rows: {len(today_df)}')

if len(today_df) > 0:
    print('\nFirst 10 Nov 24 entries:')
    print(today_df[['Name', 'Phone', 'Date']].head(10))
else:
    print('\nNo records for today. Showing date distribution:')
    print(df['Date'].value_counts().head(20))
