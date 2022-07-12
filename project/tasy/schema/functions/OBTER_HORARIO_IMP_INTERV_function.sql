-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE campos AS (dt_hora		timestamp);


CREATE OR REPLACE FUNCTION obter_horario_imp_interv ( nr_seq_prescr_p bigint, nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(2000)	:= null;
ds_horario_w		varchar(255);
ds_hora_w		varchar(008);
ds_hor_res_w		varchar(255);
ds_pos_res_w		varchar(255);
ds_cor_res_w		varchar(255);
ds_estilo_res_w	varchar(255);
type Vetor is table of campos index by integer;
horarios_w		Vetor;
horario_w		Vetor;
i			integer	:= 0;
k			integer := 0;
z			integer;
dt_hora_w		timestamp;
dt_inic_w		timestamp;
dt_fim_w		timestamp;
ie_separador_w	varchar(1)	:= '';
ds_noturno_w		varchar(5)	:= '19/06';
ie_Estilo_w		varchar(1)	:= '';
ie_Cor_w		varchar(5)	:= '';
qT_dia_adic_w		bigint := 0;

C01 CURSOR FOR
	SELECT	padroniza_horario_prescr(ds_horarios, '01/01/2000'||hr_prim_horario)
	from	pe_prescr_proc
	where	nr_seq_prescr	  = nr_seq_prescr_p
	  and	(padroniza_horario_prescr(ds_horarios, '01/01/2000'||hr_prim_horario) IS NOT NULL AND (padroniza_horario_prescr(ds_horarios, '01/01/2000'||hr_prim_horario))::text <> '');


BEGIN

select	padroniza_horario_prescr(ds_horarios, '01/01/2000'||hr_prim_horario),
	ds_horarios
into STRICT	ds_horario_w,
	ds_retorno_w
from	pe_prescr_proc
where	nr_seq_prescr	  = nr_seq_prescr_p
  and	nr_sequencia	 = nr_sequencia_p;

if (coalesce(ds_horario_w::text, '') = '') then
	ds_retorno_w		:= '1#1#'  || ds_retorno_w || '#1#;#;';
else
	begin
	i	:= 0;
	while	(ds_horario_w IS NOT NULL AND ds_horario_w::text <> '') LOOP
		begin
		select position(' ' in ds_horario_w) into STRICT k;
		if (k > 1) then
			ds_hora_w	:= substr(ds_horario_w, 1, k-1);
			ds_horario_w	:= substr(ds_horario_w, k + 1, 200);
		elsif (ds_horario_w IS NOT NULL AND ds_horario_w::text <> '') then
			ds_hora_w 	:= replace(ds_horario_w, ' ','');
			ds_horario_w	:= '';
		end if;

		if (position('A' in ds_hora_w) > 0) and (qt_dia_adic_w = 0) then
			qt_dia_adic_w	:= 1;
		elsif (position('AA' in ds_hora_w) > 0) then
			qt_dia_adic_w	:= qt_dia_adic_w + 1;
		end if;

		ds_hora_w	:= replace(ds_hora_w,'A','');
		ds_hora_w	:= replace(ds_hora_w,'A','');

		i	:= i + 1;
		horario_w[i].dt_hora	:= To_date('01/01/2000 ' || replace(ds_hora_w,'A',''), 'dd/mm/yyyy hh24:mi') + qt_dia_adic_w;

		end;
	END LOOP;
/* Selecionar os horários de toda prescrição */

	i		:= 0;
	qt_dia_adic_w	:= 0;
	OPEN C01;
	LOOP
	FETCH C01 into ds_horario_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		while	(ds_horario_w IS NOT NULL AND ds_horario_w::text <> '') LOOP
			begin
			select position(' ' in ds_horario_w) into STRICT k;
			if (k > 1) then
				ds_hora_w	:= substr(ds_horario_w, 1, k-1);
				ds_horario_w	:= substr(ds_horario_w, k + 1, 200);
			elsif (ds_horario_w IS NOT NULL AND ds_horario_w::text <> '') then
				ds_hora_w 	:= replace(ds_horario_w, ' ','');
				ds_horario_w	:= '';
			end if;

			if (position('A' in ds_hora_w) > 0) and (qt_dia_adic_w = 0) then
				qt_dia_adic_w	:= 1;
			elsif (position('AA' in ds_hora_w) > 0) then
				qt_dia_adic_w	:= qt_dia_adic_w + 1;
			end if;

			ds_hora_w	:= replace(ds_hora_w,'A','');
			ds_hora_w	:= replace(ds_hora_w,'A','');

			z			:= 0;
			k			:= 1;

			dt_hora_w	:= To_date('01/01/2000 ' || replace(ds_hora_w,'A',''), 'dd/mm/yyyy hh24:mi') + qt_dia_adic_w;

			FOR k in 1..Horarios_w.count LOOP
				if (horarios_w[k].dt_hora = dt_hora_w) then
					z	:= k;
				end if;
			END LOOP;
			if (z = 0) then
				i	:= i + 1;
				horarios_w[i].dt_hora	:= dt_hora_w;
			end if;
			end;
		END LOOP;
	END LOOP;
	CLOSE C01;



/* Classificar os horários */

	k		:= 1;
	z		:= 0;
	while	z = 0 LOOP
		z	:= 1;
		FOR k in 1..Horarios_w.count LOOP
			if (k < Horarios_w.count) and (horarios_w[k].dt_hora > horarios_w[k+ 1].dt_hora) then
				dt_hora_w		:= horarios_w[k].dt_hora;
				horarios_w[k].dt_hora	:= horarios_w[K + 1].dt_hora;
				horarios_w[k+1].dt_hora	:= dt_hora_w;
				z			:= 0;
			end if;
		END LOOP;
	END LOOP;

/* Retorno dos horários na sequencia */

	k	:= 1;
	FOR k in 1..Horario_w.count LOOP
		begin
		i	:= 1;
		for i in 1..horarios_w.count LOOP
			if (horario_w[k].dt_hora = horarios_w[i].dt_hora) then
				z	:= i;
			end if;
		END LOOP;
		ds_hora_w		:= to_char(horario_w[k].dt_hora,'hh24:mi');
		if (substr(ds_hora_w,1,2) = '24') then
			ds_hora_w	:= '00:' || substr(ds_hora_w,4,2);
		end if;
		if (substr(ds_hora_w,4,2) = '00') then
			ds_hora_w	:= substr(ds_hora_w,1,2);
		end if;
		if (horario_w[k].dt_hora >= dt_inic_w) and (horario_w[k].dt_hora <= dt_fim_w) then
			ie_Cor_w	:= 'V';
			ie_estilo_w	:= 'N';
		else
			ie_Cor_w	:= '';
			ie_estilo_w	:= '';
		end if;
		ds_hor_res_w		:= ds_hor_res_w || ie_separador_w || ds_hora_w;
		ds_pos_res_w		:= ds_pos_res_w || ie_separador_w || z;
		ds_cor_res_w		:= ds_cor_res_w  || ie_separador_w || ie_cor_w;
		ds_estilo_res_w		:= ds_estilo_res_w || ie_separador_w || ie_estilo_w;
		ie_separador_w		:= ';';
		end;
	END LOOP;
	ds_retorno_w	:= horarios_w.count || '#' || horario_w.count || '#' ||
			ds_hor_res_w || '#' || ds_pos_res_w ||
			'#' || ds_estilo_res_w || '#' || ds_cor_res_w;
	end;
end if;

return	substr(ds_retorno_w,1,255);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_horario_imp_interv ( nr_seq_prescr_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
