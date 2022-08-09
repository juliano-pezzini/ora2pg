-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_reducao_ciclo ( nr_seq_paciente_p bigint, pr_reducao_p bigint, nr_ciclo_p bigint, ds_dia_ciclo_p text, nm_usuario_p text) AS $body$
BEGIN
 
update 	paciente_atendimento 
set 	pr_reducao	= pr_reducao_p 
where 	nr_seq_paciente = nr_seq_paciente_p 
and	coalesce(nr_prescricao::text, '') = '' 
and	somente_numero(ds_dia_ciclo) >= somente_numero(ds_dia_ciclo_p);
commit;
 
CALL recalcula_dose_onc_ciclo(nr_seq_paciente_p,nm_usuario_p,0);
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_reducao_ciclo ( nr_seq_paciente_p bigint, pr_reducao_p bigint, nr_ciclo_p bigint, ds_dia_ciclo_p text, nm_usuario_p text) FROM PUBLIC;
