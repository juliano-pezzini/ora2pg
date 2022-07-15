-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE carregar_cal_ausencia_html5 (cd_prof_p text, nr_seq_escala_p bigint, mes_base_p bigint, ano_base_p bigint, ds_string_w INOUT text) AS $body$
DECLARE


qt_last_day_w		bigint;
ds_pos_string_w		varchar(255);
qt_dia_base_w		bigint;
qt_vezes_w			bigint;
i					bigint;
qt_pos_virgula_w	bigint;
ds_carac_w 			varchar(255);
qt_virgulas_w		bigint;

C01 CURSOR FOR
	SELECT TO_CHAR(dt_inicio,'dd')
	FROM escala_afastamento_prof
	WHERE dt_inicio between  PKG_DATE_UTILS.GET_DATE(ano_base_p,mes_base_p) and PKG_DATE_UTILS.END_OF(PKG_DATE_UTILS.GET_DATE(10,10),'MONTH')
	AND cd_profissional = cd_prof_p
	AND ((nr_seq_escala = nr_seq_escala_p) OR (coalesce(nr_seq_escala::text, '') = '') OR (nr_seq_escala = 0))
	AND trunc(dt_inicio) = trunc(dt_final)
	order by 1;


BEGIN

	select  to_char(PKG_DATE_UTILS.END_OF(PKG_DATE_UTILS.GET_DATE(ano_base_p,mes_base_p),'MONTH'),'dd')
	into STRICT qt_last_day_w
	;

	ds_string_w := ',';
		ds_string_w := lpad(ds_string_w, qt_last_day_w-1, ',');
	open C01;
	loop
	fetch C01 into
		qt_dia_base_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin



		qt_pos_virgula_w := 0;
		qt_virgulas_w := 0;
		FOR i IN 1..LENGTH(ds_string_w) LOOP
		begin

			ds_carac_w:= SUBSTR(ds_string_w, i, 1);
			IF (ds_carac_w = ',') THEN
				qt_virgulas_w := qt_virgulas_w + 1;
				if (qt_virgulas_w < qt_dia_base_w) then
					qt_pos_virgula_w := i;
				end if;
			end if;
		end;
		end loop;

		ds_string_w := substr(ds_string_w,1,qt_pos_virgula_w) || 'clRed' || substr(ds_string_w,qt_pos_virgula_w,length(ds_string_w)-qt_pos_virgula_w);


		end;

	end loop;
	close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE carregar_cal_ausencia_html5 (cd_prof_p text, nr_seq_escala_p bigint, mes_base_p bigint, ano_base_p bigint, ds_string_w INOUT text) FROM PUBLIC;

