-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_elimina_acent_e_caract_esp (ds_campo_p text) RETURNS varchar AS $body$
DECLARE


ds_campo_w    	varchar(4000);
i     		integer;
k     		integer;
ds_acento_w	varchar(255)	:= 'àáãàâäèéêëíóôõöúüçÀÁÃÀÂÄÈÉÊËÍÓÔÕÖÚÜÇñÑ'||chr(38);
ds_novo_w	varchar(255)	:= 'aaaaaaeeeeioooouucAAAAAAEEEEIOOOOUUCnNe';
ds_car_w	varchar(001);
ds_retorno_w	varchar(4000);
j		integer;


BEGIN
ds_campo_w		:= '';
if (ds_campo_p IS NOT NULL AND ds_campo_p::text <> '') then
	begin
	FOR i IN 1..length(ds_campo_p) LOOP
 		begin
		ds_car_w	:= substr(ds_campo_p, i, 1);
		k			:= position(ds_car_w in ds_acento_w);
		if (k = 0) then
			ds_campo_w	:= substr(ds_campo_w || ds_car_w,1,4000);
		else
			ds_campo_w	:= substr(ds_campo_w || substr(ds_novo_w,k,1),1,4000);
		end if;
		end;
	END LOOP;
	
	for j in 1..length(ds_campo_w) loop
		begin
		if (substr(ds_campo_w,j,1) in ('a','A','b','B','c','C','d','D','e','E',
							  'f','F','g','G','h','H','i','I','j','J',
							  'k','K','l','L','m','M','n','N','o','O',
							  'p','P','q','Q','r','R','s','S','t','T',
							  'u','U','v','V','w','W','x','X','y','Y',
							  'z','Z','0','1','2','3','4','5','6','7',
							  '8','9',' ','!','@','#','$','%','&','*',
							  '(',')','-','+','=','{','}','[',']',':',
							  '?',',','.',';','/','\','_','|')) then
			ds_retorno_w	:= ds_retorno_w || substr(ds_campo_w,j,1);
		end if;
		end;
	end loop;	
	end;
end if;
-- Remover espaco em branco no final pra evitar erros de hash
RETURN trim(both ds_retorno_w);
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_elimina_acent_e_caract_esp (ds_campo_p text) FROM PUBLIC;

