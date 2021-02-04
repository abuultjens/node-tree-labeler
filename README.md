# node-tree-labeler
Replaces node labels in nexus tree with ancestral state reconstructed bases and generates attributes file for visulaisation of homoplasic SNPs in FigTree

### Run
    $ sh node-tree-labeler.sh node_labelled_nexus.tre node_sequences.fasta SNP_table.csv SITE
    
### Example
    $ sh node-tree-labeler.sh node_labelled_nexus.tre node_sequences.fasta 44-ST203_snippy_4.6.0_aus0085_sub-352000_SNPs.csv 192176
