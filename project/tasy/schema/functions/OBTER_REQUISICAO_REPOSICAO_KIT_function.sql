-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_requisicao_reposicao_kit (nr_seq_kit_p bigint) RETURNS bigint AS $body$
DECLARE


nr_requisicao_w	requisicao_material.nr_requisicao%type;


BEGIN

select	max(b.nr_requisicao)
into STRICT	nr_requisicao_w
from	requisicao_material a,
	item_requisicao_material b
where	a.nr_requisicao = b.nr_requisicao
and	b.nr_seq_kit_estoque = nr_seq_kit_p
and	a.ie_origem_requisicao = 'RKT';

return	nr_requisicao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_requisicao_reposicao_kit (nr_seq_kit_p bigint) FROM PUBLIC;
