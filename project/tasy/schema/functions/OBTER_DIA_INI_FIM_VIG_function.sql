-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE qt_semana_w AS (dia_w timestamp);


CREATE OR REPLACE FUNCTION obter_dia_ini_fim_vig ( dt_mes_ref_p timestamp, ie_opcao_p text) RETURNS timestamp AS $body$
DECLARE


/*
ie_opcao_p
I - Início vigência
F - Fim vigência
*/
--vetor
type vetor is table of qt_semana_w index by integer;


vetor_w			vetor;
i 			smallint   	:=0;
dt_dia_w 		timestamp;
dt_primeiro_domingo_w	timestamp;
dt_mes_ref_w		timestamp;
dt_retorno_w		timestamp;


BEGIN

dt_primeiro_domingo_w 	:= obter_dia_mes(dt_mes_ref_p,1,1);
dt_mes_ref_w		:= dt_mes_ref_p;

if (dt_mes_ref_w < dt_primeiro_domingo_w) then
	dt_mes_ref_w 	:= pkg_date_utils.start_of(dt_mes_ref_w, 'MONTH', 0) - 1;
end if;

dt_dia_w := pkg_date_utils.start_of(dt_mes_ref_w, 'MONTH', 0);

while(dt_dia_w <= trunc(pkg_date_utils.end_of(dt_mes_ref_w, 'MONTH', 0))) loop
	if (pkg_date_utils.get_weekday(dt_dia_w) = 1) then
		begin
		i := i +1;
		vetor_w[i].dia_w := trunc(dt_dia_w);
		end;
	end if;
	dt_dia_w:= trunc(dt_dia_w) +1;
	end loop;

if (ie_opcao_p = 'I') then
	dt_retorno_w := obter_inicio_fim_semana(trunc(vetor_w[1].dia_w),'I');
else
	dt_retorno_w :=	obter_inicio_fim_semana(trunc(vetor_w[i].dia_w),'F');
end if;

return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dia_ini_fim_vig ( dt_mes_ref_p timestamp, ie_opcao_p text) FROM PUBLIC;

