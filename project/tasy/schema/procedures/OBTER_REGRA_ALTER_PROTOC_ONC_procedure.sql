-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_regra_alter_protoc_onc ( cd_protocolo_p bigint, nr_seq_medicacao_p bigint, cd_material_p bigint, ie_alterar_p INOUT text, ie_excluir_p INOUT text, ie_incluir_p INOUT text, ie_justificar_p INOUT text, ie_exceto_dose_p INOUT text, ie_exceto_dia_aplic_p INOUT text, ie_exceto_un_medida_p INOUT text, ie_pasta_p text default 'X') AS $body$
DECLARE



ie_alterar_w		varchar(1) := 'S';
ie_excluir_w		varchar(1) := 'S';
ie_incluir_w		varchar(1) := 'S';
ie_justificar_w		varchar(1) := 'N';
ie_exceto_dose_w	varchar(1) := 'N';
ie_exceto_dia_aplic_w	varchar(1) := 'N';
ie_exceto_un_medida_w	varchar(1) := 'N';

cd_grupo_material_w	smallint;
cd_subgrupo_w		smallint;
cd_classe_material_w	integer;

C01 CURSOR FOR
	SELECT	 coalesce(ie_permite_incluir,'S'),
             coalesce(ie_permite_excluir,'S'),
             coalesce(ie_permite_alterar,'S'),
             coalesce(ie_justificar,'N'),
             coalesce(ie_exceto_dose,'N'),
             coalesce(ie_exceto_dia_aplic,'N'),
             coalesce(ie_exceto_un_medida,'N')
	from	 regra_alt_prot_prescricao
	where	 coalesce(cd_protocolo,cd_protocolo_p)	      = cd_protocolo_p
	and	     coalesce(nr_seq_medicacao,nr_seq_medicacao_p) = nr_seq_medicacao_p
	and	     coalesce(cd_material,cd_material_p) 		  = cd_material_p
	and	     coalesce(cd_grupo_mat, cd_grupo_material_w)	  = cd_grupo_material_w
	and	     coalesce(cd_subgrupo_mat, cd_subgrupo_w)	  = cd_subgrupo_w
	and	     coalesce(cd_classe_mat, cd_classe_material_w) = cd_classe_material_w
	and  	 coalesce(ie_pasta,ie_pasta_p)  		          = ie_pasta_p
	and	     coalesce(cd_protocolo, cd_protocolo_p)        = cd_protocolo_p
	order by coalesce(cd_protocolo,0),
             coalesce(nr_seq_medicacao,0),
             coalesce(cd_material,0);

	c02 CURSOR FOR
	SELECT	coalesce(ie_permite_incluir,'S'),
		coalesce(ie_permite_excluir,'S'),
		coalesce(ie_permite_alterar,'S')
	from regra_alt_prot_prescricao
	where coalesce(cd_protocolo, cd_protocolo_p) = cd_protocolo_p
	and   coalesce(nr_seq_medicacao, nr_seq_medicacao_p) = nr_seq_medicacao_p
	and   coalesce(ie_pasta, ie_pasta_p) =  ie_pasta_p
	and	  (cd_protocolo IS NOT NULL AND cd_protocolo::text <> '');

BEGIN

if (cd_protocolo_p IS NOT NULL AND cd_protocolo_p::text <> '') and (cd_material_p > 0 ) then

	select	cd_grupo_material,
            cd_subgrupo_material,
            cd_classe_material
	into STRICT	cd_grupo_material_w,
            cd_subgrupo_w,
            cd_classe_material_w
	from	estrutura_material_v
	where	cd_material	= cd_material_p;


	open C01;
	loop
	fetch C01 into
		ie_incluir_w,
		ie_excluir_w,
		ie_alterar_w,
		ie_justificar_w,
		ie_exceto_dose_w,
		ie_exceto_dia_aplic_w,
		ie_exceto_un_medida_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */

		ie_incluir_p := ie_incluir_w;
		ie_excluir_p := ie_excluir_w;
		ie_alterar_p := ie_alterar_w;
		ie_justificar_p := ie_justificar_w;
		ie_exceto_dose_p := ie_exceto_dose_w;
		ie_exceto_dia_aplic_p := ie_exceto_dia_aplic_w;
		ie_exceto_un_medida_p := ie_exceto_un_medida_w;

	end loop;
	close C01;
elsif (cd_protocolo_p IS NOT NULL AND cd_protocolo_p::text <> '') then
	open c02;
	loop
	fetch c02 into
		ie_incluir_w,
		ie_excluir_w,
		ie_alterar_w;

		EXIT WHEN NOT FOUND; /* apply on c02 */

		ie_incluir_p := ie_incluir_w;
		ie_excluir_p := ie_excluir_w;
		ie_alterar_p := ie_alterar_w;
		ie_justificar_p := ie_justificar_w;
		ie_exceto_dose_p := ie_exceto_dose_w;
		ie_exceto_dia_aplic_p := ie_exceto_dia_aplic_w;
		ie_exceto_un_medida_p := ie_exceto_un_medida_w;
	end loop;
	close c02;
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_regra_alter_protoc_onc ( cd_protocolo_p bigint, nr_seq_medicacao_p bigint, cd_material_p bigint, ie_alterar_p INOUT text, ie_excluir_p INOUT text, ie_incluir_p INOUT text, ie_justificar_p INOUT text, ie_exceto_dose_p INOUT text, ie_exceto_dia_aplic_p INOUT text, ie_exceto_un_medida_p INOUT text, ie_pasta_p text default 'X') FROM PUBLIC;
