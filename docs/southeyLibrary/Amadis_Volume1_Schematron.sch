<?xml version="1.0" encoding="UTF-8"?>

<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            queryBinding="xslt2">

  <sch:title>Amadis of Gaul (1803), Volume I — Project Schematron</sch:title>

  <sch:ns prefix="tei" uri="http://www.tei-c.org/ns/1.0"/>

  <!-- Check the basic TEI document structure. -->
  <sch:pattern id="document-structure">
    <sch:rule context="/">
      <sch:assert test="tei:TEI">
        The document root must be a TEI element in the TEI namespace.
      </sch:assert>
    </sch:rule>

    <sch:rule context="tei:TEI">
      <sch:assert test="tei:teiHeader">
        The TEI document must contain a teiHeader.
      </sch:assert>
      <sch:assert test="tei:text/tei:body">
        The TEI document must contain text/body.
      </sch:assert>
    </sch:rule>

    <sch:rule context="tei:teiHeader/tei:fileDesc">
      <sch:assert test="tei:titleStmt/tei:title">
        The titleStmt must contain a title.
      </sch:assert>
      <sch:assert test="tei:titleStmt/tei:author">
        The titleStmt must identify the author.
      </sch:assert>
      <sch:assert test="tei:publicationStmt/tei:publisher">
        The publicationStmt must identify the publisher.
      </sch:assert>
      <sch:assert test="tei:publicationStmt/tei:date[@when='1803']">
        The publication date must be recorded with when="1803".
      </sch:assert>
      <sch:assert test="tei:sourceDesc/tei:bibl">
        The fileDesc must contain a bibliographic source description.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!-- Check the volume and its page divisions. -->
  <sch:pattern id="volume-and-pages">
    <sch:rule context="tei:text/tei:body">
      <sch:assert test="tei:div[@type='volume'][@n='1']">
        The body must contain the Volume I division (type="volume", n="1").
      </sch:assert>
    </sch:rule>

    <sch:rule context="tei:div[@type='volume']">
      <sch:assert test="count(tei:div[@type='page']) = 353">
        Volume I should contain 353 page divisions, matching the uploaded PDF.
      </sch:assert>
    </sch:rule>

    <sch:rule context="tei:div[@type='page']">
      <sch:assert test="@n">
        Every page division must have an n attribute.
      </sch:assert>
      <sch:assert test="tei:pb">
        Every page division must contain a page-break element.
      </sch:assert>
      <sch:assert test="count(tei:pb) = 1">
        Each page division should contain exactly one pb element.
      </sch:assert>
      <sch:assert test="tei:pb/@n = @n">
        The page division number and its pb number must match.
      </sch:assert>
      <sch:assert test="tei:ab">
        Every page division must contain an ab transcription element.
      </sch:assert>
      <sch:report test="contains(string(tei:ab), '[No OCR text on this page.]')">
        This page is marked as having no OCR text. Check the scan to confirm that this is intentional.
      </sch:report>
    </sch:rule>
  </sch:pattern>

  <!-- Check page numbering for duplicates and gaps. -->
  <sch:pattern id="page-number-sequence">
    <sch:rule context="tei:div[@type='volume']">
      <sch:assert test="count(distinct-values(tei:div[@type='page']/@n)) = count(tei:div[@type='page'])">
        Page numbers must be unique; duplicate page numbers were found.
      </sch:assert>
      <sch:assert test="every $p in 1 to 353 satisfies exists(tei:div[@type='page'][@n = string($p)])">
        Page numbers must run consecutively from 1 through 353.
      </sch:assert>
    </sch:rule>
  </sch:pattern>

  <!-- Check the word-counting/transcription content is present. -->
  <sch:pattern id="transcription-content">
    <sch:rule context="tei:text/tei:body">
      <sch:assert test="string-length(normalize-space(string-join(.//tei:ab//text(), ' '))) gt 0">
        The body must contain transcribed text in ab elements.
      </sch:assert>
      <sch:report test="count(.//tei:ab[contains(., '[No OCR text on this page.]')]) gt 0">
        One or more pages contain the no-OCR placeholder; these pages are not fully transcribed.
      </sch:report>
    </sch:rule>
  </sch:pattern>

</sch:schema>
