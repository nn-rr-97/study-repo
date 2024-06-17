
# python .apply() - apply a given function to either each row or each column of a DataFrame or to each element in a Series. It operates along the specified axis 
# python .lambda() - anonymous (unnamed) function used for simple, one-liner functions that perform a specific operation.
df.apply(lambda x: <operation>, axis=<axis>)  # x: current row or column being processed.

# concatenate two columns into a single column
df['full_name'] = df.apply(lambda row: f"{row['first_name']} {row['last_name']}", axis=1) # axis = 0 if concatenating rows to create a new one

# add 10 to each element in a DataFrame column
df['column_1'] = df['column_1'].apply(lambda x: x + 10)

# convert YES/NO to True/False
df['yes_no'] = df['yes_no'].apply(lambda x: True if x == 'Yes' else False)

# define axis in apply()

# axis=0(vertical): Operates along rows that affacts columns (apply to each column)
# calculate the sum score of multiple students
subject_totals = df[['math', 'science', 'english']].apply(lambda col: col.sum(), axis=0) # col represents each single column, col.sum() to get sum of all values in that column
# calculate math, science & english total scores seperately
# output is panda series, each index represents a column

# other example: summ all values in each column of a daraframe, drop rows with missing values, find max value in each column

# axis=1(horizontal): Operates along columns (from left to right). This is generally used for operations affecting columns.
# calculate a score from multiple columns, left to right operation
df['score'] = df.apply(lambda x: x['math'] + x['science'] + x['english'], axis=1) # calculate student's total score

# other examples: concantenate two dfs side by side, apply function to each column in a dataframe, drop columns with missing values


# nest with if
df['parsed_column_1'] = df['column_1'].apply(
    lambda x: ast.literal_eval(x) if isinstance(x, str) else x
)


# python parse json files

# ast (Abstract Syntax Tree)
ast.literal_eval(x) # convert string to python object, only interprets literals (lists, dicts, tuples etc), safer
data_str = "[1, 2, 3]"
parsed_data = ast.literal_eval(data_str)

ast.eval(x) # convert string to python object, interprets complex expressions, unsafe ()
data_str = "1 + 2 + 3"
parsed_data = ast.eval(data_str)


# python datetime

# compare two dates

tend = datetime.datetime(2024, 5, 17)

while tend.date() > datetime.datetime(2024, 5, 1): # note compare date() with datetime object
    tend -= datetime.timedelta(days=1)

    tstart = tend - datetime.timedelta(days=1)

# fill in dates - convert 'YYYY-MM' to 'YYYY-MM-01
df['month'] = pd.to_datetime(df['month'], format='%Y-%m') + pd.offsets.MonthBegin(1)

# convert 'YYYY-MM-DD' to 'YYYY-MM'
df['month'] = pd.to_datetime(df['date']).dt.to_period('M')



# python .map()