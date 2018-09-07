# Appendix 2: Gibbs updates for ILFM
\label{annexe:wmmsb}

We change the variable name from $\Theta, \Phi$ to $F, W$ in order to have consistent notation with the original ILFM paper.

The goal of the inference is to recover the posterior densities $P(W,F \mid Y) \propto P(Y \mid F, W)P(F)P(W)$.

We use use a sampling approach by MCMC method to learn the hidden variables of the model F and W. Namely we use a Gibbs sampling for features matrix $F$ and a Metropolis-Hasting for sampling the new features from the IPB as well as the weight matrix $W$ since it is not in a conjugate of the likelihood. The sampling algorithm is summarized in Algorithm \ref{algo:mcmc_ilfm}.

## Feature updates
The learning of the feature matrix $F$ is computed in 2 stages. For each entity we need to update each non-unique features \footnote{Non-unique means that feature belongs to more than one entity.}. Then, for the unique features to this entity we need to add possibly $k^{new}$ features.


The sampling of each $f_{ik}$ is given by the following conditional posterior:
\begin{equation} \label{eq:ibp_gibbs}
P(f_{ik}=1 \mid Y, F_{-(ik)}, W) = \frac{P(Y \mid W, F_{-(ik)}, f_{ik}=1)P(f_{ik}=1 \mid F_{-(ik)})}{\sum_{f_{ik}} P(Y \mid W, F_{-(ik)}, f_{ik})P(f_{ik} \mid F_{-(ik)})}
\end{equation}

The result from the IPB give us the following results for the Gibbs update for the feature $k$:
\begin{align}
& P(f_{ik} = 1 \mid F_{-(ik)}) = \frac{m_{-i,k}}{N} \\
& P(f_{ik} = 0 \mid F_{-(ik)}) = 1 - \frac{m_{-i,k}}{N}
\end{align}

Where $m_{-i,k}$ represent the number of active features $k$ for all entities excluding entity $i$, hence $m_{-i,k} = \sum_{j\neq i}f_{jk}$. 
After sampling $k$ features for a particular entity $i$, we need to evaluate the new features who should be associated with this entity $i$. The probability to have $k_i^{new}$ features is proportional to this density:
\begin{equation} \label{eq:1}
P(k_i^{new} \mid Y, F, \alpha) \propto P(Y \mid F^{new})P(k_i^{new} \mid \alpha)
\end{equation}

The probability of having $k_i^{new}$ features is drawn from a $\mathrm{Poisson(\frac{\alpha}{N})}$ distribution in the IPB process. However, we also need to sample the $\mathbf{w}_i$ weights associated with those features, and in our case, the density of weights are not conjugate of the likelihood. In consequence, we cannot integrate them out as explicitly assumed in the equation \eqref{eq:1}. We follow the approach of [@BMF] to jointly sample the new features and the weights using a Metropolis-Hasting method. Thanks to the  exchangeability of the IPB we only need to consider features unique to entity $i$ to either propose or reject new features. Therefore, we reference by a superscript $B$ the set of model parameters corresponding to unique features. A convenient choice of jumping distribution is:

\begin{equation} \label{eq:j_knew}
J(k_i^{new}, \mathbf{w}_i^{new} \mid k_i^B, \mathbf{w}_i^B) = \mathrm{Poisson}(k_i^{new} \mid \alpha) \mathcal{N}(\mathbf{w}_i^{new} \mid \sigma_w)
\end{equation}

The acceptance ratio can thus be written as:
\begin{equation}
r_{B\rightarrow new} = \frac{P(k_i^{new}, \mathbf{w}_i^{new} \mid Y, W, F, \alpha) J(k_i^{B}, \mathbf{w}_i^{B} \mid k_i^{new}, \mathbf{w}_i^{new})}{P(k_i^B, \mathbf{w}_i^B \mid Y, W, F, \alpha) J(k_i^{new}, \mathbf{w}_i^{new} \mid k_i^B, \mathbf{w}_i^B)}
\end{equation}

When replacing by equation \eqref{eq:1} and \eqref{eq:j_knew}, the acceptance ratio simplify to the ratio of data likelihoods:

\begin{equation} \label{eq:r_knew} 
r_{B\rightarrow new} = \frac{P(Y \mid F^{new}, W^{new})}{P(Y \mid F, W)}
\end{equation}

## Weight updates

The learning of the weight matrix $W$ is approximated using a Metropolis-Hasting algorithm. Thus, we sample sequentially each weight corresponding to non-zeros features interaction.
\begin{equation}
P(w_{kl} \mid Y, F, W_{-kl}, \sigma_w) \propto P(Y \mid F, W) P(w_{kl} \mid \sigma_w)
\end{equation}

We choose a jumping distribution in the same family of our prior on weight centered around the previous sample:

\begin{equation} \label{eq:j_w}
J(w_{kl}^* \mid w_{kl}) = \mathcal{N}(w_{kl}, \eta)
\end{equation}
with $\eta$ a parameter letting us controlling the acceptance ratio.

The acceptance ratio of $w_{kl}^*$ is thus:
\begin{equation} \label{eq:r_w}
r_{w_{kl}\rightarrow w_{kl}^*} = \frac{ P(Y \mid F, W^*)P(w_{kl}^* \mid \sigma_w)J(w_{kl} \mid w_{kl}^*) }{ P(Y \mid F, W)P(w_{kl} \mid \sigma_w)J(w_{kl}^* \mid w_{kl} )}
\end{equation}

## Hyper-parameter optimization

Optimization rules for  $\alpha$ is given in \ref{sec:ibp_inference}.

\begin{algorithm}
%\dontprintsemicolon
\KwIn{$Y$, $\alpha$, $\sigma_w$, $\eta$}
\KwSty{Initialize:} $F$, $W$,  randomly \\
%\Begin{}

\ForEach{entities $i \in \{1,..,N\}$ }{ %feature updates
    \ForEach{represented features $k \in \{1,..,K^+\}$}{
        \If{$ m_{-i,k} > 0$}{
             Update $f_{ik}$ using equantion \eqref{eq:ibp_gibbs} }
    }
    Draw candidate for $k_i^{new}$ and $\mathbf{w}_i^{new}$ using equation \eqref{eq:j_knew} \\
    Accept candidate with probability $\mathrm{min}(1, r_{B\rightarrow new} )$
}

\ForEach{weights $w_{kl} \in W$ }{ %weight updates
    Draw candidate for $w_{kl}^*$ using equation \eqref{eq:j_w} \\
    Accept candidate with probability $\mathrm{min}(1, r_{w_{kl}\rightarrow w_{kl}^*} )$
}

Sample $\alpha$ from eq. \eqref{eq:alpha_ibp}

\caption{Parameters sampling of ILFM for one iteration step.}
\label{algo:mcmc_ilfm}
\end{algorithm}

