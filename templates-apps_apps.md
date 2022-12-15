# (PART\*) Apps {.unnumbered}

# Building an app

## The app concept 

An __app__ is perfect for users who wish tot have a focused module of analysis
with multiple operators and views (e.g. PCA).

The building of an __app__ does not require any programming.

## Creating an app

Here is the full procedure to create an app:

* Create a workflow that you wish to convert to an app
* Select a generic dataset, preferable from the [data designs](https://github.com/tercen/data_designs)
* Prepare the workflow and run it with the generic data
* Add a __wizard__ step
* Open the wizard (__important__)
* Run the wizard, and answer the questions (factors and filters specification)
* Remove the input data (table step) and add an Input step and an Output step
* Open the wizard and fill in:
    * _Namespace_: appAbbrev
    * _App design_:  appAbbrev.dataDesignName
* Save the app to __apps__ project within the team

## Publishing an app

All __apps__ who are on a git repository are installable, only the git URL and 
a tag version number is required for a researcher to install it in Tercen.

## Customising the app for different instruments or data

* Select an instrument specific pipeline
* Run the app development workflow with an instrument specific dataset
* Clone the app to the apps project of the team 
* Run the app and answer questions with new factors and filters
* Click on the __Publish__ button give name: appAbbrev.dataDesignName
* Edit the json file with a custom __Description__ and __factorName__

