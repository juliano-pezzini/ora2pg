-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_pp_lote_pagamento_pck.obter_cd_pessoa_prestador ( nr_seq_prestador_p pls_prestador.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(50);


BEGIN
-- so verifica caso seja passado um prestador

if (nr_seq_prestador_p IS NOT NULL AND nr_seq_prestador_p::text <> '') then

	select	max(coalesce(cd_pessoa_fisica, cd_cgc))
	into STRICT	ds_retorno_w
	from	pls_prestador
	where	nr_sequencia = nr_seq_prestador_p;
end if;

return	ds_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_pp_lote_pagamento_pck.obter_cd_pessoa_prestador ( nr_seq_prestador_p pls_prestador.nr_sequencia%type) FROM PUBLIC;