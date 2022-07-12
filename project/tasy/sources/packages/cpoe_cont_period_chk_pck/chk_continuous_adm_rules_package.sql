-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE cpoe_cont_period_chk_pck.chk_continuous_adm_rules ( cd_material_p bigint, nm_usuario_p text, cd_mode_p text, nr_atendimento_p bigint, dt_prescription_start_p timestamp default null, dt_prescription_end_p timestamp default null, ds_retorno_p INOUT text DEFAULT NULL) AS $body$
DECLARE


	nr_continuous_adm_days_w bigint;
	nr_cessation_days_w bigint;
	nr_duracao_days_sum_w bigint := 0;
	dt_prescription_start_w timestamp;
	dt_prescription_end_w timestamp;
	nr_prescription_days_w bigint;
	qt_material_periodo_w bigint;
	cd_grupo_material_w grupo_material.CD_GRUPO_MATERIAL%type;
	cd_subgrupo_material_w subgrupo_material.CD_SUBGRUPO_MATERIAL%type;
	cd_classe_material_w classe_material.CD_CLASSE_MATERIAL%type;
	nr_seq_regra_w	material_cont_adm_rules.nr_sequencia%type;

	c01 CURSOR FOR
	SELECT	nr_sequencia
	from 		cpoe_material
	where	nr_atendimento = nr_atendimento_p
	and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and (coalesce(dt_suspensao::text, '') = '' or dt_suspensao > clock_timestamp() - nr_cessation_days_w)
	and (coalesce(dt_fim::text, '') = ''  or dt_fim > clock_timestamp() - nr_cessation_days_w);

	
BEGIN
	
	ds_retorno_p := '';
	
	select 	max(cd_grupo_material),
				max(cd_subgrupo_material),
				max(cd_classe_material)
	into STRICT		cd_grupo_material_w,
				cd_subgrupo_material_w,
				cd_classe_material_w
	from		estrutura_material_v
	where	cd_material = cd_material_p;

	select	max(nr_sequencia)
	into STRICT		nr_seq_regra_w
	from 		material_cont_adm_rules
	where	coalesce(cd_material,cd_material_p) = cd_material_p
	and		coalesce(cd_grupo_material,cd_grupo_material_w) = cd_grupo_material_w
	and		coalesce(cd_subgrupo_material,cd_subgrupo_material_w) = cd_subgrupo_material_w
	and		coalesce(cd_classe_material,cd_classe_material_w) = cd_classe_material_w
	order	by	coalesce(cd_material,0),
				coalesce(cd_grupo_material,0),	
				coalesce(cd_subgrupo_material,0),
				coalesce(cd_classe_material,0);
				
	if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') then

		select	qt_continuous_adm_days,
					qt_cessation_days
		into STRICT		nr_continuous_adm_days_w,
					nr_cessation_days_w 
		from 		material_cont_adm_rules
		where	nr_sequencia = nr_seq_regra_w;
		
		nr_prescription_days_w := cpoe_cont_period_chk_pck.get_distinct_days_count(coalesce(dt_prescription_start_p, clock_timestamp()), coalesce(dt_prescription_end_p, clock_timestamp() + interval '1 days'));

		if (nr_continuous_adm_days_w < nr_prescription_days_w) then
			ds_retorno_p := wheb_mensagem_pck.get_texto(1149294,'DRUG_NAME='||OBTER_DESC_MATERIAL(cd_material_p)||';QT_CONTINUOUS_ADM_DAYS='||nr_continuous_adm_days_w||';QT_CESSATION_DAYS='||nr_cessation_days_w);
		else
			
			select	count(*)
			into STRICT		qt_material_periodo_w
			from 		cpoe_material a,
						estrutura_material_v b
			where	a.nr_atendimento = nr_atendimento_p
			and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
			and (coalesce(a.dt_suspensao::text, '') = '' or a.dt_suspensao > coalesce(dt_prescription_start_p, clock_timestamp()) - nr_cessation_days_w)
			and (coalesce(a.dt_fim::text, '') = ''  or a.dt_fim > coalesce(dt_prescription_start_p, clock_timestamp()) - nr_cessation_days_w)
			and		a.cd_material = b.cd_material
			and		coalesce(b.cd_material, cd_material_p) = cd_material_p
			and		coalesce(b.cd_grupo_material, cd_grupo_material_w) = cd_grupo_material_w
			and		coalesce(b.cd_subgrupo_material, cd_subgrupo_material_w) = cd_subgrupo_material_w
			and		coalesce(b.cd_classe_material, cd_classe_material_w) = cd_classe_material_w;
					
			if (qt_material_periodo_w > 0) then
				ds_retorno_p := wheb_mensagem_pck.get_texto(1149294,'DRUG_NAME='||OBTER_DESC_MATERIAL(cd_material_p)||';QT_CONTINUOUS_ADM_DAYS='||nr_continuous_adm_days_w||';QT_CESSATION_DAYS='||nr_cessation_days_w);
			end if;
			
		end if;
		
	end if;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_cont_period_chk_pck.chk_continuous_adm_rules ( cd_material_p bigint, nm_usuario_p text, cd_mode_p text, nr_atendimento_p bigint, dt_prescription_start_p timestamp default null, dt_prescription_end_p timestamp default null, ds_retorno_p INOUT text DEFAULT NULL) FROM PUBLIC;
