# Introduction


## Thesis Overview

Networks are ubiquitous data structures that allow the representation of interactions between objects. Complex networks encompasses real-world networks with non-trivial structural properties such as social networks of individuals in the society or information networks constituted of interconnected documents. For instance, one could think about the Web, constituted of web pages interconnected by hyperlinks, or the academic papers connected by citations. Their study comes with many exciting questions concerning the laws that govern them, their dynamics and their invariant properties. Such questions are motivated by a better understanding of the *emergent* phenomena raised by the formation of complex interacting systems as well as the development of tools to enhance their analysis. The analysis of complex networks is a modern field of science and represents an opportunity for many scientific communities to interact and share knowledge between each others due to the diversity of the sources from where networks arise on one side, and the common phenomena that occur in their midst in the other.

On the other hand, Machine Learning is a discipline at the crossroad of applied mathematics and computer science that aims to build algorithms able to *explore* various kinds of observable information such as texts, images, time-series or networks.
The purpose of this exploration is to shape an abstract view of the observable information, also called the training data. This abstract view is referred to as a model and is used to accomplish some prediction tasks on unobserved or future outcomes.
The process of (machine) learning consists of fitting a model with the data which, in general, reduced to a mathematical optimization problem ^[Most of the time, the learning process can be cast into an optimization problem, but not always, as for MCMC techniques (\ref{sec:network_inference}) for example.] of an objective function which measures, in some sense, how well the model explains the data. A Machine Learning model can be seen as a data "observer" that tries to explain the data it observes. However, as one can imagine, the observation of "complex" data may result to many different interpretations depending on the beliefs of the observer, and thus choosing a "good" explanation, or model, is uncertain. Probabilistic Machine Learning is a general framework used to develop models that incorporate beliefs and deals with the uncertainty. A decisive question though, is the choice of the appropriate beliefs and degree of uncertainty according to the data to observe, and ultimately the decisions to make regarding these data.

The context of this thesis is to study and develop probabilistic machine learning based approaches towards complex networks analysis.
The objectives are to understand what models are adapted for complex networks and why, and to propose new models that overcome current limitation to improve prediction tasks on real-world networks. In particular, we studied a family of probabilistic models characterized by hierarchical relations of latent variables that provide a rich framework to capture network properties and develop statistical procedures (i.e. inference) that efficiently extract information from network datasets, predict their evolution, while controlling the uncertainty levels that are inherent to complex networks.

## Thesis Outline

This manuscript is organized into 5 chapters. 
The Chapters 2 and 3 review the state of the art of the topic. They are devoted to set the background of the main results of this thesis and to put them in perspective by exposing the associated relevant literature, and gives some fundamental theoretical building blocks. In particular, Chapter 2 focus on complex networks analysis and mining aspects by reviewing some of the key properties observed in real networks and applications. In Chapter 3, we focus on the probabilistic framework for random graph models and theoretic foundations. Our motivations in those preliminaries chapters are to provide elements of response of the following questions:

* What kind of network data are we interested in and what are their properties? (\ref{sec:network_type}, \ref{sec:network_property})
* What kind of prediction tasks do we want to solve with those models?  (\ref{sec:network_application})
* What models exist to extract knowledge from the data and infer new outcomes, and what are the theoretic foundations of the model of interest? (\ref{sec:network_model}, \ref{sec:random_graph})
* What learning processes and inference methods are used to fit the models with the data? (\ref{sec:network_inference}, \ref{sec:non_parametric})

The Chapters 4 and 5 constitute the heart of this thesis. The contributions can be resumed as follows:

* In Chapter 3, We ask whether a certain class of powerful probabilistic models, namely the class of stochastic block models, comply with two important properties found in real-world networks, namely the preferential attachment and the homophily. More specifically we study two probabilistic models, the \ifm and the \imb and show that in their standard formulation they do not comply with the homophily and the preferential attachment. However, we show that \imb comply with the local preferential attachment where only edge within communities are considered.
* In Chapter 4, we proposed a new stochastic block model that extends the \imb model in order to model weighted networks. Particularly, a hierarchical Beta-Gamma prior is proposed to have a flexible block-block parameter distributions. We develop an efficient inference algorithm able to scale on networks with millions of edges, and we evaluate and compare the model with various types of large real-world networks. We empirically show that the performance on the link prediction task can be improved when the networks are partially observed.

<!--In chapter 6, we present our model implementation through a platform that we released under an open source license. The platform implement a design pattern to help the development and sharing of complex experiments.-->


