-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_string_cal_ausencia (dia_base_p bigint, mes_base_p text, ds_string_p text, ds_string_w INOUT text) AS $body$
DECLARE


qt_last_day_w 		bigint;
qt_posicao_w		bigint;
ds_padrao_w		varchar(255);
i			bigint;
qt_pos_virgula_w	bigint;
ds_carac_w 		varchar(255);
qt_virgulas_w		bigint;


BEGIN

	if (ds_string_p IS NOT NULL AND ds_string_p::text <> '') then
		qt_pos_virgula_w := 0;
		qt_virgulas_w := 0;
		FOR i IN 1..LENGTH(ds_string_p) LOOP
		begin

		/*(if 	(qt_virgulas_w < dia_base_p) then */

			ds_carac_w:= SUBSTR(ds_string_p, i, 1);
			IF (ds_carac_w = ',') THEN
				qt_virgulas_w := qt_virgulas_w + 1;
				if (qt_virgulas_w < dia_base_p) then
					qt_pos_virgula_w := i;
				end if;
			end if;
		--end if;
		end;
		end loop;

--		insert into vieira values(qt_pos_virgula_w);
		--if (qt_pos_virgula_w = dia_base_p) then
			ds_string_w := substr(ds_string_p,1,qt_pos_virgula_w) || 'clRed' || substr(ds_string_p,qt_pos_virgula_w,length(ds_string_p)-qt_pos_virgula_w);
		--end if;
	else
		select to_char(last_day(to_date(mes_base_p,'mm')),'dd')
		into STRICT qt_last_day_w
		;

		qt_posicao_w := 1;


		while(qt_posicao_w < qt_last_day_w) loop

			if (qt_posicao_w = dia_base_p) then
				ds_string_w := ds_string_w || 'clRed,';
			else
				ds_padrao_w := ',';
			end if;

			ds_string_w := ds_string_w || ds_padrao_w;

			qt_posicao_w := qt_posicao_w+1;
		end loop;
	end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_string_cal_ausencia (dia_base_p bigint, mes_base_p text, ds_string_p text, ds_string_w INOUT text) FROM PUBLIC;

