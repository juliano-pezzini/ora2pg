-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_kit_proc_orc (cd_pessoa_fisica_p text, cd_convenio_p bigint, cd_estabelecimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, cd_setor_atendimento_p bigint, cd_medico_p text, cd_kit_material_p INOUT bigint) AS $body$
DECLARE


cd_kit_material_w	bigint	:= 0;
cd_setor_atendimento_w	bigint;
cd_medico_w		varchar(10);
qt_idade_w		double precision;
cd_convenio_w		integer;

C01 CURSOR FOR
	SELECT	coalesce(cd_kit_material,0)
	from	proc_interno_kit
	where	nr_seq_proc_interno	= nr_seq_proc_interno_p
	and	coalesce(cd_setor_atendimento,cd_setor_atendimento_w)	= cd_setor_atendimento_w
	and	cd_estabelecimento	= cd_estabelecimento_p
	and	coalesce(cd_medico,cd_medico_w)	= cd_medico_w
	and	qt_idade_w between obter_idade_kit_proced(nr_sequencia,'MIN') and obter_idade_kit_proced(nr_sequencia,'MAX')
	and	coalesce(cd_convenio, cd_convenio_w)	= cd_convenio_w
	and	coalesce(cd_perfil, coalesce(obter_perfil_ativo,0))	= coalesce(obter_perfil_ativo,0)
	order by coalesce(cd_medico,'0'),
		 coalesce(cd_setor_atendimento,0),
		 coalesce(cd_convenio,0);


BEGIN

select	max(obter_idade(b.dt_nascimento,coalesce(b.dt_obito,clock_timestamp()),'DIA'))
into STRICT	qt_idade_w
from	pessoa_fisica b
where	b.cd_pessoa_fisica = cd_pessoa_fisica_p;

cd_setor_atendimento_w		:= coalesce(cd_setor_atendimento_p,0);
cd_medico_w	:= coalesce(cd_medico_p,'0');
cd_convenio_w   := coalesce(cd_convenio_p,0);

open C01;
loop
fetch C01 into
	cd_kit_material_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

end loop;
close C01;

if (coalesce(cd_kit_material_w,0)	= 0) then
	begin
	select	coalesce(max(cd_kit_material),0)
	into STRICT	cd_kit_material_w
	from	proc_interno
	where	nr_sequencia	= nr_seq_proc_interno_p;
	exception
		when others then
		cd_kit_material_w	:= 0;
	end;
end if;

if (cd_kit_material_w = 0) then
	select	coalesce(max(cd_kit_material),0)
	into STRICT	cd_kit_material_w
	from 	procedimento
	where	cd_procedimento		= cd_procedimento_p
	and	ie_origem_proced	= ie_origem_proced_p;
end if;

cd_kit_material_p	:= cd_kit_material_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_kit_proc_orc (cd_pessoa_fisica_p text, cd_convenio_p bigint, cd_estabelecimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, cd_setor_atendimento_p bigint, cd_medico_p text, cd_kit_material_p INOUT bigint) FROM PUBLIC;

