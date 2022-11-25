@def title = "RAL Hands-on"
@def tags = ["syntax", "code"]

# Introduction

\tableofcontents <!-- you can use \toc as well -->

In order to learn and consolidate this knowledge to anyone that want it, I'm doing
this Hands-on that will follow my steps to build an UVM ambient from scratch using RAL.
The DUT in this case will be a Dungeons & Dragons Character Manager (I like RPG thematic and studying things with
something that I like motivate me to go on). Below is the final UVM diagram for the environment. Our goal is to implement
each part and run it to see things happening.


![UVM environment](/assets/full_diagram.png)


Basically, this hands-on will be divided into some pages:

- **Register Blocks** will tell more about the register bank in this case and how to model it using the RAL components
- **Adapter** will tell more about how the RAL transactions communicate with Interface transactions
- 
