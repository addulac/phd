# Introduction


## Thesis Overview

Networks are ubiquitous data structures that allow to represent interactions between objects. Complex networks encompass real-world networks with non-trivial structural properties such as social networks of individuals in the society or information networks of document resources like academic papers, and magnified by the World Wide Web. Their study comes with many exciting questions concerning the law that govern them, their dynamics, and their invariant properties. Such questions are motivated by a better understanding of the *emergent* phenomena raised by the formation of complex interacting systems as well as the development of tools to enhance their analysis. The analysis of complex networks is a modern field of science that represent an opportunity for many scientific communities to interact and share knowledge between each others due the diversity of the sources from where networks arise on one side, and the common phenomena that occur in their midst in the other.

In the other hand, Machine Learning is a discipline at the crossroad of applied mathematics and computer science that aims to build algorithms able to *explore* various kind of observable information such as texts, images, time-series or networks.
The purpose of this exploration is to shape an abstract view of the observable information, also called the training data. This abstract view is referred as a model and is used to accomplish some prediction tasks on unobserved or future outcomes.
The process of (machine) learning consists of fitting a model with the data which, in general, reduced to a mathematical optimisation problem ^[Most of the time, the learning process can be cast into an optimization problem, but not always, as for MCMC techniques (\ref{sec:network_inference}) for example.] of an objective function which measures, in some sense, how well the model explain the data.

The context of this thesis is to study and develop machine learning based approaches towards complex networks analysis.
The objectives are to understand what models are adapted for complex networks and why, and to propose new models that overcome current limitation to improve prediction tasks on real world networks. In particular, we studied a family of probabilistic models characterised by hierarchical relations of latent variables that provide a rich framework to capture networks properties and develop statistical procedures (i.e. inference) that efficiently extract information from network datasets while controlling the uncertainty levels that are inherent to complex networks.

## Thesis Outline

This thesis is organised in 4 chapters. 
The chapter 2 and 3 review the state of the art of the topic. They are devoted to put the main results of this thesis in perspective by exposing the associated relevant litterature. In particular, chapter 2 focus on complex networks analysis and mining aspects by reviewing some of the key properties of complex networks and applications. In the Chapter 3, we focus on the probabilistic framework for random graph models and theoritic foundations. Our motivations in those preliminaries chapter are to provide elements of response of the following questions:

* What kind of network data are we interested in and why? (\ref{sec:network_type}, \ref{sec:network_property})
* What kind of prediction tasks we want to solve with those models?  (\ref{sec:network_application})
* What models exist to extract knowledge from the data and infer new outcomes, and what are the theoritic foundations of the model of interest? (\ref{sec:network_model}, \ref{sec:random_graph})
* What learning processes and inference methods are used to fit the models with the data? (\ref{sec:network_inference}, \ref{sec:non_parametric})


The Chapters 4 and 5 constitute the heart of this thesis. The contributions can be resumed as follows:

* In chapter 3, We ask whether a certain class of powerful probabilistic models, namely the class of stochastic block models, comply with two important properties find in real world networks, namely the preferential attachment and the homophily. More specifically we study two probabilistic models, the \ifm and the \imb and show that in their standard formulation they do not comply with the homophily and the preferential attachment. However, we show that \imb comply with the local preferential attachment were only edge within communities are considered.
* In chapter 4, we proposed a new stochastic block model that extend the \imb model in order the model weighted networks. Particularly, a hierarchical Beta-Gamma prior is proposed to have a flexible block-block distributions parameters. We develop an efficient inference algorithm able to scale on networks with millions of edges and we evaluate and compare the model with various type of large real-world networks. We empirically show that the performance on the link prediction task can be improved when the networks are partially observed when modelling weights.

<!--In chapter 6, we present our model implementation through a platform that we released under an open source license. The platform implement a design pattern to help the development and sharing of complex experiments.-->


