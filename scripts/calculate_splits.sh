TREE_INDEX=1

for BETA_INDEX in $(seq 1 4);
do
    echo $BETA_INDEX
    #echo tree1_beta1$BETA_INDEX_witherror
    splitfrequencies --input output/tree1_beta${BETA_INDEX}_witherror_run_*.trees --output output/tree1_beta${BETA_INDEX}_splits.csv
done
