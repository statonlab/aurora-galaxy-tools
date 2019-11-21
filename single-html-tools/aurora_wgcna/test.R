opt = list(
  # Input Files
  'expression_data' = 'test-data/LiverFemale3600.gem.csv',
  'trait_data' = 'test-data/ClinicalTraits.csv',

  # Input Arguments
  'cut_height' = NULL,
  'power' = NULL,
  'min_cluster_size' = 30,
  'sname_col' = 1,
  'block_size' = 5000,
  'hard_threshold' = 0.5,
  'missing_value' = 'NA'
  'one_hot_cols' = '',
  'ignore_cols' = 'Number,Mouse_ID,Strain,DOB,parents,Western_Diet,Sac_Date',

  # Output Files
  'r_data' = 'wgcna_analysis.RData',
  'gene_module_file' = 'gene_module.csv',
  'network_edges_file' = 'network_edges.txt',
  'gene_association_file' = 'gene_association_file.csv',
  'module_association_file' = 'module_association_file.csv'
)
