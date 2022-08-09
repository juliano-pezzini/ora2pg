-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_regra_ajuste_proc ( nr_sequencia_p bigint, cd_convenio_orig_p bigint, cd_convenio_dest_p text, ie_convenio_p text, ie_tabela_p text, ie_excluir_estrutura_p text, nm_usuario_p text) AS $body$
DECLARE


/*
ie_tabela_p
	P    - tabela REGRA_AJUSTE_PROC
*/
cd_convenio_dest_w		integer;
cd_classe_material_w           	integer;
cd_grupo_material_w            	smallint;
cd_material_w                  	integer;
cd_subgrupo_material_w         	smallint;
cd_area_procedimento_w          bigint;
cd_especialidade_w              bigint;
cd_grupo_proc_w                 bigint;
cd_procedimento_w               bigint;
ie_origem_proced_w		bigint;

c01 CURSOR FOR
	SELECT	coalesce(cd_convenio,0)
	from	convenio
	where	(((ie_convenio_p = '1') and (obter_se_contido(cd_convenio, substr(elimina_aspas(cd_convenio_dest_p),1,200)) = 'S')) or
		((ie_convenio_p = '2') and (not obter_se_contido(cd_convenio, substr(elimina_aspas(cd_convenio_dest_p),1,200)) = 'S')));


BEGIN

open C01;
loop
fetch C01 into
	cd_convenio_dest_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (cd_convenio_dest_w > 0) and
		((ie_convenio_p = '1') or (ie_convenio_p = '2' AND cd_convenio_dest_w <> cd_convenio_orig_p)) then

		if (ie_excluir_estrutura_p = 'S') and (ie_tabela_p = 'P') then

			select	max(cd_area_procedimento),
				max(cd_especialidade),
				max(cd_grupo_proc),
				max(cd_procedimento),
				max(ie_origem_proced)
			into STRICT	cd_area_procedimento_w,
				cd_especialidade_w,
				cd_grupo_proc_w,
				cd_procedimento_w,
				ie_origem_proced_w
			from	regra_ajuste_proc
			where	nr_sequencia = nr_sequencia_p;

			delete 	from regra_ajuste_proc
			where 	cd_convenio = cd_convenio_dest_w
			and	coalesce(cd_area_procedimento,coalesce(cd_area_procedimento_w,0))		= coalesce(cd_area_procedimento_w,0)
			and	coalesce(cd_especialidade,coalesce(cd_especialidade_w,0))			= coalesce(cd_especialidade_w,0)
			and	coalesce(cd_procedimento,coalesce(cd_procedimento_w,0))			= coalesce(cd_procedimento_w,0)
			and	coalesce(cd_grupo_proc,coalesce(cd_grupo_proc_w,0))			= coalesce(cd_grupo_proc_w,0)
			and	coalesce(ie_origem_proced,coalesce(ie_origem_proced_w,0))			= coalesce(ie_origem_proced_w,0);

			delete 	from regra_ajuste_proc
			where 	cd_convenio = cd_convenio_orig_p
			and	nr_sequencia = nr_sequencia_p;
		end if;
	end if;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_regra_ajuste_proc ( nr_sequencia_p bigint, cd_convenio_orig_p bigint, cd_convenio_dest_p text, ie_convenio_p text, ie_tabela_p text, ie_excluir_estrutura_p text, nm_usuario_p text) FROM PUBLIC;
