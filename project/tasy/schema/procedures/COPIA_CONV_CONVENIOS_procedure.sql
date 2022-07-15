-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copia_conv_convenios ( cd_convenio_orig_p bigint, cd_convenio_dest_p bigint, nm_tabela_p text, nm_usuario_p text, ie_excluir_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_w			bigint;
nr_sequencia_w			bigint;
cd_cgc_w			varchar(14);
cd_convenio_w			integer;


c000 CURSOR FOR
	SELECT	cd_convenio
	from	convenio
	where	cd_convenio	 = cd_convenio_dest_p
	and	(cd_convenio_dest_p IS NOT NULL AND cd_convenio_dest_p::text <> '')	
	and 	ie_situacao = 'A';

c001 CURSOR FOR
	SELECT	cd_material_convenio,
		cd_grupo_material,
		cd_subgrupo_material,
		cd_classe_material,
		cd_material,
		ds_material_convenio,
		cd_grupo,
		tx_conversao_qtde,
		cd_unidade_convenio,
		dt_dia_semana,
		hr_inicial,
		hr_final,
		ie_feriado,
		ie_situacao,
		cd_cgc,
		ie_classif_acomod,
		cd_setor_atendimento,
		dt_inicio_vigencia,
		dt_final_vigencia,
		cd_estabelecimento,
		ie_tipo_material_conv,
		ie_tipo_atendimento,
		ie_origem_preco,
		cd_empresa_ref,
		ie_pacote,
		ie_carater_inter_sus,
		nr_seq_estrutura,
		nr_seq_marca,
		ie_tipo_atend_tiss,
		cd_categoria,
		cd_classif_setor,
		nr_seq_familia,
		ie_clinica,
		ie_tipo_material,
		ie_tipo_preco_autor,
                nr_proc_interno
	from	conversao_material_convenio
	where	cd_convenio = cd_convenio_orig_p;

		

c002 CURSOR FOR
	SELECT  cd_proc_convenio,
		cd_area_proced,
		cd_especial_proced,
		cd_grupo_proced,
		cd_procedimento,
		ie_origem_proced,
		ds_proc_convenio,
		cd_grupo,
		tx_conversao_qtde,
		cd_unidade_convenio,
		ie_situacao,
  		CD_ESPECIALIDADE_MEDICA,
		IE_TIPO_ATENDIMENTO,
		CD_SETOR_ATENDIMENTO,
		DT_DIA_SEMANA,
		IE_FERIADO,     
		HR_INICIAL,     
		HR_FINAL,
		IE_PACOTE,
		ie_classif_acomod,
		nr_seq_proc_interno,
		dt_inicio_vigencia,
		dt_vigencia_final,
		cd_estabelecimento,
		ie_clinica,
		vl_proc_inicial,
		vl_proc_final,
		ie_funcao_medico,
		cd_tipo_acomodacao,
		cd_tipo_acomod_conv,
		qt_ano_min,
		qt_ano_max,
		qt_ano_min_mes,
		qt_ano_min_dia,
		qt_ano_max_mes,
		qt_ano_max_dia,
		ie_sexo,
		cd_empresa_ref,
		ie_carater_inter_sus,
		nr_seq_pacote,
		nr_seq_exame,
		ie_tipo_atend_tiss,
		cd_dependente,
		IE_CREDENCIADO,
                nr_proc_interno
	from conversao_proc_convenio
	where cd_convenio = cd_convenio_orig_p;

          
c001_w	c001%rowtype;
c002_w	c002%rowtype;


BEGIN


open	c000;
loop
fetch	c000 into
	cd_convenio_w;
EXIT WHEN NOT FOUND; /* apply on c000 */
	begin

	if (nm_tabela_p = 'CONVERSAO_MATERIAL_CONVENIO') then
		if (ie_excluir_p = 'S') then
			delete from CONVERSAO_MATERIAL_CONVENIO
			where cd_convenio = cd_convenio_w;
		end if;
		
		open c001;
		loop
		fetch c001 into	
			c001_w;
		EXIT WHEN NOT FOUND; /* apply on c001 */
			begin
		
			select 	nextval('conversao_mat_convenio_seq')
			into STRICT 	nr_seq_w
			;

			insert into conversao_material_convenio(
					nr_sequencia,
					cd_convenio, 
					cd_material_convenio,
					dt_atualizacao, 
					nm_usuario, 
					cd_grupo_material,
					cd_subgrupo_material, 
					cd_classe_material, 
					cd_material,
					ds_material_convenio, 
					cd_grupo,
					tx_conversao_qtde, 
					cd_unidade_convenio,
					dt_dia_semana,
					hr_inicial,
					hr_final,
					ie_feriado,
					ie_situacao,
					nr_seq_marca,
					ie_tipo_atend_tiss,
					cd_cgc,
					ie_classif_acomod,
					cd_setor_atendimento,
					dt_inicio_vigencia,
					dt_final_vigencia,
					cd_estabelecimento,
					ie_tipo_material_conv,
					ie_tipo_atendimento,
					ie_origem_preco,
					cd_empresa_ref,
					ie_pacote,
					ie_carater_inter_sus,
					nr_seq_estrutura,
					cd_categoria,
					cd_classif_setor,
					nr_seq_familia,
					ie_clinica,
					ie_tipo_material,
					ie_tipo_preco_autor,
                                        nr_proc_interno)
			values (	nr_seq_w, 
					cd_convenio_w, 
					c001_w.cd_material_convenio,
					clock_timestamp(), 
					nm_usuario_p, 
					c001_w.cd_grupo_material,
					c001_w.cd_subgrupo_material, 
					c001_w.cd_classe_material,
					c001_w.cd_material,
					c001_w.ds_material_convenio,
					c001_w.cd_grupo,
					c001_w.tx_conversao_qtde,
					c001_w.cd_unidade_convenio,
					c001_w.dt_dia_semana,
					c001_w.hr_inicial,
					c001_w.hr_final,
					c001_w.ie_feriado,
					c001_w.ie_situacao,
					c001_w.nr_seq_marca,
					c001_w.ie_tipo_atend_tiss,
					c001_w.cd_cgc,
					c001_w.ie_classif_acomod,
					c001_w.cd_setor_atendimento,
					c001_w.dt_inicio_vigencia,
					c001_w.dt_final_vigencia,
					c001_w.cd_estabelecimento,
					c001_w.ie_tipo_material_conv,
					c001_w.ie_tipo_atendimento,
					c001_w.ie_origem_preco,
					c001_w.cd_empresa_ref,
					c001_w.ie_pacote,
					c001_w.ie_carater_inter_sus,
					c001_w.nr_seq_estrutura,
					c001_w.cd_categoria,
					c001_w.cd_classif_setor,
					c001_w.nr_seq_familia,
					c001_w.ie_clinica,
					c001_w.ie_tipo_material,
					c001_w.ie_tipo_preco_autor,
                                        c001_w.nr_proc_interno);
					
			end;
		end loop;
		close c001;
		
		
	elsif (nm_tabela_p = 'CONVERSAO_PROC_CONVENIO') then
		if (ie_excluir_p = 'S') then
			delete from CONVERSAO_PROC_CONVENIO
			where cd_convenio = cd_convenio_w;
		end if;
		open c002;
		loop
			fetch c002 into c002_w;
			EXIT WHEN NOT FOUND; /* apply on c002 */
	
			select nextval('conversao_proc_convenio_seq')
			into STRICT nr_seq_w
			;
	
			insert into conversao_proc_convenio(
					nr_sequencia,
					cd_convenio, 
					cd_proc_convenio,
					dt_atualizacao, 
					nm_usuario, 
					cd_area_proced,
					cd_especial_proced, 
					cd_grupo_proced, 
					cd_procedimento,
					ie_origem_proced, 
					ds_proc_convenio, 
					cd_grupo,
					tx_conversao_qtde, 
					cd_unidade_convenio, 
					ie_situacao,
  					CD_ESPECIALIDADE_MEDICA, 
					IE_TIPO_ATENDIMENTO, 
					CD_SETOR_ATENDIMENTO,
					DT_DIA_SEMANA,
					IE_FERIADO,
					HR_INICIAL,
					HR_FINAL,
					IE_PACOTE,
					nr_seq_exame,
					ie_tipo_atend_tiss,
					cd_dependente,
					ie_classif_acomod,
					nr_seq_proc_interno,
					dt_inicio_vigencia,
					dt_vigencia_final,
					cd_estabelecimento,
					ie_clinica,
					vl_proc_inicial,
					vl_proc_final,
					ie_funcao_medico,
					cd_tipo_acomodacao,
					cd_tipo_acomod_conv,
					qt_ano_min,
					qt_ano_max,
					qt_ano_min_mes,
					qt_ano_min_dia,
					qt_ano_max_mes,
					qt_ano_max_dia,
					ie_sexo,
					cd_empresa_ref,
					ie_carater_inter_sus,
					nr_seq_pacote,
					IE_CREDENCIADO,
                                        nr_proc_interno)
			values (	nr_seq_w, 
					cd_convenio_w, 
					c002_w.cd_proc_convenio,
					clock_timestamp(), 
					nm_usuario_p, 
					c002_w.cd_area_proced,
					c002_w.cd_especial_proced, 
					c002_w.cd_grupo_proced,
					c002_w.cd_procedimento,
					c002_w.ie_origem_proced,
					c002_w.ds_proc_convenio,
					c002_w.cd_grupo,
					c002_w.tx_conversao_qtde,
					c002_w.cd_unidade_convenio,
					c002_w.ie_situacao,
			  		c002_w.CD_ESPECIALIDADE_MEDICA,
					c002_w.IE_TIPO_ATENDIMENTO,
					c002_w.CD_SETOR_ATENDIMENTO,
					c002_w.DT_DIA_SEMANA,
					c002_w.IE_FERIADO,
					c002_w.HR_INICIAL,
					c002_w.HR_FINAL,
					c002_w.IE_PACOTE,
					c002_w.nr_seq_exame,
					c002_w.ie_tipo_atend_tiss,
					c002_w.cd_dependente,
					c002_w.ie_classif_acomod,
					c002_w.nr_seq_proc_interno,
					c002_w.dt_inicio_vigencia,
					c002_w.dt_vigencia_final,
					c002_w.cd_estabelecimento,
					c002_w.ie_clinica,
					c002_w.vl_proc_inicial,
					c002_w.vl_proc_final,
					c002_w.ie_funcao_medico,
					c002_w.cd_tipo_acomodacao,
					c002_w.cd_tipo_acomod_conv,
					c002_w.qt_ano_min,
					c002_w.qt_ano_max,
					c002_w.qt_ano_min_mes,
					c002_w.qt_ano_min_dia,
					c002_w.qt_ano_max_mes,
					c002_w.qt_ano_max_dia,
					c002_w.ie_sexo,
					c002_w.cd_empresa_ref,
					c002_w.ie_carater_inter_sus,
					c002_w.nr_seq_pacote,
					c002_w.IE_CREDENCIADO,
                                        c002_w.nr_proc_interno);
					
		end loop;
		close c002;
	elsif (nm_tabela_p = 'CONVERSAO_UNIDADE_MEDIDA') then
		if (ie_excluir_p = 'S') then
			delete from CONVERSAO_UNIDADE_MEDIDA
			where cd_convenio = cd_convenio_w;
		end if;
		insert into CONVERSAO_UNIDADE_MEDIDA(
				cd_convenio,
				cd_unidade_medida, 
				cd_unidade_convenio,
				dt_atualizacao, 
				nm_usuario)
			SELECT 	cd_convenio_w, 
				cd_unidade_medida, 
				cd_unidade_convenio,
			 	clock_timestamp(), 
				nm_usuario_p
			from 	CONVERSAO_UNIDADE_MEDIDA
			where 	cd_convenio = cd_convenio_orig_p;
	elsif (nm_tabela_p = 'CONVERSAO_MEIO_EXTERNO') then
		if (ie_excluir_p = 'S') then
			delete from CONVERSAO_MEIO_EXTERNO
			where cd_cgc = (SELECT 	max(cd_cgc)
					from 	convenio
					where 	cd_convenio = cd_convenio_w);
		end if;
		select	cd_cgc
		into STRICT	cd_cgc_w
		from	convenio
		where	cd_convenio = cd_convenio_w;
	
		insert into CONVERSAO_MEIO_EXTERNO(
				cd_cgc,
				nm_tabela, 
				nm_atributo, 
				cd_interno, 
				cd_externo, 
				dt_atualizacao, 
				nm_usuario, 
				nr_sequencia,
				IE_ENVIO_RECEB)
			SELECT 	cd_cgc_w, 
				nm_tabela, 
				nm_atributo, 
				cd_interno,
				cd_externo, 
				clock_timestamp(), 
				nm_usuario_p, 
				nextval('conversao_meio_externo_seq'),
				coalesce(IE_ENVIO_RECEB,'A')
			from 	CONVERSAO_MEIO_EXTERNO
			where 	cd_cgc = (SELECT max(cd_cgc)
					from	convenio
					where	cd_convenio = cd_convenio_orig_p);
	end if;

	end;
end loop;
close c000;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copia_conv_convenios ( cd_convenio_orig_p bigint, cd_convenio_dest_p bigint, nm_tabela_p text, nm_usuario_p text, ie_excluir_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

