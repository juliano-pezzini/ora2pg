-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_horario_padrao (ds_horarios_p text) RETURNS varchar AS $body$
DECLARE



ds_horarios_w		varchar(4000);
ds_texto_w			varchar(4000);
i					bigint;
x					varchar(1);
ds_valido_w 		varchar(12)		:= '1234567890A ';
ds_validos_ww		varchar(20)		:= '1234567890A:; ';


BEGIN
ds_horarios_w	:= replace(ds_horarios_p,',',' ');
ds_texto_w	:= '';

-- Eliminar caracteres indevidos
for i in 1..length(ds_horarios_w) loop
	x	:= substr(ds_horarios_w, i, 1);
	if (position(x in ds_validos_ww) > 0) then
		ds_texto_w	:= ds_texto_w || x;
	else
		ds_texto_w	:= ds_texto_w ||' ';
	end if;
end loop;

ds_horarios_w	:= ds_texto_w;

if (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') then
	begin
	-- Verifica se horários de item contínuo, separados por vírgulaa
	if (position(';' in ds_horarios_w) > 0) then
		-- Remover espaçamentos duplos
		ds_horarios_w	:= replace(replace(replace(ds_horarios_w,'  ',' '),'  ',' '),'  ',' ');
		-- Remover espaçamentos entre horários
		ds_horarios_w	:= replace(replace(ds_horarios_w||';','; ',';'),' ;',';');
		-- Remover espaçamento inicial
		while(ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') and (substr(ds_horarios_w,1,1) = ' ') loop
			ds_horarios_w	:= substr(ds_horarios_w,2,length(ds_horarios_w));
		end loop;

		ds_texto_w		:= ds_horarios_w;
		ds_horarios_w	:= '';

		--
		while(ds_texto_w IS NOT NULL AND ds_texto_w::text <> '') loop
			ds_horarios_w	:= substr(ds_horarios_w || substr(ds_texto_w,1,position(' ' in ds_texto_w)),1,4000);
			ds_texto_w		:= substr(substr(ds_texto_w,position(';' in ds_texto_w)+1,length(ds_texto_w)),1,4000);
		end loop;
	end if;
	end;
end if;

return ds_horarios_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_horario_padrao (ds_horarios_p text) FROM PUBLIC;
