-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE incluir_proc_exec_presc ( cd_procedimento_p bigint, qt_procedimento_p bigint, nr_seq_exame_p bigint, nr_seq_proc_interno_p bigint, ie_origem_proced_p bigint, cd_setor_atendimento_p bigint, nr_atendimento_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_tipo_baixa_p text, nr_sequencia_p INOUT bigint, dt_execucao_p timestamp, ie_utilizar_datas_p text, dt_inicio_procedimento_p timestamp, dt_final_procedimento_p timestamp, dt_procedimento_p timestamp, cd_medico_exec_p text) AS $body$
DECLARE


/** juliane menin - faz a inserção dos procedimentos - (execução da prescrição )*/

nr_sequencia_w			bigint;
dt_entrada_unidade_w		timestamp;
nr_seq_interno_w			bigint;
cd_convenio_w			integer;
cd_categoria_w			varchar(10);
nr_doc_convenio_w		varchar(20);
ie_tipo_guia_w			varchar(2);
cd_senha_w			varchar(20);
ie_emite_conta_w  			varchar(3)	:= null; --no delphi 81(conta paciente-antiga) parametro 18
cd_cgc_prestador_w 		varchar(14);
ie_origem_proced_w		bigint;
ie_tipo_atendimento_w  		varchar(2)	:=  null;
ie_medico_executor_w		varchar(2);
cd_cgc_w			varchar(14);
cd_medico_executor_w		varchar(10);
cd_medico_exec_w			varchar(10);


ie_funcao_medico_w		varchar(10)	:= 0;
dt_procedimento_w		timestamp;
cd_pessoa_fisica_w		varchar(10);

cd_tipo_procedimento_w		smallint;
ie_classificacao_w		varchar(1);
cd_procedimento_w		bigint;
cd_profissional_w		varchar(10);
nr_seq_cor_exec_w		bigint	:= 96;
ds_observacao_w			varchar(255);
nr_seq_proc_interno_w		bigint := null;
nr_seq_classificacao_w		bigint;
ie_forma_apresentacao_w		smallint;
qt_procedimento_w		double precision;
ie_usuario_logado_w		varchar(10);
cd_pessoa_fisica_usuario_w	varchar(10);

ie_Regra_Uso_Proc_w		varchar(1);
ie_acao_excesso_w		varchar(10);
qt_excedida_w			double precision	:= 0;
ds_erro_w			varchar(80);
cd_convenio_excesso_w		integer;
cd_categoria_excesso_w		varchar(10);

cd_convenio_glosa_w		integer;
cd_categoria_glosa_w		varchar(10);
nr_sequencia_ww			bigint;
cd_motivo_exc_conta_w		smallint;
nr_interno_conta_w		bigint;
ie_regra_proced_espec_w		varchar(1);
ie_clinica_w			atendimento_paciente.ie_clinica%type;
cd_especialidade_w		procedimento_paciente.cd_especialidade%type;
ie_regra_via_acesso_w	varchar(1);
ie_regra_proc_qtdzero_w varchar(1);


BEGIN
cd_procedimento_w	:= cd_procedimento_p;
ie_origem_proced_w	:= ie_origem_proced_p;
qt_procedimento_w	:= qt_procedimento_p;

ie_usuario_logado_w := obter_param_usuario(24, 281, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_usuario_logado_w);
ie_Regra_Uso_Proc_w := obter_param_usuario(24, 151, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_Regra_Uso_Proc_w);
ie_regra_proced_espec_w := obter_param_usuario(24, 108, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_regra_proced_espec_w);
ie_regra_via_acesso_w := obter_param_usuario(24, 124, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_regra_via_acesso_w);
ie_regra_proc_qtdzero_w := obter_param_usuario(24, 120, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_regra_proc_qtdzero_w);

if (coalesce(nr_seq_proc_interno_p,0) > 0) then
	SELECT * FROM obter_proc_tab_interno( nr_seq_proc_interno_p, '', nr_atendimento_p, 0, cd_procedimento_w, ie_origem_proced_w, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
	nr_seq_proc_interno_w := nr_seq_proc_interno_p;
end if;

	-- obter o código da pessoa física
	select	cd_pessoa_fisica
	into STRICT	cd_pessoa_fisica_w
	from	atendimento_paciente
	where	nr_atendimento 		= nr_atendimento_p;

	-- obter a data do procedimento( se a data da alta for igual a null então dt_atendimento = dt_alta senão dt_atendimento = sysdate)
	begin
		select	dt_alta
		into STRICT	dt_procedimento_w
		from	atendimento_paciente
		where	cd_pessoa_fisica    = cd_pessoa_fisica_w
		and	nr_atendimento      = nr_atendimento_p;
	exception
		when others then
		dt_procedimento_w	:=	clock_timestamp();
	end;

	if (coalesce(dt_procedimento_w::text, '') = '') then
		dt_procedimento_w := clock_timestamp();
	end if;

	select  max(a.nr_seq_interno)
	into STRICT	nr_seq_interno_w
	from	tipo_acomodacao b,
		setor_atendimento c,
		atend_paciente_unidade a
	where	a.cd_tipo_acomodacao	= b.cd_tipo_acomodacao
	and	a.cd_setor_atendimento  = c.cd_setor_atendimento
	and	nr_atendimento		= nr_atendimento_p
	and	a.cd_setor_atendimento  = cd_setor_atendimento_p;
	
	select	max(dt_entrada_unidade)
	into STRICT	dt_entrada_unidade_w
	from	atend_paciente_unidade
	where	nr_atendimento = nr_atendimento_p
	and	nr_seq_interno = nr_seq_interno_w;

	select	max(a.cd_cgc)
	into STRICT	cd_cgc_prestador_w
	from 	estabelecimento a,
		atendimento_paciente b
	where	a.cd_estabelecimento 	= b.cd_estabelecimento
	and	b.nr_atendimento 	= nr_atendimento_p;
	
	select	max(nr_seq_classificacao),
		max(ie_tipo_atendimento),
		max(ie_clinica)
	into STRICT	nr_seq_classificacao_w,
		ie_tipo_atendimento_w,
		ie_clinica_w
	from	atendimento_paciente
	where	nr_atendimento 		= nr_atendimento_p;

	-- obter o convênio de execucao
	SELECT * FROM obter_convenio_execucao(nr_atendimento_p, dt_entrada_unidade_w, cd_convenio_w, cd_categoria_w, nr_doc_convenio_w, ie_tipo_guia_w, cd_senha_w) INTO STRICT cd_convenio_w, cd_categoria_w, nr_doc_convenio_w, ie_tipo_guia_w, cd_senha_w;

	-- obter médico executor
	SELECT * FROM consiste_medico_executor(cd_estabelecimento_p, cd_convenio_w, cd_setor_atendimento_p, cd_procedimento_w, coalesce(ie_origem_proced_w, ie_origem_proced_p), coalesce(ie_tipo_atendimento_w,0), nr_seq_exame_p, nr_seq_proc_interno_w, ie_medico_executor_w, cd_cgc_w, cd_medico_executor_w, cd_profissional_w, null, coalesce(dt_procedimento_p, dt_procedimento_w), nr_seq_classificacao_w, 'N', null, null) INTO STRICT ie_medico_executor_w, cd_cgc_w, cd_medico_executor_w, cd_profissional_w;
			
	--anderson silva 01/08/2012 - tratamento para regra consiste médico executor fixo
	
	if (ie_medico_executor_w	= 'F') and (cd_medico_executor_w IS NOT NULL AND cd_medico_executor_w::text <> '') then
		cd_medico_exec_w := cd_medico_executor_w;
	elsif (ie_medico_executor_w = 'A') then
		select	max(cd_medico_resp)
		into STRICT 	cd_medico_exec_w
		from 	atendimento_paciente a
		where 	cd_pessoa_fisica = cd_pessoa_fisica_w
		and 	nr_atendimento = nr_atendimento_p;
	end if;
	
	if (ie_usuario_logado_w = 'S') then
		select	coalesce(max(cd_pessoa_fisica),'0')
		into STRICT	cd_pessoa_fisica_usuario_w
		from	usuario
		where	nm_usuario		= nm_usuario_p;
		if (cd_pessoa_fisica_usuario_w <> '0') then
			cd_profissional_w := cd_pessoa_fisica_usuario_w;
		end if;
	end if;
	
	if (coalesce(cd_cgc_w,'0') <> '0') then
		cd_cgc_prestador_w	:= cd_cgc_w;
	end if;

	-- obter a máxima sequencia da procedimento_paciente
	select	nextval('procedimento_paciente_seq')
	into STRICT	nr_sequencia_w
	;

	if ( coalesce(cd_medico_executor_w::text, '') = '' or cd_medico_executor_w = '') then
		ie_funcao_medico_w	:=	null;
	end if;
	
	if (ie_regra_proced_espec_w = 'S') then
		SELECT * FROM obter_proced_espec_medica(cd_estabelecimento_p, cd_convenio_w, cd_procedimento_w, coalesce(ie_origem_proced_w, ie_origem_proced_p), null, null, null, ie_clinica_w, cd_setor_atendimento_p, cd_especialidade_w, ie_funcao_medico_w, null, nr_seq_proc_interno_w, ie_tipo_atendimento_w) INTO STRICT cd_especialidade_w, ie_funcao_medico_w;
	end if;

	if ( ie_tipo_baixa_p = 'P') then --via palmweb
		nr_seq_cor_exec_w := 1013;
		ds_observacao_w	  := 'PalmWeb';

	end if;
	
	select	max(ie_forma_apresentacao)
	into STRICT	ie_forma_apresentacao_w
	from	procedimento
	where	cd_procedimento	= cd_procedimento_w
	and	ie_origem_proced = coalesce(ie_origem_proced_w, ie_origem_proced_p);
	
	if (ie_utilizar_datas_p = 'S') then
		if (ie_forma_apresentacao_w in (2,3,10,11,12,13,14,15)) then
			select	coalesce(obter_qte_proced_cirurgia(cd_procedimento_w, coalesce(ie_origem_proced_w, ie_origem_proced_p), dt_final_procedimento_p, dt_inicio_procedimento_p),1)
			into STRICT	qt_procedimento_w
			;
		end if;
	end if;	
	
	if (ie_regra_proc_qtdzero_w = 'N') and (qt_procedimento_w = 0) then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(176806);
	end if;

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
		tx_anestesia,
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
		cd_especialidade,
		ie_via_acesso)
	values (
		nr_sequencia_w,
		nr_atendimento_p,
		dt_entrada_unidade_w,
		cd_procedimento_w,
		coalesce(dt_procedimento_p, dt_procedimento_w),
		cd_convenio_w,
		cd_categoria_w,
		nr_doc_convenio_w,
		ie_tipo_guia_w,
		cd_senha_w,
		'N',
		ie_emite_conta_w,
		cd_cgc_prestador_w,
		coalesce(ie_origem_proced_w, ie_origem_proced_p),
		nr_seq_exame_p,
		nr_seq_proc_interno_w,
		qt_procedimento_w,
		cd_setor_atendimento_p,
		nr_seq_interno_w,
		nr_seq_cor_exec_w,
		ie_funcao_medico_w,
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
		ds_observacao_w,
		clock_timestamp(),
		nm_usuario_p,
		cd_profissional_w,
		coalesce(cd_medico_exec_p, cd_medico_exec_w),
		cd_especialidade_w,
		CASE WHEN ie_regra_via_acesso_w='S' THEN  substr(obter_regra_via_acesso(cd_procedimento_w, ie_origem_proced_w, cd_estabelecimento_p, cd_convenio_w),1,2) END );
		
	-- OS 620548
	if (ie_Regra_Uso_Proc_w <> 'N') then
	
		SELECT * FROM obter_regra_qtde_proc_exec(nr_atendimento_p, cd_procedimento_w, ie_origem_proced_p, 0, coalesce(dt_procedimento_p, dt_procedimento_w), coalesce(cd_medico_exec_p, cd_medico_exec_w), ie_acao_excesso_w, qt_excedida_w, ds_erro_w, cd_convenio_excesso_w, cd_categoria_excesso_w, nr_seq_proc_interno_w, cd_categoria_w, NULL, 0, null, nr_seq_exame_p, cd_setor_atendimento_p, null) INTO STRICT ie_acao_excesso_w, qt_excedida_w, ds_erro_w, cd_convenio_excesso_w, cd_categoria_excesso_w;
							
		if (ie_acao_excesso_w = 'E') then
			
			if (qt_excedida_w   > 0) then						
			
				update	procedimento_paciente
				set 	qt_procedimento = qt_procedimento_w - qt_excedida_w
				where 	nr_sequencia = nr_sequencia_w;
				
				
				select 	coalesce(max(cd_motivo_exc_conta),12)
				into STRICT	cd_motivo_exc_conta_w
				from 	parametro_faturamento
				where 	cd_estabelecimento = cd_estabelecimento_p;
				
				if	((qt_procedimento_w - qt_excedida_w) = 0) then
					
					update	procedimento_paciente
					set 	ds_compl_motivo_excon   = wheb_mensagem_pck.get_texto(309090), -- Excluído pela regra de uso de procedimento da função Cadastro de Convênios
						nr_interno_conta	 = NULL,
						cd_motivo_exc_conta	= cd_motivo_exc_conta_w,
						qt_procedimento		= qt_excedida_w
					where 	nr_sequencia 		= nr_sequencia_w;
				
				else
					nr_sequencia_ww := Inserir_Procedimento_Paciente( cd_procedimento_w, qt_excedida_w, nr_seq_exame_p, nr_seq_proc_interno_w, ie_origem_proced_p, cd_setor_atendimento_p, nr_atendimento_p, cd_estabelecimento_p, nm_usuario_p, null, null, null, nr_seq_interno_w, coalesce(dt_procedimento_p, dt_procedimento_w), cd_convenio_w, cd_categoria_w, nr_sequencia_ww, null, coalesce(cd_medico_exec_p, cd_medico_exec_w));
									
					CALL atualiza_preco_procedimento(nr_sequencia_ww, cd_convenio_w, nm_usuario_p);
					
					select 	max(nr_interno_conta)
					into STRICT	nr_interno_conta_w
					from 	procedimento_paciente
					where 	nr_sequencia = nr_sequencia_w;
					
					CALL excluir_matproc_conta(nr_sequencia_ww, nr_interno_conta_w, cd_motivo_exc_conta_w, wheb_mensagem_pck.get_texto(309090)/*Excluído pela regra de uso de procedimento da função Cadastro de Convênios*/
, 'P', nm_usuario_p);

				end if;
			end if;
			
		elsif (ie_acao_excesso_w = 'P') then
		
			if (qt_excedida_w   >= qt_procedimento_w) then
				
				SELECT * FROM obter_convenio_particular_pf(cd_estabelecimento_p, cd_convenio_w, '', coalesce(dt_procedimento_p, dt_procedimento_w), cd_convenio_glosa_w, cd_categoria_glosa_w) INTO STRICT cd_convenio_glosa_w, cd_categoria_glosa_w;
				
				update	procedimento_paciente
				set	nr_interno_conta	 = NULL,
					cd_convenio		= cd_convenio_glosa_w,
					cd_categoria		= cd_categoria_glosa_w
				where	nr_sequencia 		= nr_sequencia_w;
				
				
			else
			
				update	procedimento_paciente
				set 	qt_procedimento = qt_procedimento_w - qt_excedida_w
				where 	nr_sequencia = nr_sequencia_w;
				
				SELECT * FROM obter_convenio_particular_pf(cd_estabelecimento_p, cd_convenio_w, '', coalesce(dt_procedimento_p, dt_procedimento_w), cd_convenio_glosa_w, cd_categoria_glosa_w) INTO STRICT cd_convenio_glosa_w, cd_categoria_glosa_w;
				
				nr_sequencia_ww := Inserir_Procedimento_Paciente( cd_procedimento_w, qt_excedida_w, nr_seq_exame_p, nr_seq_proc_interno_w, ie_origem_proced_p, cd_setor_atendimento_p, nr_atendimento_p, cd_estabelecimento_p, nm_usuario_p, null, null, null, nr_seq_interno_w, coalesce(dt_procedimento_p, dt_procedimento_w), cd_convenio_glosa_w, cd_categoria_glosa_w, nr_sequencia_ww, null, coalesce(cd_medico_exec_p, cd_medico_exec_w));
					
				CALL atualiza_preco_procedimento(nr_sequencia_ww, cd_convenio_glosa_w, nm_usuario_p);
				
				CALL Ajustar_Conta_Vazia(nr_atendimento_p, nm_usuario_p);
				
			end if;		
		
		end if;
	end if;

	commit;


	select	max(ie_classificacao),
		max(cd_tipo_procedimento)
	into STRICT	ie_classificacao_w,
		cd_tipo_procedimento_w
	from	procedimento
	where	cd_procedimento	= cd_procedimento_w
	and	ie_origem_proced = ie_origem_proced;

	CALL atualiza_preco_procedimento(nr_sequencia_w, cd_convenio_w, nm_usuario_p);
	
	if (ie_classificacao_w in (1,8)) then
		CALL gerar_taxa_sala_porte(nr_atendimento_p, dt_entrada_unidade_w, coalesce(dt_procedimento_p, dt_procedimento_w), cd_procedimento_w, nr_sequencia_w, nm_usuario_p);
	end if;

	CALL atualizar_agenda_propaci(nr_sequencia_w);
	
	CALL gerar_lancamento_automatico(nr_atendimento_p,null,34,nm_usuario_p,nr_sequencia_w,null,null,null,null,null);

	CALL gerar_autor_regra(nr_atendimento_p, null, nr_sequencia_w, null, null, nr_seq_proc_interno_w,
			'EP',nm_usuario_p,null,null,null,null,null,null,'','','');


nr_sequencia_p	:= nr_sequencia_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE incluir_proc_exec_presc ( cd_procedimento_p bigint, qt_procedimento_p bigint, nr_seq_exame_p bigint, nr_seq_proc_interno_p bigint, ie_origem_proced_p bigint, cd_setor_atendimento_p bigint, nr_atendimento_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_tipo_baixa_p text, nr_sequencia_p INOUT bigint, dt_execucao_p timestamp, ie_utilizar_datas_p text, dt_inicio_procedimento_p timestamp, dt_final_procedimento_p timestamp, dt_procedimento_p timestamp, cd_medico_exec_p text) FROM PUBLIC;
