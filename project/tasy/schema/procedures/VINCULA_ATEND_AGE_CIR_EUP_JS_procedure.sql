-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincula_atend_age_cir_eup_js ( nr_seq_agenda_p bigint, nr_seq_agenda_vinculo_p bigint, ds_tipos_atend_agenda_p text, nr_atendimento_p bigint, ds_lista_agendas_pac_p text, nm_usuario_p text) AS $body$
BEGIN
 
if (coalesce(nr_atendimento_p,0) > 0) then 
	CALL atualizar_atend_agenda_pac_js(nr_seq_agenda_p, nr_seq_agenda_vinculo_p, ds_tipos_atend_agenda_p, nr_atendimento_p, ds_lista_agendas_pac_p, nm_usuario_p);
 
	CALL vinc_automaticamente_atend_EUP(nr_seq_agenda_vinculo_p, nr_atendimento_p);
 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincula_atend_age_cir_eup_js ( nr_seq_agenda_p bigint, nr_seq_agenda_vinculo_p bigint, ds_tipos_atend_agenda_p text, nr_atendimento_p bigint, ds_lista_agendas_pac_p text, nm_usuario_p text) FROM PUBLIC;
