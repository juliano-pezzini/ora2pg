-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_assinatura_digital ( nr_sequencia_p bigint, nr_prescricao_p bigint, nr_seq_interno_p bigint, nr_seq_assinatura_p bigint, nm_tabela_p text, nm_usuario_p text) AS $body$
DECLARE


ds_comando_w		varchar(8000);


BEGIN

if (nm_tabela_p = 'PRESCR_GASOTERAPIA') or (nm_tabela_p = 'NUT_PAC') or (nm_tabela_p = 'NUT_PACIENTE') then
	ds_comando_w := 'update	'||nm_tabela_p||
					' set 	nr_seq_assinatura_susp = '||nr_seq_assinatura_p||
					' where nr_sequencia = '||nr_seq_interno_p||
					' and	nr_prescricao = '||nr_prescricao_p;
elsif (nm_tabela_p <> 'PRESCR_MEDICA') then
	ds_comando_w := 'update	'||nm_tabela_p||
					' set 	nr_seq_assinatura_susp = '||nr_seq_assinatura_p||
					' where nr_seq_interno = '||nr_seq_interno_p;
end if;

CALL registrar_assinatura_item_rep(nr_sequencia_p,nr_prescricao_p,nm_usuario_p);

if (ds_comando_w IS NOT NULL AND ds_comando_w::text <> '') then
	CALL exec_sql_dinamico('ATUALIZAR_ASSINATURA_DIGITAL', ds_comando_w);
	commit;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_assinatura_digital ( nr_sequencia_p bigint, nr_prescricao_p bigint, nr_seq_interno_p bigint, nr_seq_assinatura_p bigint, nm_tabela_p text, nm_usuario_p text) FROM PUBLIC;
