-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ind_complex ( dt_inicio_p timestamp, dt_final_p timestamp, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE

/* 
Total de avaliações da escala Perroca		'A' 
Total de avaliações da escala Fugulin		'F' 
Total de avaliações da escala NAS		'N' 
Total de avaliações da escala DINI		'D' 
*/
 
			 
qt_retorno_w	varchar(255);
	

BEGIN 
 
If (ie_opcao_p = 'A') then 
	 
	select 	count(*) 
	into STRICT	qt_retorno_w	 
	from	gca_atendimento a 
	where	a.ie_autor = 'P' 
	and 	coalesce(a.dt_inativacao::text, '') = '' 
	and	trunc(a.dt_avaliacao) between trunc(dt_inicio_p) and trunc(coalesce(dt_final_p,dt_inicio_p));
		 
elsif (ie_opcao_p = 'F') then 
 
	select 	count(*) 
	into STRICT	qt_retorno_w	 
	from	gca_atendimento a 
	where	a.ie_autor = 'F' 
	and 	coalesce(a.dt_inativacao::text, '') = '' 
	and	trunc(a.dt_avaliacao) between trunc(dt_inicio_p) and trunc(coalesce(dt_final_p,dt_inicio_p));
	 
elsif (ie_opcao_p = 'N') then 
 
	select 	count(*) 
	into STRICT	qt_retorno_w	 
	from	escala_nas a 
	where 	coalesce(a.dt_inativacao::text, '') = '' 
	and	trunc(a.dt_avaliacao) between trunc(dt_inicio_p) and trunc(coalesce(dt_final_p,dt_inicio_p));
	 
elsif (ie_opcao_p = 'D') then 
 
	select 	count(*) 
	into STRICT	qt_retorno_w	 
	from	escala_dini a 
	where 	coalesce(a.dt_inativacao::text, '') = '' 
	and	trunc(a.dt_avaliacao) between trunc(dt_inicio_p) and trunc(coalesce(dt_final_p,dt_inicio_p));
	 
end if;
 
return	qt_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ind_complex ( dt_inicio_p timestamp, dt_final_p timestamp, ie_opcao_p text) FROM PUBLIC;
