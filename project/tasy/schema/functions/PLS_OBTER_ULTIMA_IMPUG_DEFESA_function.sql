-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_ultima_impug_defesa (nr_seq_impugnacao_p pls_impugnacao.nr_sequencia%type) RETURNS bigint AS $body$
DECLARE


nr_seq_defesa_w		pls_impugnacao_defesa.nr_sequencia%type;
dt_defesa_w		pls_impugnacao_defesa.dt_defesa%type;


BEGIN

select	max(dt_defesa)
into STRICT	dt_defesa_w
from	pls_impugnacao_defesa
where	nr_seq_impugnacao	= nr_seq_impugnacao_p
and	coalesce(dt_cancelamento::text, '') = '';

select	max(nr_sequencia)
into STRICT	nr_seq_defesa_w
from	pls_impugnacao_defesa
where	nr_seq_impugnacao	= nr_seq_impugnacao_p
and	coalesce(dt_cancelamento::text, '') = ''
and	dt_defesa		= dt_defesa_w;

return	nr_seq_defesa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_ultima_impug_defesa (nr_seq_impugnacao_p pls_impugnacao.nr_sequencia%type) FROM PUBLIC;

