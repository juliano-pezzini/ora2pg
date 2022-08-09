-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_obter_cod_proced_conv ( cd_proc_convenio_p text, cd_convenio_p bigint, cd_procedimento_p INOUT bigint, ie_origem_proced_p INOUT bigint) AS $body$
DECLARE


cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;

c01 CURSOR FOR
SELECT	cd_procedimento,
	ie_origem_proced
from	conversao_proc_convenio
where	cd_convenio			= cd_convenio_p
and	ltrim(cd_proc_convenio,'0')	= ltrim(cd_proc_convenio_p,'0') /*No TISS completa com '0'(Zero) até 8 casas, tendo enviado com conversão ou não */
and	ie_situacao			= 'A'				/*Por este motivo é necessário retirar neste select, pois a conversão pode ou não ter estes '0' (ZEROS)*/
order by coalesce(cd_procedimento,0),					/*NÃO PODE SER TO_NUMBER OU SOMENTE_NUMERO PORQUE PODE TER LETRAS NA CONVERSÃO*/
	coalesce(cd_grupo_proced,0),
	coalesce(cd_especial_proced,0),
	coalesce(cd_area_proced,0);

c02 CURSOR FOR
SELECT	cd_material
from	conversao_material_convenio
where	ltrim(cd_material_convenio,'0')	= ltrim(cd_proc_convenio_p,'0')
and	cd_convenio			= cd_convenio_p
and	ie_situacao			= 'A';


BEGIN

open c01;
loop
fetch c01 into
	cd_procedimento_w,
	ie_origem_proced_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;

if (coalesce(cd_procedimento_w,0) = 0) then
	open c02;
	loop
	fetch c02 into
		cd_procedimento_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
	end loop;
	close c02;
end if;

cd_procedimento_p	:= coalesce(cd_procedimento_w,cd_procedimento_p);
ie_origem_proced_p	:= coalesce(ie_origem_proced_w,ie_origem_proced_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_obter_cod_proced_conv ( cd_proc_convenio_p text, cd_convenio_p bigint, cd_procedimento_p INOUT bigint, ie_origem_proced_p INOUT bigint) FROM PUBLIC;
