// The project function defines how your document looks.
// It takes your content and some metadata and formats it.

#let project(
    title: ["Cognitive representations of social networks in isolated villages"],
    authors: ("Eric Feltham", "Laura Forastiere", "Nicholas A. Christakis"),
    body
) = {
    // Set the document's basic properties.
    set document(author: authors, title: title)
    set page(numbering: "1", number-align: center, paper: "us-letter")
    set text(font: "Times New Roman", lang: "en", size: 12pt)

    // Title row.
    // align(left)[
    //     #block(text(weight: 100, 1.75em, title))
    //     #v(1em, weak: true)
    // ]

    align(center)[
        #text(size: 14pt)[Supplementary Information:]\ \
        #text(size: 14pt)[#title] \ \
    ]

    let cnt = 0
    for c in authors [
        #(cnt += 1)
        #if cnt < authors.len() [
            #c,
        ] else [#c]
    ]

    pagebreak()

    // short captions
    let in-outline = state("in-outline", false)
    show outline: it => {
        in-outline.update(true)
        it
        in-outline.update(false)
    }

    let flex-caption(long, short) = locate(loc => 
        if in-outline.at(loc) { short } else { long }
    )

    // Figures and tables
    show figure.where(
        kind: table
    ): set figure.caption(position: top)

    // https://github.com/typst/typst/discussions/3871
    set figure.caption(
        separator: [ | ]
    )

    show figure.caption: c => [
    #text(weight: "bold")[
        Supplementary #c.supplement #c.counter.display(c.numbering)#c.separator
    ]
    #c.body
    ]

    show figure: set block(breakable: true)

    show figure.where(
        kind: "table-si"
    ): set figure.caption(position: top)

    show figure.where(
        kind: "table"
    ): set figure.caption(position: top)
    
    show figure.caption: set align(left)

    // headings, numbering
    set heading(numbering: "1.")
    set math.equation(numbering: "(1)")
    
    set heading(numbering: "1.1", supplement: "Supplementary Information Section")
    set math.equation(numbering: "(S1)", supplement: "Supplementary Equation")
    counter(heading).update(0)

    // Main body.
    set par(justify: true)

  body
}
