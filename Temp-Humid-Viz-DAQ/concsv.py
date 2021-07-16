import pandas as pd

read_file = pd.read_csv (r'E:\SETUP\MATLAB 2018b\Matlab 2018b\bin\func.csv',header = None)

read_file.to_csv (r'E:\SETUP\MATLAB 2018b\Matlab 2018b\bin\ESD.csv',index=None)


