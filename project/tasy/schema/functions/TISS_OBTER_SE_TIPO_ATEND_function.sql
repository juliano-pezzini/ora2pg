-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_se_tipo_atend (nr_seq_tipo_atend_p bigint, nr_interno_conta_p bigint) RETURNS varchar AS $body$
DECLARE


cd_area_procedimento_w	bigint;
cd_especialidade_w	bigint;
cd_grupo_proc_w		bigint;
cd_procedimento_w	bigint;
cd_tipo_procedimento_w	smallint;
ie_origem_proced_w	bigint;
cd_grupo_proc_ww		bigint;
cd_especialidade_ww	bigint;
cd_area_procedimento_ww	bigint;
cd_tipo_procedimento_ww	smallint;
cd_procedimento_ww	bigint;
ie_origem_proced_ww	bigint;
ds_retorno_w		varchar(15);

c01 CURSOR FOR
SELECT	cd_area_procedimento,
	cd_especialidade,
	cd_grupo_proc,
	cd_procedimento,
	cd_tipo_procedimento,
	ie_origem_proced
from	tiss_tipo_atend_proc a
where	a.nr_seq_tipo_atend	= nr_seq_tipo_atend_p
order by	coalesce(cd_area_procedimento,0),
	coalesce(cd_especialidade,0),
	coalesce(cd_grupo_proc,0),
	coalesce(cd_procedimento,0),
	coalesce(cd_tipo_procedimento,0);

c02 CURSOR FOR
SELECT	cd_procedimento,
	ie_origem_proced
from	procedimento_paciente
where	nr_interno_conta		= nr_interno_conta_p
and	coalesce(cd_motivo_exc_conta::text, '') = '';


BEGIN

ds_retorno_w		:= null;	-- Edgar 25/06/2009, OS 133370, deverá retornar null caso não ache a regra
open c01;
loop
fetch c01 into
	cd_area_procedimento_w,
	cd_especialidade_w,
	cd_grupo_proc_w,
	cd_procedimento_w,
	cd_tipo_procedimento_w,
	ie_origem_proced_w;
EXIT WHEN NOT FOUND or ds_retorno_w = 'S';  /* apply on c01 */

	ds_retorno_w		:= 'N';

	open c02;
	loop
	fetch c02 into
		cd_procedimento_ww,
		ie_origem_proced_ww;
	EXIT WHEN NOT FOUND or ds_retorno_w = 'S';  /* apply on c02 */

		select	cd_grupo_proc,
			cd_especialidade,
			cd_area_procedimento,
			cd_tipo_procedimento
		into STRICT	cd_grupo_proc_ww,
			cd_especialidade_ww,
			cd_area_procedimento_ww,
			cd_tipo_procedimento_ww
		from	estrutura_procedimento_v
		where	cd_procedimento	= cd_procedimento_ww
		and	ie_origem_proced	= ie_origem_proced_ww;

		if (cd_tipo_procedimento_w IS NOT NULL AND cd_tipo_procedimento_w::text <> '') and (cd_tipo_procedimento_w = cd_tipo_procedimento_ww) then
			ds_retorno_w		:= 'S';
		end if;
		if (cd_area_procedimento_w IS NOT NULL AND cd_area_procedimento_w::text <> '') and (cd_area_procedimento_w = cd_area_procedimento_ww) then
			ds_retorno_w		:= 'S';
		end if;
		if (cd_especialidade_w IS NOT NULL AND cd_especialidade_w::text <> '') and (cd_especialidade_w = cd_especialidade_ww) then
			ds_retorno_w		:= 'S';
		end if;
		if (cd_grupo_proc_w IS NOT NULL AND cd_grupo_proc_w::text <> '') and (cd_grupo_proc_w = cd_grupo_proc_ww) then
			ds_retorno_w		:= 'S';
		end if;
		if (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') and (cd_procedimento_w = cd_procedimento_ww) then
			ds_retorno_w		:= 'S';
		end if;

	end loop;
	close c02;

end loop;
close c01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_se_tipo_atend (nr_seq_tipo_atend_p bigint, nr_interno_conta_p bigint) FROM PUBLIC;

