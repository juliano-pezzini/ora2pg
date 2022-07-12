-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_se_aval_funcao (nr_seq_ordem_servico_p bigint, nr_seq_tipo_avaliacao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1) := 'S';
cd_funcao_w	integer;


BEGIN
if (nr_seq_ordem_servico_p IS NOT NULL AND nr_seq_ordem_servico_p::text <> '') then
	select	max(cd_funcao)
	into STRICT	cd_funcao_w
	from	man_ordem_servico
	where	nr_sequencia = nr_seq_ordem_servico_p;

	if (coalesce(cd_funcao_w::text, '') = '') then
		ds_retorno_w := 'S';
	else
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ds_retorno_w
		from	med_avaliacao_funcao
		where	nr_seq_tipo = nr_seq_tipo_avaliacao_p
		and	cd_funcao = cd_funcao_w;

		if (ds_retorno_w = 'N') then
			select	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
			into STRICT	ds_retorno_w
			from	med_avaliacao_funcao
			where	nr_seq_tipo = nr_seq_tipo_avaliacao_p;
		end if;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_se_aval_funcao (nr_seq_ordem_servico_p bigint, nr_seq_tipo_avaliacao_p bigint) FROM PUBLIC;

