# Query TEI files by class

Inspired by the TEI workshop [Perspectives on querying TEI-annotated data](http://corpora.ids-mannheim.de/queryTEI.html) this is my vision and sample XQuery implementation of a generic TEI query. Building on the class model of TEI as documented in the according ODD file, this TEI Query allows to search on this conceptual model, returning the actual elements.

## Example Use cases
* search over idiosyncratic TEI data with added or renamed elements (e.g. a heterogenous corpus of TEI files with localised tag names)
* create a faceted search for your TEI files


## How to use

1. Create a compiled ODD version from your ODD via [OxGarage](http://www.tei-c.org/oxgarage/) (this step can be automated in the future)
2. Import the module to your XQuery: `import module namespace qtc="http://query.tei.classes" at "$relative-module-location";`
2. Query your TEI files: `qtc:query-elements-by-class($source as item()*, $odd as document-node(), $class as xs:string*)` 

## ToDo

* Automate ODD transformation
* Support Namespaces
* searching for local-name() is not performant for large corpora
* Demo website

## License


This piece of sofware is released to the public under the terms of the [GNU GPL v.3](http://www.gnu.org/copyleft/gpl.html) open source license.