-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_se_mat_compativel ( cd_estabelecimento_p bigint, cd_convenio_p bigint, nr_seq_proc_interno_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_material_p bigint) RETURNS varchar AS $body$
DECLARE

					
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
qt_registro_w		bigint;
cd_procedimento_opme_w	bigint;
ie_origem_proc_opme_w	bigint;
ds_retorno_w		varchar(10)	:= 'S';		

C01 CURSOR FOR
	SELECT	cd_procedimento,
		ie_origem_proced
	from	sus_material_opm
	where	cd_material		= cd_material_p
	and	cd_estabelecimento	= cd_estabelecimento_p
	order by nr_sequencia;


BEGIN

select	count(cd_material)
into STRICT	qt_registro_w
from	sus_material_opm
where	cd_estabelecimento	= cd_estabelecimento_p;


if (coalesce(cd_procedimento_p::text, '') = '') then
	begin
	SELECT * FROM obter_proc_tab_interno_conv(	nr_seq_proc_interno_p, cd_estabelecimento_p, cd_convenio_p, 0, null, null, cd_procedimento_w, ie_origem_proced_w, null, clock_timestamp(), null, null, null, null, null, null, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
	end;
else
	begin
	cd_procedimento_w	:= cd_procedimento_p;
	ie_origem_proced_w	:= coalesce(ie_origem_proced_p,7);
	end;
end if;

if (qt_registro_w		> 0) and (ie_origem_proced_w	= 7)then

	ds_retorno_w	:= 'N';

	open C01;
	loop
	fetch C01 into
		cd_procedimento_opme_w,
		ie_origem_proc_opme_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select	count(cd_proc_principal)
		into STRICT	qt_registro_w
		from	sus_proc_compativel
		where	cd_proc_principal    	= cd_procedimento_w
		and	ie_origem_proc_princ 	= ie_origem_proced_w
		and	cd_proc_secundario	= cd_procedimento_opme_w
		and	ie_origem_proc_sec		= ie_origem_proc_opme_w
		and	ie_tipo_compatibilidade	in ('1','4','5')
		and	sus_validar_regra(4, cd_procedimento_w, ie_origem_proced_w, null) = 0;

		if (qt_registro_w	>	0) then
			ds_retorno_w	:= 'S';
		end if;

		select	count(cd_proc_secundario)
		into STRICT	qt_registro_w
		from	sus_proc_compativel
		where 	cd_proc_secundario    	= cd_procedimento_w
		and   	ie_origem_proc_sec 	= ie_origem_proced_w
		and	cd_proc_principal		= cd_procedimento_opme_w
		and	ie_origem_proc_princ	= ie_origem_proc_opme_w
		and	ie_tipo_compatibilidade	in ('1','4','5')
		and	sus_validar_regra(4, cd_procedimento_w, ie_origem_proced_w, null) > 0;

		if (qt_registro_w	>	0) then
			ds_retorno_w	:= 'S';
		end if;

		end;
	end loop;
	close C01;
end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_se_mat_compativel ( cd_estabelecimento_p bigint, cd_convenio_p bigint, nr_seq_proc_interno_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_material_p bigint) FROM PUBLIC;

