-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION bsc_obter_edicao_indicador ( nr_seq_indicador_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


nr_seq_edicao_w				bigint;
nr_seq_superior_w			bigint;
ds_retorno_w				varchar(255);


BEGIN

if (coalesce(nr_seq_indicador_p,0) <> 0) then

	select	max(nr_seq_superior)
	into STRICT	nr_seq_superior_w
	from	bsc_indicador
	where	nr_sequencia	= nr_seq_indicador_p;

	select	max(a.nr_seq_edicao)
	into STRICT	nr_seq_edicao_w
	from	bsc_ind_obj b,
		ple_objetivo a
	where	a.nr_sequencia		= b.nr_seq_objetivo
	and	b.nr_seq_indicador	= nr_seq_indicador_p;

	if (coalesce(nr_seq_superior_w::text, '') = '') and (coalesce(nr_seq_edicao_w::text, '') = '') then

		select	max(a.nr_seq_edicao)
		into STRICT	nr_seq_edicao_w
		from	bsc_indicador c,
			bsc_ind_obj b,
			ple_objetivo a
		where	a.nr_sequencia	= b.nr_seq_objetivo
		and	c.nr_seq_superior	= nr_seq_indicador_p
		and	c.nr_sequencia	= b.nr_seq_indicador;

	end if;

	if (ie_opcao_p = 'C') then
		ds_retorno_w	:= nr_seq_edicao_w;
	elsif (nr_seq_edicao_w IS NOT NULL AND nr_seq_edicao_w::text <> '') then
		select	max(ds_edicao)
		into STRICT	ds_retorno_w
		from	ple_edicao
		where	nr_sequencia	= nr_seq_edicao_w;
	end if;
end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION bsc_obter_edicao_indicador ( nr_seq_indicador_p bigint, ie_opcao_p text) FROM PUBLIC;
