-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_acresc_cr ( cd_estabelecimento_p bigint, cd_cgc_p text, vl_acrescimo_p INOUT bigint) AS $body$
DECLARE


vl_acrescimo_w	double precision;

c01 CURSOR FOR
SELECT	vl_acrescimo
from	REGRA_ACRESC_CR
where	cd_estabelecimento = cd_estabelecimento_p
and	ie_situacao 	 = 'A'
and	((ie_pessoa = 'J' AND cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') or
	 ((ie_pessoa = 'F')   and (coalesce(cd_cgc_p::text, '') = '')) or (ie_pessoa = 'A'))
and	coalesce(cd_cgc, coalesce(cd_cgc_p, 'X'))	= coalesce(cd_cgc_p, 'X')
order 	by coalesce(cd_cgc,'0');


BEGIN

open c01;
loop
fetch c01 into
	vl_acrescimo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	vl_acrescimo_p	:= vl_acrescimo_w;

end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_acresc_cr ( cd_estabelecimento_p bigint, cd_cgc_p text, vl_acrescimo_p INOUT bigint) FROM PUBLIC;
