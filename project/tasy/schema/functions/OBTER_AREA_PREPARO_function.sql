-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_area_preparo ( nr_prescricao_p bigint, nr_seq_material_p bigint) RETURNS bigint AS $body$
DECLARE

		
cd_setor_atendimento_w	integer;
nr_seq_material_w		integer;
cd_local_estoque_w	smallint;
cd_unidade_medida_w	varchar(30);
ie_via_aplicacao_w		varchar(5);
cd_grupo_material_w	smallint;
cd_subgrupo_material_w	smallint;
cd_classe_material_w	integer;
cd_material_w		integer;
nr_seq_regra_prep_w	bigint;
nr_seq_area_prep_w	bigint;
nr_atendimento_w	bigint;
cd_setor_prescr_w	integer;
cd_local_prescr_w	smallint;
cd_estabelecimento_w	integer;
cd_local_estoque_prescr_w smallint;
ie_local_estoque_proc_w	varchar(2);
nr_seq_kit_w		bigint;
nr_sequencia_w		bigint;
nr_seq_familia_w	bigint;
cd_material_estoque_w	integer;
ie_gerar_area_sem_disp_w	varchar(1);
nr_seq_agrup_classif_w		bigint;
nr_seq_agrupamento_w		bigint;
ie_urgencia_w				varchar(1);
ie_acm_w					varchar(1);
ie_se_necessario_w			varchar(1);
qt_dose_especial_w			double precision;
ie_item_fracionado_w varchar(1);
qt_dose_w prescr_material.qt_dose%type;
ie_agrupador_w              prescr_material.ie_agrupador%type;
nr_seq_mat_cpoe_w           prescr_material.nr_seq_mat_cpoe%type;
ie_tipo_solucao_w           cpoe_material.ie_tipo_solucao%type;
ie_tipo_bomba_w             cpoe_material.ie_bomba_infusao%type;
nr_sequencia_solucao_w      prescr_material.nr_sequencia_solucao%type;
			
c01 CURSOR FOR
SELECT	coalesce(cd_local_prescr_w,0),
	a.nr_sequencia,
	coalesce(a.cd_unidade_medida,'XPTO'),
	coalesce(a.ie_via_aplicacao,'XPTO'),
	b.cd_grupo_material,
	b.cd_subgrupo_material,
	b.cd_classe_material,
	b.cd_material,
	coalesce(b.nr_seq_familia,0),
	b.cd_material_estoque,
	a.ie_agrupador,
	coalesce(ie_urgencia,'N'),
	coalesce(a.ie_acm, 'N'),
	coalesce(a.ie_se_necessario,'N'),
	coalesce(qt_dose_especial,0),
	coalesce(Obter_dose_convertida(	a.cd_material,
								a.qt_dose,
								a.cd_unidade_medida_dose,
								obter_dados_material_estab(a.cd_material,cd_estabelecimento_w,'UMS')),0) qt_dose,
    a.nr_seq_mat_cpoe,
    a.nr_sequencia_solucao
from	estrutura_material_v b,
	prescr_material a
where	b.cd_material		= a.cd_material
and	((ie_gerar_area_sem_disp_w = 'S') or (coalesce(ie_regra_disp,'S') <> 'N'))
and	a.nr_prescricao		= nr_prescricao_p
and	((coalesce(nr_seq_material_p,0) = 0) or (a.nr_sequencia	= nr_seq_material_p))
order by
	a.nr_sequencia;
	
c02 CURSOR FOR
SELECT	a.nr_sequencia,
	a.nr_seq_area_prep
from	adep_area_prep b,
	adep_regra_area_prep a
where	a.nr_seq_area_prep					= b.nr_sequencia
and obter_se_regra_setor_area(cd_setor_atendimento_w, b.nr_sequencia) = 'S'
and	coalesce(b.cd_setor_atendimento, cd_setor_atendimento_w)	= cd_setor_atendimento_w
and coalesce(a.cd_estabelecimento_regra, cd_estabelecimento_w)		= cd_estabelecimento_w
and	coalesce(a.cd_local_estoque, cd_local_estoque_w)		= cd_local_estoque_w
and	coalesce(a.cd_unidade_medida, cd_unidade_medida_w)		= cd_unidade_medida_w
and	coalesce(a.ie_via_aplicacao, ie_via_aplicacao_w)		= ie_via_aplicacao_w
and	coalesce(a.cd_grupo_material, cd_grupo_material_w)		= cd_grupo_material_w
and	coalesce(a.cd_subgrupo_material, cd_subgrupo_material_w)	= cd_subgrupo_material_w
and	coalesce(a.cd_classe_material, cd_classe_material_w)		= cd_classe_material_w
and	coalesce(a.cd_material, cd_material_w)			= cd_material_w
and	coalesce(nr_seq_familia, coalesce(nr_seq_familia_w,0))		= coalesce(nr_seq_familia_w,0)
and	coalesce(a.cd_controlador_estoque, coalesce(cd_material_estoque_w,0))	= coalesce(cd_material_estoque_w,0)
and	coalesce(a.nr_seq_agrupamento_setor, coalesce(nr_seq_agrupamento_w,0)) = coalesce(nr_seq_agrupamento_w,0)
and	coalesce(b.ie_situacao,'A')				= 'A'
and	coalesce(a.ie_situacao,'A')				= 'A'
and	coalesce(a.ie_exclusao,'N')				= 'N'
and	coalesce(a.nr_seq_agrup_classif, coalesce(nr_seq_agrup_classif_w,0)) = coalesce(nr_seq_agrup_classif_w,0)
and	(((coalesce(a.ie_hemodialise,'S') = 'S') and (ie_agrupador_w = 13)) or
	 ((coalesce(a.ie_hemodialise,'N') = 'N') and (ie_agrupador_w <> 13)))
and 	((coalesce(ie_dose_especial,'N') = 'N') or ((coalesce(ie_dose_especial,'N') = 'S') and (qt_dose_especial_w > 0)))
and		(((coalesce(ie_somente_acmsn,'N') = 'G') and ((ie_acm_w = 'S') or (ie_se_necessario_w = 'S') or (ie_urgencia_w = 'S'))) or
		((coalesce(ie_somente_acmsn,'N') = 'S') and ((ie_acm_w = 'S') or (ie_se_necessario_w = 'S'))) or
		((coalesce(ie_somente_acmsn,'N') = 'A') and (ie_acm_w = 'S') and (ie_se_necessario_w = 'N')) or
		((coalesce(ie_somente_acmsn,'N') = 'C') and (ie_acm_w = 'N') and (ie_se_necessario_w = 'S')) or (coalesce(ie_somente_acmsn,'N') = 'N'))
and ((coalesce(a.ie_somente_fracionados, 'N') = 'S' and ie_item_fracionado_w = 'S') or (coalesce(a.ie_somente_fracionados, 'N') = 'N'))
and	not exists (	SELECT	1
			from	adep_area_prep x,
				adep_regra_area_prep z
			where	x.nr_sequencia = b.nr_sequencia
			and	z.nr_seq_area_prep					= x.nr_sequencia
			and obter_se_regra_setor_area(cd_setor_atendimento_w, b.nr_sequencia) = 'S'
			and	coalesce(x.cd_setor_atendimento, cd_setor_atendimento_w)	= cd_setor_atendimento_w
      and coalesce(z.cd_estabelecimento_regra, cd_estabelecimento_w)		= cd_estabelecimento_w
			and	coalesce(z.cd_local_estoque, cd_local_estoque_w)		= cd_local_estoque_w
			and	coalesce(z.cd_unidade_medida, cd_unidade_medida_w)		= cd_unidade_medida_w
			and	coalesce(z.ie_via_aplicacao, ie_via_aplicacao_w)		= ie_via_aplicacao_w
			and	coalesce(z.cd_grupo_material, cd_grupo_material_w)		= cd_grupo_material_w
			and	coalesce(z.cd_subgrupo_material, cd_subgrupo_material_w)	= cd_subgrupo_material_w
			and	coalesce(z.cd_classe_material, cd_classe_material_w)		= cd_classe_material_w
			and	coalesce(z.cd_material, cd_material_w)			= cd_material_w
			and	coalesce(z.nr_seq_familia, coalesce(nr_seq_familia_w,0))		= coalesce(nr_seq_familia_w,0)
			and	coalesce(z.cd_controlador_estoque, coalesce(cd_material_estoque_w,0))	= coalesce(cd_material_estoque_w,0)
			and	coalesce(x.ie_situacao,'A')					= 'A'
			and	coalesce(z.ie_situacao,'A')					= 'A'		
			and	coalesce(z.ie_exclusao,'N')					= 'S'
			and	coalesce(a.nr_seq_agrup_classif, coalesce(nr_seq_agrup_classif_w,0)) = coalesce(nr_seq_agrup_classif_w,0)
			and	coalesce(a.nr_seq_agrupamento_setor, coalesce(nr_seq_agrupamento_w,0)) = coalesce(nr_seq_agrupamento_w,0)
			and	(((coalesce(a.ie_hemodialise,'S') = 'S') and (ie_agrupador_w = 13)) or
				 ((coalesce(a.ie_hemodialise,'N') = 'N') and (ie_agrupador_w <> 13)))
			and 	((coalesce(ie_dose_especial,'N') = 'N') or ((coalesce(ie_dose_especial,'N') = 'S') and (qt_dose_especial_w > 0)))
			and		(((coalesce(ie_somente_acmsn,'N') = 'G') and ((ie_acm_w = 'S') or (ie_se_necessario_w = 'S') or (ie_urgencia_w = 'S'))) or
					((coalesce(ie_somente_acmsn,'N') = 'S') and ((ie_acm_w = 'S') or (ie_se_necessario_w = 'S'))) or
					((coalesce(ie_somente_acmsn,'N') = 'A') and (ie_acm_w = 'S') and (ie_se_necessario_w = 'N')) or
					((coalesce(ie_somente_acmsn,'N') = 'C') and (ie_acm_w = 'N') and (ie_se_necessario_w = 'S')) or (coalesce(ie_somente_acmsn,'N') = 'N'))
      and ((coalesce(z.ie_somente_fracionados, 'N') = 'S' and ie_item_fracionado_w = 'S') or (coalesce(z.ie_somente_fracionados, 'N') = 'N')))
and     coalesce(a.ie_tipo_sol, ie_tipo_solucao_w, 'XPTO') = coalesce(ie_tipo_solucao_w, 'XPTO')
and     coalesce(a.ie_bomba_infusao, ie_tipo_bomba_w, 'XPTO') = coalesce(ie_tipo_bomba_w, 'XPTO')
order by
  coalesce(a.ie_somente_fracionados, 'N'),
	coalesce(b.cd_setor_atendimento,0),
	coalesce(a.cd_local_estoque,0),
	coalesce(a.cd_material,0),
	coalesce(a.cd_controlador_estoque,0),
	coalesce(a.cd_grupo_material,0),
	coalesce(a.cd_subgrupo_material,0),
	coalesce(a.cd_classe_material,0),
	coalesce(nr_seq_familia,0),
	coalesce(a.cd_unidade_medida,'AAAAA'),
	coalesce(a.ie_via_aplicacao,'AAAAA'),
	coalesce(CASE WHEN ie_somente_acmsn='N' THEN NULL  ELSE ie_somente_acmsn END ,'AAAAA');


BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
	
	select	coalesce(max(cd_setor_atendimento),0),
		max(nr_atendimento),
		max(cd_estabelecimento),
		max(obter_local_estoque_setor(cd_setor_atendimento, cd_estabelecimento))
	into STRICT	cd_setor_atendimento_w,
		nr_atendimento_w,
		cd_estabelecimento_w,
		cd_local_estoque_prescr_w
	from	prescr_medica
	where	nr_prescricao = nr_prescricao_p;
	
	select	coalesce(max(nr_seq_agrup_classif),0),
			coalesce(max(nr_seq_agrupamento),0)
	into STRICT	nr_seq_agrup_classif_w,
			nr_seq_agrupamento_w
	from	setor_atendimento
	where	cd_setor_atendimento = cd_setor_atendimento_w;

	select	coalesce(max(ie_local_estoque_proc),'P'),
			coalesce(max(ie_gerar_area_sem_disp),'S')
	into STRICT	ie_local_estoque_proc_w,
			ie_gerar_area_sem_disp_w
	from	parametros_farmacia
	where	cd_estabelecimento	= cd_estabelecimento_w;

	cd_setor_prescr_w	:= Obter_Unidade_Atendimento(nr_atendimento_w,'IAA','CS');

	if (ie_local_estoque_proc_w = 'P') then
		cd_local_prescr_w	:= obter_local_estoque_setor(cd_setor_prescr_w, obter_estab_atend(nr_atendimento_w));
	elsif (ie_local_estoque_proc_w = 'S') then
		cd_local_prescr_w	:= coalesce(cd_local_estoque_prescr_w, obter_local_estoque_setor(cd_setor_prescr_w, obter_estab_atend(nr_atendimento_w)));
	end if;
	
	open c01;
	loop
	fetch c01 into	cd_local_estoque_w,
			nr_seq_material_w,
			cd_unidade_medida_w,
			ie_via_aplicacao_w,
			cd_grupo_material_w,
			cd_subgrupo_material_w,
			cd_classe_material_w,
			cd_material_w,
			nr_seq_familia_w,
			cd_material_estoque_w,
			ie_agrupador_w,
			ie_urgencia_w,
			ie_acm_w,			
			ie_se_necessario_w,
			qt_dose_especial_w,
			qt_dose_w,
            nr_seq_mat_cpoe_w,
            nr_sequencia_solucao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
			
		nr_seq_regra_prep_w	:= 0;
		nr_seq_area_prep_w	:= 0;

        if (ie_agrupador_w = 4) then
            if (nr_seq_mat_cpoe_w IS NOT NULL AND nr_seq_mat_cpoe_w::text <> '') then
                select  coalesce(max(converte_ie_tipo_solucao_cpoe(a.nr_sequencia)), 0),
                        coalesce(max(a.ie_bomba_infusao), 'XPTO')
                into STRICT    ie_tipo_solucao_w,
                        ie_tipo_bomba_w
                from    cpoe_material a
                where   a.nr_sequencia = nr_seq_mat_cpoe_w;
            else
                select  coalesce(max(converte_ie_tipo_solucao(a.nr_prescricao, a.nr_seq_solucao)), 0),
                        coalesce(max(a.ie_bomba_infusao), 'XPTO')
                into STRICT    ie_tipo_solucao_w,
                        ie_tipo_bomba_w
                from    prescr_solucao a
                where   a.nr_prescricao = nr_prescricao_p
                and     a.nr_seq_solucao = nr_sequencia_solucao_w;
            end if;
        end if;
		
		if (ie_local_estoque_proc_w = 'R') then
			cd_local_estoque_w	:= obter_local_estoque_regra_ged(cd_setor_prescr_w,nr_prescricao_p,nr_seq_material_w,null,null,'N');	
		end if;

    if ((qt_dose_w - trunc(qt_dose_w)) = 0) then
      ie_item_fracionado_w := 'N';
    else
      ie_item_fracionado_w := 'S';
    end if;

		open c02;
		loop
		fetch c02 into	nr_seq_regra_prep_w,
				nr_seq_area_prep_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			nr_seq_area_prep_w := nr_seq_area_prep_w;
			end;
		end loop;
		close c02;
		end;
	end loop;
	close c01;
end if;

return	nr_seq_area_prep_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_area_preparo ( nr_prescricao_p bigint, nr_seq_material_p bigint) FROM PUBLIC;

