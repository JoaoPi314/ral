+++
title = "Results"
+++


After running our Ambient, these are the waveforms obtained (open it in a new tab to see the values):

![Waveforms](/assets//waveforms.png)

Note that the three operations defined in register sequence were performed changing the respective signals in order to write or read the registers. This project can be
accessed and executed at 
~~~
<a href="https://edaplayground.com/x/NCFE" target="_blank">EDA Playground.</a>
~~~

This Hands-on cover only the basics of RAL. My register model access the DUT register via frontdoor (Using the DUT interface to drive the read and write operations). It could be done via backdoor, accessing
the register directly. This and a lot of more complex stuff can be checked at the reference links.

## References


- “UVM Tutorial for Candy Lovers – 16. Register Access Methods – ClueLogic.” UVM Tutorial for Candy Lovers – 16. Register Access Methods – ClueLogic, 1 Feb. 2013, ~~~
<a href="https://http://cluelogic.com/2012/10/uvm-tutorial-for-candy-lovers-register-abstraction/" target="_blank">cluelogic.com/2013/02/uvm-tutorial-for-candy-lovers-register-access-methods.</a>
~~~
- “UVM Tutorial for Candy Lovers – 16. Register Access Methods – ClueLogic.” UVM Tutorial for Candy Lovers – 16. Register Access Methods – ClueLogic, 1 Feb. 2013, ~~~
<a href="https://cluelogic.com/2013/02/uvm-tutorial-for-candy-lovers-register-access-methods" target="_blank">cluelogic.com/2013/02/uvm-tutorial-for-candy-lovers-register-access-methods.</a>
~~~
- “Introduction to UVM RAL - Verification Guide.” Verification Guide, ~~~
<a href="https://verificationguide.com/uvm-ral/introduction-to-uvm-ral" target="_blank">verificationguide.com/uvm-ral/introduction-to-uvm-ral.</a>
~~~ Accessed 13 Dec. 2022.

- “UVM RAL Model: Usage and Application.” Design and Reuse, ~~~
<a href="https://www.design-reuse.com/articles/46675/uvm-ral-model-usage-and-application.html." target="_blank">www.design-reuse.com/articles/46675/uvm-ral-model-usage-and-application.html.</a>
~~~  Accessed 13 Dec. 2022.
- ~~~
<a href="https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.1b/html/files/reg/uvm_reg-svh.html#uvm_reg.write" target="_blank">https://verificationacademy.com/verification-methodology-reference/uvm/docs_1.1b/html/files/reg/uvm_reg-svh.html#uvm_reg.write.</a>
~~~ Accessed 13 Dec. 2022.
