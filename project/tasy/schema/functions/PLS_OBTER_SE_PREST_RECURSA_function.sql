-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_prest_recursa ( nr_seq_item_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_prestador_p pls_prestador.nr_sequencia%type, ie_tipo_prestador_p text, ie_tipo_item_p text) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1) := 'N';
qt_prest_w		integer := 0;


BEGIN

if (ie_tipo_prestador_p = 'PG') then

	if (ie_tipo_item_p = 'P') then
		select	count(1)
		into STRICT	qt_prest_w
		from	pls_conta_medica_resumo
		where	nr_seq_conta = nr_seq_conta_p
		and	nr_seq_conta_proc = nr_seq_item_p
		and	nr_seq_prestador_pgto = nr_seq_prestador_p;
	elsif (ie_tipo_item_p = 'M') then
		select	count(1)
		into STRICT	qt_prest_w
		from	pls_conta_medica_resumo
		where	nr_seq_conta = nr_seq_conta_p
		and	nr_seq_conta_mat = nr_seq_item_p
		and	nr_seq_prestador_pgto = nr_seq_prestador_p;
	end if;

	if (qt_prest_w > 0) then
		ie_retorno_w := 'S';
	end if;
else
	ie_retorno_w := 'S';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_prest_recursa ( nr_seq_item_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_prestador_p pls_prestador.nr_sequencia%type, ie_tipo_prestador_p text, ie_tipo_item_p text) FROM PUBLIC;

