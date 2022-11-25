+++
title = "Predictors"
+++


# Predictors

\toc

Let's take a break with the coding stuff to understand what is a predictor. This RAL component will be instantiated in environment, and
you will see that it is only one code line to declare it, because we won't implement this component. However, we need to undestand what is the main
function of this component before code it.

## The main goal

Basically, the predictor will update the values of our register model based on the Interface Transactions. It can be done with implicit prediction (We don't instantiates any component) or with explicity prediction (we have to instantiate a component). The main difference is that with implicit prediciton, the register model must be integrated only with the bus sequencer, while the explicit
prediction requires a integration of the register model with bus sequencer and the bus monitor. The component we instantiate is a `uvm_reg_predictor`. In the table below we can see a comparison between these two methods:

| **Prediction Mode**  | **Advantage**         | **Disavantage**                                                                       |
|:--------------------:|:---------------------:|:-------------------------------------------------------------------------------------:|
| Implicit             | Simple implementation                                                                                         |Cannot update register model if register sequences are written to access DUT registers|
| Explicit             | Keeps register model updated (Receives from monitor the current values of registers)                          |Instantiate, build and connect a new component|

In the next page, we will se how the Environment is implemented with the predictor.