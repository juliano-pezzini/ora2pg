-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION plt_gerar_horarios_pck.obter_se_mostra_rep_inter (ie_motivo_prescricao_p text) RETURNS varchar AS $body$
DECLARE

	ie_motivo_prescricao_w	varchar(255);
	
BEGIN
	ie_motivo_prescricao_w	:= coalesce(ie_motivo_prescricao_p,'XPTO');
	if (current_setting('plt_gerar_horarios_pck.vetor_mostrar_rep_w')::vetorMostrarRep.exists(ie_motivo_prescricao_w)) then
		return current_setting('plt_gerar_horarios_pck.vetor_mostrar_rep_w')::vetorMostrarRep[ie_motivo_prescricao_w].ie_mostrar;
	else
		current_setting('plt_gerar_horarios_pck.vetor_mostrar_rep_w')::vetorMostrarRep[ie_motivo_prescricao_w].ie_mostrar	:= PLT_OBTER_SE_MOSTRA_REP(ie_motivo_prescricao_p);
		return current_setting('plt_gerar_horarios_pck.vetor_mostrar_rep_w')::vetorMostrarRep[ie_motivo_prescricao_w].ie_mostrar;
	end if;
	return PLT_OBTER_SE_MOSTRA_REP(ie_motivo_prescricao_p);
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION plt_gerar_horarios_pck.obter_se_mostra_rep_inter (ie_motivo_prescricao_p text) FROM PUBLIC;