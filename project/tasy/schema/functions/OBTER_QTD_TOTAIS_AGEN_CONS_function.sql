-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qtd_totais_agen_cons ( ds_agenda_mes_p text, ie_tipo_total_p text, cd_medico_par_p text, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE

			 
ds_retorno_w		integer;
qt_total_consultas_w	integer;
qt_total_retornos_w		integer;
qt_total_faltas_w		integer;	
 
/*ie_tipo_total_p*/
 
/*TC = Total de Consultas*/
 
/*TR = Total de Retornos*/
 
/*TF = Total de Faltas*/
 
 

BEGIN 
 
if (ds_agenda_mes_p IS NOT NULL AND ds_agenda_mes_p::text <> '') and (cd_medico_par_p IS NOT NULL AND cd_medico_par_p::text <> '') and (ie_tipo_total_p = 'TC') then 
 
	select 	count(a.dt_agenda) 
	into STRICT	qt_total_consultas_w 
	from	agenda b, 
		Agenda_Consulta_v a 
	where	a.cd_agenda = b.cd_agenda 
	and	to_char(a.dt_agenda, 'mm/yyyy') = ds_agenda_mes_p 
	and	(a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '') 
	and	a.ie_classif_agenda in ('N','P26') 
	and	a.ie_status_agenda not in ('A','AA','AT','AC','AP','AE','AR','F','I','C','B','II') 
	and (b.cd_agenda = cd_medico_par_p) 
	and 	a.cd_agenda = b.cd_agenda 
	and	((b.cd_estabelecimento = cd_estabelecimento_p) or (cd_estabelecimento_p = '0')) 
	and b.ie_situacao = 'A';
	 
	ds_retorno_w := qt_total_consultas_w;	
 
elsif (ds_agenda_mes_p IS NOT NULL AND ds_agenda_mes_p::text <> '') and (cd_medico_par_p IS NOT NULL AND cd_medico_par_p::text <> '') and (ie_tipo_total_p = 'TR') then 
 
	select 	count(a.dt_agenda) 
	into STRICT	qt_total_retornos_w 
	from	agenda b, 
		Agenda_Consulta_v a 
	where	a.cd_agenda = b.cd_agenda 
	and	to_char(a.dt_agenda, 'mm/yyyy') = ds_agenda_mes_p 
	and	(a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '') 
	and	a.ie_classif_agenda in ('R2','N1','R','61','59') 
	and	a.ie_status_agenda not in ('F','I','C') 
	and (b.cd_agenda = cd_medico_par_p) 
	and 	a.cd_agenda = b.cd_agenda 
	and	((b.cd_estabelecimento = cd_estabelecimento_p) or (cd_estabelecimento_p = '0')) 
	and b.ie_situacao = 'A';
	 
	ds_retorno_w := qt_total_retornos_w;
	 
elsif (ds_agenda_mes_p IS NOT NULL AND ds_agenda_mes_p::text <> '') and (cd_medico_par_p IS NOT NULL AND cd_medico_par_p::text <> '') and (ie_tipo_total_p = 'TF') then 
	 
	select 	count(a.dt_agenda) 
	into STRICT	qt_total_faltas_w 
	from	agenda b, 
		Agenda_Consulta_v a 
	where	a.cd_agenda = b.cd_agenda 
	and	to_char(a.dt_agenda, 'mm/yyyy') = ds_agenda_mes_p 
	and	(a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '') 
	and	a.ie_status_agenda in ('F','I') 
	and (b.cd_agenda = cd_medico_par_p) 
	and 	a.cd_agenda = b.cd_agenda 
	and	((b.cd_estabelecimento = cd_estabelecimento_p) or (cd_estabelecimento_p = '0')) 
	and b.ie_situacao = 'A';
	 
	ds_retorno_w := qt_total_faltas_w;
 
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qtd_totais_agen_cons ( ds_agenda_mes_p text, ie_tipo_total_p text, cd_medico_par_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

