-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_itens_conversao_conv ( nr_sequencia_p bigint, cd_conv_destino_p text, cd_conv_origem_p bigint, ie_tipo_item_p bigint, ie_todos_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

				
nr_sequencia_w	bigint;
cd_convenio_w	integer;	
ie_teste_w varchar(1);

C01 CURSOR FOR
	SELECT	cd_convenio
	from	convenio
	where	obter_se_contido(cd_convenio, elimina_aspas(cd_conv_destino_p)) = 'S'
	and 	ie_situacao = 'A'
	and	ie_todos_p = 'N'
	and	cd_convenio <> cd_conv_origem_p
	
union all

	SELECT	cd_convenio
	from	convenio		
	where 	ie_situacao = 'A'
	and	ie_todos_p = 'S'
	and	cd_convenio <> cd_conv_origem_p
	and	obter_se_contido(cd_convenio, elimina_aspas(cd_conv_destino_p)) = 'N';


BEGIN



open C01;
loop
fetch C01 into	
	cd_convenio_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	if (ie_tipo_item_p = 1) then

		select nextval('conversao_proc_convenio_seq')
		into STRICT	nr_sequencia_w
		;

		insert into conversao_proc_convenio(
			dt_atualizacao,
			cd_convenio,
			nm_usuario,
			nr_sequencia,
			cd_area_proced,
			cd_especialidade_medica,
			cd_especial_proced,
			cd_estabelecimento,
			cd_grupo,
			cd_grupo_proced,
			cd_plano,
			cd_proc_convenio,
			cd_procedimento,
			cd_setor_atendimento,
			cd_tipo_acomodacao,
			cd_tipo_acomod_conv,
			cd_unidade_convenio,
			ds_proc_convenio,
			dt_dia_semana,
			dt_inicio_vigencia,
			dt_vigencia_final,
			hr_final,
			hr_inicial,
			ie_carater_inter_sus,
			ie_classif_acomod,
			ie_clinica,
			ie_feriado,
			ie_funcao_medico,
			ie_origem_proced,
			ie_pacote,
			ie_sexo,
			ie_situacao,
			ie_tipo_atendimento,
			nr_seq_pacote,
			nr_seq_proc_interno,
			qt_ano_max,
			qt_ano_max_dia,
			qt_ano_max_mes,
			qt_ano_min,
			qt_ano_min_dia,
			qt_ano_min_mes,
			tx_conversao_qtde,
			vl_proc_final,
			vl_proc_inicial,
			nr_seq_exame,
			cd_dependente,
                        nr_proc_interno)
		SELECT	clock_timestamp(),
			cd_convenio_w,
			nm_usuario_p,
			nr_sequencia_w,
			cd_area_proced,
			cd_especialidade_medica,
			cd_especial_proced,
			cd_estabelecimento,
			cd_grupo,
			cd_grupo_proced,
			cd_plano,
			cd_proc_convenio,
			cd_procedimento,
			cd_setor_atendimento,
			cd_tipo_acomodacao,
			cd_tipo_acomod_conv,
			cd_unidade_convenio,
			ds_proc_convenio,
			dt_dia_semana,
			dt_inicio_vigencia,
			dt_vigencia_final,
			hr_final,
			hr_inicial,
			ie_carater_inter_sus,
			ie_classif_acomod,
			ie_clinica,
			ie_feriado,
			ie_funcao_medico,
			ie_origem_proced,
			ie_pacote,
			ie_sexo,
			ie_situacao,
			ie_tipo_atendimento,
			nr_seq_pacote,
			nr_seq_proc_interno,
			qt_ano_max,
			qt_ano_max_dia,
			qt_ano_max_mes,
			qt_ano_min,
			qt_ano_min_dia,
			qt_ano_min_mes,
			tx_conversao_qtde,
			vl_proc_final,
			vl_proc_inicial,
			nr_seq_exame,
			cd_dependente,
                        nr_proc_interno
		from	conversao_proc_convenio
		where	nr_sequencia = nr_sequencia_p;
		
	elsif (ie_tipo_item_p = 2) then

		select nextval('conversao_mat_convenio_seq')
		into STRICT	nr_sequencia_w
		;
		
		insert into  conversao_material_convenio(
			dt_atualizacao,
			nr_sequencia,
			nm_usuario,
			cd_convenio,
			cd_material_convenio,
			cd_grupo_material,
			cd_subgrupo_material,
			cd_classe_material,
			cd_material,
			ds_material_convenio,
			cd_grupo,
			tx_conversao_qtde,
			cd_unidade_convenio,
			cd_setor_atendimento,
			cd_cgc,
			ie_classif_acomod,
			dt_inicio_vigencia,
			dt_final_vigencia,
			cd_estabelecimento,
			dt_dia_semana,
			ie_situacao,
			hr_inicial,
			hr_final,
			ie_feriado,
			ie_tipo_material_conv,
			ie_tipo_atendimento,
			ie_origem_preco,
			cd_empresa_ref,
			ie_pacote,
			ie_carater_inter_sus,
			nr_seq_estrutura,
			nr_seq_marca,
			ie_tipo_material,
			ie_tipo_preco_autor,
                        nr_proc_interno)
		SELECT	clock_timestamp(),
			nr_sequencia_w,
			nm_usuario_p,
			cd_convenio_w,
			cd_material_convenio,
			cd_grupo_material,
			cd_subgrupo_material,
			cd_classe_material,
			cd_material,
			ds_material_convenio,
			cd_grupo,
			tx_conversao_qtde,
			cd_unidade_convenio,
			cd_setor_atendimento,
			cd_cgc,
			ie_classif_acomod,
			dt_inicio_vigencia,
			dt_final_vigencia,
			cd_estabelecimento,
			dt_dia_semana,
			ie_situacao,
			hr_inicial,
			hr_final,
			ie_feriado,
			ie_tipo_material_conv,
			ie_tipo_atendimento,
			ie_origem_preco,
			cd_empresa_ref,
			ie_pacote,
			ie_carater_inter_sus,
			nr_seq_estrutura,
			nr_seq_marca,
			ie_tipo_material,
			ie_tipo_preco_autor,
                        nr_proc_interno
		from	conversao_material_convenio
		where	nr_sequencia = nr_sequencia_p;

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
-- REVOKE ALL ON PROCEDURE copiar_itens_conversao_conv ( nr_sequencia_p bigint, cd_conv_destino_p text, cd_conv_origem_p bigint, ie_tipo_item_p bigint, ie_todos_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
