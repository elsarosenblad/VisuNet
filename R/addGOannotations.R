#' Add GO annotations to VisuNet nodes
#' @param vis_object A VisuNet object
#' @param ontology GO ontology (MF/BP/CC)
#' @return VisuNet object with GO annotations
#' @export

addGOannotations <- function(vis_object, ontology = "MF") {
    # get all genenames from network
    gene_names <- vis_object$all$nodes$label
    # convert gene symbols to entrez ids, "TP53" to "7157"
    gene_entrez <- bitr(gene_names, fromType = "SYMBOL", toType = "ENTREZID", OrgDb = "org.Hs.eg.db")
    # if no genes could be converted to entrez ids, use original network
    if (nrow(gene_entrez) == 0) {
        return(vis_object)
    }
    
}