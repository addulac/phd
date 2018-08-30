# Introduction


## Thesis Overview

Networks are ubiquitous data structures that allow to represent interactions between objects. Complex networks encompass real-world networks with non-trivial structural properties such as social networks of individuals in the society or information networks of document ressources like academic papers, and magnified by the World Wide Web. Their study comes with many exciting questions concerning the law that governs complex networks, their dynamics, and their invariant properties which are motivated by a better understanging of the *emergent* phenomenons raised by the formation of complex interacting systems. The analysis of complex networks is a modern field of science that reprensents an oppurtunity for many scientific communities to interact and share knowledge between each others.

In the other hand, Machine Learning is a discipline at the crossroad of applied mathematics and computer science that aims to build algorithms able to *explore* various kind of observable information such as texts, images, time-series or networks.
The purpose of this exploration is to shape an abstract view of the observable information, also called the training data. This abstract view is referred as a model and is used to accomplish some prediction tasks on unobserved or future outcomes.
The processus of (machine) learning consists of fitting a model with the data which, in general, reduced to a mathematical optimisation problem ^[Most of the time, the learning process can be cast into an optimization problem, but not always, as for MCMC techniques (\ref{sec:mcmc}) for example.] of an objective function which mesures, in some sense, how well the model explain the data.

The context of this thesis is the study of complex networks with a machine learning approach.
The objectives are to understand what models are adapted for networks and why, and to propose new models that overcome current limitation to improve prediction tasks on real world networks.




## Thesis Outline

This thesis is organised in 4 chapters. 
The chapters 2 and 3 review the state of the art of the topic. In particular, chapter 2 focus on complex networks analysis and mining aspects while chapter 3 focus on the random graph theory and models aspects. Our motivations in those preliminaries chapter are to provide elements of response of the following questions:

* what kind of network data are we interested in and why? (\ref{sec:network_type}, \ref{sec:network_property})
* what kind of prediction tasks we want to solve with those models?  (\ref{sec:network_application})
* what models exist to extract knowledge from the data and infer new outcomes? (\ref{sec:network_model})
* what learning processes are used to fit the models with the data? (\ref{sec:network_inference})


The Chapters 4 and 5 constitute the heart of the thesis. The contributions can be resumed as follows:

* In chapter 3, We ask whether a certain class of powerful probabilistic models, namely the class of stochastic block models, comply with two important properties find in real world networks, namely the preferential attachment and the homophily. More specifically we study two probabilistic models, the \ifm and the \imb and show that in their standard formulation they do not comply with the homophily and the preferential attachment. However, we show that \imb comply with the local preferential attachment were only edge within communities are considered.
* In chapter 4, we proposed a new stochastic block model that extend the \imb model in order the model weighted networks. Particularly, a hierarchical beta-gamma prior is proposed to have a flexible block-block distributions parameters. We develop an efficient inference algorithm able to scale on networks with millions of edges and we evaluate and compare the model with various type of large real-world networks. We empirically show that the performance on the link prediction task can be improved when the networks are partially observed when modelling weights.

<!--In chapter 6, we present our model implementation through a platform that we released under an open source license. The platform implement a design pattern to help the development and sharing of complex experiments.-->


