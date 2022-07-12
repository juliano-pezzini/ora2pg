-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_menor_validade ( nr_seq_ordem_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_validade_w	timestamp;
hr_validade_w	bigint;


BEGIN

select 	min(obter_estabilidade_mat(cd_material))
into STRICT 	hr_validade_w
from 	can_ordem_item_prescr
where 	nr_seq_ordem = nr_seq_ordem_p;

dt_validade_w := clock_timestamp() + hr_validade_w / 24;

return	dt_validade_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_menor_validade ( nr_seq_ordem_p bigint) FROM PUBLIC;

