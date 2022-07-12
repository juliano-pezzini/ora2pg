-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_melhor_acesso (cd_pessoa_fisica_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
	C -> Retorna a sequencia do acesso
	D -> Retornar a descricao tecnica concatenada com o local
*/
nr_seq_acesso_w			bigint;
ds_tecnica_acesso_w		varchar(80);
ds_local_acesso_w		varchar(80);
ds_retorno_w			varchar(160);


BEGIN

select	max(nr_sequencia)
	into STRICT	nr_seq_acesso_w
from	hd_acesso
where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and	ie_adequado = 'S'
	and	dt_instalacao <= clock_timestamp()
	and	coalesce(dt_perda_retirada::text, '') = '';

if (coalesce(nr_seq_acesso_w::text, '') = '') then
   begin
	select	max(nr_sequencia)
		into STRICT	nr_seq_acesso_w
	from	hd_acesso
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
		and	dt_instalacao <= clock_timestamp()
		and	coalesce(dt_perda_retirada::text, '') = '';
   end;
end if;

if (ie_opcao_p = 'C') then
	ds_retorno_w	:= nr_seq_acesso_w;
elsif (ie_opcao_p = 'D') then
	begin

	select	substr(c.ds_tecnica_acesso,1,80),
		substr(b.ds_local_acesso,1,80)
	into STRICT	ds_tecnica_acesso_w,
		ds_local_acesso_w
	from	hd_tecnica_acesso c,
		hd_local_acesso b,
		hd_acesso a
	where	c.nr_sequencia	= a.nr_seq_tecnica
		and	b.nr_sequencia	= a.nr_seq_local	
		and	a.nr_sequencia	= nr_seq_acesso_w;

	ds_retorno_w	:= ds_tecnica_acesso_w || ' ' || ds_local_acesso_w;
	end;
else
	ds_retorno_w	:= '';
end if;

return ds_retorno_w;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_melhor_acesso (cd_pessoa_fisica_p text, ie_opcao_p text) FROM PUBLIC;
