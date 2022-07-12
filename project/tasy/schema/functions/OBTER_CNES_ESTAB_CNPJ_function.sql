-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cnes_estab_cnpj (cnpj_p text) RETURNS varchar AS $body$
DECLARE


cd_cnes_w	varchar(30);


BEGIN

select	max(cd_cns)
into STRICT	cd_cnes_w
from	estabelecimento
where	cd_cgc = cnpj_p;

RETURN cd_cnes_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cnes_estab_cnpj (cnpj_p text) FROM PUBLIC;

