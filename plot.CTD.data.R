
library(reshape2)
library(ggplot2)

plot.CTD.data <- function(CTD.data){
    df   <- subset(CTD.data$data, statistic == "(avg)")
    meta <- CTD.data$meta
    
    potential.id.vars <- c("depSM", "DepSM", "prDM", "PrDM", "pr",
                           "scan", "nbin", "Date", "statistic",
                           "Btl_Posn", "Btl_ID",
                           "flag", "timeS", "nbf",
                           "altM", "prDM", "spar",
                           "header.latitude", "header.longitude",
                           "latitude", "longitude")
    potential.depvars <- c("depSM", "DepSM", "prDM", "PrDM", "pr")
    
    try({
        melted.df <- melt(df, id.vars = names(df)[names(df) %in% potential.id.vars])
        
        #"water depth parameter of choice is the first one that matches 'potential.depvars':
        melted.df$depth <- melted.df[, names(melted.df)[names(melted.df) %in% potential.depvars][1]]
        
        if(nrow(df) < 50){
            geom_case <- geom_point()
        }else{geom_case <- geom_line()} 
        
        ggplot(melted.df,
               aes(x = depth, y = value)) +
            geom_vline(xintercept = 0) +
            geom_case +
            scale_x_reverse() +
            coord_flip() +
            facet_grid(.~variable, scales = "free") +
            theme_bw() +
            ggtitle(paste(meta, collapse = ", ")) +
            theme(axis.text.x = element_text(angle = 45, hjust = 1))
    })
    
}



