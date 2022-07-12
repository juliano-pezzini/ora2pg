-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION converte_codigo_bloqueto_hsbc ( ie_Conversao_p text, ds_Origem_p text) RETURNS varchar AS $body$
DECLARE



ds_campo_w				varchar(60);
ds_destino_w				varchar(60);


BEGIN

if (ie_Conversao_p = 'Lido_Barra')  then
	begin
	ds_campo_w	:= Substr(ds_Origem_p, 34, length(ds_Origem_p) - 33);
	ds_campo_w	:= to_char((replace(ds_campo_w,' ',''))::numeric ,'FM00000000000000');
	ds_destino_w 	:= Substr(ds_Origem_p, 1, 4);
	ds_destino_w 	:= ds_destino_w || Substr(ds_origem_p, 33, 1);
	ds_destino_w 	:= ds_destino_w || substr(ds_campo_w,1,14);
	ds_destino_w 	:= ds_destino_w || Substr(ds_Origem_p, 5, 5);
	ds_destino_w 	:= ds_destino_w || Substr(ds_Origem_p, 11, 10);
	ds_destino_w 	:= ds_destino_w || Substr(ds_Origem_p, 22, 10);
	end;
elsif (ie_Conversao_p = 'Barra_Lido')  then
	begin
	ds_campo_w	:= Substr(ds_origem_p, 1, 4) || Substr(ds_origem_p, 30, 5);
	ds_destino_w	:= ds_campo_w || Calcula_Digito('Modulo10', ds_campo_w);

	ds_campo_w	:= Substr(ds_origem_p, 35, 6) || Substr(ds_origem_p, 41, 4);
	ds_destino_w	:= ds_destino_w || ds_campo_w || Calcula_Digito('Modulo10', ds_campo_w);

	ds_campo_w	:= Substr(ds_origem_p, 45, 10);
	ds_destino_w	:= ds_destino_w || ds_campo_w || Calcula_Digito('Modulo10', ds_campo_w);

	ds_campo_w	:= Substr(ds_origem_p, 5, 1) || Substr(ds_origem_p, 9, 14);
	ds_destino_w	:= ds_destino_w || ds_campo_w;
	end;
elsif (ie_Conversao_p = 'Lido_Editado')  then
	begin
	ds_campo_w	:= 	Substr(ds_origem_p,34,14);
	ds_campo_w	:= 	to_char((replace(ds_campo_w,' ',''))::numeric ,'FM99999999999000');
	ds_destino_w	:= 	Substr(ds_origem_p,01,5) || '.' ||
        	       		Substr(ds_origem_p,06,5) || ' ' ||
	               		Substr(ds_origem_p,11,5) || '.' ||
        	       		Substr(ds_origem_p,16,6) || ' ' ||
	               		Substr(ds_origem_p,22,5) || '.' ||
        	       		Substr(ds_origem_p,27,6) || ' ' ||
				Substr(ds_origem_p,33,1) || ' ' ||
	        	        ds_campo_w;
	end;
elsif (ie_Conversao_p = 'Barra_Editado')  then
	begin
	ds_destino_w	:=  Converte_Codigo_Bloqueto('Barra_Lido', ds_origem_p);
	ds_destino_w	:=  Converte_Codigo_Bloqueto('Lido_Editado', ds_destino_w);
	end;
end if;

RETURN ds_Destino_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION converte_codigo_bloqueto_hsbc ( ie_Conversao_p text, ds_Origem_p text) FROM PUBLIC;
