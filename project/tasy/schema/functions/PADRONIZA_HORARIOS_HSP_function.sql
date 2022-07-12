-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION padroniza_horarios_hsp ( ds_horarios_p text, nr_prescricao_p bigint ) RETURNS varchar AS $body$
DECLARE


ds_horarios_w		varchar(2000);
ds_horarios_ww		varchar(2000);
ie_pos_espaco_w		smallint;
qt_tam_horarios_w		smallint;
ds_horario_w		varchar(6);
ds_horario_ww		varchar(12);
dt_atualizacao_w		smallint;


BEGIN
if (ds_horarios_p IS NOT NULL AND ds_horarios_p::text <> '') then

	ds_horarios_w	:= padroniza_horario(ds_horarios_p);

	while(ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') loop
		begin

		ie_pos_espaco_w	:= position(' ' in ds_horarios_w);
		qt_tam_horarios_w	:= length(ds_horarios_w);

		if (ie_pos_espaco_w > 0) then
			ds_horario_w	:= substr(ds_horarios_w, 1, ie_pos_espaco_w - 1);
			ds_horarios_w	:= substr(ds_horarios_w, ie_pos_espaco_w + 1, qt_tam_horarios_w);
		else
			ds_horario_w	:= ds_horarios_w;
			ds_horarios_w	:= null;
		end if;

		select	coalesce(to_char(max(dt_atualizacao), 'dd'), '') + 1
		into STRICT	dt_atualizacao_w
		from	prescr_material
		where	nr_prescricao = nr_prescricao_p;

		if (position('A' in ds_horario_w) > 0) then
			ds_horario_ww	:= substr(ds_horario_w,2,length(ds_horario_w)) || '(' || dt_atualizacao_w || ')';
		else
			ds_horario_ww	:= ds_horario_w;
		end if;

		ds_horarios_ww	:= ds_horarios_ww || ds_horario_ww || ' ';

		end;
	end loop;

end if;

return ds_horarios_ww;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION padroniza_horarios_hsp ( ds_horarios_p text, nr_prescricao_p bigint ) FROM PUBLIC;
