package Local::Reducer::MinMaxAvgObj;
use base qw(Class::Accessor);
use strict;
use DDP;
Local::Reducer::MinMaxAvgObj->follow_best_practice;
Local::Reducer::MinMaxAvgObj->mk_accessors(qw(min max avg));
1;
