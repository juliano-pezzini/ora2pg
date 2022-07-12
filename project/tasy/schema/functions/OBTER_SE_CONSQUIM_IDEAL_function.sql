-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_consquim_ideal (cd_pessoa_fisica_p text, dt_agenda_p timestamp) RETURNS varchar AS $body$
DECLARE

 
/* 
Rotina utilizada para determinar se o tempo entre 
*/
			 
			 
qt_agenda_w		smallint;
ds_retorno_w		varchar(1) := 'N';
ie_existe_ag_w		smallint;


BEGIN 
 
select 	coalesce(max(1), 0) 
into STRICT	qt_agenda_w 
from 	agenda a, 
	agenda_consulta b, 
	agenda_classif c 
where 	a.cd_agenda = b.cd_agenda 
and	b.cd_pessoa_fisica = cd_pessoa_fisica_p 
and 	b.ie_status_agenda not in ('C', 'F', 'I', 'S') 
and	b.IE_CLASSIF_AGENDA = c.CD_CLASSIFICACAO 
and	c.ie_validar_poltrona = 'S' 
and 	b.dt_agenda between pkg_date_utils.START_OF( dt_agenda_p , 'DD') and pkg_date_utils.END_OF( dt_agenda_p , 'DAY') 
and 	b.dt_agenda+CASE WHEN b.NR_MINUTO_DURACAO=0 THEN  0  ELSE b.NR_MINUTO_DURACAO/24/60 END  between dt_agenda_p-CASE WHEN coalesce(c.QT_TEMPO_AGENDAMENTO,0)=0 THEN  0  ELSE c.QT_TEMPO_AGENDAMENTO/24/60 END  AND dt_agenda_p;
 
if (qt_agenda_w > 0) then 
	ds_retorno_w := 'S';
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_consquim_ideal (cd_pessoa_fisica_p text, dt_agenda_p timestamp) FROM PUBLIC;
