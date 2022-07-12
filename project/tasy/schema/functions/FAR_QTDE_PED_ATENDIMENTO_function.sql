-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION far_qtde_ped_atendimento (nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


qt_retorno_w		bigint;


BEGIN

select	count(*)
into STRICT	qt_retorno_w
from	far_pedido a
where	(dt_fechamento IS NOT NULL AND dt_fechamento::text <> '')
and	nr_atendimento = nr_atendimento_p;

return qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION far_qtde_ped_atendimento (nr_atendimento_p bigint) FROM PUBLIC;

