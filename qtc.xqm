xquery version "3.0";

(:~
: A simple XQuery library for querying TEI files by class names
:
: @author Peter Stadler (stadler at weber hyphen gesamtausgabe dot de) 
: @version 1.0
:)

module namespace qtc="http://query.tei.classes";

declare namespace tei="http://www.tei-c.org/ns/1.0";

(:~
 : Main entry point to the library
 : Queries TEI file(s) by class names
 :
 : @param $source the TEI documents|nodes to query
 : @param $odd the compiled(!) ODD belonging to the TEI files
 : @param $class the classe(s) to search for as xs:string (e.g. 'model.nameLike.agent')
 : @return TEI elements from the input matching the given class(es) 
 :)
declare function qtc:query-elements-by-class($source as item()*, $odd as document-node(), $class as xs:string*) as element()* {
    let $elements := for $i in $class return qtc:get-elements-from-class($odd, $i)
    return 
        for $elem in $elements
        return $source//*[local-name() = $elem]
};

(:~
 : Returns a list of all classes specified by the given ODD file 
 :
 : @param $odd the compiled(!) ODD belonging to the TEI files
 : @param $type the class type (model|atts) as xs:string
 : @return the class names as a sequence of xs:string 
 :)
declare function qtc:get-classes($odd as document-node(), $type as xs:string) as xs:string* {
    $odd//tei:classSpec[@type = $type]/data(@ident)
};

(:~
 : (Recursively) returns a list of all elements which are member of a given model class 
 :
 : @param $odd the compiled(!) ODD belonging to the TEI files
 : @param $class the class to search for as xs:string (e.g. 'model.nameLike.agent')
 : @return the element names (without namespace information!) as a sequence of xs:string 
 :)
declare function qtc:get-elements-from-class($odd as document-node(), $class as xs:string) as xs:string* {
    $odd//tei:elementSpec[./tei:classes/tei:memberOf/@key = $class]/data(@ident),
    for $member-class in $odd//tei:classSpec[@type = 'model'][./tei:classes/tei:memberOf/@key = $class]/data(@ident)
    return qtc:get-elements-from-class($odd, $member-class)
};

(:~
 : (Recursively) returns a list of all attributes which are member of a given attribute class 
 :
 : @param $odd the compiled(!) ODD belonging to the TEI files
 : @param $class the class to search for as xs:string (e.g. 'att.global')
 : @return the attribute names as a sequence of xs:string 
 :)
declare function qtc:get-attributes-from-class($odd as document-node(), $class as xs:string) as xs:string* {
    let $this := $odd//tei:classSpec[@ident = $class]
    return (
        $this//tei:attDef/data(@ident),
        for $member-class in $this//tei:classes/tei:memberOf/data(@key)
        return qtc:get-attributes-from-class($odd, $member-class)
    )
};

