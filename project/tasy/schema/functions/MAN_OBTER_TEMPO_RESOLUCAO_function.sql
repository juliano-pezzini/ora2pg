-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_tempo_resolucao ( nr_seq_ordem_serv_p bigint) RETURNS bigint AS $body$
DECLARE


dt_fim_real_w					timestamp;
dt_ordem_servico_w				timestamp;
ie_periodo_meta_w				varchar(2);
nr_grupo_trabalho_w				bigint;
qt_dia_w					bigint;
qt_minuto_w					bigint;
qt_tempo_w					bigint	:= 0;


BEGIN

if (nr_seq_ordem_serv_p IS NOT NULL AND nr_seq_ordem_serv_p::text <> '') then
	begin
	select	coalesce(nr_grupo_trabalho,0),
		dt_ordem_servico,
		dt_fim_real
	into STRICT	nr_grupo_trabalho_w,
		dt_ordem_servico_w,
		dt_fim_real_w
	from	man_ordem_servico
	where	nr_sequencia = nr_seq_ordem_serv_p;

	if (nr_grupo_trabalho_w > 0) then

		select	coalesce(ie_periodo_meta,'X')
		into STRICT	ie_periodo_meta_w
		from	man_grupo_trabalho
		where	nr_sequencia = nr_grupo_trabalho_w;

		if (ie_periodo_meta_w <> 'X') then
			select	obter_min_entre_datas(dt_ordem_servico_w, dt_fim_real_w,1),
				OBTER_DIAS_ENTRE_DATAS(dt_ordem_servico_w, dt_fim_real_w)
			into STRICT	qt_minuto_w,
				qt_dia_w
			;

			if (ie_periodo_meta_w = 'SS') then
				qt_tempo_w	:= qt_minuto_w * 60;
			elsif (ie_periodo_meta_w = 'HH') then
				qt_tempo_w	:= qt_minuto_w / 60;
			elsif (ie_periodo_meta_w = 'MM') then
				qt_tempo_w	:= trunc(months_between(dt_fim_real_w, dt_ordem_servico_w));
			elsif (ie_periodo_meta_w = 'MI') then
				qt_tempo_w	:= qt_minuto_w;
			elsif (ie_periodo_meta_w = 'DD') then
				qt_tempo_w	:= qt_dia_w;
			end if;
		end if;

	end if;
	end;
end if;

return coalesce(qt_tempo_w,0);
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_tempo_resolucao ( nr_seq_ordem_serv_p bigint) FROM PUBLIC;

