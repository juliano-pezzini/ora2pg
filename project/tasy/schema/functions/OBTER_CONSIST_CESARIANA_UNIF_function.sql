-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_consist_cesariana_unif (nr_seq_protocolo_p bigint, ie_tipo_p bigint) RETURNS bigint AS $body$
DECLARE

 
/* 
ie_tipo_p		 
 1 - Total parto normal 
 2 - Total cesariana 
 3 - Total parto 
 4 - % cesariana 
*/
 
 
qt_parto_normal_w	double precision	:= 0;
qt_cesariana_w		double precision	:= 0;
qt_total_parto_w	double precision	:= 0;
pr_cesariana_w		double precision	:= 0;
vl_retorno_w		double precision	:= 0;


BEGIN 
 
begin 
Select	coalesce(sum(a.qt_procedimento),0) 
into STRICT 	qt_parto_normal_w 
from 	procedimento_paciente	a, 
	conta_paciente 		b 
where 	a.nr_interno_conta 	= b.nr_interno_conta 
and	b.nr_seq_protocolo	= nr_seq_protocolo_p 
and	a.cd_procedimento in (310010039,310010047) 
and	coalesce(a.cd_motivo_exc_conta::text, '') = '';
exception 
	when others then 
		qt_parto_normal_w	:= 0;
end;
 
begin 
Select	coalesce(sum(a.qt_procedimento),0) 
into STRICT 	qt_cesariana_w 
from 	procedimento_paciente	a, 
	conta_paciente 		b 
where 	a.nr_interno_conta	= b.nr_interno_conta 
and	b.nr_seq_protocolo	= nr_seq_protocolo_p 
and	a.cd_procedimento in (411010026,411010034,411010042) 
and	coalesce(a.cd_motivo_exc_conta::text, '') = '';
exception 
	when others then 
		qt_cesariana_w	:= 0;
end;
 
qt_total_parto_w	:= (qt_parto_normal_w + qt_cesariana_w);
 
if (qt_total_parto_w	> 0) then 
	pr_cesariana_w	:= ((qt_cesariana_w * 100) / qt_total_parto_w);	
end if;
 
if (ie_tipo_p	= 1) then 
	vl_retorno_w	:= qt_parto_normal_w;
elsif (ie_tipo_p	= 2) then 
	vl_retorno_w	:= qt_cesariana_w;
elsif (ie_tipo_p	= 3) then 
	vl_retorno_w	:= qt_total_parto_w;
elsif (ie_tipo_p	= 4) then 
	vl_retorno_w	:= pr_cesariana_w;
end if;
 
Return	vl_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_consist_cesariana_unif (nr_seq_protocolo_p bigint, ie_tipo_p bigint) FROM PUBLIC;

