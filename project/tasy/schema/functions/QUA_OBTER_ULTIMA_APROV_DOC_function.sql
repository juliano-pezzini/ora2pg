-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qua_obter_ultima_aprov_doc ( nr_sequencia_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_aprovacao_w			timestamp;


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	select	max(dt_aprovacao)
	into STRICT	dt_aprovacao_w
	from	qua_doc_revisao
	where	nr_seq_doc	= nr_sequencia_p;

	if (coalesce(dt_aprovacao_w::text, '') = '') then
		select	max(dt_aprovacao)
		into STRICT	dt_aprovacao_w
		from	qua_documento
		where	nr_sequencia	= nr_sequencia_p;
	end if;
end if;

return	dt_aprovacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qua_obter_ultima_aprov_doc ( nr_sequencia_p bigint) FROM PUBLIC;
