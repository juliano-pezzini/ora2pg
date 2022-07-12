-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_peso_bco_sangue ( nr_prescricao_p bigint) RETURNS bigint AS $body$
DECLARE


qt_retorno_w	real;


BEGIN

select	coalesce(max(qt_peso),0)
into STRICT	qt_retorno_w
from	prescr_solic_bco_sangue
where	nr_prescricao = nr_prescricao_p;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_peso_bco_sangue ( nr_prescricao_p bigint) FROM PUBLIC;

