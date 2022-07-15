-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_log_lote_agrup ( nr_atendimento_p bigint, nr_prescricao_p bigint, nr_seq_lote_p bigint, ds_log_p text, nm_usuario_p text) AS $body$
BEGIN
insert into ap_lote_log_agrup(nr_sequencia,
		nr_prescricao, 
		nr_seq_lote, 
		ds_log,
		nm_usuario,
		nr_atendimento,
		dt_atualizacao)
values (nextval('ap_lote_log_agrup_seq'),
		nr_prescricao_p,
		nr_seq_lote_p,
		substr(ds_log_p || ' CallStack=' || dbms_utility.format_call_stack,1,2000),
		nm_usuario_p,
		nr_atendimento_p,
		clock_timestamp());
		
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_log_lote_agrup ( nr_atendimento_p bigint, nr_prescricao_p bigint, nr_seq_lote_p bigint, ds_log_p text, nm_usuario_p text) FROM PUBLIC;

