-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_alerta_sinal_vital ( nr_seq_sinal_vital_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(2000) := '';
ds_mensagem_w		varchar(255);
pr_perda_inicial_w	real;
pr_perda_final_w	real;
qt_dias_perda_w		smallint;
qt_peso_w		double precision;
qt_peso_ant_w		double precision;
qt_peso_atu_w		double precision;
qt_reducao_peso_w	double precision := 0;
qt_ganho_peso_w		double precision := 0;
cd_paciente_w		varchar(255);
pr_ganho_inicial_w	real;
pr_ganho_final_w	real;

C01 CURSOR FOR
	SELECT	ds_mensagem,
		pr_perda_inicial,
		pr_perda_final,
		qt_dias_perda
	from	regra_alteracao_sv
	where	pr_ganho_final = 0
	order by qt_dias_perda desc;

C02 CURSOR FOR
	SELECT	qt_peso
	from	atendimento_sinal_vital
	where	cd_paciente = cd_paciente_w
	and	(qt_peso IS NOT NULL AND qt_peso::text <> '')
	and	dt_sinal_vital >= (clock_timestamp() - qt_dias_perda_w)
	and	nr_sequencia <> nr_seq_sinal_vital_p
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	order by dt_sinal_vital;

C03 CURSOR FOR
	SELECT	ds_mensagem,
		qt_dias_perda,
		pr_ganho_inicial,
		pr_ganho_final
	from	regra_alteracao_sv
	where	pr_perda_final = 0
	order by qt_dias_perda desc;


BEGIN

select	cd_paciente,
	qt_peso
into STRICT	cd_paciente_w,
	qt_peso_atu_w
from	atendimento_sinal_vital
where	nr_sequencia = nr_seq_sinal_vital_p;

-- PERDA
open C01;
loop
fetch C01 into
	ds_mensagem_w,
	pr_perda_inicial_w,
	pr_perda_final_w,
	qt_dias_perda_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	open C02;
	loop
	fetch C02 into
		qt_peso_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		if (coalesce(qt_peso_ant_w,0) < qt_peso_w) then
			qt_peso_ant_w := qt_peso_w;
		end if;
		end;
	end loop;
	close C02;

	if	((qt_peso_ant_w - qt_peso_atu_w) > 0) then
		qt_reducao_peso_w	:= round(dividir((100 * (qt_peso_ant_w - qt_peso_atu_w)), qt_peso_ant_w),1);
	end if;

	if (qt_reducao_peso_w between pr_perda_inicial_w and pr_perda_final_w) then
		if (coalesce(ds_retorno_w::text, '') = '') then
			ds_retorno_w	:= ds_mensagem_w;
		else
			ds_retorno_w	:= ds_retorno_w || chr(13) || ds_mensagem_w;
		end if;

		ds_retorno_w	:= replace_macro(ds_retorno_w,'@reducao',to_char(qt_reducao_peso_w));
	end if;
	end;
end loop;
close C01;

-- GANHO
open C03;
loop
fetch C03 into
	ds_mensagem_w,
	qt_dias_perda_w,
	pr_ganho_inicial_w,
	pr_ganho_final_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin
	open C02;
	loop
	fetch C02 into
		qt_peso_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		if (coalesce(qt_peso_ant_w,0) < qt_peso_w) then
			qt_peso_ant_w := qt_peso_w;
		end if;
		end;
	end loop;
	close C02;

	if	((qt_peso_atu_w - qt_peso_ant_w) > 0) then
		qt_ganho_peso_w	:= round(dividir((100 * (qt_peso_atu_w - qt_peso_ant_w)), qt_peso_ant_w),1);
	end if;

	if (qt_ganho_peso_w between pr_ganho_inicial_w and pr_ganho_final_w) then
		if (coalesce(ds_retorno_w::text, '') = '') then
			ds_retorno_w	:= ds_mensagem_w;
		else
			ds_retorno_w	:= ds_retorno_w || chr(13) || ds_mensagem_w;
		end if;

		ds_retorno_w	:= replace_macro(ds_retorno_w,'@ganho',to_char(qt_ganho_peso_w));
	end if;

	end;
end loop;
close C03;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_alerta_sinal_vital ( nr_seq_sinal_vital_p bigint) FROM PUBLIC;
