-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_local_estoque_nf ( cd_material_p bigint ) RETURNS bigint AS $body$
DECLARE


cd_local_estoque_w		smallint;


BEGIN

select	max(cd_local_estoque)
into STRICT	cd_local_estoque_w
from	nota_fiscal_item a,
         	nota_fiscal b
where	a.nr_sequencia		 = b.nr_sequencia
and	a.cd_material_estoque	 = cd_material_p
and	(cd_local_estoque IS NOT NULL AND cd_local_estoque::text <> '')
and	b.dt_entrada_saida >= (	SELECT	max(dt_entrada_saida)
                                 		from	nota_fiscal_item x,
                                    			nota_fiscal w
                              			where	x.nr_sequencia	 	= w.nr_sequencia
                              			and	x.cd_material_estoque	 = cd_material_p
                              			and	(x.cd_local_estoque IS NOT NULL AND x.cd_local_estoque::text <> ''));

return cd_local_estoque_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_local_estoque_nf ( cd_material_p bigint ) FROM PUBLIC;
