@def title = "RAL Hands-on"
@def tags = ["syntax", "code"]

# Introduction

\tableofcontents <!-- you can use \toc as well -->

In order to learn and consolidate this knowledge to anyone that want it, I'm doing
this Hands-on that will follow my steps to build an UVM ambient from scratch using RAL.
The DUT in this case will be a Call of Cthulhu Life and Sanity Manager (I like RPG thematic and studying things with
something that I like motivate me to go on). Below is the final UVM diagram for the environment. Our goal is to implement
each part and run it to see things happening.


![UVM environment](/assets/full_diagram.png)


Basically, this hands-on will be divided into some pages:

- **Register Blocks** will tell more about the register bank in this case and how to model it using the RAL components;
- **Adapter** will tell more about how the RAL transactions communicate with Interface transactions;
- **Agent** will teach which RAL components must be inserted in agent;
- **Predictor** will tell more about the function of the predictor;
- **Env** will teach which RAL components must be inserted in Environment;
- **Take a Breath** is a section that will show the other UVM components that are not part of the RAL, it is a optional section just to make a pause showing new stuffs
- **Register sequence** will detail what happens in the sequence file using RAL
- **Test** will teach how to insert the register block at Test and connect to the other RAL components
- **Results** will show the ambient execution
- **Source code** will keep all the code developed during the hands-on.


**Obs**: I'm not a RAL expert, this hands-on was developed during my RAL studying. So, feel free to report any mistake!