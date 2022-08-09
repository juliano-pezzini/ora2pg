-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_obter_evento_convenio (cd_estabelecimento_p bigint, cd_convenio_p bigint, nr_seq_evento_p bigint, cd_convenio_regra_p INOUT bigint, ie_ws_generico_p INOUT text) AS $body$
DECLARE


cd_convenio_regra_w	bigint;
ie_ws_generico_w	varchar(10);

c01 CURSOR FOR
SELECT	cd_convenio
from	evento_convenio
where	cd_estabelecimento			= cd_estabelecimento_p
and	nr_seq_evento 				= nr_seq_evento_p
and	nr_seq_interface 			in (64,69)
and	coalesce(cd_convenio,coalesce(cd_convenio_p,0))	= coalesce(cd_convenio_p,0)
order by coalesce(cd_convenio,0);


BEGIN

ie_ws_generico_w	:= 'N';

open C01;
loop
fetch C01 into
	cd_convenio_regra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	ie_ws_generico_w	:= 'S';
end loop;
close C01;

cd_convenio_regra_p	:= cd_convenio_regra_w;
ie_ws_generico_p	:= ie_ws_generico_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_obter_evento_convenio (cd_estabelecimento_p bigint, cd_convenio_p bigint, nr_seq_evento_p bigint, cd_convenio_regra_p INOUT bigint, ie_ws_generico_p INOUT text) FROM PUBLIC;
