-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION wheb_obter_valor_hora (qt_horas_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


/*
ie_opcao_p

essa function tem por finalidade receber um valor X em horas
Exmeplo:
2,98194444444444 horas

o valor antes da vírgula deve ser horas
o valor após a vírgula será transformado em minutos

sempre haverá uma diferença de minutos ou segundos.

o retorno do exemplo será:

2:59:00

H - horas
M - Minutos
*/
vl_horas_w		bigint;
retorno_w		bigint;
vl_minutos_ww		bigint;
vl_minutos_w		bigint;
BEGIN



if (ie_opcao_p	=	'H') then
	begin
	for	i in 1 .. length(qt_horas_p) loop
		begin
		if	substr(qt_horas_p,i,1) = ',' then
			vl_horas_w	:= substr(qt_horas_p,1,i-1);
		end if;
		end;
	end loop;

	end;
end if;


if (ie_opcao_p	=	'M') then
	begin
	for	i in 1 .. length(qt_horas_p) loop
		begin
		if	substr(qt_horas_p,i,1) = ',' then
			begin
			vl_minutos_w	:= substr(qt_horas_p,i+1,2);

			select trunc((vl_minutos_w	* 61) / 100)
			into STRICT	vl_minutos_ww
			;

			end;
		end if;
		end;
	end loop;

	end;
end if;



if (ie_opcao_p	=	'H') then
	retorno_w	:=	vl_horas_w;
end if;
if (ie_opcao_p	=	'M') then
	retorno_w	:=	vl_minutos_ww;
end if;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION wheb_obter_valor_hora (qt_horas_p bigint, ie_opcao_p text) FROM PUBLIC;
