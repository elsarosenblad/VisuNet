addGOannotations <- function(vis_object, ontology = "MF") {
  library(clusterProfiler)
  library(GO.db)
  library(org.Hs.eg.db)

  gene_names <- vis_object$all$nodes$label
  gene_entrez <- bitr(gene_names, fromType = "SYMBOL", toType = "ENTREZID", OrgDb = org.Hs.eg.db)

  if (nrow(gene_entrez) == 0) return(vis_object)

  go_list <- list()
  for (i in 1:nrow(gene_entrez)) {
    entrez_id <- gene_entrez$ENTREZID[i]
    symbol <- gene_entrez$SYMBOL[i]

    go_data <- tryCatch(
      AnnotationDbi::select(org.Hs.eg.db, keys = entrez_id, columns = c("GO", "ONTOLOGY"), keytype = "ENTREZID"),
      error = function(e) NULL
    )

    if (!is.null(go_data) && nrow(go_data) > 0) {
      if (ontology != "ALL") go_data <- go_data[go_data$ONTOLOGY == ontology, ]
      if (nrow(go_data) > 0) {
        go_ids <- unique(go_data$GO)
        go_list[[symbol]] <- paste(go_ids, collapse = "; ")
      }
    }
  }

  if (length(go_list) == 0) return(vis_object)

  go_df <- data.frame(label = names(go_list), GO_term = unlist(go_list), stringsAsFactors = FALSE)

  nodes <- merge(vis_object$all$nodes, go_df, by = "label", all.x = TRUE)
  nodes$label <- ifelse(!is.na(nodes$GO_term),
                       paste0('GO: ', ifelse(nodes$GO_term == "", "NA", nodes$GO_term), '\n', nodes$label),
                       nodes$label)
  nodes$title <- ifelse(!is.na(nodes$GO_term),
                       paste0(nodes$title, '<br/>GO: <b>', ifelse(nodes$GO_term == "", "NA", nodes$GO_term), '</b>'),
                       nodes$title)
  vis_object$all$nodes <- nodes

  for (dec in setdiff(names(vis_object), "all")) {
    if (!is.null(vis_object[[dec]]$nodes) && nrow(vis_object[[dec]]$nodes) > 0) {
      dec_nodes <- merge(vis_object[[dec]]$nodes, go_df, by = "label", all.x = TRUE)
      dec_nodes$label <- ifelse(!is.na(dec_nodes$GO_term),
                               paste0('GO: ', ifelse(dec_nodes$GO_term == "", "NA", dec_nodes$GO_term), '\n', dec_nodes$label),
                               dec_nodes$label)
      dec_nodes$title <- ifelse(!is.na(dec_nodes$GO_term),
                               paste0(dec_nodes$title, '<br/>GO: <b>', ifelse(dec_nodes$GO_term == "", "NA", dec_nodes$GO_term), '</b>'),
                               dec_nodes$title)
      vis_object[[dec]]$nodes <- dec_nodes
    }
  }

  message("GO annotations added")
  return(vis_object)
}