
/* My matlab data is converted to ESD.csv*/
bulk insert ESDMP
from 'E:\<location of directory>\ESD.csv'
WITH
(
  rowterminator = '\n',
  fieldterminator = ','
)


SELECT * from ESDMP;