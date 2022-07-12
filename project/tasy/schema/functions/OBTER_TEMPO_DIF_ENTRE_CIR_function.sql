-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tempo_dif_entre_cir ( nr_cirurgia_p bigint, dt_cirurgia_p timestamp, cd_setor_atendimento_p bigint, cd_unidade_p text) RETURNS bigint AS $body$
DECLARE


qt_tempo_espera_w	bigint;
nr_cir_w		bigint;
dt_inicio_w		timestamp;
dt_fim_w		timestamp;
dt_fim_ant_w		timestamp;

ds_retorno_w		bigint;

C01 CURSOR FOR
	SELECT	nr_cirurgia ,
		dt_inicio_real
	from	cirurgia
	where	trunc(dt_inicio_real) = trunc(dt_cirurgia_p)
	and	ie_status_cirurgia = 2
	and	nr_cirurgia	= nr_cirurgia_p
	and	cd_setor_atendimento 	= cd_setor_atendimento_p
	and	substr(obter_unid_setor_cirurgia(nr_cirurgia,'UN'),1,80) = cd_unidade_p
	order by 1;

C02 CURSOR FOR
	SELECT 	dt_termino
	from cirurgia
	where	trunc(dt_inicio_real) = trunc(dt_cirurgia_p)
	and	ie_status_cirurgia = 2
	and	cd_setor_atendimento 	= cd_setor_atendimento_p
	and	substr(obter_unid_setor_cirurgia(nr_cirurgia,'UN'),1,80) = cd_unidade_p
	and	nr_cirurgia < nr_cir_w
	order by dt_inicio_real;


BEGIN

open C01;
loop
fetch C01 into
	nr_cir_w,
	dt_inicio_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

		open C02;
		loop
		fetch C02 into
			dt_fim_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
			if (dt_fim_w IS NOT NULL AND dt_fim_w::text <> '') then
			begin
				qt_tempo_espera_w :=  obter_min_entre_datas(dt_fim_w,dt_inicio_w,null);
			end;
			else
			begin
				qt_tempo_espera_w := 0;
			end;
			end if;
		end;
		end loop;
		close C02;
	end;
end loop;
close C01;
	ds_retorno_w := qt_tempo_espera_w;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tempo_dif_entre_cir ( nr_cirurgia_p bigint, dt_cirurgia_p timestamp, cd_setor_atendimento_p bigint, cd_unidade_p text) FROM PUBLIC;

