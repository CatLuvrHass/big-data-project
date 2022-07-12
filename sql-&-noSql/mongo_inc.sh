#!/bin/bash

input="last.csv"

sed 1d $input | while IFS="," read -r -a var

do

mongo 127.0.0.1/people --eval '

db.counters.insert(
   {
      _id: "userid",
      seq: 0
   }
)

function getNextSequence(name) {
   var ret = db.counters.findAndModify(
          {
            query: { _id: name },
            update: { $inc: { seq: 1 } },
            new: true
          }
   );

   return ret.seq;
}

db.id.insert({

_id: getNextSequence("userid"),
INDEX: "'"${var[0]}"'",
Name: "'"${var[1]}"'",
Age: "'"${var[2]}"'",
Country: "'"${var[3]}"'",
Height: "'"${var[4]}"'",
Hair_Colour: "'"${var[5]}"'"

})'

done

