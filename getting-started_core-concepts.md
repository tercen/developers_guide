# (PART\*) Getting started {.unnumbered}

# Core concepts

## Tercen modules {-}

There are three main types of Tercen __modules__:

* __Templates__
* __Apps__
* __Operators__

A researcher wanting a complete workflow data analysis (e.g. RNA-seq, flow cyto,
etc.) chooses one of the workflows expressed as a list of __template__. A 
__template__ therefore represents the highest level app because it defines a 
set of many steps in sequence to achieve the complete analysis. There would be
a __template__ for each of the high-level workflow (e.g. RNA-seq, flow cyto, etc.).

A researcher wanting a specific statistical process (e.g. quality control, two 
group analysis, or enrichment analysis, etc.) chooses from a list of __apps__. 
A __app__ therefore represents the second highest level app because it defines a
focused set of steps and visuals to achieve one particular statistical objective.


A researcher wanting a specific operator function (e.g. scale, log, multiplication,
addition and subtraction, etc.) chooses from a list of __operators__. 
An __operator__ therefore represents a single computational step. It is a 
typically a single R or Python function.


In summary a researcher wishing a full end-to-end workflow chooses a __template__, 
a specific data process chooses a __workflow__, a specific computation chooses 
an __operator__.

Once an app is built, it may be added to the __app library__ where it can be 
accessed by researchers.


Deciding on which to build is determined by what you would like the app to achieve.
The first two, __template__ and __workflow__, do not need programming experience, 
the __operator__ does. 


The building of each type of module is explained in the following chapters.

## Template {-}

No programming knowledge is required to build a template.
These are built by using the Tercen user interface and deployed within Tercen.

## App {-}

No programming knowledge is required to build an app.
These are built by using the Tercen user interface and deployed within Tercen.

## Operator {-}

Programming knowledge is required to build an __operator__ using any number of 
programming languages (R, Python, Rust, etc.). The code is put on Github 
for the __app library__ to find. 

Currently Tercen has made a convenient R package for working with the Tercen API,
we aim to quickly cater for the other programming languages (Python, Matlab etc.) 
during our final release.

A command line function can also be deployed as an __operator__. This is 
done using a docker concept.
