-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_updade_preco (vl_sa_p bigint, vl_total_amb_p bigint, vl_tph_p bigint, vl_taxa_sala_p bigint, vl_honorario_medico_p bigint, vl_anestesia_p bigint, vl_matmed_p bigint, vl_contraste_p bigint, vl_filme_rx_p bigint, vl_gesso_p bigint, vl_quimioterapia_p bigint, vl_dialise_p bigint, vl_sadt_rx_p bigint, vl_sadt_pc_p bigint, vl_sadt_outros_p bigint, vl_filme_ressonancia_p bigint, vl_outros_p bigint, vl_plantonista_p bigint, ie_versao_bpa_p text, cd_procedimento_p bigint, dt_competencia_p timestamp) AS $body$
BEGIN

update  sus_preco
set     ie_bpa               	= 'S',
	vl_sa                	= vl_sa_p,
	vl_total_amb         	= vl_total_amb_p,
	dt_atualizacao       	= clock_timestamp(),
	vl_tph               	= vl_tph_p,
	vl_taxa_sala         	= vl_taxa_sala_p,
	vl_honorario_medico  = vl_honorario_medico_p,
	vl_anestesia         	= vl_anestesia_p,
	vl_matmed            	= vl_matmed_p,
	vl_contraste         	= vl_contraste_p,
	vl_filme_rx          	= vl_filme_rx_p,
	vl_gesso             	= vl_gesso_p,
	vl_quimioterapia     	= vl_quimioterapia_p,
	vl_dialise           	= vl_dialise_p,
	vl_sadt_rx           	= vl_sadt_rx_p,
	vl_sadt_pc           	= vl_sadt_pc_p,
	vl_sadt_outros       	= vl_sadt_outros_p,
	vl_filme_ressonancia = vl_filme_ressonancia_p,
	vl_outros            	= vl_outros_p,
	vl_plantonista       	= vl_plantonista_p,
	ie_versao_bpa        	= ie_versao_bpa_p
where   cd_procedimento      	= cd_procedimento_p
and     ie_origem_proced     	= 7
and     dt_competencia       	= dt_competencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_updade_preco (vl_sa_p bigint, vl_total_amb_p bigint, vl_tph_p bigint, vl_taxa_sala_p bigint, vl_honorario_medico_p bigint, vl_anestesia_p bigint, vl_matmed_p bigint, vl_contraste_p bigint, vl_filme_rx_p bigint, vl_gesso_p bigint, vl_quimioterapia_p bigint, vl_dialise_p bigint, vl_sadt_rx_p bigint, vl_sadt_pc_p bigint, vl_sadt_outros_p bigint, vl_filme_ressonancia_p bigint, vl_outros_p bigint, vl_plantonista_p bigint, ie_versao_bpa_p text, cd_procedimento_p bigint, dt_competencia_p timestamp) FROM PUBLIC;
