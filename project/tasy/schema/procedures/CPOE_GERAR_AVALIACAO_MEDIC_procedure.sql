-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_gerar_avaliacao_medic ( nr_seq_cpoe_p cpoe_material.nr_sequencia%type, nr_atendimento_p cpoe_material.nr_atendimento%type, cd_pessoa_fisica_p cpoe_material.cd_pessoa_fisica%type, cd_perfil_p cpoe_material.cd_perfil_ativo%type, cd_medico_p cpoe_material.cd_medico%type, nm_usuario_p cpoe_material.nm_usuario%type, ie_avaliar_p INOUT text) AS $body$
DECLARE

			 
 
nr_seq_tipo_aval_medic_w		rep_avaliacao_medicamento.nr_seq_tipo_aval%type;
nr_seq_tipo_aval_comp1_w		rep_avaliacao_medicamento.nr_seq_tipo_aval%type;
nr_seq_tipo_aval_comp2_w		rep_avaliacao_medicamento.nr_seq_tipo_aval%type;
nr_seq_tipo_aval_comp3_w		rep_avaliacao_medicamento.nr_seq_tipo_aval%type;
nr_seq_tipo_aval_comp4_w		rep_avaliacao_medicamento.nr_seq_tipo_aval%type;
nr_seq_tipo_aval_comp5_w		rep_avaliacao_medicamento.nr_seq_tipo_aval%type;
nr_seq_tipo_aval_comp6_w		rep_avaliacao_medicamento.nr_seq_tipo_aval%type;

 
cd_material_w		cpoe_material.cd_material%type;
cd_mat_comp1_w		cpoe_material.cd_mat_comp1%type;
cd_mat_comp2_w		cpoe_material.cd_mat_comp2%type;
cd_mat_comp3_w		cpoe_material.cd_mat_comp3%type;
cd_mat_comp4_w		cpoe_material.cd_mat_comp4%type;
cd_mat_comp5_w		cpoe_material.cd_mat_comp5%type;
cd_mat_comp6_w		cpoe_material.cd_mat_comp6%type;	
 
	procedure gerar_aval_medic( nr_seq_tipo_aval_p		rep_avaliacao_medicamento.nr_seq_tipo_aval%type) is 
	 
	nr_sequencia_w	med_avaliacao_paciente.nr_sequencia%type;
	
BEGIN
	 
		select	nextval('med_avaliacao_paciente_seq') 
		into STRICT	nr_sequencia_w 
		;
 
		insert into	med_avaliacao_paciente( 
				nr_sequencia, 
				cd_pessoa_fisica, 
				cd_medico, 
				dt_atualizacao, 
				dt_avaliacao, 
				nm_usuario, 
				nr_seq_tipo_avaliacao, 
				nr_atendimento, 
				nr_seq_mat_cpoe, 
				ie_situacao, 
				cd_perfil_ativo, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec) 
		values ( 
				nr_sequencia_w, 
				cd_pessoa_fisica_p, 
				cd_medico_p, 
				clock_timestamp(), 
				clock_timestamp(), 
				nm_usuario_p, 
				nr_seq_tipo_aval_p, 
				nr_atendimento_p, 
				nr_seq_cpoe_p, 
				'A', 
				cd_perfil_p, 
				clock_timestamp(), 
				nm_usuario_p);
 
	end;
	 
begin 
	 
	ie_avaliar_p := 'N';
 
	select	coalesce(max(cd_material),0), 
		coalesce(max(cd_mat_comp1),0), 
		coalesce(max(cd_mat_comp2),0), 
		coalesce(max(cd_mat_comp3),0), 
		coalesce(max(cd_mat_comp4),0), 
		coalesce(max(cd_mat_comp5),0), 
		coalesce(max(cd_mat_comp6),0) 
	into STRICT	cd_material_w, 
		cd_mat_comp1_w, 
		cd_mat_comp2_w, 
		cd_mat_comp3_w, 
		cd_mat_comp4_w, 
		cd_mat_comp5_w, 
		cd_mat_comp6_w 
	from	cpoe_material 
	where	nr_sequencia = nr_seq_cpoe_p;
 
	if (coalesce(cd_material_w,0) > 0) then 
		nr_seq_tipo_aval_medic_w := obter_avaliacao_medic(cd_material_w, nr_atendimento_p);
		 
		if (coalesce(nr_seq_tipo_aval_medic_w,0) > 0) then 
			gerar_aval_medic(nr_seq_tipo_aval_medic_w);
			ie_avaliar_p := 'S';
		end if;
	end if;
 
	if (coalesce(cd_mat_comp1_w,0) > 0) then 
		nr_seq_tipo_aval_comp1_w := obter_avaliacao_medic(cd_mat_comp1_w, nr_atendimento_p);
		 
		if (coalesce(nr_seq_tipo_aval_comp1_w,0) > 0) then 
			gerar_aval_medic(nr_seq_tipo_aval_comp1_w);
			ie_avaliar_p := 'S';
		end if;
	end if;
 
	if (coalesce(cd_mat_comp2_w,0) > 0) then 
		nr_seq_tipo_aval_comp2_w := obter_avaliacao_medic(cd_mat_comp2_w, nr_atendimento_p);
		 
		if (coalesce(nr_seq_tipo_aval_comp2_w,0) > 0) then 
			gerar_aval_medic(nr_seq_tipo_aval_comp2_w);
			ie_avaliar_p := 'S';
		end if;
	end if;
 
	if (coalesce(cd_mat_comp3_w,0) > 0) then 
		nr_seq_tipo_aval_comp3_w := obter_avaliacao_medic(cd_mat_comp3_w, nr_atendimento_p);
		 
		if (coalesce(nr_seq_tipo_aval_comp3_w,0) > 0) then 
			gerar_aval_medic(nr_seq_tipo_aval_comp3_w);
			ie_avaliar_p := 'S';
		end if;
	end if;
	 
	if (coalesce(cd_mat_comp4_w,0) > 0) then 
		nr_seq_tipo_aval_comp4_w := obter_avaliacao_medic(cd_mat_comp4_w, nr_atendimento_p);
		 
		if (coalesce(nr_seq_tipo_aval_comp4_w,0) > 0) then 
			gerar_aval_medic(nr_seq_tipo_aval_comp4_w);
			ie_avaliar_p := 'S';
		end if;
	end if;
	 
	if (coalesce(cd_mat_comp5_w,0) > 0) then 
		nr_seq_tipo_aval_comp5_w := obter_avaliacao_medic(cd_mat_comp5_w, nr_atendimento_p);
		 
		if (coalesce(nr_seq_tipo_aval_comp5_w,0) > 0) then 
			gerar_aval_medic(nr_seq_tipo_aval_comp5_w);
			ie_avaliar_p := 'S';
		end if;
	end if;
	 
	if (coalesce(cd_mat_comp6_w,0) > 0) then 
		nr_seq_tipo_aval_comp6_w := obter_avaliacao_medic(cd_mat_comp6_w, nr_atendimento_p);
		 
		if (coalesce(nr_seq_tipo_aval_comp6_w,0) > 0) then 
			gerar_aval_medic(nr_seq_tipo_aval_comp6_w);
			ie_avaliar_p := 'S';
		end if;
	end if;
	 
	commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gerar_avaliacao_medic ( nr_seq_cpoe_p cpoe_material.nr_sequencia%type, nr_atendimento_p cpoe_material.nr_atendimento%type, cd_pessoa_fisica_p cpoe_material.cd_pessoa_fisica%type, cd_perfil_p cpoe_material.cd_perfil_ativo%type, cd_medico_p cpoe_material.cd_medico%type, nm_usuario_p cpoe_material.nm_usuario%type, ie_avaliar_p INOUT text) FROM PUBLIC;
