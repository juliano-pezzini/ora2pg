-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE qt_semana_w AS (dia_w timestamp);


CREATE OR REPLACE FUNCTION obter_semana_cardapio ( dt_ref_p timestamp) RETURNS bigint AS $body$
DECLARE

			
--vetor
type vetor is table of qt_semana_w index by integer;
			
vetor_w			vetor;
ie_retorno_w		varchar(60);
i 			smallint   	:=0;
ind 			smallint   	:=1;
dt_dia_w 		timestamp 	:= pkg_date_utils.start_of(dt_ref_p,'MONTH',0);
data_referencia_w			timestamp;

BEGIN

data_referencia_w	:= pkg_date_utils.start_of(to_date(obter_inicio_fim_semana(pkg_date_utils.start_of(dt_ref_p,'DD',0),'I')),'MONTH',0);

while(dt_dia_w <= pkg_date_utils.end_of(pkg_date_utils.start_of(dt_ref_p,'DD',0),'MONTH',0)) and
	((data_referencia_w) = (pkg_date_utils.start_of(dt_ref_p,'MONTH',0))) loop
	
	if (pkg_date_utils.get_WeekDay(dt_dia_w) = 1) then
		begin
		i := i +1;
		vetor_w[i].dia_w := pkg_date_utils.start_of(dt_dia_w, 'DD', 0);
		end;
	end if;
	dt_dia_w:= pkg_date_utils.start_of(dt_dia_w, 'DD', 0) +1;
	end loop;

if (i = 0) then

	dt_dia_w	:= PKG_DATE_UTILS.ADD_MONTH(PKG_DATE_UTILS.start_of(dt_ref_p,'month', 0),-1, 0);
	
	while(dt_dia_w <= pkg_date_utils.end_of(pkg_date_utils.start_of(dt_ref_p, 'DD', 0), 'MONTH', 0)) loop
		if (pkg_date_utils.get_WeekDay(dt_dia_w) = 1) then
			begin
			i := i +1;
			vetor_w[i].dia_w := pkg_date_utils.start_of(dt_dia_w, 'DD', 0);
			end;
		end if;
	dt_dia_w:= pkg_date_utils.start_of(dt_dia_w, 'DD', 0) +1;
	end loop;
	
end if;
		
ind := 1;
while(ind <= i) loop
	if (obter_inicio_fim_semana(trunc(dt_ref_p),'I')	= vetor_w[ind].dia_w) then
		ie_retorno_w := ind;
		exit;
	end if;	
	ind := 	ind + 1;
end loop;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION obter_semana_cardapio ( dt_ref_p timestamp) FROM PUBLIC;
