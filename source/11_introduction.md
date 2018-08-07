# Introduction

## Thesis Overview

...Introductory note on networks.
- (network what that is, where there are, why its interesting)

In the other hand, Machine Learning is a discipline at the crossroad of applied mathematics and computer science that aims to build algorithms able to explore various kind of observable information such as texts, images or time-series for example. The exploration leads to the co such texts, images or time-series for examplenstruction of an abstract view of the observable information, also called the training data, or just "the data". This abstract view is refered as a model and is used to accomplish some prediction tasks on unobserved or future outcomes. The processus of (machine) learning consists of fitting a model with the data which is generally reduced to a mathematical optimisation [[Most of the time, the learning process can be cast into on optimization problem, but not always, as for MCMC techniques (see chapter \ref{sec:mcmc})]] for example, ]] problem of an objective function which mesures, in some sense, how well the model explain the data.

The context of this thesis is the study of complex networks under the viewpoint of machine learning.
The objectives are to understand what models are adapted for networks and why, and to propose new models that overcome current limitation to improve prediction  of real world networks.

## Thesis Outline

This thesis is organised in 4 chapters. The chapters 2 review the state of the art of the topic. In particular, it reviews the state of the art by answering each of the following questions:

* what kind of data are we interested in and why \ref{sec:networks_type} \ref{sec:network_property} ?
* what kind of prediction tasks we want to solve with those models \ref{sec:network_application} ?
* what models exist to extract knowledge from the data and infer new outcomes \ref{sec:network_model} ?
* what learning process is used to fit the model with the data \ref{sec:network_inference} ?


In chapter 3, we focus on two powerful proposed probabilistic model and several real-wolrd network properties. We proposed definitions of these properties adapted to a probabilistic context and we assess how the models comply with the latter.

Chapter 3, 4 and 5 constitute the heart of the thesis, and the contributions of this thesis, that can be resume as folllows:

* We ask wheter a certain class of powerful probabilistic models, namely the class of stochastic block models, comply with two important properties find in real world networks, namely the preferential attachment and the homophily \ref{sec:blockmodel_property}. More specifically we study two models, the \ifm and 
* 



The data of interest in this thesis are complex networks. Whithout restrictions, a complex networks represents a set of objects that have some relations between them. The study 





