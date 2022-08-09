-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE executar_proced_lib_prescr ( nr_prescricao_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
nr_seq_exame_w			bigint;
nr_seq_proc_interno_w		bigint;
nr_sequencia_w			integer;
nr_seq_grupo_w			bigint;
cd_area_procedimento_prescr_w	bigint;
cd_especialidade_prescr_w	bigint;
cd_grupo_proc_prescr_w		bigint;
cd_estabelecimento_w		smallint;
ie_liberar_w			bigint;
nr_seq_propaci_w		bigint;
cd_convenio_w			integer;
cd_setor_atendimento_w		integer;
cd_setor_execucao_w		integer;
cd_tipo_procedimento_w		smallint;
nr_seq_w			bigint;
ie_tipo_atendimento_w		smallint;
nr_seq_grupo_sus_w		bigint;
nr_seq_subgrupo_w		bigint;
nr_seq_forma_org_w		bigint;
cd_setor_entrega_w		integer;
cd_perfil_w 			integer;
cd_cgc_laboratorio_w		varchar(14);
cd_proc_excluir_w		bigint;
ie_origem_proc_excluir_w 	integer;
nr_interno_conta_w		bigint;
nr_seq_proc_excluir_w	 	bigint;
cd_motivo_exc_conta_w	 	smallint;
ie_regra_uso_w			varchar(1);
nr_atendimento_w		bigint;
qt_lancamento_w			double precision;
dt_execucao_w			timestamp;
cd_medico_executor_w		varchar(10);
ie_acao_excesso_w		varchar(10);
qt_excedida_w			double precision	:= 0;
ds_erro_w			varchar(80);
cd_categoria_w			varchar(20);
nr_cirurgia_propaci_w		bigint;
nr_interno_conta_ww		bigint;
cd_convenio_glosa_w		integer;
cd_categoria_glosa_w		varchar(10);
ie_executar_w			varchar(1);
cd_medico_exec_w		varchar(50);
cd_funcao_w			integer;
dt_prev_execucao_w		timestamp;
IE_CHARGE_COSEGURO_w   regra_executa_lib_prescr.IE_CHARGE_COSEGURO%TYPE;
ie_tipo_convenio_w		smallint;
cd_convenio_excesso_w		integer;
cd_categoria_excesso_w		varchar(10);
cd_setor_proc_w			integer;
qt_consist_proc_w		bigint;
nr_seq_superior_w		prescr_procedimento.nr_seq_superior%type;
nr_seq_proc_compl_w		prescr_procedimento.nr_seq_proc_compl%type;
nr_seq_proc_excesso_w		procedimento_paciente.nr_sequencia%type;
ie_executa_proc_associado_w 	varchar(1);
nr_seq_classificacao_w 		atendimento_paciente.nr_seq_classificacao%type;

C01 CURSOR FOR
	SELECT	b.cd_procedimento,
		b.ie_origem_proced,
		b.nr_seq_exame,
		b.nr_seq_proc_interno,
		b.nr_sequencia,
		b.cd_setor_atendimento,
		b.cd_cgc_laboratorio,
		b.cd_medico_exec,
		b.dt_prev_execucao,
		b.nr_seq_superior,
        b.nr_seq_proc_compl
	from	prescr_procedimento b,
		prescr_medica a
	where	a.nr_prescricao	= b.nr_prescricao
	and	a.nr_prescricao	= nr_prescricao_p
	and	coalesce(cd_motivo_baixa_exame::text, '') = ''
	and (ie_executa_proc_associado_w = 'S' or coalesce(nr_seq_proc_princ::text, '') = '')
	and	(a.nr_atendimento IS NOT NULL AND a.nr_atendimento::text <> '');

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	procedimento_paciente
	where	nr_interno_conta = nr_interno_conta_w
	and	cd_procedimento	 = cd_proc_excluir_w
	and	ie_origem_proced = ie_origem_proc_excluir_w
	and	coalesce(cd_motivo_exc_conta::text, '') = '';

C03 CURSOR FOR
	SELECT 	cd_proc_excluir,
		ie_origem_proc_excluir
	from	regra_executa_lib_prescr
	where	coalesce(cd_area_procedimento, coalesce(cd_area_procedimento_prescr_w,0))	= coalesce(cd_area_procedimento_prescr_w,0)
	and	coalesce(cd_especialidade, coalesce(cd_especialidade_prescr_w,0))		= coalesce(cd_especialidade_prescr_w,0)
	and	coalesce(cd_grupo_proc, coalesce(cd_grupo_proc_prescr_w,0))		= coalesce(cd_grupo_proc_prescr_w,0)
	and	coalesce(nr_seq_grupo_lab, coalesce(nr_seq_grupo_w,0))			= coalesce(nr_seq_grupo_w,0)
	and	coalesce(nr_seq_exame_interno, coalesce(nr_seq_proc_interno_w,0))		= coalesce(nr_seq_proc_interno_w,0)
	and	coalesce(nr_seq_exame_lab, coalesce(nr_seq_exame_w,0))			= coalesce(nr_seq_exame_w,0)
	and	((coalesce(cd_procedimento::text, '') = '') or (coalesce(ie_origem_proced, coalesce(ie_origem_proced_w,0))		= coalesce(ie_origem_proced_w,0)))
	and	coalesce(cd_procedimento, coalesce(cd_procedimento_w,0))			= coalesce(cd_procedimento_w,0)
	and	cd_estabelecimento						= cd_estabelecimento_w
	and	coalesce(cd_convenio, coalesce(cd_convenio_w,0))				= coalesce(cd_convenio_w,0)
	and	coalesce(cd_cgc_laboratorio, coalesce(cd_cgc_laboratorio_w,0))		= coalesce(cd_cgc_laboratorio_w,0)
	and	coalesce(cd_setor_atendimento, coalesce(cd_setor_atendimento_w,0))	= coalesce(cd_setor_atendimento_w,0)
	and	coalesce(cd_setor_entrega, coalesce(cd_setor_entrega_w,0))		= coalesce(cd_setor_entrega_w,0)
	and	coalesce(cd_tipo_procedimento, coalesce(cd_tipo_procedimento_w,0))	= coalesce(cd_tipo_procedimento_w,0)
	and	coalesce(ie_tipo_atendimento, coalesce(ie_tipo_atendimento_w,0))		= coalesce(ie_tipo_atendimento_w,0)
	and	coalesce(cd_setor_execucao, coalesce(cd_setor_execucao_w,0))		= coalesce(cd_setor_execucao_w,0)
	and	coalesce(nr_seq_grupo, coalesce(nr_seq_grupo_sus_w,0))			= coalesce(nr_seq_grupo_sus_w,0)
	and	coalesce(nr_seq_subgrupo, coalesce(nr_seq_subgrupo_w,0))			= coalesce(nr_seq_subgrupo_w,0)
	and	coalesce(nr_seq_forma_org, coalesce(nr_seq_forma_org_w,0))		= coalesce(nr_seq_forma_org_w,0)
	and	coalesce(cd_medico_exec, coalesce(cd_medico_exec_w,'0'))			= coalesce(cd_medico_exec_w,'0')
	and	coalesce(cd_perfil, coalesce(obter_perfil_ativo,0))			= coalesce(obter_perfil_ativo,0)
	and	((coalesce(IE_SEM_SETOR,'N') = 'N') or (coalesce(cd_setor_execucao_w::text, '') = ''))
	and	((coalesce(ie_tipo_convenio, coalesce(ie_tipo_convenio_w,0)) = coalesce(ie_tipo_convenio_w,0)) or (coalesce(ie_tipo_convenio_w,0) = 0))
	and 	dt_prev_execucao_w between ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_prev_execucao_w, coalesce(hr_inicial,'00:00'))
		and ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_prev_execucao_w, coalesce(hr_final,'23:59'))
	and	(cd_proc_excluir IS NOT NULL AND cd_proc_excluir::text <> '')
	and	(ie_origem_proc_excluir IS NOT NULL AND ie_origem_proc_excluir::text <> '');

C04 CURSOR FOR
	SELECT	
        coalesce(ie_executar,'S') IE_EXECUTAR,
        IE_CHARGE_COSEGURO
	from	regra_executa_lib_prescr
	where	coalesce(cd_area_procedimento, coalesce(cd_area_procedimento_prescr_w,0))	= coalesce(cd_area_procedimento_prescr_w,0)
	and	coalesce(cd_especialidade, coalesce(cd_especialidade_prescr_w,0))		= coalesce(cd_especialidade_prescr_w,0)
	and	coalesce(cd_grupo_proc, coalesce(cd_grupo_proc_prescr_w,0))		= coalesce(cd_grupo_proc_prescr_w,0)
	and	coalesce(nr_seq_grupo_lab, coalesce(nr_seq_grupo_w,0))			= coalesce(nr_seq_grupo_w,0)
	and	coalesce(nr_seq_exame_interno, coalesce(nr_seq_proc_interno_w,0))		= coalesce(nr_seq_proc_interno_w,0)
	and	coalesce(nr_seq_exame_lab, coalesce(nr_seq_exame_w,0))			= coalesce(nr_seq_exame_w,0)
	and	((coalesce(cd_procedimento::text, '') = '') or (coalesce(ie_origem_proced, coalesce(ie_origem_proced_w,0))		= coalesce(ie_origem_proced_w,0)))
	and	coalesce(cd_procedimento, coalesce(cd_procedimento_w,0))			= coalesce(cd_procedimento_w,0)
	and	cd_estabelecimento						= cd_estabelecimento_w
	and	((coalesce(IE_SEM_SETOR,'N') = 'N') or (coalesce(cd_setor_execucao_w::text, '') = ''))
	and	((coalesce(IE_SOMENTE_AUTORIZADO,'N') = 'N') or (qt_consist_proc_w = 0))
	and	coalesce(cd_convenio, coalesce(cd_convenio_w,0))				= coalesce(cd_convenio_w,0)
	and	coalesce(cd_cgc_laboratorio, coalesce(cd_cgc_laboratorio_w,0))		= coalesce(cd_cgc_laboratorio_w,0)
	and	coalesce(cd_setor_atendimento, coalesce(cd_setor_atendimento_w,0))	= coalesce(cd_setor_atendimento_w,0)
	and	coalesce(cd_setor_entrega, coalesce(cd_setor_entrega_w,0))		= coalesce(cd_setor_entrega_w,0)
	and	coalesce(cd_tipo_procedimento, coalesce(cd_tipo_procedimento_w,0))	= coalesce(cd_tipo_procedimento_w,0)
	and	coalesce(ie_tipo_atendimento, coalesce(ie_tipo_atendimento_w,0))		= coalesce(ie_tipo_atendimento_w,0)
	and	coalesce(cd_setor_execucao, coalesce(cd_setor_execucao_w,0))		= coalesce(cd_setor_execucao_w,0)
	and	coalesce(nr_seq_grupo, coalesce(nr_seq_grupo_sus_w,0))			= coalesce(nr_seq_grupo_sus_w,0)
	and	coalesce(cd_medico_exec, coalesce(cd_medico_exec_w,'0'))			= coalesce(cd_medico_exec_w,'0')
	and	coalesce(nr_seq_subgrupo, coalesce(nr_seq_subgrupo_w,0))			= coalesce(nr_seq_subgrupo_w,0)
	and	coalesce(cd_perfil, coalesce(obter_perfil_ativo,0))			= coalesce(obter_perfil_ativo,0)
	and 	coalesce(nr_seq_classificacao, nr_seq_classificacao_w, 0)       = coalesce(nr_seq_classificacao_w,0)
	and	coalesce(nr_seq_forma_org, coalesce(nr_seq_forma_org_w,0))		= coalesce(nr_seq_forma_org_w,0)
	and	((coalesce(ie_tipo_convenio, coalesce(ie_tipo_convenio_w,0)) = coalesce(ie_tipo_convenio_w,0)) or (coalesce(ie_tipo_convenio_w,0) = 0))
	and 	dt_prev_execucao_w between ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_prev_execucao_w, coalesce(hr_inicial, '00:00'))
		and ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_prev_execucao_w, coalesce(hr_final, '23:59'))
	order by
		coalesce(cd_convenio, 0),
		coalesce(cd_setor_atendimento,0),
		coalesce(cd_setor_entrega,0),
		coalesce(cd_setor_execucao,0),
		coalesce(cd_procedimento,0),
		coalesce(nr_seq_exame_interno,0),
		coalesce(nr_seq_exame_lab,0),
		coalesce(cd_grupo_proc,0),
		coalesce(cd_especialidade,0),
		coalesce(cd_area_procedimento,0),
		coalesce(cd_tipo_procedimento,0),
		coalesce(nr_seq_grupo_lab,0),
		coalesce(cd_cgc_laboratorio,0),
		coalesce(ie_tipo_atendimento,0),
		coalesce(nr_seq_grupo,0),
		coalesce(nr_seq_subgrupo,0),
		coalesce(cd_medico_exec, '0'),
		coalesce(nr_seq_forma_org,0),
		coalesce(nr_seq_classificacao,0),
		coalesce(ie_tipo_convenio,0),
		coalesce(cd_perfil,0);
		


BEGIN

begin
select	max(cd_estabelecimento),
	max(obter_convenio_atendimento(nr_atendimento)),
	max(cd_setor_atendimento),
	max(obter_tipo_atendimento(nr_atendimento)),
	max(cd_setor_entrega),
	max(nr_atendimento)
into STRICT	cd_estabelecimento_w,
	cd_convenio_w,
	cd_setor_atendimento_w,
	ie_tipo_atendimento_w,
	cd_setor_entrega_w,
	nr_atendimento_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;
exception
	when others then
		cd_estabelecimento_w := 1;
end;

select	max(coalesce(nr_seq_classificacao,0))
into STRICT    nr_seq_classificacao_w
from    atendimento_paciente
where   nr_atendimento = nr_atendimento_w;

cd_perfil_w := wheb_usuario_pck.GET_CD_PERFIL;

cd_funcao_w	:= coalesce(obter_funcao_ativa,924);

if (cd_funcao_w = 2314) then
	cd_funcao_w := 924;
end if;

select	max(cd_motivo_exc_conta)
into STRICT	cd_motivo_exc_conta_w
from	parametro_faturamento
where	cd_estabelecimento = cd_estabelecimento_w;

select	coalesce(max(ie_tipo_convenio),0)
into STRICT	ie_tipo_convenio_w
from	convenio
where	cd_convenio = cd_convenio_w;

ie_executa_proc_associado_w := obter_param_usuario(916, 1242, cd_perfil_w, nm_usuario_p, cd_estabelecimento_w, ie_executa_proc_associado_w);

OPEN	C01;
LOOP
FETCH	C01 into
	cd_procedimento_w,
	ie_origem_proced_w,
	nr_seq_exame_w,
	nr_seq_proc_interno_w,
	nr_sequencia_w,
	cd_setor_execucao_w,
	cd_cgc_laboratorio_w,
	cd_medico_exec_w,
	dt_prev_execucao_w,
	nr_seq_superior_w,
    nr_seq_proc_compl_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	nr_seq_grupo_w := null;
	if (nr_seq_exame_w IS NOT NULL AND nr_seq_exame_w::text <> '') then
		begin
		select	max(nr_seq_grupo)
		into STRICT	nr_seq_grupo_w
		from	exame_laboratorio
		where	nr_seq_exame = nr_seq_exame_w;
		exception
			when others then
				nr_seq_grupo_w := null;
		end;
	end if;

	select	max(cd_grupo_proc),
		max(cd_especialidade),
		max(cd_area_procedimento),
		max(cd_tipo_procedimento)
	into STRICT	cd_grupo_proc_prescr_w,
		cd_especialidade_prescr_w,
		cd_area_procedimento_prescr_w,
		cd_tipo_procedimento_w
	from	estrutura_procedimento_v
	where	cd_procedimento 	= cd_procedimento_w
	and	ie_origem_proced	= ie_origem_proced_w;


	select	count(*)
	into STRICT	qt_consist_proc_w
	from	prescr_medica_erro a,
		prescr_procedimento b
	where	b.nr_sequencia      = a.nr_seq_proced
	and	b.nr_prescricao     = a.nr_prescricao
	and	a.nr_prescricao     = nr_prescricao_p
	and	b.cd_procedimento   = cd_procedimento_w
	and	b.ie_origem_proced  = ie_origem_proced_w
	and	b.nr_sequencia 	   = nr_sequencia_w
	and	nr_regra in (67,69);

	begin
	select	max(nr_seq_grupo),
		max(nr_seq_subgrupo),
		max(nr_seq_forma_org)
	into STRICT	nr_seq_grupo_sus_w,
		nr_seq_subgrupo_w,
		nr_seq_forma_org_w
	from	sus_estrutura_procedimento_v
	where	cd_procedimento		= cd_procedimento_w
	and	ie_origem_proced	= ie_origem_proced_w;
	exception
		when others then
		nr_seq_grupo_sus_w	:= 0;
		nr_seq_subgrupo_w	:= 0;
		nr_seq_forma_org_w	:= 0;
	end;

	ie_executar_w	:= 'N';

	open C04;
	loop
	fetch C04 into
		ie_executar_w,
        IE_CHARGE_COSEGURO_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		ie_executar_w	:= ie_executar_w;
		end;
	end loop;
	close C04;

	if (nr_seq_superior_w IS NOT NULL AND nr_seq_superior_w::text <> '') and (ie_executar_w = 'S') then
		select  CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
		into STRICT	ie_executar_w
		from 	exame_lab_dependente a,
				prescr_procedimento  b
		where   a.nr_seq_exame_dep = b.nr_seq_exame
		and		b.nr_prescricao = nr_prescricao_p
		and		b.nr_sequencia  = nr_sequencia_w
		and		coalesce(a.ie_agrupa_conta,'S') = 'S'
		and		a.ie_geracao = 0;
	end if;

	CALL gravar_log_tasy(10011, 'Executar_Proced_Lib_Prescr ln ' || $$plsql_line
					|| ' - nr_prescricao_p: ' || nr_prescricao_p
					|| ' ie_executar_w: ' || ie_executar_w
					|| ' nr_sequencia_w: ' || nr_sequencia_w
					|| ' cd_perfil_w: ' || cd_perfil_w
					|| ' cd_funcao_w: ' || cd_funcao_w
					|| ' cd_estabelecimento_w: ' || cd_estabelecimento_w
					|| ' nr_seq_propaci_w: ' || nr_seq_propaci_w, nm_usuario_p);

	if (ie_executar_w = 'S') then
		update	prescr_procedimento
		set	ie_executado_automatico = 'S'
		where	nr_prescricao 	= nr_prescricao_p
		and	nr_sequencia	= nr_sequencia_w;


		nr_seq_propaci_w := Gerar_Proced_Paciente_Pendente(nr_prescricao_p, nr_sequencia_w, nm_usuario_p, cd_perfil_w, cd_funcao_w, null, null, nr_seq_propaci_w);

		ie_regra_uso_w := obter_param_usuario(916, 745, cd_perfil_w, nm_usuario_p, cd_estabelecimento_w, ie_regra_uso_w);

		if (ie_regra_uso_w = 'S') and (philips_fat_pck.get_executar_regra_uso = 'S') then

			select	max(nr_atendimento),
				max(qt_procedimento),
				max(dt_procedimento),
				max(cd_medico_executor),
				max(cd_categoria),
				max(nr_cirurgia),
				max(nr_interno_conta),
				max(cd_setor_atendimento)
			into STRICT	nr_atendimento_w,
				qt_lancamento_w,
				dt_execucao_w,
				cd_medico_executor_w,
				cd_categoria_w,
				nr_cirurgia_propaci_w,
				nr_interno_conta_ww,
				cd_setor_proc_w
			from	procedimento_paciente
			where	nr_sequencia = nr_seq_propaci_w;

			SELECT * FROM obter_regra_qtde_proc_exec(nr_atendimento_w, cd_procedimento_w, ie_origem_proced_w, 0, dt_execucao_w, cd_medico_executor_w, ie_acao_excesso_w, qt_excedida_w, ds_erro_w, cd_convenio_excesso_w, cd_categoria_excesso_w, nr_seq_proc_interno_w, cd_categoria_w, NULL, 0, nr_cirurgia_propaci_w, nr_seq_exame_w, cd_setor_proc_w, null) INTO STRICT ie_acao_excesso_w, qt_excedida_w, ds_erro_w, cd_convenio_excesso_w, cd_categoria_excesso_w;

			if (ie_acao_excesso_w = 'E') then
				if (qt_excedida_w   > 0) then

					if ((qt_lancamento_w - qt_excedida_w) >= 0) then
						CALL excluir_matproc_conta(nr_seq_propaci_w, nr_interno_conta_ww, coalesce(cd_motivo_exc_conta_w, 12), WHEB_MENSAGEM_PCK.get_texto(299052,null), 'P', nm_usuario_p);

					else

						update	procedimento_paciente
						set	qt_procedimento = qt_lancamento_w - qt_excedida_w
						where	nr_sequencia  = nr_seq_propaci_w;

						nr_seq_proc_excesso_w := Duplicar_Proc_Paciente(	nr_seq_propaci_w, nm_usuario_p, nr_seq_proc_excesso_w);

						update	procedimento_paciente
						set	qt_procedimento = qt_excedida_w
						where	nr_sequencia  = nr_seq_proc_excesso_w;

						CALL excluir_matproc_conta(nr_seq_proc_excesso_w, nr_interno_conta_ww, coalesce(cd_motivo_exc_conta_w, 12), WHEB_MENSAGEM_PCK.get_texto(299052,null), 'P', nm_usuario_p);
						CALL atualiza_preco_procedimento(nr_seq_proc_excesso_w, cd_convenio_w, nm_usuario_p);

					end if;

					CALL atualiza_preco_procedimento(nr_seq_propaci_w, cd_convenio_w, nm_usuario_p);

				end if;

			elsif (ie_acao_excesso_w = 'P') then
				if (qt_excedida_w   > 0) then

					SELECT * FROM obter_convenio_particular_pf(cd_estabelecimento_w, cd_convenio_w, '', dt_execucao_w, cd_convenio_glosa_w, cd_categoria_glosa_w) INTO STRICT cd_convenio_glosa_w, cd_categoria_glosa_w;

					if (qt_excedida_w >= qt_lancamento_w) then

						update	procedimento_paciente
						set	nr_interno_conta	 = NULL,
							cd_convenio		= cd_convenio_glosa_w,
							cd_categoria		= cd_categoria_glosa_w
						where	nr_sequencia 		= nr_seq_propaci_w;

						if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;



					else

						update	procedimento_paciente
						set	qt_procedimento = qt_lancamento_w - qt_excedida_w
						where	nr_sequencia  = nr_seq_propaci_w;

						nr_seq_proc_excesso_w := Duplicar_Proc_Paciente(	nr_seq_propaci_w, nm_usuario_p, nr_seq_proc_excesso_w);

						update	procedimento_paciente
						set	nr_interno_conta	 = NULL,
							cd_convenio		= cd_convenio_glosa_w,
							cd_categoria		= cd_categoria_glosa_w,
							qt_procedimento 	= qt_excedida_w
						where	nr_sequencia 		= nr_seq_proc_excesso_w;

						CALL atualiza_preco_procedimento(nr_seq_proc_excesso_w, cd_convenio_w, nm_usuario_p);

					end if;
					CALL atualiza_preco_procedimento(nr_seq_propaci_w, cd_convenio_w, nm_usuario_p);
					CALL Ajustar_Conta_Vazia(nr_atendimento_w, nm_usuario_p);
				end if;

			elsif (ie_acao_excesso_w = 'Z') then
				if (qt_excedida_w   > 0) then

					if (qt_excedida_w >= qt_lancamento_w) then
						update	procedimento_paciente
						set	vl_anestesista		= 0,
							vl_auxiliares		= 0,
							vl_custo_operacional	= 0,
							vl_materiais		= 0,
							vl_medico		= 0,
							vl_procedimento		= 0,
							ie_valor_informado	= 'S'
						where	nr_sequencia 		= nr_seq_propaci_w;
					else

						update	procedimento_paciente
						set	qt_procedimento = qt_lancamento_w - qt_excedida_w
						where	nr_sequencia  = nr_seq_propaci_w;

						nr_seq_proc_excesso_w := Duplicar_Proc_Paciente(	nr_seq_propaci_w, nm_usuario_p, nr_seq_proc_excesso_w);

						update	procedimento_paciente
						set	vl_anestesista		= 0,
							vl_auxiliares		= 0,
							vl_custo_operacional	= 0,
							vl_materiais		= 0,
							vl_medico		= 0,
							vl_procedimento		= 0,
							ie_valor_informado	= 'S',
							qt_procedimento 	= qt_excedida_w
						where	nr_sequencia 		= nr_seq_proc_excesso_w;

						CALL atualiza_preco_procedimento(nr_seq_propaci_w, cd_convenio_w, nm_usuario_p);

					end if;

					if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

				end if;

			elsif (ie_acao_excesso_w = 'C') then

				if (qt_excedida_w   > 0) and
					(cd_convenio_excesso_w IS NOT NULL AND cd_convenio_excesso_w::text <> '' AND cd_categoria_excesso_w IS NOT NULL AND cd_categoria_excesso_w::text <> '') then

					if (qt_excedida_w >= qt_lancamento_w) then
						update	procedimento_paciente
						set	nr_interno_conta	 = NULL,
							cd_convenio		= cd_convenio_excesso_w,
							cd_categoria		= cd_categoria_excesso_w
						where	nr_sequencia 		= nr_sequencia_w;


					else
						update	procedimento_paciente
						set	qt_procedimento = qt_lancamento_w - qt_excedida_w
						where	nr_sequencia  = nr_seq_propaci_w;

						nr_seq_proc_excesso_w := Duplicar_Proc_Paciente(	nr_seq_propaci_w, nm_usuario_p, nr_seq_proc_excesso_w);

						update	procedimento_paciente
						set	nr_interno_conta	 = NULL,
							cd_convenio		= cd_convenio_excesso_w,
							cd_categoria		= cd_categoria_excesso_w,
							qt_procedimento 	= qt_excedida_w
						where	nr_sequencia 		= nr_seq_proc_excesso_w;

						CALL atualiza_preco_procedimento(nr_seq_proc_excesso_w, cd_convenio_w, nm_usuario_p);
					end if;

					CALL atualiza_preco_procedimento(nr_sequencia_w, cd_categoria_excesso_w, nm_usuario_p);
					CALL Ajustar_Conta_Vazia(nr_atendimento_w, nm_usuario_p);
				end if;

			end if;

		end if;

		CALL philips_fat_pck.set_executar_regra_uso('S');

		CALL Executar_Mat_Lib_Prescr(nr_prescricao_p, nr_sequencia_w, nm_usuario_p);

		if (coalesce(nr_seq_propaci_w,0) > 0) then

			select	coalesce(max(nr_interno_conta),0)
			into STRICT	nr_interno_conta_w
			from	procedimento_paciente
			where	nr_sequencia =  nr_seq_propaci_w;

			open C03;
			loop
			fetch C03 into
				cd_proc_excluir_w,
				ie_origem_proc_excluir_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin

				open C02;
				loop
				fetch C02 into
					nr_seq_proc_excluir_w;
				EXIT WHEN NOT FOUND; /* apply on C02 */
					begin

					CALL excluir_matproc_conta(nr_seq_proc_excluir_w,nr_interno_conta_w,coalesce(cd_motivo_exc_conta_w, 0),WHEB_MENSAGEM_PCK.get_texto(299053,null),'P',nm_usuario_p);

					end;
				end loop;
				close C02;
				end;
			end loop;
			close C03;
			
		end if;
	
    elsif (IE_CHARGE_COSEGURO_w = 'Y' and pkg_i18n.get_user_locale = 'es_AR') THEN

            if (coalesce(nr_seq_proc_compl_w::text, '') = '') THEN 
            
                SELECT nextval('prescr_procedimento_compl_seq') INTO STRICT nr_seq_proc_compl_w;

                INSERT INTO PRESCR_PROCEDIMENTO_COMPL(
                    NR_SEQUENCIA, 
                    DT_ATUALIZACAO, 
                    NM_USUARIO,
                    IE_CHARGE_COSEGURO
                ) VALUES (
                    nr_seq_proc_compl_w,
                    clock_timestamp(),
                    nm_usuario_p,
                    'Y'
                );

                UPDATE PRESCR_PROCEDIMENTO SET NR_SEQ_PROC_COMPL = nr_seq_proc_compl_w
                WHERE 
                    NR_SEQUENCIA  = nr_sequencia_w AND
                    NR_PRESCRICAO = nr_prescricao_p;

                nr_seq_proc_compl_w := null;
            ELSE

                UPDATE PRESCR_PROCEDIMENTO_COMPL SET IE_CHARGE_COSEGURO = 'Y' 
                WHERE NR_SEQUENCIA = nr_seq_proc_compl_w;

            END IF;

            
            CALL GERAR_PROC_PAC_PRESCRICAO(
                nr_prescricao_p,
                nr_sequencia_w,
                cd_perfil_w, 
                cd_funcao_w,
                nm_usuario_p, 
                null, 
                null,
                null
            );		
        end if;
end;
END LOOP;
CLOSE C01;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE executar_proced_lib_prescr ( nr_prescricao_p bigint, nm_usuario_p text) FROM PUBLIC;
