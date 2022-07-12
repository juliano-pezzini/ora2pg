-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exib_atend_canc (cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_cancelado_censo_w	varchar(1);


BEGIN

select	coalesce(max(ie_cancelado_censo),'S')
into STRICT	ie_cancelado_censo_w
from	parametro_atendimento
where	cd_estabelecimento = cd_estabelecimento_p;

return	ie_cancelado_censo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exib_atend_canc (cd_estabelecimento_p bigint) FROM PUBLIC;

