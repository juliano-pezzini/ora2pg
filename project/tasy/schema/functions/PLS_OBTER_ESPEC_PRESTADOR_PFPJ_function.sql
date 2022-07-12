-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_espec_prestador_pfpj (nr_seq_prestador_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(4000);

C01 CURSOR(	nr_seq_prestador_pc	pls_prestador.nr_sequencia%type) FOR
	SELECT	distinct ds_especialidade
	from (SELECT	c.ds_especialidade
		from	especialidade_medica	c,
			pls_prestador_med_espec	b,
			pls_prestador		a
		where	a.nr_sequencia		= nr_seq_prestador_pc
		and	a.nr_Sequencia		= b.nr_seq_prestador
		and	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
		and	b.cd_especialidade	= c.cd_especialidade
		and	clock_timestamp() between trunc(coalesce(b.dt_inicio_vigencia, clock_timestamp())) and fim_dia(coalesce(b.dt_fim_vigencia, clock_timestamp()))
		
union all

		select	c.ds_especialidade
		from	especialidade_medica	c,
			pls_prestador_med_espec	b,
			pls_prestador		a
		where	a.nr_sequencia		= nr_seq_prestador_pc
		and	a.nr_Sequencia		= b.nr_seq_prestador
		and	coalesce(a.cd_pessoa_fisica::text, '') = ''
		and	coalesce(b.cd_pessoa_fisica::text, '') = ''
		and	b.cd_especialidade	= c.cd_especialidade
		and	clock_timestamp() between trunc(coalesce(b.dt_inicio_vigencia, clock_timestamp())) and fim_dia(coalesce(b.dt_fim_vigencia, clock_timestamp()))) alias17
	order by ds_especialidade desc;

BEGIN

for r_C01_w in C01( nr_seq_prestador_p ) loop
	ds_retorno_w := ds_retorno_w || ', ' || r_C01_w.ds_especialidade;
end loop;

if (substr(ds_retorno_w, 1, 2) = ', ') then
	ds_retorno_w := substr(ds_retorno_w, 2, length(ds_retorno_w));
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_espec_prestador_pfpj (nr_seq_prestador_p bigint) FROM PUBLIC;

