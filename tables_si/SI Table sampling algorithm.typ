#import "@preview/tablex:0.0.8": cellx, gridx, hlinex, vlinex

#figure(
    gridx(
        columns: (auto, auto),
        rows: auto,
        fill: none,
        align: left + top,
        cellx(x: 0, y: 0)[Step],
        cellx(x: 1, y: 0)[Description],
        hlinex(y: 1, stroke: 0.1em),
        hlinex(y: 11, stroke: 0.1em),
        vlinex(x: 0, start: 1, stroke: 0.1em),
        vlinex(x: 2, start: 1, stroke: 0.1em),
        cellx(x: 0, y: 1)[1],
        // vlinex(x: 1, start: 1, end: 2),
        cellx(x: 1, y: 1)[Consider the ego network of some perceiver, $k$, up to degree 1. \  1. Take the set of real relationships among the nodes (excluding $k$), and \
        2. The set of counterfactual relationships among these nodes (the relationships possibly formed among these nodes that do not exist in the underlying network).],
        cellx(x: 0, y: 2)[2],
        cellx(x: 1, y: 2)[Sample 5 real relationships from the set of ties that exist, and 5 counterfactual relationships (that do not exist).],
        cellx(x: 0, y: 3)[3],
        cellx(x: 1, y: 3)[Repeat step [1] for up to degree 2.],
        cellx(x: 0, y: 4)[4],
        cellx(x: 1, y: 4)[Remove all relationships that exist in the network formed in step [1] from the network formed in step [3].],
        cellx(x: 0, y: 5)[5],
        cellx(x: 1, y: 5)[Sample 5 real, and 5 counterfactual relationships from the set in step [4].],
        cellx(x: 0, y: 6)[6],
        cellx(x: 1, y: 6)[Repeat step [1] for up to degree 3.],
        cellx(x: 0, y: 7)[7],
        cellx(x: 1, y: 7)[Remove all relationships that exist in the network formed in [4] from the network formed in step [5].],
        cellx(x: 0, y: 8)[8],
        cellx(x: 1, y: 8)[Sample 5 real, and 5 counterfactual relationships from the set in step [7].],
        cellx(x: 0, y: 9)[9],
        cellx(x: 1, y: 9)[Repeat step [1] for up to degree 4.],
        cellx(x: 0, y: 10)[10],
        cellx(x: 1, y: 10)[Remove all relationships that exist in the network formed in [7] from the network formed in step [6].],

    ),
    caption: [Algorithm for the dyad-based sampling procedure.],
    kind: table
) <algo>

