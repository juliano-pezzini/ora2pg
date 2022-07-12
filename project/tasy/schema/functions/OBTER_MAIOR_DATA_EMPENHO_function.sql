-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_maior_data_empenho ( nr_ordem_compra_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_empenho_w		timestamp;


BEGIN

select	max(dt_empenho)
into STRICT	dt_empenho_w
from	ordem_compra_item
where	nr_ordem_compra	= nr_ordem_compra_p;

return	dt_empenho_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_maior_data_empenho ( nr_ordem_compra_p bigint) FROM PUBLIC;

