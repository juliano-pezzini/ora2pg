-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_evol_motivo_alta (cd_motivo_alta_p bigint) RETURNS bigint AS $body$
DECLARE


cd_tipo_evolucao_w	bigint;


BEGIN

select	max(cd_tipo_evolucao)
into STRICT	cd_tipo_evolucao_w
from	cih_tipo_evolucao
where	cd_motivo_alta = cd_motivo_alta_p
and	ie_situacao = 'A';


return	cd_tipo_evolucao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_evol_motivo_alta (cd_motivo_alta_p bigint) FROM PUBLIC;
