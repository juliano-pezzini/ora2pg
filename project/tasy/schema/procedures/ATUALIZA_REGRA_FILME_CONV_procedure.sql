-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_regra_filme_conv ( cd_estabelecimento_p bigint, nr_sequencia_p bigint, cd_convenio_p bigint, nm_usuario_p text, vl_filme_p INOUT bigint, nr_seq_regra_p INOUT bigint) AS $body$
DECLARE


nr_seq_regra_w		bigint:= 0;
cd_area_procedimento_w	bigint;
cd_especialidade_w	bigint;
cd_grupo_proc_w		bigint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
qt_regras_w		bigint:= 0;
vl_materiais_w		double precision;
vl_procedimento_w		double precision;
ie_proc_mat_filme_w	varchar(1);
cd_material_filme_w		integer;
cd_procedimento_filme_w	bigint;
ie_origem_proc_filme_w	bigint;
nr_atendimento_w		bigint;
nr_interno_conta_w		bigint;
ie_atualizou_w		varchar(1):= 'N';
nr_sequencia_w		bigint;
nr_seq_atepacu_w		bigint;
dt_procedimento_w		timestamp;
cd_categoria_w		varchar(10);
nr_seq_gerada_w		bigint;
cd_setor_atendimento_w	bigint;
qt_procedimento_w		double precision;
nr_doc_convenio_w	varchar(30);
ie_tipo_atendimento_w	smallint;
nr_seq_proc_interno_w	bigint;
nr_seq_exame_w		bigint;
ie_medico_executor_w	varchar(10);
cd_cgc_prest_regra_w	varchar(14);
cd_medico_executor_w	varchar(10);
cd_pessoa_fisica_w	varchar(10);
cd_medico_exec_w		varchar(10) := null;
nr_seq_classificacao_w	bigint;
cd_medico_laudo_sus_w	varchar(10);
nr_prescricao_w			bigint;
nr_sequencia_prescricao_w	integer;
ie_origem_inf_w			varchar(1);
cd_cgc_laboratorio_w		varchar(14);
nr_sequencia_ww		bigint;
dt_entrada_unidade_w	timestamp;
cd_unidade_medida_w	varchar(30);
cd_cgc_prestador_w 	varchar(14);
cd_setor_prescricao_w	integer;


C01 CURSOR FOR
	SELECT	nr_sequencia,
		ie_proc_mat_filme,
		cd_material_filme,
		cd_procedimento_filme,
		ie_origem_proc_filme
	from	convenio_regra_filme
	where	cd_convenio = cd_convenio_p
	and 	ie_situacao = 'A'
	and 	cd_estabelecimento = cd_estabelecimento_p
	and 	coalesce(cd_area_procedimento, coalesce(cd_area_procedimento_w,0)) = coalesce(cd_area_procedimento_w,0)
	and 	coalesce(cd_especialidade, coalesce(cd_especialidade_w,0)) = coalesce(cd_especialidade_w,0)
	and 	coalesce(cd_grupo_proc, coalesce(cd_grupo_proc_w,0)) = coalesce(cd_grupo_proc_w,0)
	and 	coalesce(cd_procedimento, coalesce(cd_procedimento_w,0)) = coalesce(cd_procedimento_w,0)
	order by	coalesce(cd_area_procedimento,0),
		coalesce(cd_especialidade,0),
		coalesce(cd_grupo_proc,0),
		coalesce(cd_procedimento,0);

c02 CURSOR FOR
	SELECT 	nr_sequencia
	from 	material_atend_paciente
	where 	nr_seq_proc_princ = nr_sequencia_p
	and 	nr_atendimento = nr_atendimento_w
	and 	nr_interno_conta = nr_interno_conta_w
	and 	cd_material = cd_material_filme_w;

c03 CURSOR FOR
	SELECT 	nr_sequencia
	from 	procedimento_paciente
	where 	nr_seq_proc_princ = nr_sequencia_p
	and 	nr_atendimento = nr_atendimento_w
	and 	nr_interno_conta = nr_interno_conta_w
	and 	cd_procedimento = cd_procedimento_filme_w
	and 	ie_origem_proced = ie_origem_proc_filme_w;


BEGIN

vl_materiais_w:= vl_filme_p;

select	count(*)
into STRICT	qt_regras_w
from	convenio_regra_filme
where	cd_convenio = cd_convenio_p;

if (coalesce(qt_regras_w,0) > 0) then

	select 	coalesce(max(cd_procedimento),0),
		coalesce(max(ie_origem_proced),1),
		max(nr_atendimento),
		max(nr_interno_conta),
		max(nr_seq_atepacu),
		max(dt_procedimento),
		max(cd_categoria),
		max(cd_setor_atendimento),
		coalesce(max(qt_procedimento),1),
		max(nr_doc_convenio),
		max(nr_seq_proc_interno),
		max(nr_seq_exame),
		max(nr_prescricao),
		max(nr_sequencia_prescricao)
	into STRICT	cd_procedimento_w,
		ie_origem_proced_w,
		nr_atendimento_w,
		nr_interno_conta_w,
		nr_seq_atepacu_w,
		dt_procedimento_w,
		cd_categoria_w,
		cd_setor_atendimento_w,
		qt_procedimento_w,
		nr_doc_convenio_w,
		nr_seq_proc_interno_w,
		nr_seq_exame_w,
		nr_prescricao_w,
		nr_sequencia_prescricao_w
	from 	procedimento_paciente
	where 	nr_sequencia = nr_sequencia_p
	and 	coalesce(ie_valor_informado,'N') = 'N';

	select	max(ie_tipo_atendimento),
		max(nr_seq_classificacao)
	into STRICT	ie_tipo_atendimento_w,
		nr_seq_classificacao_w
	from	atendimento_paciente
	where	nr_atendimento = nr_atendimento_w;

	begin

	select 	cd_area_procedimento,
		cd_especialidade,
		cd_grupo_proc
	into STRICT	cd_area_procedimento_w,
		cd_especialidade_w,
		cd_grupo_proc_w
	from 	estrutura_procedimento_v
	where 	cd_procedimento = cd_procedimento_w
	and	ie_origem_proced = ie_origem_proced_w;
	exception
	when others then
		cd_area_procedimento_w	:= null;
		cd_grupo_proc_w		:= null;
		cd_especialidade_w	:= null;
	end;

	open C01;
	loop
	fetch C01 into
		nr_seq_regra_w,
		ie_proc_mat_filme_w,
		cd_material_filme_w,
		cd_procedimento_filme_w,
		ie_origem_proc_filme_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		nr_seq_regra_w		:= nr_seq_regra_w;
		ie_proc_mat_filme_w	:= ie_proc_mat_filme_w;
		cd_material_filme_w	:= cd_material_filme_w;
		cd_procedimento_filme_w	:= cd_procedimento_filme_w;
		ie_origem_proc_filme_w	:= ie_origem_proc_filme_w;
		end;
	end loop;
	close C01;

	if (coalesce(nr_seq_regra_w,0) > 0) then

		--Material
		if (coalesce(ie_proc_mat_filme_w,'M') = 'M') then

			ie_atualizou_w:= 'N';

			open C02;
			loop
			fetch C02 into
				nr_sequencia_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin

				update	material_atend_paciente
				set 	qt_material = qt_procedimento_w,
					vl_unitario = dividir(vl_materiais_w,qt_procedimento_w),
					vl_material = vl_materiais_w,
					ie_valor_informado = 'S'
				where 	nr_sequencia = nr_sequencia_w;

				ie_atualizou_w:= 'S';

				end;
			end loop;
			close C02;

			if (ie_atualizou_w = 'N') then

				select	max(cd_setor_Atendimento),
					max(dt_entrada_unidade)
				into STRICT	cd_setor_atendimento_w,
					dt_entrada_unidade_w
				from	atend_paciente_unidade
				where	nr_seq_interno	= nr_seq_atepacu_w;

				select	nextval('material_atend_paciente_seq')
				into STRICT	nr_sequencia_ww
				;

				select	max(cd_unidade_medida_consumo)
				into STRICT	cd_unidade_medida_w
				from	material
				where	cd_material = cd_material_filme_w;

				insert into material_atend_paciente(
						nr_sequencia,
						cd_material,
						dt_atendimento,
						cd_convenio,
						cd_categoria,
						nr_seq_atepacu,
						cd_setor_atendimento,
						dt_entrada_unidade,
						qt_material,
						cd_local_estoque,
						dt_Atualizacao,
						nm_usuario,
						nr_atendimento,
						cd_unidade_medida,
						cd_acao,
						ie_valor_informado,
						nr_interno_conta,
						nr_seq_cor_exec)
				values (	nr_sequencia_ww,
						cd_material_filme_w,
						dt_procedimento_w,
						cd_convenio_p,
						cd_categoria_w,
						nr_seq_atepacu_w,
						cd_setor_atendimento_w,
						dt_entrada_unidade_w,
						qt_procedimento_w,
						null,
						clock_timestamp(),
						nm_usuario_p,
						nr_atendimento_w,
						cd_unidade_medida_w,
						'1',
						'N',
						nr_interno_conta_w,
						5519);

				nr_seq_gerada_w := nr_sequencia_ww;

				update	material_atend_paciente
				set 	vl_unitario = dividir(vl_materiais_w, qt_procedimento_w),
					vl_material = vl_materiais_w,
					nr_seq_proc_princ = nr_sequencia_p,
					ie_valor_informado = 'S',
					ie_auditoria	 = 'N',
					nr_doc_convenio  = nr_doc_convenio_w
				where 	nr_sequencia = nr_seq_gerada_w;

				CALL atualiza_preco_material(nr_seq_gerada_w, nm_usuario_p);

				ie_atualizou_w:= 'S';
			end if;

			if (ie_atualizou_w = 'S') then
				vl_materiais_w:= 0;
			end if;

		end if;

		--Procedimento
		if (coalesce(ie_proc_mat_filme_w,'M') = 'P') then

			ie_atualizou_w:= 'N';

			open C03;
			loop
			fetch C03 into
				nr_sequencia_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin

				update	procedimento_paciente
				set 	qt_procedimento		= qt_procedimento_w,
					vl_medico 		= 0,
					vl_custo_operacional 	= 0,
					vl_materiais		= 0,
					vl_procedimento		= vl_materiais_w,
					ie_valor_informado 	= 'S'
				where 	nr_sequencia = nr_sequencia_w;

				ie_atualizou_w:= 'S';

				end;
			end loop;
			close C03;

			if (ie_atualizou_w = 'N') then

				if (coalesce(nr_prescricao_w,0) > 0) then

					select	max(cd_setor_atendimento)
					into STRICT	cd_setor_prescricao_w
					from	prescr_medica
					where	nr_prescricao = nr_prescricao_w;

					if (coalesce(nr_sequencia_prescricao_w,0) > 0) then
						select	max(ie_origem_inf),
							max(cd_cgc_laboratorio)
						into STRICT	ie_origem_inf_w,
							cd_cgc_laboratorio_w
						from	prescr_procedimento
						where	nr_prescricao = nr_prescricao_w
						and	nr_sequencia = nr_sequencia_prescricao_w;
					end if;

				end if;

				SELECT * FROM consiste_medico_executor(cd_estabelecimento_p, cd_convenio_p, cd_setor_atendimento_w, cd_procedimento_filme_w, ie_origem_proc_filme_w, ie_tipo_atendimento_w, nr_seq_exame_w, nr_seq_proc_interno_w, ie_medico_executor_w, cd_cgc_prest_regra_w, cd_medico_executor_w, cd_pessoa_fisica_w, null, clock_timestamp(), nr_seq_classificacao_w, ie_origem_inf_w, cd_cgc_laboratorio_w, cd_setor_prescricao_w) INTO STRICT ie_medico_executor_w, cd_cgc_prest_regra_w, cd_medico_executor_w, cd_pessoa_fisica_w;

				if (cd_medico_executor_w IS NOT NULL AND cd_medico_executor_w::text <> '') and (coalesce(cd_medico_exec_w::text, '') = '') then
					cd_medico_exec_w := cd_medico_executor_w;
				end if;

				if (coalesce(cd_medico_executor_w::text, '') = '') and (ie_medico_executor_w = 'N') then
					cd_medico_exec_w := null;
				end if;

				if (ie_medico_executor_w	= 'F') and (cd_medico_executor_w IS NOT NULL AND cd_medico_executor_w::text <> '') then
					cd_medico_exec_w	:= cd_medico_executor_w;
				end if;

				if (ie_medico_executor_w = 'A') and (coalesce(cd_medico_exec_w::text, '') = '') then
					select	max(cd_medico_resp)
					into STRICT	cd_medico_exec_w
					from	atendimento_paciente
					where	nr_atendimento = nr_atendimento_w;
				end if;

				select	max(a.dt_entrada_unidade)
				into STRICT	dt_entrada_unidade_w
				from	atend_paciente_unidade a
				where	nr_seq_interno	= nr_seq_atepacu_w;

				select	max(a.cd_cgc)
				into STRICT	cd_cgc_prestador_w
				from 	estabelecimento a,
					atendimento_paciente b
				where	a.cd_estabelecimento = b.cd_estabelecimento
				and	b.nr_atendimento = nr_atendimento_w;

				select	nextval('procedimento_paciente_seq')
				into STRICT	nr_sequencia_ww
				;

				-- inserir na tabela procedimento_paciente
				insert into procedimento_paciente(
						nr_sequencia,
						nr_atendimento,
						dt_entrada_unidade,
						cd_procedimento,
						dt_procedimento,
						cd_convenio,
						cd_categoria,
						nr_doc_convenio,
						ie_tipo_guia,
						cd_senha,
						ie_auditoria,
						ie_emite_conta,
						cd_cgc_prestador,
						ie_origem_proced,
						nr_seq_exame,
						nr_seq_proc_interno,
						qt_procedimento,
						cd_setor_atendimento,
						nr_seq_atepacu,
						nr_seq_cor_exec,
						ie_funcao_medico,
						vl_procedimento,
						ie_proc_princ_atend,
						ie_video,
						tx_medico,
						tx_Anestesia,
						tx_procedimento,
						ie_valor_informado,
						ie_guia_informada,
						cd_situacao_glosa,
						nm_usuario_original,
						ds_observacao,
						dt_atualizacao,
						nm_usuario,
						cd_pessoa_fisica,
						cd_medico_executor,
						nr_interno_conta)
				values (	nr_sequencia_ww,
						nr_atendimento_w,
						dt_entrada_unidade_w,
						cd_procedimento_filme_w,
						dt_procedimento_w,
						cd_convenio_p,
						cd_categoria_w,
						null,
						null,
						null,
						'N',
						null,
						cd_cgc_prestador_w,
						ie_origem_proc_filme_w,
						null,
						null,
						1,
						cd_setor_atendimento_w,
						nr_seq_atepacu_w,
						5419,
						0,
						100,
						'N',
						'N',
						100,
						100,
						100,
						'N',
						'N',
						0,
						nm_usuario_p,
						null,
						clock_timestamp(),
						nm_usuario_p,
						null,
						cd_medico_exec_w,
						nr_interno_conta_w);

				nr_seq_gerada_w	:= nr_sequencia_ww;

				update	procedimento_paciente
				set 	qt_procedimento		= qt_procedimento_w,
					vl_medico 		= 0,
					vl_anestesista		= 0,
					vl_auxiliares		= 0,
					vl_custo_operacional 	= 0,
					vl_materiais		= 0,
					vl_procedimento		= vl_materiais_w,
					ie_valor_informado 	= 'S',
					nr_seq_proc_princ	= nr_sequencia_p
				where 	nr_sequencia = nr_seq_gerada_w;

				CALL atualiza_preco_servico(nr_seq_gerada_w, nm_usuario_p);

				ie_atualizou_w:= 'S';
			end if;

			if (ie_atualizou_w = 'S') then
				vl_materiais_w:= 0;
			end if;

		end if;

	end if;
end if;

vl_filme_p	:= vl_materiais_w;
nr_seq_regra_p	:= nr_seq_regra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_regra_filme_conv ( cd_estabelecimento_p bigint, nr_sequencia_p bigint, cd_convenio_p bigint, nm_usuario_p text, vl_filme_p INOUT bigint, nr_seq_regra_p INOUT bigint) FROM PUBLIC;
