-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_lib_regra (cd_motivo_alta_p bigint, dt_saida_real_p timestamp) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1);
nr_seq_regra_w		integer;
hr_ini_w		varchar(10);
hr_fim_w		varchar(10);
ie_dia_semana_w		varchar(3);
ie_feriado_w		varchar(1);
qt_mot_alta_W		integer;
qt_count_w		integer;
qt_motivos_w		integer;
ie_achou_periodo_w	varchar(1);


c01 CURSOR FOR
	SELECT 	nr_sequencia
	into STRICT 	nr_seq_regra_w
	from 	REGRA_CONS_PART_ALTA_REAL
	where 	coalesce(cd_estabelecimento, obter_estabelecimento_ativo) = obter_estabelecimento_ativo
	order by nr_sequencia;


BEGIN

ds_retorno_w := 'S';

open c01;
loop
fetch	c01 into
	nr_seq_regra_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	if (nr_seq_regra_w > 0) then

		select 	to_char(hr_inicio,'hh24:mi'),
			to_char(hr_fim,'hh24:mi'),
			ie_dia_semana,
			ie_feriado
		into STRICT	hr_ini_w,
			hr_fim_w,
			ie_dia_semana_w,
			ie_feriado_w
		from 	REGRA_CONS_PART_ALTA_REAL
		where 	ie_situacao = 'A'
		and 	nr_sequencia = nr_seq_regra_w;

		select 	count(*)
		into STRICT 	qt_motivos_w
		from 	REGRA_PART_ALTA_REAL_MOT
		where 	nr_seq_regra_alta_real = nr_seq_regra_w;

		if (qt_motivos_w > 0) then
			 select count(*)
			 into STRICT 	qt_mot_alta_w
			 from 	REGRA_PART_ALTA_REAL_MOT
			 where 	nr_seq_regra_alta_real = nr_seq_regra_w
			 and	cd_motivo_alta = cd_motivo_alta_p;
		else
			 qt_mot_alta_w := 1;
		end if;

		if (obter_se_feriado(wheb_usuario_pck.get_cd_estabelecimento,dt_saida_real_p) > 0) then
			 if (ie_feriado_w = 'S')
			 and (to_char(dt_saida_real_p,'hh24:mi') between hr_ini_w and hr_fim_w)
			 and	(( pkg_date_utils.get_WeekDay(dt_saida_real_p) = ie_dia_semana_w) or (ie_dia_semana_w = 9)) then
				 return 'N';
			 else
				 ie_achou_periodo_W := 'N';
			 end if;
		else
			if (ie_feriado_w = 'N') then
				if (to_char(dt_saida_real_p,'hh24:mi') between hr_ini_w and hr_fim_w)
				and	(( pkg_date_utils.get_WeekDay(dt_saida_real_p) = ie_dia_semana_w) or (ie_dia_semana_w = 9)) then
					 return 'N';
				else
					 ie_achou_periodo_W := 'N';
				end if;
			else
				ie_achou_periodo_W := 'N';
			end if;
		end if;
	end if;
end loop;
close c01;

if (ie_achou_periodo_W = 'S') then
	ds_retorno_w := 'N';
elsif (qt_mot_alta_w > 0) then
	ds_retorno_w := 'S';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_lib_regra (cd_motivo_alta_p bigint, dt_saida_real_p timestamp) FROM PUBLIC;
