-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_datas_versao ( ie_opcao_p text, cd_versao_p text default null) RETURNS timestamp AS $body$
DECLARE


/*
	IE_OPCAO_P

	I - DT_INICIO
	F - DT_FIM


	CD_VERSAO_P

	Se informado, retorna as datas da versão informada.
	Se não informada, retorna as datas da versão corrente (versão que ainda não foi gerada).

*/
dt_versao_w			timestamp;


BEGIN

if (coalesce(cd_versao_p::text, '') = '') then

	if (ie_opcao_p = 'I') then

		select	max(dt_inicio)
		into STRICT	dt_versao_w
		from	escala_diaria d
		where	d.nr_seq_escala = 21
		and	clock_timestamp() between dt_inicio and dt_fim;

	elsif (ie_opcao_p = 'F') then

		select	min(dt_inicio)
		into STRICT	dt_versao_w
		from	escala_diaria d
		where	d.nr_seq_escala = 21
		and	dt_inicio > clock_timestamp();

	end if;
else
	select	max(trunc(dt_versao))
	into STRICT	dt_versao_w
	from	aplicacao_tasy_versao
	where	cd_aplicacao_tasy = 'Tasy'
	and	cd_versao = cd_versao_p;

	if (dt_versao_w IS NOT NULL AND dt_versao_w::text <> '') then

		if (ie_opcao_p = 'I') then

			select	max(dt_inicio)
			into STRICT	dt_versao_w
			from	escala_diaria d
			where	d.nr_seq_escala = 21
			and	dt_versao_w between dt_inicio and dt_fim;

		elsif (ie_opcao_p = 'F') then

			select	min(dt_inicio)
			into STRICT	dt_versao_w
			from	escala_diaria d
			where	d.nr_seq_escala = 21
			and	dt_inicio > dt_versao_w;

		end if;
	end if;
end if;

return dt_versao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_datas_versao ( ie_opcao_p text, cd_versao_p text default null) FROM PUBLIC;

