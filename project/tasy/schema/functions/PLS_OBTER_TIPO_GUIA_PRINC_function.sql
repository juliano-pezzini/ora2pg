-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_tipo_guia_princ (nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_princ_p pls_conta.nr_seq_conta_princ%type) RETURNS varchar AS $body$
DECLARE


ie_tipo_guia_w		pls_conta.ie_tipo_guia%type;

BEGIN

if (nr_seq_conta_princ_p IS NOT NULL AND nr_seq_conta_princ_p::text <> '') then
	select 	max(ie_tipo_guia)
	into STRICT	ie_tipo_guia_w
	from	pls_conta
	where 	nr_sequencia 	= nr_seq_conta_princ_p;
else
	select 	max(ie_tipo_guia)
	into STRICT	ie_tipo_guia_w
	from	pls_conta
	where 	nr_sequencia 	= nr_seq_conta_p;
end if;

return	ie_tipo_guia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_tipo_guia_princ (nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_princ_p pls_conta.nr_seq_conta_princ%type) FROM PUBLIC;

