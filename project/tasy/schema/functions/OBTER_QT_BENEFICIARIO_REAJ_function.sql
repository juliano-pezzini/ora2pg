-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_beneficiario_reaj ( nr_seq_reajuste_p bigint) RETURNS bigint AS $body$
DECLARE


qt_registros_w	bigint;


BEGIN

if (coalesce(nr_seq_reajuste_p,0) > 0) then
	select	count(*)
	into STRICT	qt_registros_w
	from	pls_segurado_preco a,
		pls_segurado b
	where	a.nr_seq_segurado = b.nr_sequencia
	and	coalesce(b.dt_rescisao::text, '') = ''
	and	nr_seq_lote_reajuste = nr_seq_reajuste_p;

end if;

return	qt_registros_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_beneficiario_reaj ( nr_seq_reajuste_p bigint) FROM PUBLIC;
