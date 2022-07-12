-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_fim_preparo (cd_material_p bigint, nr_seq_lote_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_fim_preparo_w 	timestamp;


BEGIN

select 	max(dt_fim_preparo)
into STRICT 	dt_fim_preparo_w
from can_ordem_prod
where nr_sequencia in ( SELECT nr_seq_ordem
			from can_ordem_prod_mat
			where nr_seq_lote_fornec = nr_seq_lote_p
			and cd_material = cd_material_p
			and coalesce(dt_solic_perda::text, '') = '');

return	dt_fim_preparo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_fim_preparo (cd_material_p bigint, nr_seq_lote_p bigint) FROM PUBLIC;

