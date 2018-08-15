# State of the Art 


## Context of the Study

The study of complex networks is grounded by the graph theory and in particular, for the statistical analysis of networks, by the random graph theory [@albert2002statistical][@Newman03]. The latter approach is particularly well adapted for complex networks because, by definition, their associated graphs haven't a *rigid* topological structure such as being acyclic, complete, or other specific symmetries in their connectivity patterns. This can be resumed by the statement: *a complex network is governed by simple assumptions*.
Meanwhile, using random structures provides a rich formalism to encode data priors and model the uncertainty through representation (\ref{sec:network_model}) that are sound with the assumptions made on the network [@orbanz2015bayesian].
A major difficulty in modelling complex networks is that there are several degrees of uncertainty in the topological structure and in the law that control the dynamics of a complex network.
This uncertainty makes the problem of finding a good model to explain the construction of a given network (and make prediction on it) ill-defined.
Besides, there is an other source of uncertainty that comes from the fact that there is no strong consensus about the semantics behind the construction of the network [@krackhardt1999ties]; what does it means that there exists a connection between two nodes in a network? Why and when a connection is established between two nodes? There is no obvious answer to those questions, and worse, the answer may not be the same depending on the type of the network considered (\ref{sec:network_type}). Even for two networks of similar type, the answer may differ for two different couple of nodes. For example, the notion of friendship in a social network can vary according to the country or the culture considered. Or, for a hyperlink network, such as the Web^[The World Wide Web], a web page could points to another because the content is related in some way, or maybe because it references a sponsor, which are two completely different reasons.
Hence, to face this uncertainty we focus our study on probabilistic models as they provide a natural framework to build powerful and flexible model in this context [@ghahramani15_nature]. 

In the rest of the section, we gives a quick review the type of networks we are interested in. Then, we recall the basic properties of graphs and the application of interest our context. Finally, we introduce the models and inference scheme that are relevant to our work.

## Complex Network Analysis

### Network type
\label{sec:network_type}

Most of the scientific fields involved the study of interactions between set of objects which constitute a network. The datasets are often build 
Networks are  in plenty 

Les réseaux peuvent être issues d'un nombre très divers de domaines. Nous sommes très famillier avec certains réseaux qui nous entoure, surtout depuis l'emergence des technologie de l'information et des plateforme de réseaux sociaux online. En effet, les réseaux sociaux de type friendship, représente un grande partie des données utilisés par la communauté machine learning^[See the statistics on https://icon.colorado.edu and http://konect.uni-koblenz.de/]. Ils representent aussi un objet d'intéret pour les sciences sociales pour des evaluations empiriques.

De manière plus général, la catégorie de réseaux de type **Social Interaction** are used to study any kind of relation between individuals, humans or not. Here is a non exaustive list of such networks:

* *Friendship network*: The nodes of these networks represent individuals and an edge exists between two nodes if they have a friendship relation. Several online platform provide free dataset of the network of they users for academic research [@kunegis2013konect].
* *Communication network*: The nodes of these networks are constituted of sender and receiver actors and an edge is present if a message has been sent from the sender to the receiver. Such networks can be built from email exchange in a company for example [@klimt2004enron] or from phone call patterns [@aiello2001random].
* *Economic network*: click, rating, money loan
* *Predator-prey network*: They are used to represent food web. The nodes are the species and the edge indicates feeding relations [@lafferty2006parasites][@thompson2000resolution].
* *Sexual contact*:  Networks of sexual relation between individuals have attracted some attentions [@liljeros2001web].

Une autre source importante de réseaux se trouve dans les liens existant entre les documents textuelles. Ce sont les réseaux dit **Information Network**, et la sémantique de leurs construction est associé au format des documents représentant les noeuds du réseaux:

* *Citation network*:
* *Collaboration network*:
* *hyperlink network*:
* *lexical network*:



Recently, interesting metrics have also  been proposed in order to automatically construct taxonomies of networks [@onnela2012taxonomies].


#### Datasets

The networks datasets used in the machine learning community comes most of the times from each specialized 
* they are some well know website that maintains and classify datasets of networks to help the scientific community.
* they have been collected, formated an putting online by the unbiversity of "". There is large amount of network available where their descsiptio, statistics and source references made available.

### Basic properties
\label{sec:network_property}
* take the table for notation as in hdp.pdf to descibe variable, and text

### Applications
\label{sec:network_application}




## Random Graph Models
\label{sec:network_model}

[@goldenberg2010survey]



## Approximate Inference
\label{sec:network_inference}

### Markov Chain Monte Carlo
\label{sec:mcmc}

### Variational Inference
\label{sec:vb}

### Alternative Methods




## Other Approaches

