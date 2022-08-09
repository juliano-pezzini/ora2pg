-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desfazer_baixa_especial_ge ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_atualizar_adep_p text, nr_atendimento_p bigint, nm_usuario_p text) AS $body$
BEGIN
 
update 	prescr_procedimento 
set 	cd_motivo_baixa = 0, 
	dt_baixa  = NULL, 
	nm_usuario = nm_usuario_p, 
	dt_atualizacao = clock_timestamp(), 
	ie_status_execucao = '10', 
	nm_usuario_baixa_esp = nm_usuario_p 
where 	nr_prescricao = nr_prescricao_p 
and 	nr_sequencia = nr_sequencia_p;
 
if (coalesce(ie_atualizar_adep_p,'N') = 'S') then 
	CALL Baixar_horarios_proc_esp(nr_atendimento_p,nr_prescricao_p,nr_sequencia_p,nm_usuario_p,'2');
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desfazer_baixa_especial_ge ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_atualizar_adep_p text, nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;
