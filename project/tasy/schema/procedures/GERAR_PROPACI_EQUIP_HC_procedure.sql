-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_propaci_equip_hc ( nr_atendimento_p bigint, nr_seq_equipamento_p bigint, nr_seq_pac_equip_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_categoria_w		varchar(10);
cd_cbo_w		varchar(6);
cd_cgc_prestador_w	varchar(14);
cd_cgc_w		varchar(14);
cd_convenio_w		integer;
cd_especialidade_w	integer;
cd_estabelecimento_w	smallint;
cd_funcao_medico_w	smallint;
cd_local_estoque_w	smallint;
cd_medico_exec_w	varchar(10);
cd_medico_regra_w	varchar(10);
cd_procedimento_w	bigint;
cd_profissional_w	varchar(10);
cd_setor_atendimento_w	integer;
cont_w			integer;
ds_erro_w		varchar(255);
dt_entrada_unidade_w	timestamp;
ie_clinica_w		integer;
ie_medico_executor_w	varchar(1);
ie_origem_proced_w	bigint;
ie_tipo_atendimento_w	smallint;
ie_via_acesso_w		varchar(1);
nr_atendimento_w	bigint;
nr_doc_conv_w		varchar(20);
nr_seq_classificacao_w	bigint;
nr_seq_interno_w	bigint;
nr_sequencia_w		bigint;
ie_existe_no_dia_w	varchar(1);
ie_equip_proc_w		varchar(1);
ie_tipo_equip_w		varchar(1);
nr_seq_hc_equipamento_w	bigint;
cd_equipamento_w	bigint;
					

BEGIN
ie_tipo_equip_w := obter_param_usuario(867, 84, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_tipo_equip_w);

if (coalesce(nr_seq_pac_equip_p,0) > 0) then

	begin
	select	'S'
	into STRICT	ie_equip_proc_w
	from	hc_equipamento
	where	nr_sequencia = nr_seq_equipamento_p
	and (ie_tipo_equip_w = 'H' or ie_tipo_equip_w = 'A')
	and	(cd_procedimento IS NOT NULL AND cd_procedimento::text <> '')  LIMIT 1;
	exception
	when others then
		ie_equip_proc_w := 'N';
	end;
	if (ie_equip_proc_w = 'N') then
		begin
		select	'S'
		into STRICT	ie_equip_proc_w
		from	equipamento
		where	cd_equipamento = nr_seq_equipamento_p
		and	ie_tipo_equip_w = 'E'
		and	(cd_procedimento IS NOT NULL AND cd_procedimento::text <> '')  LIMIT 1;
		exception
		when others then
			ie_equip_proc_w := 'N';
		end;
	end if;
	
	if (ie_equip_proc_w = 'S') then
		if (coalesce(nr_atendimento_p,0) = 0) then
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(59254); -- O paciente nao possui atendimento de origem para lancar o procedimento na conta!
		else
			begin			
			select	'S'
			into STRICT	ie_existe_no_dia_w
			from	procedimento_paciente
			where	((nr_seq_hc_equipamento = nr_seq_pac_equip_p AND (ie_tipo_equip_w = 'H' or ie_tipo_equip_w = 'A'))
			or (cd_equipamento = nr_seq_equipamento_p) and (ie_tipo_equip_w = 'E'))
			and	dt_procedimento between inicio_dia(clock_timestamp()) and fim_dia(clock_timestamp())  LIMIT 1;
			exception
			when others then
				ie_existe_no_dia_w := 'N';
			end;

			if (ie_existe_no_dia_w = 'N') then

				begin
				select	dt_entrada_unidade,
					cd_setor_atendimento
				into STRICT	dt_entrada_unidade_w,
					cd_setor_atendimento_w
				from	atend_paciente_unidade
				where	nr_atendimento = nr_atendimento_p
				and	nr_seq_interno = obter_atepacu_paciente(nr_atendimento, 'A');
				exception
					when others then
					-- Nao existe passagem de setor para este atendimento!
					CALL Wheb_mensagem_pck.exibir_mensagem_abort(191440);
				end;

				select	nextval('procedimento_paciente_seq')
				into STRICT	nr_sequencia_w
				;

				if (ie_tipo_equip_w = 'H' or ie_tipo_equip_w = 'A') then

					select	max(cd_procedimento),
						max(ie_origem_proced)
					into STRICT	cd_procedimento_w,
						ie_origem_proced_w
					from	hc_equipamento a,
						hc_pac_equipamento b,
						paciente_home_care c
					where	a.nr_sequencia = b.nr_seq_equipamento
					and	b.nr_seq_paciente = c.nr_sequencia	
					and	a.nr_sequencia = nr_seq_equipamento_p
					and	c.nr_atendimento_origem = nr_atendimento_p;
					
				end if;
				if (ie_tipo_equip_w = 'E') then

					select	max(cd_procedimento),
						max(ie_origem_proced),
						max(cd_equipamento)
					into STRICT	cd_procedimento_w,
						ie_origem_proced_w,
						cd_equipamento_w
					from	equipamento a,
						hc_pac_equipamento b,
						paciente_home_care c
					where	a.cd_equipamento	= b.nr_seq_equip_hosp
					and	b.nr_seq_paciente = c.nr_sequencia	
					and	a.cd_equipamento	= nr_seq_equipamento_p
					and	c.nr_atendimento_origem = nr_atendimento_p;
					
				end if;
				
				select	max(b.cd_cgc),
					max(a.cd_estabelecimento),
					max(a.ie_tipo_atendimento),
					max(a.ie_clinica),
					max(obter_atepacu_paciente(a.nr_atendimento,'IA')),
					max(ie_tipo_atendimento),
					max(nr_seq_classificacao)
				into STRICT	cd_cgc_prestador_w,
					cd_estabelecimento_w,
					ie_tipo_atendimento_w,
					ie_clinica_w,
					nr_seq_interno_w,
					ie_tipo_atendimento_w,
					nr_seq_classificacao_w
				from	estabelecimento b,
					atendimento_paciente a
				where	a.nr_atendimento	= nr_atendimento_p
				and	a.cd_estabelecimento	= b.cd_estabelecimento;

				select	max(cd_convenio),
					max(cd_categoria),
					max(nr_doc_convenio)
				into STRICT	cd_convenio_w,
					cd_categoria_w,
					nr_doc_conv_w
				from	atend_categoria_convenio
				where	nr_atendimento = nr_atendimento_p
				and	nr_seq_interno = OBTER_ATECACO_ATENDIMENTO(nr_atendimento_p);

				SELECT * FROM consiste_medico_executor(cd_estabelecimento_w, cd_convenio_w, cd_setor_atendimento_w, cd_procedimento_w, ie_origem_proced_w, ie_tipo_atendimento_w, null, null, ie_medico_executor_w, cd_cgc_w, cd_medico_regra_w, cd_profissional_w, null, clock_timestamp(), nr_seq_classificacao_w, 'N', null, null) INTO STRICT ie_medico_executor_w, cd_cgc_w, cd_medico_regra_w, cd_profissional_w;
							
				if (ie_medico_executor_w = 'N') then
					cd_medico_exec_w	:= null;
				else
					cd_medico_exec_w	:= coalesce(cd_medico_regra_w, 0);
				end if;

				select	count(*)
				into STRICT	cont_w
				from	medico
				where	cd_pessoa_fisica = cd_medico_exec_w;

				if (cont_w = 0) then
					cd_medico_exec_w	:= null;
				end if;

				begin
				select	obter_regra_via_acesso(cd_procedimento_w, ie_origem_proced_w, cd_estabelecimento_w, cd_convenio_w)
				into STRICT	ie_via_acesso_w
				;
				exception
					when others then
						ie_via_acesso_w	:= null;
				end;

				if (ie_origem_proced_w	= 7) then
					cd_cbo_w := sus_obter_cbo_medico(coalesce(cd_medico_regra_w,cd_profissional_w), cd_procedimento_w, clock_timestamp(), 0);
				end if;

				SELECT * FROM obter_proced_espec_medica(	cd_estabelecimento_w, cd_convenio_w, cd_procedimento_w, ie_origem_proced_w, null, null, null, ie_clinica_w, cd_setor_atendimento_w, cd_especialidade_w, cd_funcao_medico_w, cd_medico_regra_w, null, ie_tipo_atendimento_w) INTO STRICT cd_especialidade_w, cd_funcao_medico_w;
								
				select	max(cd_local_estoque)
				into STRICT	cd_local_estoque_w
				from	setor_atendimento
				where	cd_setor_atendimento	= cd_setor_atendimento_w;

				select	CASE WHEN ie_tipo_equip_w='H' THEN nr_seq_pac_equip_p WHEN ie_tipo_equip_w='A' THEN nr_seq_pac_equip_p  ELSE null END ,
					CASE WHEN ie_tipo_equip_w='E' THEN  cd_equipamento_w  ELSE null END
				into STRICT	nr_seq_hc_equipamento_w,
					cd_equipamento_w
				;
				
				insert into 	procedimento_paciente(
						nr_sequencia,
						nr_atendimento,
						dt_entrada_unidade,
						cd_procedimento,
						dt_procedimento,
						qt_procedimento,
						dt_atualizacao,
						nm_usuario,
						cd_convenio,
						cd_categoria,
						dt_prescricao,
						nr_prescricao,
						nr_sequencia_prescricao,
						cd_acao,
						cd_setor_atendimento,
						ie_origem_proced,
						tx_procedimento,
						cd_cgc_prestador,
						nm_usuario_original,
						nr_doc_convenio,
						nr_seq_atepacu,
						ie_auditoria,
						nr_seq_proc_interno,
						cd_medico_executor,
						cd_senha,
						nr_seq_exame,
						ie_via_acesso,
						ie_tecnica_utilizada,
						cd_pessoa_fisica,
						cd_cbo,
						ie_funcao_medico,
						cd_especialidade,
						nr_interno_conta,
						nr_sequencia_gas,
						nr_seq_hc_equipamento,
						cd_equipamento)
					values (
						nr_sequencia_w,
						nr_atendimento_p,
						dt_entrada_unidade_w,
						cd_procedimento_w,
						clock_timestamp(),
						1,
						clock_timestamp(),
						nm_usuario_p,
						cd_convenio_w,
						cd_categoria_w,
						clock_timestamp(),
						null,
						null,
						0,
						cd_setor_atendimento_w,
						ie_origem_proced_w,
						100,
						cd_cgc_prestador_w,
						nm_usuario_p,
						nr_doc_conv_w,
						nr_seq_interno_w,
						'N',
						null,
						cd_medico_exec_w,
						null,
						null,
						ie_via_acesso_w,
						null,
						cd_profissional_w,
						cd_cbo_w,
						cd_funcao_medico_w,
						cd_especialidade_w,
						null,
						null,
						nr_seq_hc_equipamento_w,
						cd_equipamento_w);

				ds_erro_w := consiste_exec_procedimento(nr_sequencia_w, ds_erro_w);
				CALL atualiza_preco_procedimento(nr_sequencia_w, cd_convenio_w, nm_usuario_p);
				CALL gerar_lancamento_automatico(nr_atendimento_w,cd_local_estoque_w,34,nm_usuario_p,nr_sequencia_w,null,null,null,'A',null);
			end if;
		end if;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_propaci_equip_hc ( nr_atendimento_p bigint, nr_seq_equipamento_p bigint, nr_seq_pac_equip_p bigint, nm_usuario_p text) FROM PUBLIC;
