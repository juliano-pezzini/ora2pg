-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_valor_fixo_prest ( nr_seq_prestador_p bigint, dt_referencia_p timestamp, cd_pessoa_fisica_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_regra_w			bigint	:= 0;
vl_fixo_w			double precision	:= 0;


BEGIN

if (coalesce(cd_pessoa_fisica_p,'X') <> 'X') then
	select	max(nr_sequencia)
	into STRICT	nr_seq_regra_w
	from	pls_prestador_pgto_fixo
	where	trunc(dt_referencia_p) between trunc(dt_inicio_vigencia) and trunc(coalesce(dt_fim_vigencia, dt_referencia_p))
	and	cd_pessoa_fisica = cd_pessoa_fisica_p
	and	nr_seq_prestador_pf = nr_seq_prestador_p;

	if (coalesce(nr_seq_regra_w,0) = 0) then
		select	max(nr_sequencia)
		into STRICT	nr_seq_regra_w
		from	pls_prestador_pgto_fixo
		where	trunc(dt_referencia_p) between trunc(dt_inicio_vigencia) and trunc(coalesce(dt_fim_vigencia, dt_referencia_p))
		and	cd_pessoa_fisica = cd_pessoa_fisica_p
		and	coalesce(nr_seq_prestador_pf::text, '') = '';
	end if;
end if;

if (coalesce(nr_seq_regra_w,0) = 0) then
	select	max(nr_sequencia)
	into STRICT	nr_seq_regra_w
	from	pls_prestador_pgto_fixo
	where	nr_seq_prestador	= nr_seq_prestador_p
	and	trunc(dt_referencia_p) between trunc(dt_inicio_vigencia) and trunc(coalesce(dt_fim_vigencia, dt_referencia_p));
end if;

if (coalesce(nr_seq_regra_w,0) > 0) then
	select	coalesce(vl_fixo,0)
	into STRICT	vl_fixo_w
	from	pls_prestador_pgto_fixo
	where	nr_sequencia	= nr_seq_regra_w;
end if;

return	vl_fixo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_valor_fixo_prest ( nr_seq_prestador_p bigint, dt_referencia_p timestamp, cd_pessoa_fisica_p text) FROM PUBLIC;

