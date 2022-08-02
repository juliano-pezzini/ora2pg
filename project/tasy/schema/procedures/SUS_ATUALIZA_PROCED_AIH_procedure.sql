-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_atualiza_proced_aih ( nr_aih_p bigint, nr_sequencia_p bigint, nm_usuario_p text, ds_erro_p INOUT text, cd_setor_atendimento_p bigint) AS $body$
DECLARE


nr_atendimento_w			bigint;
nr_apac_w			bigint;
cd_medico_resp_w			varchar(10);
cd_pessoa_fisica_w		varchar(10);
cd_estabelecimento_w		smallint;
cd_cgc_prestador_w		varchar(14);

cd_setor_atendimento_w		integer;
dt_entrada_unidade_w		timestamp;
nr_seq_atepacu_w			bigint;

cd_convenio_w			integer;
cd_categoria_w			varchar(10);
nr_seq_atecaco_w			bigint;

nr_prescricao_w			bigint;
nr_seq_exame_w			bigint;
cd_material_exame_w		varchar(20);
nr_seq_item_prescr_w		integer;
dt_prescricao_w			timestamp;
cd_setor_prescr_w			integer;
cd_medico_prescr_w		varchar(10);
cd_medico_proc_apac_w		varchar(10);

ie_tipo_apac_w			smallint;
cd_motivo_cobranca_w		smallint;
cd_procedimento_solic_w		bigint;
cd_procedimento_w		bigint;
cd_atividade_prof_w		smallint;
qt_procedimento_w			double precision;
cd_cgc_fornecedor_w		varchar(14);
nr_nota_fiscal_w			varchar(20);
nr_seq_proc_apac_w		bigint;
nr_seq_propaci_w			bigint;

nr_seq_protocolo_w		bigint;
dt_mesano_referencia_w		timestamp;
dt_entrada_w			timestamp;
nr_interno_conta_w			bigint;
ds_erro_w			varchar(255);
ie_vincular_prot_w			varchar(1);
ie_tipo_protocolo_w			smallint;
cd_setor_apac_w			integer;
ie_fecha_atend_w			varchar(1);

ie_consiste_comp_w		varchar(1);
ie_consiste_apac_prot_w		varchar(1);
dt_fim_validade_w			timestamp;

qt_proced_conta_w			integer	:= 0;
ie_origem_proc_solic_w		bigint;
ie_origem_proced_w		bigint;
cd_medico_responsavel_w		varchar(10);
cd_medico_autorizador_w		varchar(10);
cd_medico_solic_w		varchar(10);

libera_setor_excl_w			varchar(1);

ie_tipo_atendimento_w		smallint;
ie_medico_executor_w		varchar(10);
cd_cgc_prest_regra_w		varchar(14);
nr_seq_classificacao_w		bigint;
cd_medico_executor_w		varchar(10);
cd_medico_exec_proc_w		varchar(10);
ie_medico_exec_proc_w		varchar(10) := 'R';
ie_aterar_proc_mudanca_w	varchar(10) := 'N';
ie_mudanca_proc_w		varchar(1);
ie_cria_nova_conta_w		varchar(15) := 'N';
dt_procedimento_w		timestamp;
dt_emissao_aih_w		timestamp;


BEGIN

begin
/* Buscar dados AIH */

select	a.nr_atendimento,
	a.nr_interno_conta,
	a.cd_procedimento_real,
	a.ie_origem_proc_real,
	a.cd_procedimento_solic,
	a.ie_origem_proc_solic,
	b.cd_convenio_parametro,
	b.cd_categoria_parametro,
	a.cd_medico_responsavel,
	a.cd_medico_solic,
	a.cd_medico_autorizador,
	b.cd_estabelecimento,
	coalesce(a.ie_mudanca_proc,'N'),
	a.dt_emissao
into STRICT	nr_atendimento_w,
	nr_interno_conta_w,
	cd_procedimento_w,
	ie_origem_proced_w,
	cd_procedimento_solic_w,
	ie_origem_proc_solic_w,
	cd_convenio_w,
	cd_categoria_w,
	cd_medico_responsavel_w,
	cd_medico_solic_w,
	cd_medico_autorizador_w,
	cd_estabelecimento_w,
	ie_mudanca_proc_w,
	dt_emissao_aih_w
from	sus_aih_unif a,
	conta_paciente b
where	a.nr_interno_conta	= b.nr_interno_conta
and	a.nr_sequencia = nr_sequencia_p
and	a.nr_aih = nr_aih_p
and	b.ie_status_acerto	= 1;
exception
	when others then
	nr_interno_conta_w	:= null;
	select	nr_atendimento,
		substr(obter_convenio_atendimento(nr_atendimento),1,10),
              	substr(obter_categoria_atendimento(nr_atendimento),1,10),
		cd_procedimento_real,
		ie_origem_proc_real,
		cd_procedimento_solic,
		ie_origem_proc_solic,
		cd_medico_responsavel,
		cd_medico_solic,
		cd_medico_autorizador,
		cd_estabelecimento,
		coalesce(ie_mudanca_proc,'N'),
		dt_emissao
	into STRICT	nr_atendimento_w,
		cd_convenio_w,
		cd_categoria_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		cd_procedimento_solic_w,
		ie_origem_proc_solic_w,
		cd_medico_responsavel_w,
		cd_medico_solic_w,
		cd_medico_autorizador_w,
		cd_estabelecimento_w,
		ie_mudanca_proc_w,
		dt_emissao_aih_w
	from	sus_aih_unif
	where	nr_sequencia    = nr_sequencia_p
	and	nr_aih = nr_aih_p;
end;

ie_medico_exec_proc_w 		:= coalesce(Obter_Valor_Param_Usuario(1123,168,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_w),'R');
ie_aterar_proc_mudanca_w	:= coalesce(Obter_Valor_Param_Usuario(1123,169,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_w),'N');
ie_cria_nova_conta_w		:= coalesce(Obter_Valor_Param_Usuario(1123,246,Obter_Perfil_Ativo,nm_Usuario_p,cd_estabelecimento_w),'N');

if (nr_interno_conta_w IS NOT NULL AND nr_interno_conta_w::text <> '') then
	begin
	
	select	count(*)
	into STRICT	qt_proced_conta_w
	from	procedimento_paciente
	where	nr_interno_conta = nr_interno_conta_w
	and	cd_procedimento = cd_procedimento_solic_w
	and	ie_origem_proced = ie_origem_proced_w
	and	coalesce(cd_motivo_exc_conta::text, '') = '';

	end;
else
	begin

	select	count(*)
	into STRICT	qt_proced_conta_w
	from	conta_paciente b,
		procedimento_paciente a
	where	a.nr_atendimento = nr_atendimento_w
	and	a.cd_procedimento = cd_procedimento_solic_w
	and	a.ie_origem_proced = ie_origem_proced_w
	and	a.nr_interno_conta = b.nr_interno_conta
	and	b.ie_status_acerto = 1
	and	coalesce(sus_obter_aihunif_conta(a.nr_interno_conta), 0) = 0
	and	coalesce(a.cd_motivo_exc_conta::text, '') = '';

	end;
end if;

if (coalesce(ie_aterar_proc_mudanca_w,'N') = 'S') and (coalesce(ie_mudanca_proc_w,'N') = 'S') and (coalesce(qt_proced_conta_w,0) > 0) and (cd_procedimento_solic_w <> cd_procedimento_w) then
	begin
	
	if (nr_interno_conta_w IS NOT NULL AND nr_interno_conta_w::text <> '') then
		begin
		
		select	max(nr_sequencia)
		into STRICT	nr_seq_propaci_w
		from	procedimento_paciente
		where	nr_interno_conta = nr_interno_conta_w
		and	cd_procedimento = cd_procedimento_solic_w
		and	ie_origem_proced = ie_origem_proc_solic_w
		and	coalesce(cd_motivo_exc_conta::text, '') = '';
	
		end;
	else
		begin
	
		select	max(nr_sequencia)
		into STRICT	nr_seq_propaci_w
		from	conta_paciente b,
			procedimento_paciente a
		where	a.nr_atendimento = nr_atendimento_w
		and	a.cd_procedimento = cd_procedimento_solic_w
		and	a.ie_origem_proced = ie_origem_proc_solic_w
		and	a.nr_interno_conta = b.nr_interno_conta
		and	b.ie_status_acerto = 1
		and	coalesce(sus_obter_aihunif_conta(a.nr_interno_conta), 0) = 0
		and	coalesce(a.cd_motivo_exc_conta::text, '') = '';
	
		end;
	end if;
	
	if (coalesce(nr_seq_propaci_w,0) <> 0) then
			
		Update 	procedimento_paciente
		set	cd_procedimento = cd_procedimento_w,
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_propaci_w;
		
	end if;
	
	end;
else	

	begin
	
	if (ie_medico_exec_proc_w = 'R') then
		cd_medico_exec_proc_w := cd_medico_responsavel_w;
	elsif (ie_medico_exec_proc_w = 'S') then
		cd_medico_exec_proc_w := cd_medico_solic_w;
	elsif (ie_medico_exec_proc_w = 'A') then
		cd_medico_exec_proc_w := cd_medico_autorizador_w;	
	end if;
	
	/* Buscar dados da unidade */

	if (coalesce(cd_setor_atendimento_p,0) <> 0) then
		begin
		
		begin
		select	a.cd_setor_atendimento,
			a.dt_entrada_unidade,
			a.nr_seq_interno
		into STRICT	cd_setor_atendimento_w,
			dt_entrada_unidade_w,
			nr_seq_atepacu_w
		from	atend_paciente_unidade a
		where	a.nr_atendimento	= nr_atendimento_w
		and	a.cd_setor_atendimento	= cd_setor_atendimento_p
		and	a.dt_entrada_unidade 	= (	SELECT	max(x.dt_entrada_unidade)
							from	atend_paciente_unidade x
							where	x.nr_atendimento 	= a.nr_atendimento
							and	x.cd_setor_atendimento	= cd_setor_atendimento_p);
		exception
			when others then
			ds_erro_p	:= WHEB_MENSAGEM_PCK.get_texto(278010);
		end;
		
		end;
	else
		begin
		
		begin
		select	a.cd_setor_atendimento,
			a.dt_entrada_unidade,
			a.nr_seq_interno
		into STRICT	cd_setor_atendimento_w,
			dt_entrada_unidade_w,
			nr_seq_atepacu_w
		from	atend_paciente_unidade a,
			setor_atendimento b
		where	a.nr_atendimento	= nr_atendimento_w
		and	a.cd_setor_atendimento	= b.cd_setor_atendimento
		and	a.dt_entrada_unidade 	= (	SELECT	max(x.dt_entrada_unidade)
							from	atend_paciente_unidade x,
								setor_atendimento y
							where	x.nr_atendimento 	= a.nr_atendimento
							and	x.cd_setor_atendimento	= y.cd_setor_atendimento
							and	y.cd_classif_setor = 3)
		and	b.cd_classif_setor	= 3;
		exception
			when others then
			ds_erro_p	:= WHEB_MENSAGEM_PCK.get_texto(278014);
		end;
		
		end;
	end if;
	
	if (ie_cria_nova_conta_w = 'S' and coalesce(ie_mudanca_proc_w,'N') = 'N') then
		dt_procedimento_w := dt_emissao_aih_w;
	else
		dt_procedimento_w := dt_entrada_unidade_w;
	end if;
	
	select	max(a.cd_cgc),
		max(b.ie_tipo_atendimento),
		max(b.nr_seq_classificacao)
	into STRICT	cd_cgc_prestador_w,
		ie_tipo_atendimento_w,
		nr_seq_classificacao_w
	from	estabelecimento a,
		atendimento_paciente b
	where	a.cd_estabelecimento = b.cd_estabelecimento
	and	b.nr_atendimento = nr_atendimento_w;
	
	SELECT * FROM consiste_medico_executor(cd_estabelecimento_w, cd_convenio_w, cd_setor_atendimento_w, cd_procedimento_w, ie_origem_proced_w, ie_tipo_atendimento_w, null, null, ie_medico_executor_w, cd_cgc_prest_regra_w, cd_medico_executor_w, cd_pessoa_fisica_w, cd_medico_exec_proc_w, dt_procedimento_w, nr_seq_classificacao_w, 'N', null, null) INTO STRICT ie_medico_executor_w, cd_cgc_prest_regra_w, cd_medico_executor_w, cd_pessoa_fisica_w;
				
	if (ie_medico_executor_w	= 'F') and (cd_medico_executor_w IS NOT NULL AND cd_medico_executor_w::text <> '') then
		cd_medico_exec_proc_w	:= cd_medico_executor_w;
	end if;	
	
	if (cd_cgc_prest_regra_w IS NOT NULL AND cd_cgc_prest_regra_w::text <> '') then
		cd_cgc_prestador_w := cd_cgc_prest_regra_w;
	end if;
	
	if (qt_proced_conta_w = 0) and (nr_seq_atepacu_w IS NOT NULL AND nr_seq_atepacu_w::text <> '')  then
		
		libera_setor_excl_w := obter_param_usuario(1123, 23, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, libera_setor_excl_w);
		
		if (libera_setor_excl_w = 'N') and (verifica_setor_esclusivo(cd_procedimento_w,ie_origem_proced_w,cd_setor_atendimento_w,null,nm_usuario_p) = 0) then
			
			ds_erro_p := WHEB_MENSAGEM_PCK.get_texto(278016) ||cd_procedimento_w|| WHEB_MENSAGEM_PCK.get_texto(278017) ||substr(obter_nome_setor(cd_setor_atendimento_w),1,100)||'.'|| WHEB_MENSAGEM_PCK.get_texto(278018);
	
		else
			begin
			ds_erro_p := '';
			
			if (to_char(dt_procedimento_w, 'hh24:mi:ss') = '00:00:00') then
			
				dt_procedimento_w	:= PKG_DATE_UTILS.get_DateTime((to_char(dt_procedimento_w, 'YYYY'))::numeric ,
											(to_char(dt_procedimento_w, 'MM'))::numeric ,
											(to_char(dt_procedimento_w, 'DD'))::numeric ,
											(to_char(clock_timestamp(), 'HH24'))::numeric ,
											(to_char(clock_timestamp(), 'MI'))::numeric ,
											(to_char(clock_timestamp(), 'SS'))::numeric
								);
			
			end if;
	
			select	nextval('procedimento_paciente_seq')
			into STRICT	nr_seq_propaci_w
			;
			
			begin
			insert into 	procedimento_paciente(
				nr_sequencia, 		nr_atendimento, 	dt_entrada_unidade, 	cd_procedimento,
				dt_procedimento,	qt_procedimento, 	dt_atualizacao, 	nm_usuario,
				cd_medico, 		cd_convenio, 		cd_categoria, 		cd_pessoa_fisica,
				dt_prescricao, 		ds_observacao, 		vl_procedimento, 	vl_medico,
				vl_anestesista, 	vl_materiais, 		cd_edicao_amb, 		cd_tabela_servico,
				dt_vigencia_preco, 	cd_procedimento_princ, 	dt_procedimento_princ, 	dt_acerto_conta,
				dt_acerto_convenio, 	dt_acerto_medico, 	vl_auxiliares, 		vl_custo_operacional,
				tx_medico, 		tx_anestesia, 		nr_prescricao, 		nr_sequencia_prescricao,
				cd_motivo_exc_conta, 	ds_compl_motivo_excon, 	cd_acao, 		qt_devolvida,
				cd_motivo_devolucao, 	nr_cirurgia, 		nr_doc_convenio, 	cd_medico_executor,
				ie_cobra_pf_pj, 	nr_laudo, 		dt_conta, 		cd_setor_atendimento,
				cd_conta_contabil, 	cd_procedimento_aih, 	ie_origem_proced, 	nr_aih,
				ie_responsavel_credito, tx_procedimento, 	cd_equipamento, 	ie_valor_informado,
				cd_estabelecimento_custo,cd_tabela_custo, 	cd_situacao_glosa, 	nr_lote_contabil,
				cd_procedimento_convenio,nr_seq_autorizacao, 	ie_tipo_servico_sus, 	ie_tipo_ato_sus,
				cd_cgc_prestador, 	nr_nf_prestador, 	cd_atividade_prof_bpa,	nr_interno_conta,
				nr_seq_proc_princ, 	ie_guia_informada, 	dt_inicio_procedimento, ie_emite_conta,
				ie_funcao_medico, 	ie_classif_sus, 	cd_especialidade, 	nm_usuario_original,
				nr_seq_proc_pacote, 	ie_tipo_proc_sus, 	cd_setor_receita, 	vl_adic_plant,
				nr_seq_atepacu, 	ie_auditoria)
			values (nr_seq_propaci_w, 	nr_atendimento_w,	dt_entrada_unidade_w,	cd_procedimento_w,
				dt_procedimento_w, 	1, 			clock_timestamp(), 		nm_usuario_p,
				null, 			cd_convenio_w,		cd_categoria_w, 	null,
				null,			null, 			0, 			0,
				0, 			0,			null,			null,
				null, 			null, 			null, 			null,
				null,			null, 			0, 			0,
				1, 			1, 			null, 			null,
				null, 			null, 			null, 			null,
				null, 			null, 			null, 			cd_medico_exec_proc_w,
				null, 			null, 			null, 			cd_setor_atendimento_w,
				null, 			null, 			ie_origem_proced_w, 	nr_aih_p,
				null, 			null, 			null, 			'N',
				cd_estabelecimento_w, 	null, 			null, 			null,		
				null, 			null, 			null, 			null,
				cd_cgc_prestador_w, 	null,			null, 			nr_interno_conta_w,
				null, 			null, 			null, 			null,
				null, 			null, 			null, 			null,
				null, 			null, 			cd_setor_atendimento_w, 0,
				nr_seq_atepacu_w,	null);		
			exception
				when others then
					CALL Wheb_mensagem_pck.exibir_mensagem_abort(191447);
				end;
			end;
		end if;
	end if;
	
	end;
end if;

if (coalesce(nr_seq_propaci_w,0) <> 0) then
	begin
	/* Atualizar preco da procedimento paciente  */

	CALL atualiza_preco_procedimento(nr_seq_propaci_w,cd_convenio_w,nm_usuario_p);
	CALL gerar_lancamento_automatico(nr_atendimento_w,null,34,'Tasy',nr_seq_propaci_w,null,null,null,null,null);	
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_atualiza_proced_aih ( nr_aih_p bigint, nr_sequencia_p bigint, nm_usuario_p text, ds_erro_p INOUT text, cd_setor_atendimento_p bigint) FROM PUBLIC;

