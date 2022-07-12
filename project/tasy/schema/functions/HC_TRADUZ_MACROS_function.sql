-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hc_traduz_macros ( nr_seq_paciente_hc_p bigint, ds_texto_p text) RETURNS varchar AS $body$
DECLARE

 
c01 CURSOR FOR 
	SELECT 	a.nr_atendimento_origem atendimento, 
		obter_nome_pf(a.cd_pessoa_fisica) paciente, 
		a.dt_inicio datainicio, 
		a.dt_final datafinal, 
		obter_nome_pf(a.cd_medico_resp) medicoresphc, 
		obter_nome_pf(a.cd_medico_indicou) medicoassisthc, 
		a.ds_observacao observacao, 
		b.dt_entrada dataentrada, 
		obter_nome_pf(b.cd_medico_resp) medicoresp 
	FROM paciente_home_care a
LEFT OUTER JOIN atendimento_paciente b ON (a.nr_atendimento_origem = b.nr_atendimento)
WHERE nr_sequencia = nr_seq_paciente_hc_p;

ds_texto_final_w	varchar(4000);
BEGIN
	ds_texto_final_w := ds_texto_p;
	 
	for	row_C01 in C01 loop 
		ds_texto_final_w := regexp_replace(ds_texto_final_w, '@ATENDIMENTO', coalesce(row_C01.atendimento, ''), 1,0, 'i');
		ds_texto_final_w := regexp_replace(ds_texto_final_w, '@PACIENTE', coalesce(row_C01.paciente, ''), 1,0, 'i');
		ds_texto_final_w := regexp_replace(ds_texto_final_w, '@DATAINICIO', coalesce(row_C01.datainicio, ''), 1,0, 'i');
		ds_texto_final_w := regexp_replace(ds_texto_final_w, '@DATAFINAL', coalesce(row_C01.datafinal, ''), 1,0, 'i');
		ds_texto_final_w := regexp_replace(ds_texto_final_w, '@MEDICORESPHC', coalesce(row_C01.medicoresphc, ''), 1,0, 'i');
		ds_texto_final_w := regexp_replace(ds_texto_final_w, '@MEDICOASSISTHC', coalesce(row_C01.medicoassisthc, ''), 1,0, 'i');
		ds_texto_final_w := regexp_replace(ds_texto_final_w, '@OBSERVACAO', coalesce(row_C01.observacao, ''), 1,0, 'i');
		ds_texto_final_w := regexp_replace(ds_texto_final_w, '@DATAENTRADA', coalesce(row_C01.dataentrada, ''), 1,0, 'i');
		ds_texto_final_w := regexp_replace(ds_texto_final_w, '@MEDICORESP', coalesce(row_C01.medicoresp, ''), 1,0, 'i');
	end loop;
 
return	ds_texto_final_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hc_traduz_macros ( nr_seq_paciente_hc_p bigint, ds_texto_p text) FROM PUBLIC;

