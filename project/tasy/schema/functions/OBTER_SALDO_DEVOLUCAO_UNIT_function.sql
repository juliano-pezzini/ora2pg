-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_saldo_devolucao_unit (nr_solic_unitarizacao_p bigint) RETURNS bigint AS $body$
DECLARE


qt_devolucao_w		double precision;
qt_solicitacao_w	double precision;
qt_devolvida_w		double precision;
qt_unitarizada_w	double precision;


BEGIN

select	coalesce(sum(qt_material),0)
into STRICT	qt_solicitacao_w
from	solic_unitarizacao
where	nr_sequencia = nr_solic_unitarizacao_p;

select	coalesce(sum(qt_devolucao),0)
into STRICT	qt_devolvida_w
from	solic_unitarizacao_dev
where	nr_solic_unitarizacao = nr_solic_unitarizacao_p;

select	coalesce(sum(qt_material),0)
into STRICT	qt_unitarizada_w
from	unitarizacao
where	nr_solic_unitarizacao = nr_solic_unitarizacao_p;

qt_devolucao_w := qt_solicitacao_w - (qt_devolvida_w + qt_unitarizada_w);

return	qt_devolucao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_saldo_devolucao_unit (nr_solic_unitarizacao_p bigint) FROM PUBLIC;

