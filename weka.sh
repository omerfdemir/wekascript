#!/bin/bash
#Finding Users Home
ANIMATION=true
cd $HOME
HOMEE="$(pwd)"
OUTPUTDIRNAME=omerfdemir.zubeyirdurgay.oguzalkan
#Making directory for files
mkdir $HOMEE/Desktop/$OUTPUTDIRNAME
OUTPUTDIRPATH=$HOMEE/Desktop/$OUTPUTDIRNAME
#Downloading weka.jar
wget -O $OUTPUTDIRPATH/weka.jar "https://github.com/omerfdemir/wekascript/raw/master/weka.jar"
#weka.jar path
WEKAJAR=$OUTPUTDIRPATH/weka.jar
#Downloading responses.csv
wget -O $OUTPUTDIRPATH/responses.csv "https://raw.githubusercontent.com/omerfdemir/wekascript/master/responses.csv"
#responses.csv path
RESPONSESCSV=$OUTPUTDIRPATH/responses.csv
echo Please wait. This process may take 'while' depends on your computer specs.
while $ANIMATION; do for X in '-' '/' '|' '\'; do echo -en "\b$X" ; sleep 0.5; done; done &
#converting responses.csv to responses.arff
java -cp $WEKAJAR weka.core.converters.CSVLoader $RESPONSESCSV > $OUTPUTDIRPATH/responses.arff -B 512
#responses.arff path
RESPONSESARFF=$OUTPUTDIRPATH/responses.arff
#Numeric to Nominal 1-73,76-107,110-132,134-140 Columns
java -cp  $WEKAJAR weka.filters.unsupervised.attribute.NumericToNominal -R 1-73,76-107,110-132,134-140 -i $RESPONSESARFF -o $OUTPUTDIRPATH/responses2.arff
#responses2.arff path
RESPONSES2ARFF=$OUTPUTDIRPATH/responses2.arff
#Remove 1,20,61,133,144,146,148-149 Columns
java -cp $WEKAJAR weka.filters.unsupervised.attribute.Remove -R 1,20,61,133,144,146,148-149 -i $RESPONSES2ARFF -o $OUTPUTDIRPATH/responses3.arff
#responses3.arff path
RESPONSES3ARFF=$OUTPUTDIRPATH/responses3.arff
#Discritize for Age
java -cp $WEKAJAR weka.filters.unsupervised.attribute.Discretize -B 4 -M -1.0 -R 137 -i $RESPONSES3ARFF -o $OUTPUTDIRPATH/responses4.arff
#responses4.arff path
RESPONSES4ARFF=$OUTPUTDIRPATH/responses4.arff
mkdir $OUTPUTDIRPATH/before.resample
BEFORERESAMPLEPATH=$OUTPUTDIRPATH/before.resample
#Age ZeroR
java -cp $WEKAJAR weka.classifiers.rules.ZeroR -c 137  -t $RESPONSES4ARFF > $BEFORERESAMPLEPATH/Age.zeroR.txt
#Education ZeroR
java -cp $WEKAJAR weka.classifiers.rules.ZeroR -c 141  -t $RESPONSES4ARFF > $BEFORERESAMPLEPATH/Education.zeroR.txt
#Gender ZeroR
java -cp $WEKAJAR weka.classifiers.rules.ZeroR -c 140  -t $RESPONSES4ARFF > $BEFORERESAMPLEPATH/Gender.zeroR.txt
#Age J48 minNumObj = 3 CrossValidation = 15
java -cp $WEKAJAR weka.classifiers.trees.J48 -c 137 -M 3 -x 15 -t $RESPONSES4ARFF > $BEFORERESAMPLEPATH/Age.J48.txt
#Education J48 minNumObj = 3 CrossValidation = 15
java -cp $WEKAJAR weka.classifiers.trees.J48 -c 141 -M 3 -x 15 -t $RESPONSES4ARFF > $BEFORERESAMPLEPATH/Education.J48.txt
#Gender J48 minNumObj = 3 CrossValidation = 15
java -cp $WEKAJAR weka.classifiers.trees.J48 -c 140 -M 3 -x 15 -t $RESPONSES4ARFF > $BEFORERESAMPLEPATH/Gender.J48.txt
#Age NaiveBayes -D True
java -cp $WEKAJAR weka.classifiers.bayes.NaiveBayes -c 137 -D -t $RESPONSES4ARFF > $BEFORERESAMPLEPATH/Age.NaiveBayes.txt
#Education NaiveBayes -D True
java -cp $WEKAJAR weka.classifiers.bayes.NaiveBayes -c 141 -D -t $RESPONSES4ARFF > $BEFORERESAMPLEPATH/Education.NaiveBayes.txt
#Gender NaiveBayes -D True
java -cp $WEKAJAR weka.classifiers.bayes.NaiveBayes -c 140 -D -t $RESPONSES4ARFF > $BEFORERESAMPLEPATH/Gender.NaiveBayes.txt
#Age IBk(kNN) kNN=10 FiltedNeighbourSearch
java -cp $WEKAJAR weka.classifiers.lazy.IBk -K 10 -W 0 -A "weka.core.neighboursearch.FilteredNeighbourSearch -F \"weka.filters.AllFilter \" -S \"weka.core.neighboursearch.LinearNNSearch -A \\\"weka.core.EuclideanDistance -R first-last\\\"\"" -c 137  -t $RESPONSES4ARFF > $BEFORERESAMPLEPATH/Age.IBk.txt
#Education IBk(kNN) kNN=10 FiltedNeighbourSearch
java -cp $WEKAJAR weka.classifiers.lazy.IBk -K 10 -W 0 -A "weka.core.neighboursearch.FilteredNeighbourSearch -F \"weka.filters.AllFilter \" -S \"weka.core.neighboursearch.LinearNNSearch -A \\\"weka.core.EuclideanDistance -R first-last\\\"\"" -c 141  -t $RESPONSES4ARFF > $BEFORERESAMPLEPATH/Education.IBk.txt
#Gender IBk(kNN) kNN=10 FiltedNeighbourSearch
java -cp $WEKAJAR weka.classifiers.lazy.IBk -K 10 -W 0 -A "weka.core.neighboursearch.FilteredNeighbourSearch -F \"weka.filters.AllFilter \" -S \"weka.core.neighboursearch.LinearNNSearch -A \\\"weka.core.EuclideanDistance -R first-last\\\"\"" -c 140  -t $RESPONSES4ARFF > $BEFORERESAMPLEPATH/Gender.IBk.txt
#Age SMO(SVM) NormalizedPolyKernel
java -cp $WEKAJAR weka.classifiers.functions.SMO -C 1.0 -L 0.001 -P 1.0E-12 -N 0 -V -1 -W 1 -K "weka.classifiers.functions.supportVector.NormalizedPolyKernel -C 250007 -E 2.0" -c 137  -t $RESPONSES4ARFF > $BEFORERESAMPLEPATH/Age.SMO.txt
#Education SMO(SVM) NormalizedPolyKernel
java -cp $WEKAJAR weka.classifiers.functions.SMO -C 1.0 -L 0.001 -P 1.0E-12 -N 0 -V -1 -W 1 -K "weka.classifiers.functions.supportVector.NormalizedPolyKernel -C 250007 -E 2.0" -c 141  -t $RESPONSES4ARFF > $BEFORERESAMPLEPATH/Education.SMO.txt
#Gender SMO(SVM) NormalizedPolyKernel
java -cp $WEKAJAR weka.classifiers.functions.SMO -C 1.0 -L 0.001 -P 1.0E-12 -N 0 -V -1 -W 1 -K "weka.classifiers.functions.supportVector.NormalizedPolyKernel -C 250007 -E 2.0" -c 140  -t $RESPONSES4ARFF > $BEFORERESAMPLEPATH/Gender.SMO.txt
#Age DecisionStump CrossValidation = 5
java -cp $WEKAJAR weka.classifiers.trees.DecisionStump -x 5 -c 137  -t $RESPONSES4ARFF > $BEFORERESAMPLEPATH/Age.DecisionStump.txt
#Education DecisionStump CrossValidation = 5
java -cp $WEKAJAR weka.classifiers.trees.DecisionStump -x 5 -c 141  -t $RESPONSES4ARFF > $BEFORERESAMPLEPATH/Education.DecisionStump.txt
#Gender DecisionStump CrossValidation = 5
java -cp $WEKAJAR weka.classifiers.trees.DecisionStump -x 5 -c 140  -t $RESPONSES4ARFF > $BEFORERESAMPLEPATH/Gender.DecisionStump.txt
#Resample (Default)
java -cp  $WEKAJAR weka.filters.unsupervised.instance.Resample -S 1 -Z 100.0 -i $RESPONSES4ARFF -o $OUTPUTDIRPATH/responses5.arff
#responses5.arff path
RESPONSES5ARFF=$OUTPUTDIRPATH/responses5.arff
mkdir $OUTPUTDIRPATH/after.resample
AFTERRESAMPLEPATH=$OUTPUTDIRPATH/after.resample
#Age J48 Default
java -cp $WEKAJAR weka.classifiers.trees.J48 -c 137 -M 2 -x 10 -t $RESPONSES5ARFF > $AFTERRESAMPLEPATH/Age.J48.txt
#Education J48 Default
java -cp $WEKAJAR weka.classifiers.trees.J48 -c 141 -M 2 -x 10 -t $RESPONSES5ARFF > $AFTERRESAMPLEPATH/Education.J48.txt
#Gender J48 Default
java -cp $WEKAJAR weka.classifiers.trees.J48 -c 140 -M 2 -x 10 -t $RESPONSES5ARFF > $AFTERRESAMPLEPATH/Gender.J48.txt
#Age IBk kNN = 1 Cross Validation = True
java -cp $WEKAJAR weka.classifiers.lazy.IBk -X -K 2 -W 0 -A "weka.core.neighboursearch.FilteredNeighbourSearch -F \"weka.filters.AllFilter \" -S \"weka.core.neighboursearch.LinearNNSearch -A \\\"weka.core.EuclideanDistance -R first-last\\\"\"" -c 137  -t $RESPONSES5ARFF > $AFTERRESAMPLEPATH/Age.IBk.txt
#Education IBk kNN = 1 Cross Validation = True
java -cp $WEKAJAR weka.classifiers.lazy.IBk -X -K 2 -W 0 -A "weka.core.neighboursearch.FilteredNeighbourSearch -F \"weka.filters.AllFilter \" -S \"weka.core.neighboursearch.LinearNNSearch -A \\\"weka.core.EuclideanDistance -R first-last\\\"\"" -c 141  -t $RESPONSES5ARFF > $AFTERRESAMPLEPATH/Education.IBk.txt
#Gender IBk kNN = 1 Cross Validation = True
java -cp $WEKAJAR weka.classifiers.lazy.IBk -X -K 2 -W 0 -A "weka.core.neighboursearch.FilteredNeighbourSearch -F \"weka.filters.AllFilter \" -S \"weka.core.neighboursearch.LinearNNSearch -A \\\"weka.core.EuclideanDistance -R first-last\\\"\"" -c 140  -t $RESPONSES5ARFF > $AFTERRESAMPLEPATH/Gender.IBk.txt
#Age BayesNet CrossValidation = 15
java -cp $WEKAJAR weka.classifiers.bayes.BayesNet -c 137 -x 15 -l -t $RESPONSES5ARFF -D -Q weka.classifiers.bayes.net.search.local.K2 -- -P 1 -S BAYES -E weka.classifiers.bayes.net.estimate.SimpleEstimator -- -A 0.5 > $AFTERRESAMPLEPATH/Age.BayesNet.txt
#Education BayesNet CrossValidation = 15
java -cp $WEKAJAR weka.classifiers.bayes.BayesNet -c 141 -x 15 -l -t $RESPONSES5ARFF -D -Q weka.classifiers.bayes.net.search.local.K2 -- -P 1 -S BAYES -E weka.classifiers.bayes.net.estimate.SimpleEstimator -- -A 0.5 > $AFTERRESAMPLEPATH/Education.BayesNet.txt
#Gender BayesNet CrossValidation = 15
java -cp $WEKAJAR weka.classifiers.bayes.BayesNet -c 140 -x 15 -l -t $RESPONSES5ARFF -D -Q weka.classifiers.bayes.net.search.local.K2 -- -P 1 -S BAYES -E weka.classifiers.bayes.net.estimate.SimpleEstimator -- -A 0.5 > $AFTERRESAMPLEPATH/Gender.BayesNet.txt
#Age SMO CrossValidation = 15
java -cp $WEKAJAR weka.classifiers.functions.SMO -x 15 -C 1.0 -L 0.001 -P 1.0E-12 -N 0 -V -1 -W 1 -K "weka.classifiers.functions.supportVector.NormalizedPolyKernel -C 250007 -E 2.0" -c 137  -t $RESPONSES5ARFF > $AFTERRESAMPLEPATH/Age.SMO.txt
#Education SMO CrossValidation = 15
java -cp $WEKAJAR weka.classifiers.functions.SMO -x 15 -C 1.0 -L 0.001 -P 1.0E-12 -N 0 -V -1 -W 1 -K "weka.classifiers.functions.supportVector.NormalizedPolyKernel -C 250007 -E 2.0" -c 141  -t $RESPONSES5ARFF > $AFTERRESAMPLEPATH/Education.SMO.txt
#Gender SMO CrossValidation = 15
java -cp $WEKAJAR weka.classifiers.functions.SMO -x 15 -C 1.0 -L 0.001 -P 1.0E-12 -N 0 -V -1 -W 1 -K "weka.classifiers.functions.supportVector.NormalizedPolyKernel -C 250007 -E 2.0" -c 140  -t $RESPONSES5ARFF > $AFTERRESAMPLEPATH/Gender.SMO.txt
#Age KStar missingMode = ignoreMissingValues
java -cp $WEKAJAR weka.classifiers.lazy.KStar -B 20 -M d -c 137  -t $RESPONSES5ARFF > $AFTERRESAMPLEPATH/Age.KStar.txt
#Education KStar missingMode = ignoreMissingValues
java -cp $WEKAJAR weka.classifiers.lazy.KStar -B 20 -M d -c 141  -t $RESPONSES5ARFF > $AFTERRESAMPLEPATH/Education.KStar.txt
#Gender KStar missingMode = ignoreMissingValues
java -cp $WEKAJAR weka.classifiers.lazy.KStar -B 20 -M d -c 140  -t $RESPONSES5ARFF > $AFTERRESAMPLEPATH/Gender.KStar.txt
#Age SimpleLogistic CrossValidation = 15
java -Xmx2g -cp $WEKAJAR weka.classifiers.functions.SimpleLogistic -I 0 -M 500 -H 50 -W 0.0 -c 137 -x 15  -t $RESPONSES5ARFF > $AFTERRESAMPLEPATH/Age.SimpleLogistic.txt
#Education SimpleLogistic CrossValidation = 15
java -Xmx2g -cp $WEKAJAR weka.classifiers.functions.SimpleLogistic -I 0 -M 500 -H 50 -W 0.0 -c 141 -x 15  -t $RESPONSES5ARFF > $AFTERRESAMPLEPATH/Education.SimpleLogistic.txt
#Gender SimpleLogistic CrossValidation = 15
java -Xmx2g -cp $WEKAJAR weka.classifiers.functions.SimpleLogistic -I 0 -M 500 -H 50 -W 0.0 -c 140 -x 15  -t $RESPONSES5ARFF > $AFTERRESAMPLEPATH/Gender.SimpleLogistic.txt
#Association Learning and Correlation
#Data removal
java -cp $WEKAJAR weka.filters.unsupervised.attribute.Remove -R 1,20,61,133,144,146,148-149 -i $RESPONSESARFF -o $OUTPUTDIRPATH/responses7.arff
#NumerictoNominal except Age
java -cp  $WEKAJAR weka.filters.unsupervised.attribute.NumericToNominal -R 1-136,138-141 -i $OUTPUTDIRPATH/responses7.arff -o $OUTPUTDIRPATH/responses8.arff
#Discretize for Age B-4
java -cp $WEKAJAR weka.filters.unsupervised.attribute.Discretize -B 4 -M -1.0 -R 137 -i $OUTPUTDIRPATH/responses8.arff -o $OUTPUTDIRPATH/responses9.arff
#responses9.arff path
RESPONSES9ARFF=$OUTPUTDIRPATH/responses9.arff
mkdir $OUTPUTDIRPATH/appriori
APPRIORIPATH=$OUTPUTDIRPATH/appriori
#Appriori Confidence
java -Xmx2g -cp $WEKAJAR weka.associations.Apriori -N 25 -T 0 -C 0.5 -D 0.05 -U 1.0 -M 0.1 -S -1.0 -c -1  -t $RESPONSES9ARFF > $APPRIORIPATH/Appriori.Confidence.txt
#Appriori Lift
java -Xmx2g -cp $WEKAJAR weka.associations.Apriori -N 25 -T 1 -C 0.5 -D 0.05 -U 1.0 -M 0.1 -S -1.0 -c -1  -t $RESPONSES9ARFF > $APPRIORIPATH/Appriori.Lift.txt
#Appriori Leverage
java -Xmx2g -cp $WEKAJAR weka.associations.Apriori -N 25 -T 2 -C 0.1 -D 0.05 -U 1.0 -M 0.1 -S -1.0 -c -1  -t $RESPONSES9ARFF > $APPRIORIPATH/Appriori.Leverage.txt
#Appriori Conviction
java -Xmx2g -cp $WEKAJAR weka.associations.Apriori -N 25 -T 3 -C 1.1 -D 0.05 -U 1.5 -M 0.1 -S -1.0 -c -1  -t $RESPONSES9ARFF > $APPRIORIPATH/Apriori.Conviction.txt
mkdir $OUTPUTDIRPATH/correlation
CORRELATIONPATH=$OUTPUTDIRPATH/correlation

#Age Correlation
java -cp $WEKAJAR weka.attributeSelection.CorrelationAttributeEval -i $RESPONSES9ARFF -s "weka.attributeSelection.Ranker -T -1.7976931348623157E308 -N -1" -c 137  > $CORRELATIONPATH/Age.Correlation.txt
#Education Correlation
java -cp $WEKAJAR weka.attributeSelection.CorrelationAttributeEval -i $RESPONSES9ARFF -s "weka.attributeSelection.Ranker -T -1.7976931348623157E308 -N -1" -c 141  > $CORRELATIONPATH/Education.Correlation.txt
#Gender Correlation
java -cp $WEKAJAR weka.attributeSelection.CorrelationAttributeEval -i $RESPONSES9ARFF -s "weka.attributeSelection.Ranker -T -1.7976931348623157E308 -N -1" -c 140  > $CORRELATIONPATH/Gender.Correlation.txt
ANIMATION=false
