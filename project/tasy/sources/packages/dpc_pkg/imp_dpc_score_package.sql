-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE dpc_pkg.imp_dpc_score (cd_dpc_p text, cd_procedimento_p text, dt_end_p text, dt_start_p text, dt_update_p text, ie_origem_proced_p bigint, nm_dpc_p text, nm_surgery_p text, nr_list_p bigint, nr_seq_edition_p bigint, qt_days_hosp_1_p bigint, qt_days_hosp_2_p bigint, qt_days_hosp_3_p bigint, qt_points_hosp_1_p bigint, qt_points_hosp_2_p bigint, qt_points_hosp_3_p bigint, si_change_category_p text, si_definition_p text, si_severity_p text, si_surgery_treat_1_p text, si_surgery_treat_2_p text, nm_usuario_p text) AS $body$
BEGIN

insert into dpc_score(
	cd_dpc,                  
	cd_procedimento,         
	dt_atualizacao,          
	dt_atualizacao_nrec,     
	dt_end,                  
	dt_start,                
	dt_update,               
	ie_origem_proced,        
	nm_dpc,                  
	nm_surgery,              
	nm_usuario,              
	nm_usuario_nrec,         
	nr_list,                 
	nr_seq_edition,          
	nr_sequencia,            
	qt_days_hosp_1,          
	qt_days_hosp_2,          
	qt_days_hosp_3,          
	qt_points_hosp_1,        
	qt_points_hosp_2,        
	qt_points_hosp_3,        
	si_change_category,      
	si_definition,           
	si_severity,             
	si_surgery_treat_1,      
	si_surgery_treat_2)
values (cd_dpc_p,                  
	cd_procedimento_p,         
	clock_timestamp(),          
	clock_timestamp(),     
	CASE WHEN dt_end_p='99999999' THEN null WHEN dt_end_p='00000000' THEN null  ELSE to_date(dt_end_p,'yyyy-mm-dd') END ,
    CASE WHEN dt_start_p='99999999' THEN null WHEN dt_start_p='00000000' THEN null  ELSE to_date(dt_start_p,'yyyy-mm-dd') END ,
    CASE WHEN dt_update_p='99999999' THEN null WHEN dt_update_p='00000000' THEN null  ELSE to_date(dt_update_p,'yyyy-mm-dd') END ,	              
	ie_origem_proced_p,        
	nm_dpc_p,                  
	nm_surgery_p,              
	nm_usuario_p,              
	nm_usuario_p,         
	nr_list_p,                 
	nr_seq_edition_p,          
	nextval('dpc_score_seq'), 
	qt_days_hosp_1_p,          
	qt_days_hosp_2_p,          
	qt_days_hosp_3_p,          
	qt_points_hosp_1_p,        
	qt_points_hosp_2_p,        
	qt_points_hosp_3_p,        
	si_change_category_p,      
	si_definition_p,           
	si_severity_p,             
	si_surgery_treat_1_p,      
	si_surgery_treat_2_p);

end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dpc_pkg.imp_dpc_score (cd_dpc_p text, cd_procedimento_p text, dt_end_p text, dt_start_p text, dt_update_p text, ie_origem_proced_p bigint, nm_dpc_p text, nm_surgery_p text, nr_list_p bigint, nr_seq_edition_p bigint, qt_days_hosp_1_p bigint, qt_days_hosp_2_p bigint, qt_days_hosp_3_p bigint, qt_points_hosp_1_p bigint, qt_points_hosp_2_p bigint, qt_points_hosp_3_p bigint, si_change_category_p text, si_definition_p text, si_severity_p text, si_surgery_treat_1_p text, si_surgery_treat_2_p text, nm_usuario_p text) FROM PUBLIC;