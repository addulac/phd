# Appendix 1: WMMSB inference derivations and complete results {.unnumbered}
\label{annexe:wmmsb}

## Derivation of the collapsed variational updates

The derivation of the collapsed variational updates is first obtained by maximizing the ELBO w.r.t $\gamma_{ijkk'}$ with:
\begin{align*}
\frac{\partial \L_Z}{\partial \gamma_{ijkk'}} &= \frac{\partial }{\partial \gamma_{ijkk'}}  \sum_{Z^{-ij}}\sum_{k_1=1}^K\sum_{k_2=1}^K  q(Z^{-ij}) \gamma_{ijk_1 k_2} (\log p(Y, Z^{-ij}, z_{i\rightarrow j}=k_1, z_{i\leftarrow j}=k_2|\Omega)+ \\
& \qquad \log q(Z^{-ij}, z_{i\rightarrow j}=k_1, z_{i\leftarrow j}=k_2) )   \\
&= E_{q(Z^{-ij})}[ p(Y, Z^{-ij}, z_{i\rightarrow j}=k, z_{i\leftarrow j}=k'|\Omega))] + H[Z^{-ij}] -\log(\gamma_{ijkk'}) +1
\end{align*}

By equating this derivative to zero, one obtains the following update:
\begin{equation} \label{eq1}
\gamma_{ijkk'} \propto \exp E_{q(Z^{-ij})} [\log P(z_{i\rightarrow j}=k, z_{i\leftarrow j}=k' | Y^{-ij}, Z^{-ij}, \Omega) ]
\end{equation}
with  $P(z_{i\rightarrow j}=k, z_{i\leftarrow j}=k' | Y^{-ij}, Z^{-ij}, \Omega)$ being the collapsed Gibbs update of WMMSB, of the form:
\begin{align*}
&P(z_{i\rightarrow j}=k, z_{i\leftarrow j}=k' |Y^{-ij}, Z^{-ij}, \Omega) \propto \\
& \qquad  (n_{\rightarrow ik}^{\Theta^{-j}} + \alpha_k) (n_{\leftarrow jk}^{\Theta^{-i}} + \alpha_{k'}) \mathrm{NB}\left(y_{ij}; n^{Y^{-ij}}_{kk'} + r, \frac{p}{p\,n^{\Phi^{-ij}}_{\bm{.}kk'} + 1} \right)
\end{align*}
with count statistics given by the following equations:
\begin{align*}                                                                                                                                        
&n^{\Theta}_{\rightarrow ik} = \sum_j \delta(\zij=k)\\
&n^{Y}_{kk'} = \sum_{ij} y_{ij}\delta(\zij=k, \zji=k') \\
&n^{\Phi}_{\bm{.}kk'} = \sum_{ij} \delta( \zij=k, \zji=k') 
\end{align*}   

By applying a first order Taylor expansion on Eq.\eqref{eq1}, following [@teh2007collapsed], one obtains:
\begin{align*}
\gamma_{ijkk'} \propto& (E_{q(Z^{-ij})}[n_{\rightarrow ik}^{\Theta^{-j}}] + \alpha_k)(E_{q(Z^{-ij})}[n_{\leftarrow jk}^{\Theta^{-i}}] + \alpha_{k'}) \\
  & \times \mathrm{NB}\left(y_{ij}; E_{q(Z^{-ij})}[n^{Y^{-ij}}_{kk'}] + r, \frac{p}{p\,E_{q(Z^{-ij})}[n^{\Phi^{-ij}}_{\bm{.}kk'}] + 1} \right) 
\end{align*}

Finally, using a Gaussian approximation (as in \textit{e.g.} [@asuncion2009smoothing]), one can estimate the expectations $E_{q(Z^{-ij})}[n_{\rightarrow ik}^{\Theta^{-j}}], E_{q(Z^{-ij})}[n_{\leftarrow jk}^{\Theta^{-i}}]$ and  $E_{q(Z^{-ij})}[n^{\Phi^{-ij}}_{\bm{.}kk'}]$ with the counts defined in Eq. \ref{eq:sss}.

## Beta-Gamma updates

In the WMMSB-bg model, the collapsed variational distribution takes the form:
\begin{equation*}
q(\Pi) = q(\Theta, \Phi|Z, R, P) q(Z)q(R)q(P)
\end{equation*}

The variational distribution for $r_{kk'}$ is taken in the Gamma family:  $q(r_{kk'}) = \textrm{Gamma}(a_{kk'},b_{kk'})$ for $1\leq k,k' \leq K$. The collapsed ELBO can thus be rewritten as:
\begin{align*}
\log p(Y) \geq \L_{Z,R,P} &= \E_{q}[\log p(Y, Z, R, P|\Omega)] + \textrm{H}[q(Z)] + \textrm{H}[q(R)] + \textrm{H}[q(P)] \\
                        &= \E_{q}[\log p(Y, Z)] + \textrm{H}[q(Z)] \\
                        &\qquad + \E_{q}[\log p(R|Y,Z,P)] + \textrm{H}[q(R)] \\
                        &\qquad +\E_{q}[\log p(P|Y,Z)] + \textrm{H}[q(P)] 
\end{align*}

### Optimizing $\gamma_{ijkk'}$

In the Beta-Gamma augmentation, the parameters $p$ and $r$ are marginalized in the update given by Eq. \eqref{eq1}:
\begin{equation}
\gamma_{ijkk'} \propto \exp E_{q(Z^{-ij})} [\log E_{q(r_{kk'})}[E_{q(p_{kk'})}[ P(z_{i\rightarrow j}=k, z_{i\leftarrow j}=k' | Y^{-ij}, Z^{-ij}, \Omega) ] ] ] \nonumber
\end{equation}

By using a first order Taylor expansion, one obtains:
\begin{equation}
\gamma_{ijkk'} \propto (N_{\rightarrow ik}^{\Theta^{-j}} + \alpha_k) (N_{\leftarrow jk'}^{\Theta^{-i}} + \alpha_{k'}) \mathrm{NB}\left(y_{ij}; N^{Y^{-ij}}_{kk'} + \E_{q}[r_{kk'}], \frac{\E_{q}[p_{kk'}]}{\E_{q}[p_{kk'}]\,N^{\Phi^{-ij}}_{\bm{.}kk'} + 1} \right) \nonumber
\end{equation}

### Optimizing $r_{kk'}$

We isolate the part of the ELBO than depends only on $r_{kk'}$ parameters ($a_{kk'}$ and $b_{kk'}$). Thus, we consider only the links that have been generated within the classes $k,k'$, denoted by $Y^{(kk')}$. Furthermore, as $y_{ij} \sim NB(r_{kk'}, p_{kk'})$ if $i$ is in class $k$ and $j$ in class $k'$, one has:
\begin{align*}
\L_{[r_{kk'}]} = \E_{q(r_{kk'})}[\log p(r_{kk'}|Y^{(kk')},Z^{(kk')},p_{kk'})] + \textrm{H}[q(r_{kk'})] \\
\end{align*}

By applying Bayes rules and dropping the normalizing term that does not depend on $r_{kk'}$, one gets:
\begin{align*}
\L_{[r_{kk'}]} &= \E_{q(r_{kk'})}[\log \left( p(Y^{(kk')}|Z^{(kk')}, r_{kk'}, p_{kk'}) p(r_{kk'}]) \right)] + \textrm{H}[q(r_{kk'})] \\
    &= \E_{q(r_{kk'})}[\log \left( \prod_{ij\in Y^{(kk')}} \dbinom{r_{kk'} + y_{ij}-1}{y_{ij}} (1-p_{kk'})^{r_{kk'}} p_k^{y_{ij}} p(r_{kk'}) \right) ] + \textrm{H}[q(r_{kk'})] \\
    &= \E_{q(r_{kk'})}[\log \left( (1-p_{kk'})^{r_{kk'} N^{\Phi}_{kk'}} p_{kk'}^{N^{Y}_{kk'}} p(r_{kk'}) \prod_{ij\in Y^{(kk')}} \frac{\Gamma(r_{kk'}+y_{ij})}{\Gamma(r_{kk'}) \Gamma(y_{ij}+1) }  \right) ] + \textrm{H}[q(r_{kk'})]
\end{align*}

If $y_{ij} = 0$, then $\frac{\Gamma(r_{kk'}+y_{ij})}{\Gamma(r_{kk'}) \Gamma(y_{ij}+1)} = 1$, whereas if $y_{ij} \ne 0$, then $\frac{\Gamma(r_{kk'}+y_{ij})}{\Gamma(r_{kk'}) \Gamma(y_{ij}+1)} = \frac{1}{B(r_{kk'}, y_{ij})y_{ij}}$. Furthermore, in this latter case:
\begin{align*}
B(r_{kk'}, y_{ij}) = \int_0^1 t^{r_{kk'}-1} (1-t)^{y_{ij}-1} dt  \leq \int_0^1 t^{r_{kk'}-1} dt = \frac{1}{r_k}
\end{align*}
so that:
\begin{equation*}
\log \prod_{ij\in Y^{(kk')}} \frac{\Gamma(r_{kk'}+y_{ij})}{\Gamma(r_{kk'}) \Gamma(y_{ij}+1) } \geq N^Y_{kk'} \log(r_{kk'}) + \mathrm{cst}
\end{equation*}
with $N^Y_{kk'} = \sum_{ij\in Y^{(kk')}} y_{ij}$.
Furthermore, from the model definitions, one has $$\log p(r_{kk'}) = (r_0 c_0-1)\log(r_{kk'}) - r_{kk'} c_0 + \mathrm{cst}\ ,$$  and $$\textrm{H}[q(r_{kk'})] = a_{kk'} + \log(b_{kk'}) +\log \Gamma(a_{kk'}) + (1-a_{kk'})\Psi(a_{kk'})\ .$$
Hence:
\begin{align*}
    \L_{[r_{kk'}]} &\geq N^\Phi_{kk'} a_{kk'} b_{kk'} \log(1-p_{kk'}) + (r_0 c_0-1 )(\Psi(a_{kk'}) + \log(b_{kk'})) -c_0 a_{kk'} b_{kk'} \\
    &\qquad +N^Y_{kk'} (\Psi(a_{kk'}) + \log(b_{kk'}))+ a_{kk'} + \log(b_{kk'}) +\log \Gamma(a_{kk'}) + (1-a_{kk'})\Psi(a_{kk'})
\end{align*}
Maximizing the right-hand term of the above inequality with respect to $b_{kk'}$ yields:
\begin{equation} \label{eq:update2}
b_{kk'} = \frac{r_0 c_0 + N^Y_{kk'}}{a_{kk'} (c_0 - N^\Phi_{kk'} \log(1-p_{kk'}))} \nonumber
\end{equation}
As $r_{kk'} \sim \textrm{Gamma}(a_{kk'},b_{kk'})$, one finally obtains:
\begin{equation}
\E_q[r_{kk'}] = a_{kk'} b_{kk'} = \frac{r_0 c_0 + N^Y_{kk'}}{c_0 - N^\Phi_{kk'} \log(1-p_{kk'})} \nonumber
\end{equation}

### Optimizing $p_{kk'}$

In oder to maximize the ELBO w.r.t $p_{kk'}$, one can let $q(p_{kk'}) = p(p_{kk'} | Y,Z) = E_q(r_{kk'}) [ p(p_{kk'} | Y^{(kk')},Z^{(kk')} ,r_{kk'})]$. As the negative binomial and Beta distributions are conjugate, a closed-form expression can be obtained:
\begin{align*}
p(p_{kk'} | Y^{(kk')}, Z^{(kk')}, r_{kk'}) &\propto p(Y^{(kk')| Z^{(kk')}, r_{kk'}} p(r_{kk'}) \\
                               &\propto (1-p_{kk'})^{r_{kk'} N^\Phi_{kk'}}p_{kk'}^{N^Y_{kk'}} p_{kk'}^{c\epsilon -1} (1-p_{kk'})^{c(1-\epsilon) -1}\\
                               &\propto p_{kk'}^{c\epsilon + N^Y_{kk'} -1} (1-p_{kk'})^{c(1-\epsilon) + N^\Phi_{kk'}r_{kk'}-1}\\
                               &= \mathrm{Beta}(c\epsilon + N^Y_{kk'}, c(1-\epsilon) + N^\Phi_{kk'}r_{kk'})
\end{align*}

Finally, by resorting again to a first order Taylor expansion, one obtains:
\begin{equation*}
p_{kk'} \sim \mathrm{Beta}(c\epsilon + N^Y_{kk'}, c(1-\epsilon) + N^\Phi_{kk'} E_q[r_{kk'}]) \nonumber
\end{equation*}



## Experimentation (full results)

We provide here the complete set of results for the AUC-ROC scores evaluations for the full range of training sets proportions (1\%, 5\%, 10\%, 20\%, 30\%, 50\% and 100\%) in Figure \ref{fig:roc} for all the datasets. The log-likelihood convergence of the inference for all the datasets are given in Figure \ref{fig:conv_entropy},

\begin{figure}[h]
\centering
  \input{source/figures/chap5/img/roc_evolv_fig}
   \label{fig:roc}
\end{figure}


\begin{figure}[h]
\centering
  \input{source/figures/chap5/img/conv_entropy2}
    \label{fig:conv_entropy}
\end{figure}

### Reproducible Research

We published our implementation within a platform that aims to ease the development of reproducible complex experiments. We are maintaining this platform that we released under open-source license.\footnote{The name of the project is anonymized.}

To reproduce our results, one can proceed as follows:
* Install the XXX project:   
```bash
    $ git clone https://github.com/*/*
    $ cd XXX && make install
```
* Fit all the models on all the corpus, and save the results:
```bash
    $ XXX online_roc -x fit -w --repeat 0 1 2 3 4 5 6 7 8 9 
```
* Parallelization can be obtained by adding the options \lstinline|--cores NUMBER_OF_CORES|,
* Figures can be plotted with the command:  
```bash
    $ XXX online_roc -x roc_evolution2 --repeat 0 1 2 3 4 5 6 7 8 9
```



