-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_produto_benef ( nr_seq_segurado_p bigint, dt_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


nr_seq_plano_w		pls_plano.nr_sequencia%type;
nr_seq_plano_ant_w	pls_plano.nr_sequencia%type;
nr_seq_alt_plano_w	pls_segurado_alt_plano.nr_sequencia%type;
nr_seq_alt_plano_ww	pls_segurado_alt_plano.nr_sequencia%type;
dt_alteracao_w		pls_segurado_alt_plano.dt_alteracao%type;


BEGIN

select	max(nr_seq_plano)
into STRICT	nr_seq_plano_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;

select	max(nr_sequencia)
into STRICT	nr_seq_alt_plano_w
from	pls_segurado_alt_plano
where	nr_seq_segurado	= nr_seq_segurado_p
and	nr_seq_plano_atual = nr_seq_plano_w
and	ie_situacao = 'A'
and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_alteracao) > dt_referencia_p;

if (nr_seq_alt_plano_w IS NOT NULL AND nr_seq_alt_plano_w::text <> '') then
	select	max(nr_seq_plano_ant),
		max(dt_alteracao)
	into STRICT	nr_seq_plano_ant_w,
		dt_alteracao_w
	from	pls_segurado_alt_plano
	where	nr_sequencia	= nr_seq_alt_plano_w;
	
	select	max(nr_sequencia)
	into STRICT	nr_seq_alt_plano_ww
	from	pls_segurado_alt_plano
	where	nr_seq_segurado	= nr_seq_segurado_p
	and	nr_seq_plano_atual = nr_seq_plano_ant_w
	and	ie_situacao = 'A'
	and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_alteracao) = ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_alteracao_w);
	
	if (coalesce(nr_seq_alt_plano_ww::text, '') = '') then
		nr_seq_plano_w	:= nr_seq_plano_ant_w;
	end if;
end if;

return	nr_seq_plano_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_produto_benef ( nr_seq_segurado_p bigint, dt_referencia_p timestamp) FROM PUBLIC;

