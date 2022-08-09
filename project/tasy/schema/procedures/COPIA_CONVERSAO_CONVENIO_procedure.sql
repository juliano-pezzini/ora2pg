-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copia_conversao_convenio ( cd_convenio_origem_p bigint, cd_convenio_destino_p bigint, ie_copia_proc_p text, ie_copia_mat_p text, ie_copia_unidade_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			bigint;
nr_seq_nova_w			bigint;
cd_unidade_medida_w		varchar(30);
cd_unidade_convenio_w		varchar(10);


c001 CURSOR FOR
SELECT	nr_sequencia
from	conversao_proc_convenio
where	cd_convenio = cd_convenio_origem_p;

c002 CURSOR FOR
SELECT	nr_sequencia
from	conversao_material_convenio
where	cd_convenio = cd_convenio_origem_p;

c003 CURSOR FOR
SELECT	cd_unidade_medida,
	cd_unidade_convenio
from	conversao_unidade_medida
where	cd_convenio = cd_convenio_origem_p;


BEGIN
if (ie_copia_proc_p = 'S') then
	begin
	open 	c001;
	loop
	fetch c001 	into
			nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on c001 */
		begin
		select nextval('conversao_proc_convenio_seq')
		into STRICT  nr_seq_nova_w
		;

		insert into conversao_proc_convenio(nr_sequencia,
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
			cd_especialidade_medica,
			ie_tipo_atendimento,
			cd_setor_atendimento,
			ie_classif_acomod,
			nr_seq_proc_interno,
			dt_inicio_vigencia,
			dt_vigencia_final,
			cd_estabelecimento,
			dt_dia_semana,
			ie_feriado,
			hr_inicial,
			hr_final,
			ie_pacote,
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
                        nr_proc_interno)
		(SELECT nr_seq_nova_w,
			cd_convenio_destino_p,
			b.cd_proc_convenio,
			clock_timestamp(),
			nm_usuario_p,
			b.cd_area_proced,
			b.cd_especial_proced,
			b.cd_grupo_proced,
			b.cd_procedimento,
			b.ie_origem_proced,
			b.ds_proc_convenio,
			b.cd_grupo,
			b.tx_conversao_qtde,
			b.cd_unidade_convenio,
			b.ie_situacao,
			b.cd_especialidade_medica,
			b.ie_tipo_atendimento,
			b.cd_setor_atendimento,
			b.ie_classif_acomod ,
			b.nr_seq_proc_interno,
			b.dt_inicio_vigencia,
			b.dt_vigencia_final,
			b.cd_estabelecimento,
			b.dt_dia_semana,
			b.ie_feriado,
			b.hr_inicial,
			b.hr_final,
			b.ie_pacote,
			b.ie_clinica,
			b.vl_proc_inicial,
			b.vl_proc_final,
			b.ie_funcao_medico,
			b.cd_tipo_acomodacao,
			b.cd_tipo_acomod_conv,
			b.qt_ano_min,
			b.qt_ano_max,
			b.qt_ano_min_mes,
			b.qt_ano_min_dia,
			b.qt_ano_max_mes,
			b.qt_ano_max_dia,
			b.ie_sexo,
			b.cd_empresa_ref,
			b.ie_carater_inter_sus,
			b.nr_seq_pacote,
			b.nr_seq_exame,
			b.ie_tipo_atend_tiss,
			b.cd_dependente,
                        b.nr_proc_interno
		from	conversao_proc_convenio b
		where	b.nr_sequencia = nr_sequencia_w);
		end;
	end loop;
	close c001;
	end;
end if;

if (ie_copia_mat_p = 'S') then
	begin
	open 	c002;
	loop
	fetch c002 	into
			nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on c002 */
		begin
		select nextval('conversao_mat_convenio_seq')
		into STRICT  nr_seq_nova_w
		;

		insert into conversao_material_convenio(nr_sequencia,
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
			ie_tipo_atend_tiss,
			ie_tipo_material,
			ie_tipo_preco_autor,
                        nr_proc_interno)
		(
		SELECT 	nr_seq_nova_w,
			cd_convenio_destino_p,
			b.cd_material_convenio,
			clock_timestamp(),
			nm_usuario_p,
			b.cd_grupo_material,
			b.cd_subgrupo_material,
			b.cd_classe_material,
			b.cd_material,
			b.ds_material_convenio,
			b.cd_grupo,
			b.tx_conversao_qtde,
			b.cd_unidade_convenio,
			b.cd_setor_atendimento,
			b.cd_cgc,
			b.ie_classif_acomod,
			b.dt_inicio_vigencia,
			b.dt_final_vigencia,
			b.cd_estabelecimento,
			b.dt_dia_semana,
			b.ie_situacao,
			b.hr_inicial,
			b.hr_final,
			b.ie_feriado,
			b.ie_tipo_material_conv,
			b.ie_tipo_atendimento,
			b.ie_origem_preco,
			b.cd_empresa_ref,
			b.ie_pacote,
			b.ie_carater_inter_sus,
			b.nr_seq_estrutura,
			b.nr_seq_marca,
			b.ie_tipo_atend_tiss,
			b.ie_tipo_material,
			b.ie_tipo_preco_autor,
                        b.nr_proc_interno
		from	conversao_material_convenio b
		where	b.nr_sequencia = nr_sequencia_w);
		end;
	end loop;
	close c002;
	end;
end if;

if (ie_copia_unidade_p = 'S') then
	begin
	open 	c003;
	loop
	fetch c003 	into
			cd_unidade_medida_w,
			cd_unidade_convenio_w;
	EXIT WHEN NOT FOUND; /* apply on c003 */
		begin
		insert into conversao_unidade_medida(
			 cd_convenio,
			 cd_unidade_medida,
			 cd_unidade_convenio,
			 dt_atualizacao,
			 nm_usuario)
		values (cd_convenio_destino_p,
			cd_unidade_medida_w,
			cd_unidade_convenio_w,
			clock_timestamp(),
			nm_usuario_p);
		end;
	end loop;
	close c003;
	end;
end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copia_conversao_convenio ( cd_convenio_origem_p bigint, cd_convenio_destino_p bigint, ie_copia_proc_p text, ie_copia_mat_p text, ie_copia_unidade_p text, nm_usuario_p text) FROM PUBLIC;
