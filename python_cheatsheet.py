
# python .apply() - apply a given function to either each row or each column of a DataFrame or to each element in a Series. It operates along the specified axis 
# python .lambda() - anonymous (unnamed) function used for simple, one-liner functions that perform a specific operation.
df.apply(lambda x: <operation>, axis=<axis>)  # x: current row or column being processed.
# axis=0: Operates across rows (from top to bottom). This is generally used for operations affecting rows.
# axis=1: Operates across columns (from left to right). This is generally used for operations affecting columns.

# concatenate two columns into a single column
df['full_name'] = df.apply(lambda row: f"{row['first_name']} {row['last_name']}", axis=1) # axis = 0 if concatenating rows to create a new one

# add 10 to each element in a DataFrame column
df['column_1'] = df['column_1'].apply(lambda x: x + 10)

# convert YES/NO to True/False
df['yes_no'] = df['yes_no'].apply(lambda x: True if x == 'Yes' else False)

# row based operation - calculate a score from multiple columns
df['score'] = df.apply(lambda x: x['math'] + x['science'] + x['english'], axis=1) # calculate student's total score

# column based operation - calculate the sum score of multiple students
subject_totals = df[['math', 'science', 'english']].apply(lambda col: col.sum(), axis=0) # col represents each single column, col.sum() to get sum of all values in that column
# calculate math, science & english total scores seperately
# output is panda series, each index represents a column

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


# python .map()