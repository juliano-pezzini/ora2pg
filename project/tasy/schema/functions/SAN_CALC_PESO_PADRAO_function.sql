-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_calc_peso_padrao ( nr_seq_derivado_p bigint, qt_volume_p bigint) RETURNS bigint AS $body$
DECLARE


-- Após alterar esta function, deve ser verificada a SAN_CALC_VOLUME_PADRAO, que faz o oposto desta
qt_densidade_w		double precision;
qt_peso_bolsa_w		double precision;

BEGIN

select	coalesce(max(qt_densidade_hemo),1)
into STRICT	qt_densidade_w
from	san_derivado
where	nr_sequencia = nr_seq_derivado_p;

select	trunc(coalesce(qt_volume_p,0) * qt_densidade_w)
into STRICT	qt_peso_bolsa_w
;

return	qt_peso_bolsa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_calc_peso_padrao ( nr_seq_derivado_p bigint, qt_volume_p bigint) FROM PUBLIC;

