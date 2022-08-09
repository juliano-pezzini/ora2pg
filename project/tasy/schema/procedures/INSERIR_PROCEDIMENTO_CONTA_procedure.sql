-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_procedimento_conta (cd_procedimento_p bigint, ie_origem_proced_p bigint, qt_procedimento_p bigint, dt_procedimento_p timestamp, nr_interno_conta_p bigint, nr_atendimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_estabelecimento_p bigint, nr_seq_cor_exec_p bigint, nm_usuario_p text, ds_info_p INOUT text, ds_abort_p INOUT text) AS $body$
DECLARE

		
cd_setor_atendimento_w	procedimento_paciente.cd_setor_atendimento		%type;
dt_entrada_unidade_w	procedimento_paciente.dt_entrada_unidade		%type;
nr_seq_atepacu_w	procedimento_paciente.nr_seq_atepacu			%type;
nr_seq_proc_pac_w  	procedimento_paciente.nr_sequencia			%type;
cd_cgc_prestador_w	procedimento_paciente.cd_cgc_prestador			%type;
cd_cgc_regra_w		procedimento_paciente.cd_cgc_prestador			%type;
ie_funcao_medico_w	procedimento_paciente.ie_funcao_medico			%type;
cd_senha_w		procedimento_paciente.cd_senha				%type;
ie_via_acesso_w		procedimento_paciente.ie_via_acesso			%type;
ie_tipo_guia_w		procedimento_paciente.ie_tipo_guia			%type;
nr_interno_conta_w	procedimento_paciente.nr_interno_conta			%type := nr_interno_conta_p;
nr_interno_conta_ww	procedimento_paciente.nr_interno_conta			%type;
cd_motivo_exc_conta_w	procedimento_paciente.cd_motivo_exc_conta		%type;
qt_lancamento_w		procedimento_paciente.qt_procedimento			%type := qt_procedimento_p;
cd_convenio_w		procedimento_paciente.cd_convenio			%type := cd_convenio_p;
cd_categoria_w		procedimento_paciente.cd_categoria			%type := cd_categoria_p;
ie_situacao_w		procedimento.ie_situacao				%type;
ie_acao_excesso_w								varchar(10);
qt_excedida_w									double precision;
ds_erro_uso_w									varchar(255);
cd_convenio_excesso_w	procedimento_paciente.cd_convenio			%type;
cd_categoria_excesso_w	procedimento_paciente.cd_categoria			%type;
cd_plano_convenio_w	atend_categoria_convenio.cd_plano_convenio		%type;
nr_seq_excedido_w	procedimento_paciente.nr_sequencia			%type;
nr_conta_w		procedimento_paciente.nr_interno_conta			%type;
ds_texto_w									varchar(255);
cd_motivo_exc_conta_ww	procedimento_paciente.cd_motivo_exc_conta		%type;
cd_convenio_glosa_w	convenio.cd_convenio_glosa				%type;
cd_categoria_glosa_w	convenio.cd_categoria_glosa				%type;
cd_medico_resp_w	procedimento_paciente.cd_medico_executor		%type;
cd_medico_regra_w	procedimento_paciente.cd_medico_executor		%type;
cd_espec_medica_w	procedimento_paciente.cd_especialidade			%type;
ie_tipo_atendimento_w	atendimento_paciente.ie_tipo_atendimento		%type;
ie_medico_executor_w	consiste_setor_proc.ie_medico_executor			%type;
cd_profissional_w	procedimento_paciente.cd_pessoa_fisica			%type;
cd_profissional_regra_w	procedimento_paciente.cd_pessoa_fisica			%type;
nr_seq_classificacao_w	atendimento_paciente.nr_seq_classificacao		%type;
ie_valida_regra_qtde_w								varchar(1) := 'N';
ie_consiste_plano_convenio_w							varchar(1) := 'N';
ie_exibir_regra_plano_w								varchar(1) := 'N';
ds_erro_w									varchar(2000) := '';
ie_regra_w		regra_convenio_plano.ie_regra				%type;
nr_seq_regra_w									bigint;
ds_observacao_regra_w	regra_convenio_plano.ds_observacao			%type := '';
ie_bloqueia_w		convenio_estabelecimento.ie_bloqueia_proc_sem_autor	%type;
ie_glosa_w		regra_ajuste_proc.ie_glosa				%type;
nr_seq_regra_preco_w	regra_ajuste_proc.nr_sequencia				%type;
ie_permite_incluir_w								varchar(1);
nr_doc_convenio_w	atend_categoria_convenio.nr_doc_convenio		%type;
ie_valor_informado_w	procedimento_paciente.ie_valor_informado		%type := 'N';
vl_procedimento_w	procedimento_paciente.vl_procedimento			%type;
ie_tipo_lanc_auto_w								varchar(3)	:= '0';


BEGIN

ie_permite_incluir_w		:= obter_valor_param_usuario(67, 1, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p);
ie_valida_regra_qtde_w 		:= obter_valor_param_usuario(67, 111, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p);
ie_tipo_lanc_auto_w 		:= obter_valor_param_usuario(67, 117, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p);
ie_consiste_plano_convenio_w 	:= obter_valor_param_usuario(67, 124, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p);
ie_exibir_regra_plano_w 	:= obter_valor_param_usuario(67, 524, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p);

if (ie_permite_incluir_w = 'N') then
	ds_abort_p := wheb_mensagem_pck.get_texto(446589);
	goto final;
end if;

select 	coalesce(max(ie_situacao),'A')
into STRICT	ie_situacao_w
from	procedimento
where	cd_procedimento	 = cd_procedimento_p
and	ie_origem_proced = ie_origem_proced_p;

if (ie_situacao_w = 'I') then
	ds_abort_p := wheb_mensagem_pck.get_texto(155113);
	goto final;
end if;

select	ie_tipo_atendimento,
	cd_setor_atendimento,
	dt_entrada_unidade,
	nr_seq_atepacu,
	cd_senha,
	ie_tipo_guia,
	cd_plano_convenio,
	cd_medico_resp,
	nr_seq_classificacao,
	CASE WHEN obter_valor_conv_estab(cd_convenio_w, cd_estabelecimento_p, 'IE_DOC_CONVENIO')='N' THEN  null WHEN obter_valor_conv_estab(cd_convenio_w, cd_estabelecimento_p, 'IE_DOC_CONVENIO')='S' THEN  coalesce(cd_senha, nr_doc_convenio)  ELSE nr_doc_convenio END
into STRICT	ie_tipo_atendimento_w,
	cd_setor_atendimento_w,
	dt_entrada_unidade_w,
	nr_seq_atepacu_w,
	cd_senha_w,
	ie_tipo_guia_w,
	cd_plano_convenio_w,
	cd_medico_resp_w,
	nr_seq_classificacao_w,
	nr_doc_convenio_w
from 	atendimento_paciente_v
where	nr_atendimento = nr_atendimento_p;

cd_profissional_w := cd_medico_resp_w;

select	a.cd_cgc
into STRICT	cd_cgc_prestador_w
from 	estabelecimento a,
	atendimento_paciente b
where	a.cd_estabelecimento = b.cd_estabelecimento
and	b.nr_atendimento = nr_atendimento_p;

select	obter_regra_via_acesso(cd_procedimento_p, ie_origem_proced_p, cd_estabelecimento_p, cd_convenio_w),
	obter_espec_medico_atend(nr_atendimento_p, cd_medico_resp_w, 'C'),
	nextval('procedimento_paciente_seq')
into STRICT	ie_via_acesso_w,
	cd_espec_medica_w,
	nr_seq_proc_pac_w
;

select 	max(cd_funcao_medico),
	max(cd_motivo_exc_conta)
into STRICT	ie_funcao_medico_w,
	cd_motivo_exc_conta_w
from	parametro_faturamento
where	cd_estabelecimento = cd_estabelecimento_p;

SELECT * FROM consiste_medico_executor(cd_estabelecimento_p, cd_convenio_w, cd_setor_atendimento_w, cd_procedimento_p, ie_origem_proced_p, ie_tipo_atendimento_w, null, null, ie_medico_executor_w, cd_cgc_regra_w, cd_medico_regra_w, cd_profissional_regra_w,  -- out
	coalesce(cd_medico_regra_w, cd_medico_resp_w), dt_procedimento_p, nr_seq_classificacao_w, null, null, null) INTO STRICT ie_medico_executor_w, cd_cgc_regra_w, cd_medico_regra_w, cd_profissional_regra_w;
			
if (ie_medico_executor_w = 'F' and (cd_medico_regra_w IS NOT NULL AND cd_medico_regra_w::text <> '')) then
	cd_medico_resp_w := cd_medico_regra_w;
	
	if (cd_cgc_regra_w IS NOT NULL AND cd_cgc_regra_w::text <> '') then
		cd_cgc_prestador_w := cd_cgc_regra_w;
	end if;
	
	if (cd_profissional_regra_w IS NOT NULL AND cd_profissional_regra_w::text <> '') then
		cd_profissional_w := cd_profissional_regra_w;
	end if;
elsif (ie_medico_executor_w = 'N') then
	cd_medico_resp_w	:= null;
	cd_cgc_prestador_w	:= null;
	cd_profissional_w	:= null;
end if;

if (ie_consiste_plano_convenio_w = 'S' or ie_consiste_plano_convenio_w = 'A') then

	SELECT * FROM consiste_plano_convenio(nr_atendimento_p, cd_convenio_w, cd_procedimento_p, ie_origem_proced_p, dt_procedimento_p, qt_lancamento_w, ie_tipo_atendimento_w, cd_plano_convenio_w, null, ds_erro_w, cd_setor_atendimento_w, null, ie_regra_w, null, nr_seq_regra_w, null, cd_categoria_w, cd_estabelecimento_p, null, cd_medico_resp_w, cd_profissional_w, ie_glosa_w, nr_seq_regra_preco_w) INTO STRICT ds_erro_w, ie_regra_w, nr_seq_regra_w, ie_glosa_w, nr_seq_regra_preco_w;
				
	if (ie_exibir_regra_plano_w = 'S') then
		begin
		select	coalesce(ds_observacao, '') ds_observacao
		into STRICT	ds_observacao_regra_w
		from	regra_convenio_plano
		where	nr_sequencia = nr_seq_regra_w;
		exception
		when others then
			ds_observacao_regra_w	:= '';
		end;
	end if;
	
	begin
	select	coalesce(ie_bloqueia_proc_sem_autor, 'N') ie_bloqueia
	into STRICT	ie_bloqueia_w
	from	convenio_estabelecimento
	where	cd_estabelecimento = cd_estabelecimento_p
	and	cd_convenio = cd_convenio_w;
	exception
	when others then
		ie_bloqueia_w := 'N';
	end;
	
	if (ie_regra_w = 1 or ie_regra_w = 2) then
		ds_abort_p := wheb_mensagem_pck.get_texto(450961, 'regra=' || nr_seq_regra_w || ';observacao=' || ds_observacao_regra_w);
		goto final;
	elsif (ie_regra_w = 7 and ie_bloqueia_w = 'S' and substr(ds_erro_w, 3, 3) = '406') then
		ds_abort_p := wheb_mensagem_pck.get_texto(450960);
		goto final;
	end if;

end if;

if (ie_valida_regra_qtde_w = 'S') then

	SELECT * FROM obter_regra_qtde_proc_exec(nr_atendimento_p, cd_procedimento_p, ie_origem_proced_p, qt_lancamento_w, dt_procedimento_p, cd_medico_resp_w, ie_acao_excesso_w, qt_excedida_w, ds_erro_uso_w, cd_convenio_excesso_w, cd_categoria_excesso_w, null, cd_categoria_w, cd_plano_convenio_w, nr_interno_conta_w, null, null, cd_setor_atendimento_w, null) INTO STRICT ie_acao_excesso_w, qt_excedida_w, ds_erro_uso_w, cd_convenio_excesso_w, cd_categoria_excesso_w;

	if (ie_acao_excesso_w = 'E') then
		if (qt_excedida_w   > 0) then
			if 	((qt_lancamento_w - qt_excedida_w) >= 0) then

				nr_seq_excedido_w := inserir_procedimento_paciente(cd_procedimento_p, qt_excedida_w, null, null, ie_origem_proced_p, cd_setor_atendimento_w, nr_atendimento_p, cd_estabelecimento_p, nm_usuario_p, null, 'S', cd_medico_resp_w, nr_seq_atepacu_w, dt_procedimento_p, cd_convenio_w, cd_categoria_w, nr_seq_excedido_w);
				CALL atualiza_preco_procedimento(nr_seq_excedido_w, cd_convenio_w, nm_usuario_p);

				select	max(nr_interno_conta)
				into STRICT	nr_conta_w
				from	procedimento_paciente
				where	nr_sequencia = nr_seq_excedido_w;
				--Excluido pela regra de uso da funcao Cadastro de Convenios
				ds_texto_w := substr(wheb_mensagem_pck.get_texto(306744),1,255);
				CALL excluir_matproc_conta(nr_seq_excedido_w, nr_conta_w, coalesce(cd_motivo_exc_conta_w, 12), ds_texto_w, 'P', nm_usuario_p);
				
				CALL ajustar_conta_vazia(nr_atendimento_p, nm_usuario_p);

				if	((qt_lancamento_w - qt_excedida_w) = 0) then
					ds_abort_p := wheb_mensagem_pck.get_texto(152722);
					goto final;
				else
					qt_lancamento_w := qt_lancamento_w - qt_excedida_w;
				end if;
			end if;
		end if;

	elsif (ie_acao_excesso_w = 'P') then
	
		SELECT * FROM obter_convenio_particular_pf(cd_estabelecimento_p, cd_convenio_w, '', dt_procedimento_p, cd_convenio_glosa_w, cd_categoria_glosa_w) INTO STRICT cd_convenio_glosa_w, cd_categoria_glosa_w;

		if (qt_excedida_w >= qt_lancamento_w) then
			nr_interno_conta_w 	:= null;
			cd_convenio_w		:= cd_convenio_glosa_w;
			cd_categoria_w		:= cd_categoria_glosa_w;
		else
			qt_lancamento_w := qt_lancamento_w - qt_excedida_w;

			nr_seq_excedido_w := inserir_procedimento_paciente(cd_procedimento_p, qt_excedida_w, null, null, ie_origem_proced_p, cd_setor_atendimento_w, nr_atendimento_p, cd_estabelecimento_p, nm_usuario_p, null, 'S', cd_medico_resp_w, nr_seq_atepacu_w, dt_procedimento_p, cd_convenio_glosa_w, cd_categoria_glosa_w, nr_seq_excedido_w);

			CALL atualiza_preco_procedimento(nr_seq_excedido_w, cd_convenio_glosa_w, nm_usuario_p);
			CALL ajustar_conta_vazia(nr_atendimento_p, nm_usuario_p);
		end if;
		
	elsif (ie_acao_excesso_w = 'Z') then
		
		if (qt_excedida_w >= qt_lancamento_w) then		
			ie_valor_informado_w 	:= 'S';
			vl_procedimento_w 	:= 0;			
		else		
			qt_lancamento_w := qt_lancamento_w - qt_excedida_w;
			
			nr_seq_excedido_w := inserir_procedimento_paciente(cd_procedimento_p, qt_excedida_w, null, null, ie_origem_proced_p, cd_setor_atendimento_w, nr_atendimento_p, cd_estabelecimento_p, nm_usuario_p, null, 'S', cd_medico_resp_w, nr_seq_atepacu_w, dt_procedimento_p, cd_convenio_w, cd_categoria_w, nr_seq_excedido_w);
			
			CALL atualiza_preco_procedimento(nr_seq_excedido_w, cd_convenio_w, nm_usuario_p);
			CALL ajustar_conta_vazia(nr_atendimento_p, nm_usuario_p);		
		end if;
		
	elsif (ie_acao_excesso_w = 'C'
		and (cd_convenio_excesso_w IS NOT NULL AND cd_convenio_excesso_w::text <> '')
		and (cd_categoria_excesso_w IS NOT NULL AND cd_categoria_excesso_w::text <> '')
		and qt_excedida_w >= qt_lancamento_w) then
	
		nr_interno_conta_w 	:= null;
		cd_convenio_w		:= cd_convenio_excesso_w;
		cd_categoria_w		:= cd_categoria_excesso_w;
		
	elsif (ds_erro_uso_w IS NOT NULL AND ds_erro_uso_w::text <> '') then
		ds_abort_p := ds_erro_uso_w;
		goto final;	
	end if;
end if;

insert into procedimento_paciente( 	nr_sequencia,
		nr_atendimento,
		nr_interno_conta,
		dt_entrada_unidade,
		cd_procedimento,
		dt_procedimento,
		qt_procedimento,
		dt_atualizacao,
		nm_usuario,
		cd_setor_atendimento,
		ie_origem_proced,
		nr_seq_atepacu,
		cd_convenio,
		cd_categoria,
		cd_cgc_prestador,
		dt_conta,
		tx_medico,
		tx_anestesia,
		tx_procedimento,
		cd_acao,
		ie_valor_informado,
		cd_setor_receita,
		cd_situacao_glosa,
		ie_funcao_medico,
		ie_auditoria,
		cd_senha,
		ie_via_acesso,
		ie_tecnica_utilizada,
		ie_tipo_guia,
		cd_medico,
		cd_medico_executor,
		cd_pessoa_fisica,
		cd_especialidade,
		nr_doc_convenio,
		vl_procedimento,
		nr_seq_cor_exec
		)
values (	nr_seq_proc_pac_w,
		nr_atendimento_p,
		nr_interno_conta_w,
		dt_entrada_unidade_w,
		cd_procedimento_p,
		dt_procedimento_p,
		qt_lancamento_w,
		clock_timestamp(),
		nm_usuario_p,
		cd_setor_atendimento_w,
		ie_origem_proced_p,
		nr_seq_atepacu_w,
		cd_convenio_w,
		cd_categoria_w,
		cd_cgc_prestador_w,
		dt_procedimento_p,
		100,
		100,
		100,
		'1',
		ie_valor_informado_w,
		cd_setor_atendimento_w,
		0,
		ie_funcao_medico_w,
		'N',
		cd_senha_w,
		ie_via_acesso_w,
		null,
		ie_tipo_guia_w,
		cd_medico_resp_w,
		cd_medico_resp_w,
		cd_profissional_w,
		cd_espec_medica_w,
		nr_doc_convenio_w,
		vl_procedimento_w,
		nr_seq_cor_exec_p
		);			
		
CALL atualiza_preco_procedimento(nr_seq_proc_pac_w, cd_convenio_w, nm_usuario_p);

if (ie_tipo_lanc_auto_w = '0') then
	CALL gerar_lancamento_automatico(nr_atendimento_p, null, 34, nm_usuario_p, nr_seq_proc_pac_w, null, null, null, null, null);	
end if;

CALL gerar_autor_regra(nr_atendimento_p, null, nr_seq_proc_pac_w, null, null, null, 'CP', nm_usuario_p, null, null, null, null, null, null, '', '', '');

select 	nr_interno_conta,
	cd_motivo_exc_conta
into STRICT	nr_interno_conta_ww,
	cd_motivo_exc_conta_ww
from 	procedimento_paciente
where 	nr_sequencia = nr_seq_proc_pac_w;

if (ds_erro_uso_w IS NOT NULL AND ds_erro_uso_w::text <> '') then
	ds_info_p	:= ds_erro_uso_w;
elsif (coalesce(nr_interno_conta_ww,0) <> coalesce(nr_interno_conta_w,0)) then
	ds_info_p	:= wheb_mensagem_pck.get_texto(150498);
elsif (cd_motivo_exc_conta_ww IS NOT NULL AND cd_motivo_exc_conta_ww::text <> '') then
	ds_info_p	:= wheb_mensagem_pck.get_texto(1091279);
elsif (coalesce(nr_interno_conta_ww::text, '') = '') then
	ds_info_p	:= wheb_mensagem_pck.get_texto(1091280);
end if;

<<final>>

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_procedimento_conta (cd_procedimento_p bigint, ie_origem_proced_p bigint, qt_procedimento_p bigint, dt_procedimento_p timestamp, nr_interno_conta_p bigint, nr_atendimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_estabelecimento_p bigint, nr_seq_cor_exec_p bigint, nm_usuario_p text, ds_info_p INOUT text, ds_abort_p INOUT text) FROM PUBLIC;
