DIR=../lib
SUBJ="float_addsub"
TEST="_test.v"

iverilog -o $SUBJ $DIR/$SUBJ.v $DIR/$SUBJ$TEST && vvp $SUBJ
