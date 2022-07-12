-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sup_obter_total_requisicao ( nr_requisicao_p requisicao_material.nr_requisicao%type) RETURNS bigint AS $body$
DECLARE


vl_retorno_w			item_requisicao_material.vl_unit_previsto%type	:= 0;


BEGIN

select	coalesce(sum(b.qt_material_requisitada * b.vl_unit_previsto),0)
into STRICT	vl_retorno_w
from	requisicao_material a,
	item_requisicao_material b
where	a.nr_requisicao	= b.nr_requisicao
and	a.nr_requisicao = nr_requisicao_p;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sup_obter_total_requisicao ( nr_requisicao_p requisicao_material.nr_requisicao%type) FROM PUBLIC;
