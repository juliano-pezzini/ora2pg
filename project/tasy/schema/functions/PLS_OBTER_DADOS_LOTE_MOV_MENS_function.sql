-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_lote_mov_mens ( nr_seq_lote_p pls_mov_mens_lote.nr_sequencia%type, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);


BEGIN

if (ie_opcao_p = 'LM') then --Lote de mensalidade
	select	max(nr_sequencia)
	into STRICT	ds_retorno_w
	from	pls_lote_mensalidade
	where	nr_seq_lote_mov_mens = nr_seq_lote_p;
elsif (ie_opcao_p = 'V') then --Valor total
	select	coalesce(sum(a.vl_item),0)
	into STRICT	ds_retorno_w
	from	pls_mov_mens_benef_item a,
		pls_mov_mens_benef b
	where	b.nr_sequencia	= a.nr_seq_mov_benef
	and	b.nr_seq_lote	= nr_seq_lote_p;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_lote_mov_mens ( nr_seq_lote_p pls_mov_mens_lote.nr_sequencia%type, ie_opcao_p text) FROM PUBLIC;

