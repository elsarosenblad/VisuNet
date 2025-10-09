#' Add GO annotations to VisuNet nodes
#' @param vis_object A VisuNet object
#' @param ontology GO ontology (MF/BP/CC)
#' @return VisuNet object with GO annotations
#' @export

addGOannotations <- function(vis_object, ontology = "MF") {
    if (!requireNamespace("clusterProfiler", quietly = TRUE))
        stop("clusterProfiler required")
    if (!requireNamespace("GO.db", quietly = TRUE))
        stop("GO.db required")
    # get all genenames from network
    gene_names <- vis_object$all$nodes$label
    # convert gene symbols to entrez ids, "TP53" to "7157"
    gene_entrez <- bitr(gene_names, fromType = "SYMBOL", toType = "ENTREZID", OrgDb = "org.Hs.eg.db")
    # if no genes could be converted to entrez ids, use original network
    if (nrow(gene_entrez) == 0) {
        return(vis_object)
    }

    # get GO annotations for each gene
    go_list <- list()
    for (i in 1:nrow(gene_entrez)) {
        entrez_id <- gene_entrez$ENTREZID[i]
        symbol <- gene_entrez$SYMBOL[i]

        # get GO annotations from org.HS database for each gene
        go_data <- tryCatch(
            AnnotationDbi::select(org.Hs.eg.db, keys = entrez_id, columns = c("GO", "ONTOLOGY"), keytype = "ENTREZID"),
            error = function(e) NULL
        )

        # if GO annotations could be found, add them to the network
        if (!is.null(go_data) && nrow(go_data) > 0) {
            if (ontology != "ALL") go_data <- go_data[go_data$ONTOLOGY == ontology, ]
            if (nrow(go_data) > 0) {
                go_ids <- unique(go_data$GO)
                go_list[[symbol]] <- paste(go_ids, collapse = "; ")
            }
        }
    }
    #return visunet object 
    if (length(go_list) == 0) {
        warning("No GO annotations")
        return(vis_object)
    }

    # convert go_list to data frame
    go_df <- data.frame(label = names(go_list), GO_term = unlist(go_list), stringsAsFactors = FALSE)
}