#!/bin/bash

sudo mysql << EOF
USE mysql
USE people

select country, avg(height) from general_info group by country;
select hair_colour, max(height) from general_info group by hair_colour;
EOF
