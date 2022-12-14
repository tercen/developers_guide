# Creating a shiny operator

It is easy to create a shiny operator. It is exactly like the creating a standard operator but it uses a the shiny framework.

An example of a simple shiny is found at:

https://github.com/tercen/heatmap_shiny_operator


In Tercen, a shiny app can be in three modes, these modes reflect the three states of a shiny operator.

* show
* run
* showResult

The first mode "show" is when the initial mode when an shiny operator is added to the cross-tab view.

The second mode "run" is when the shiny has been executed.

The third mode "showResult" is when the results of the an executed shiny is presented. For example, the result maybe a new graph based on a computation performed during the run. 

A good example of all three modes go to 
https://github.com/tercen/shiny_operator2
