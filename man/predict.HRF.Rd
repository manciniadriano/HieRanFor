% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/predict.HRF.R
\name{predict.HRF}
\alias{predict.HRF}
\title{For all cases, the proportion of OOB votes that each class received in
each local randomForest classifier.}
\usage{
\method{predict}{HRF}(object, train.predict = TRUE, new.data = NULL,
  new.data.case.ID = 1, new.data.exp.var = c(2:ncol(new.data)),
  bind.train.new = FALSE, ...)
}
\arguments{
\item{object}{Object of class \code{"HRF"} - the output of
  \code{RunHRF}.}

\item{train.predict}{Logical, if \code{TRUE}, returns for each case in
  the training data the proportion of OOB votes that each class received in
  each local randomForesst classifier. If \code{FALSE}, only the votes for
  \code{new.data} are returned.}

\item{new.data}{Optional data frame containing additional cases
  that were note a part of the original training set, for which the
  proportion of votes should be extracted.}

\item{new.data.case.ID}{Integer, specifying the column number with the
  \code{case.ID} in the \code{new.data} data frame. The \code{case.ID} values
  should be unique and different from those in the training data.}

\item{new.data.exp.var}{Vector of integers, specifying the columns of
  \code{new.data} that contains the same set of explanatory variables as used
  in the training of \code{hie.RF}. Before running the \code{RunHRF}, we
  recommend using the \code{link{JoinLevels}} function on each categorical
  variables to ensure the extraction of votes for \code{new.data}.}

\item{bind.train.new}{Logical, if \code{TRUE} the cases in the training
  set and \code{new.data} will be returned as one output data frame (along
  with the two separate ones).}

\item{\dots}{Optional parameters to be passed to the low level functions.}
}
\value{
a list consisting of up to three of the following data frames:
\item{prop.vote.train}{The proportion of OOB votes that each case from the
  training dataset received in each local classifier for each class.}
\item{prop.vote.new}{The proportion of OOB votes that each case from the
  \code{new.data} dataset received in each local classifier for each class.}
\item{prop.vote.full}{Bind of \code{prop.vote.train} and \code{prop.vote.new}
if \code{bind.train.new} is \code{TRUE}.}
}
\description{
The function takes as input an object of class \code{"HRF"}. For each case in
the original training data or in \code{new.data}, the function extracts the
proportion of OOB votes for each node (internal and terminal) in each local
classifier.
}
\details{
For the training data, only OOB votes are used in each local
classifier.\cr
Inherited from \code{\link{randomForest}}, predictions for \code{new.data}
cannot be made if the \code{new.data} contains factor levels (both for
classes and for categorical explanatory variables) that were not represented
in the training data. Before running \code{RunHRF} we recommend either
sub-setting the training and new data from one general data frame or running
the \code{\link{JoinLevels}} function on each categorical variable.
}
\examples{
set.seed(354)
random.hRF <- RandomHRF(num.term.nodes = 20, tree.depth = 4)
train.data <- random.hRF$train.data
new.data   <- random.hRF$new.data

# run HRF
hie.RF.random <- RunHRF(train.data = train.data,
                        case.ID    = "case.ID",
                        hie.levels = c(2:(random.hRF$call$tree.depth + 1)))

# predict only for the training data
Predict.HRF.train    <- predict(hie.RF.random)
prop.votes.lRF.train <- Predict.HRF.train$prop.vote.train

# predict only for new.data
Predict.HRF.new <- predict(object           = hie.RF.random,
                           train.predict    = FALSE,
                           new.data         = new.data,
                           new.data.case.ID = 1,
                           new.data.exp.var = c(2:ncol(new.data)),
                           bind.train.new   = FALSE)
prop.votes.lRF.new <- Predict.HRF.new$prop.vote.new

# predict for training and new data + bind

Predict.HRF.both <- predict(object = hie.RF.random,
                            train.predict    = TRUE,
                            new.data         = new.data,
                            new.data.case.ID = 1,
                            new.data.exp.var = c(2:ncol(new.data)),
                            bind.train.new   = TRUE)
attributes(Predict.HRF.both)
prop.votes.lRF.both <- Predict.HRF.both$prop.vote.full

# the prop.votes.lRF.both data frame contains
# one additional column: 'train.or.test'
# cases from the training data sat are listed as train
# cases from the new.data data set are listed as test
names(prop.votes.lRF.both)[1]
levels(prop.votes.lRF.both$train.or.test)
}
\author{
Yoni Gavish <gavishyoni@gmail.com>
}
\seealso{
\code{\link{RunHRF}} for running a hierarchical randomForest analysis,
\code{\link{GetMultPropVotes}} for estimating the multiplicative proportion
of votes from the output of \code{predict.HRF}, \code{\link{PerformanceHRF}}
for assessing performance and accuracy, \code{\link{PredictNewHRF}} for
predicting crisp class for each case of \code{new.data}.
}

