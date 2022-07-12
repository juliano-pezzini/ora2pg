-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_motalta_procxconv ( nr_atendimento_p bigint, cd_motivo_alta_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1) := 'S';
qt_existe_w		bigint;
cd_procedimento_w	numeric(20);
ie_origem_proced_w	numeric(20);
cd_convenio_w		numeric(20);

C01 CURSOR FOR
	SELECT	cd_procedimento,
		ie_origem_proced,
		cd_convenio
	from	regra_mot_alta_conv_proc
	where	ie_situacao = 'A'
	and	cd_motivo_alta = cd_motivo_alta_p;


BEGIN
if (coalesce(cd_motivo_alta_p,0) > 0) and (coalesce(nr_atendimento_p,0) > 0) then

	select 	count(*)
	into STRICT	qt_existe_w
	from	regra_mot_alta_conv_proc
	where	ie_situacao = 'A'
	and	cd_motivo_alta = cd_motivo_alta_p;

	if (qt_existe_w > 0) then
		ds_retorno_w := 'N';

		open C01;
		loop
		fetch C01 into
			cd_procedimento_w,
			ie_origem_proced_w,
			cd_convenio_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin

			if (ds_retorno_w = 'N') then

				select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
				into STRICT	ds_retorno_w
				from	procedimento_paciente
				where	cd_procedimento = cd_procedimento_w
				and	ie_origem_proced = ie_origem_proced_w
				and (obter_convenio_atendimento(nr_atendimento) = cd_convenio_w or coalesce(cd_convenio_w::text, '') = '')
				and	nr_atendimento = nr_atendimento_p;

			end if;
			end;
		end loop;
		close C01;
	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_motalta_procxconv ( nr_atendimento_p bigint, cd_motivo_alta_p bigint) FROM PUBLIC;
