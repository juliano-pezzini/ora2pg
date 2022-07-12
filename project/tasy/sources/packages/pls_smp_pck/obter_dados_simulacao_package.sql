-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_smp_pck.obter_dados_simulacao ( nr_seq_simulacao_p pls_smp.nr_sequencia%type, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/*	ie_opcao_p
	"VLP" 	- Valor selecionado do prestador
*/
ds_retorno_w	varchar(500) := '';

BEGIN

if (ie_opcao_p = 'VLP') then

	select	to_char(max(b.vl_simulacao_prest))
	into STRICT	ds_retorno_w
	from	pls_smp			a,
		pls_smp_result_prest	b
	where	b.nr_sequencia		= a.nr_seq_result_prest
	and	a.nr_sequencia		= nr_seq_simulacao_p;
end if;

return ds_retorno_w;
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_smp_pck.obter_dados_simulacao ( nr_seq_simulacao_p pls_smp.nr_sequencia%type, ie_opcao_p text) FROM PUBLIC;