-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION adep_atualizar_inf_horarios ( ds_horarios_p text, nr_horario_p integer, vl_horario_p text) RETURNS varchar AS $body$
DECLARE


ds_horarios_w	varchar(2000);
nr_pos_hora_w	smallint;
nr_pos_virg_w	smallint;
vl_horario_w	varchar(100);


BEGIN
if (nr_horario_p IS NOT NULL AND nr_horario_p::text <> '') and (vl_horario_p IS NOT NULL AND vl_horario_p::text <> '') then
	begin
	ds_horarios_w	:= ds_horarios_p;
	nr_pos_hora_w	:= position('HORA'||to_char(nr_horario_p) in ds_horarios_w);
	if (nr_pos_hora_w > 0) then
		begin
		nr_pos_virg_w	:= position(';' in substr(ds_horarios_w,nr_pos_hora_w,length(ds_horarios_w)));
		vl_horario_w	:= substr(ds_horarios_w,nr_pos_hora_w,nr_pos_virg_w);
		ds_horarios_w	:= replace(ds_horarios_w,vl_horario_w,'HORA'||to_char(nr_horario_p)||'='||vl_horario_p||';');
		end;
	else
		begin
		ds_horarios_w	:= ds_horarios_w||'HORA'||to_char(nr_horario_p)||'='||vl_horario_p||';';
		end;
	end if;
	end;
end if;
return ds_horarios_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION adep_atualizar_inf_horarios ( ds_horarios_p text, nr_horario_p integer, vl_horario_p text) FROM PUBLIC;

