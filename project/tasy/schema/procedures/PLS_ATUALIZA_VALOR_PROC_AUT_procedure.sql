-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualiza_valor_proc_aut ( nr_seq_procedimento_p bigint, ie_tipo_p text, nm_usuario_p text) AS $body$
DECLARE


/*
ie_tipo_p	
   COMPL - 	Complemento de pedido de autorizacao
   A -	Autorizacao
   R - 	Requisicao
   AA- 	Analise de Autorizacao
   AR-	Analise de Requisicao
*/
nr_seq_guia_w			bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
dt_solicitacao_w		timestamp;
nr_seq_segurado_w		bigint;
cd_medico_solicitante_w		varchar(10);
nr_seq_prestador_w		bigint;
nr_seq_plano_w			bigint;
nr_seq_tipo_acomodacao_w	bigint;
nr_seq_clinica_w		bigint;
cd_estabelecimento_w		bigint;
ie_tipo_contratacao_w		varchar(2);
nr_seq_classificacao_prest_w	bigint;
nr_seq_categoria_w		bigint;
nr_seq_contrato_w		bigint;
cd_convenio_w			varchar(10);
cd_categoria_w			varchar(10);
vl_procedimento_w		double precision	:= 0;
vl_custo_operacional_w		double precision	:= 0;
vl_anestesista_w		double precision	:= 0;
vl_medico_w			double precision	:= 0;
vl_auxiliares_w			double precision	:= 0;
vl_filme_w			double precision	:= 0;
nr_seq_regra_w			bigint;
cd_edicao_amb_w			integer;
ie_preco_informado_w		varchar(1)	:= 'N';
cd_porte_anestesico_w		varchar(10);
ds_retorno_w			varchar(10);
nr_seq_pacote_w			bigint;
vl_servico_w			varchar(14);
nr_seq_proc_w			bigint;
nr_aux_regra_w			bigint;
nr_seq_requisicao_w		bigint;
nr_seq_regra_autogerado_w	bigint;
ie_carater_internacao_w		varchar(10);
dt_procedimento_w		timestamp	:= null;
ie_regra_preco_w		varchar(3);
nr_seq_regra_preco_pac_w	bigint;
nr_seq_preco_pacote_w		bigint;
ie_tipo_guia_w			varchar(4);
ie_excluir_proc_pacote_w	varchar(4);
qt_reg_convertidos_w		bigint;
cd_moeda_autogerado_w		smallint;
nr_seq_cong_seg_w		pls_congenere.nr_sequencia%type;
nr_seq_uni_exec_w		pls_guia_plano.nr_seq_uni_exec%type;		
cd_cgc_cong_seg_w		pls_congenere.cd_cgc%type;
cd_cgc_outorgante_w		pls_outorgante.cd_cgc_outorgante%type;
cd_cgc_congenere_w		pls_congenere.cd_cgc%type;		
sg_estado_congenere_w		pessoa_juridica.sg_estado%type;
sg_estado_cong_seg_w		pessoa_juridica.sg_estado%type;
sg_estado_outorgante_w		pessoa_juridica.sg_estado%type;
ie_tipo_intercambio_w		pls_guia_plano.ie_tipo_intercambio%type := 'A';
ie_tipo_processo_w		pls_guia_plano.ie_tipo_processo%type;
vl_ch_honorarios_w		cotacao_moeda.vl_cotacao%type;
vl_ch_custo_oper_w		cotacao_moeda.vl_cotacao%type;
vl_ch_custo_filme_w		cotacao_moeda.vl_cotacao%type;
vl_ch_anestesista_w		cotacao_moeda.vl_cotacao%type;
dados_regra_preco_proc_w	pls_cta_valorizacao_pck.dados_regra_preco_proc;
dados_guia_w			pls_cta_valorizacao_pck.dados_guia;
cd_pacote_item_w		pls_requisicao_proc.cd_pacote_item%type;
ie_origem_pacote_item_w		pls_requisicao_proc.ie_origem_pacote_item%type;
ie_prestador_preco_w		pls_param_requisicao.ie_prestador_preco%type;
ie_regime_atendimento_w		pls_conta.ie_regime_atendimento%type;
ie_saude_ocupacional_w		pls_conta.ie_saude_ocupacional%type;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_guia_plano_proc
	where	nr_seq_guia = nr_seq_guia_w
	and	(nr_seq_pacote IS NOT NULL AND nr_seq_pacote::text <> '')
	and	coalesce(vl_procedimento,'0') = 0;
	
C02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_requisicao_proc
	where	nr_seq_requisicao = nr_seq_requisicao_w
	and	(nr_seq_pacote IS NOT NULL AND nr_seq_pacote::text <> '')
	and	coalesce(vl_procedimento,'0') = 0;
	

BEGIN
/*Gerar preco para os servicos do  PTU - Pedido de Complemento de Autorizacao [00505] */

if (ie_tipo_p	= 'COMPL') then
	/*Obter dados do complemento*/

	select	a.nr_seq_guia,
		a.nr_seq_requisicao,
		b.nr_seq_pacote,
		b.cd_servico,
		b.ie_origem_servico
	into STRICT	nr_seq_guia_w,
		nr_seq_requisicao_w,
		nr_seq_pacote_w,
		cd_procedimento_w,
		ie_origem_proced_w
	from	ptu_pedido_compl_aut_serv	b,
		ptu_pedido_compl_aut		a
	where	b.nr_sequencia	= nr_seq_procedimento_p
	and	b.nr_seq_pedido	= a.nr_sequencia;
	
	if (nr_seq_pacote_w IS NOT NULL AND nr_seq_pacote_w::text <> '') then
		CALL pls_atualiza_valor_pacote(nr_seq_procedimento_p, 'COMPL', nm_usuario_p, 'S', 'N');
	else
		/*Obter dados guia*/

		if (nr_seq_guia_w IS NOT NULL AND nr_seq_guia_w::text <> '') then
			select	a.dt_solicitacao,
				a.nr_seq_segurado,
				a.cd_medico_solicitante,
				a.nr_seq_prestador,
				a.nr_seq_plano,
				a.nr_seq_tipo_acomodacao,
				a.nr_seq_clinica,
				a.cd_estabelecimento,
				a.ie_carater_internacao,
				a.ie_tipo_consulta,
				a.nr_seq_uni_exec,
				a.ie_tipo_processo,
				a.ie_regime_atendimento,
				a.ie_saude_ocupacional
			into STRICT	dt_solicitacao_w,
				nr_seq_segurado_w,
				cd_medico_solicitante_w,
				nr_seq_prestador_w,
				nr_seq_plano_w,
				nr_seq_tipo_acomodacao_w,
				nr_seq_clinica_w,
				cd_estabelecimento_w,
				ie_carater_internacao_w,
				dados_guia_w.ie_tipo_consulta_guia,
				nr_seq_uni_exec_w,
				ie_tipo_processo_w,
				ie_regime_atendimento_w,
				ie_saude_ocupacional_w
			from	pls_guia_plano a
			where	a.nr_sequencia = nr_seq_guia_w;
			
		elsif (nr_seq_requisicao_w IS NOT NULL AND nr_seq_requisicao_w::text <> '')  then
			select	a.dt_requisicao,
				a.nr_seq_segurado,
				a.cd_medico_solicitante,
				a.nr_seq_prestador,
				a.nr_seq_plano,
				a.nr_seq_tipo_acomodacao,
				a.nr_seq_clinica,
				a.cd_estabelecimento,
				a.ie_carater_atendimento,
				a.ie_tipo_consulta,
				a.nr_seq_uni_exec,
				a.ie_tipo_processo,
				a.ie_regime_atendimento,
				a.ie_saude_ocupacional
			into STRICT	dt_solicitacao_w,
				nr_seq_segurado_w,
				cd_medico_solicitante_w,
				nr_seq_prestador_w,
				nr_seq_plano_w,
				nr_seq_tipo_acomodacao_w,
				nr_seq_clinica_w,
				cd_estabelecimento_w,
				ie_carater_internacao_w,
				dados_guia_w.ie_tipo_consulta_req,
				nr_seq_uni_exec_w,
				ie_tipo_processo_w,
				ie_regime_atendimento_w,
				ie_saude_ocupacional_w
			from	pls_requisicao a
			where	a.nr_sequencia = nr_seq_requisicao_w;
		end if;
		
		/*Define o tipo de intercambio caso o tipo processo  = 'I'*/

		if (ie_tipo_processo_w = 'I') then
			/*Obter operadora do estabelecimento*/

			begin
				select	b.cd_cgc_outorgante
				into STRICT	cd_cgc_outorgante_w
				from	pls_outorgante	b
				where	b.cd_estabelecimento = cd_estabelecimento_w;
			exception
			when others then
				cd_cgc_outorgante_w	:= null;
			end;
			/*Obter estado do estabelecimento*/

			begin
				select	a.sg_estado
				into STRICT	sg_estado_outorgante_w	
				from	pessoa_juridica	a
				where	a.cd_cgc = cd_cgc_outorgante_w;
			exception
			when others then
				sg_estado_outorgante_w	:= null;
			end;
			/*Obter operadora executora*/

			begin
				select	cd_cgc
				into STRICT	cd_cgc_congenere_w
				from	pls_congenere
				where	nr_sequencia = nr_seq_uni_exec_w;
			exception
			when others then
				cd_cgc_congenere_w	:= null;
			end;
			/*Obter estado da operadora executora*/

			begin
				select	sg_estado
				into STRICT	sg_estado_congenere_w
				from	pessoa_juridica
				where	cd_cgc = cd_cgc_congenere_w;
			exception
			when others then
				sg_estado_congenere_w	:= null;
			end;
			
			/*Comparando operadora estabelecimento com operadora executora*/

			if (cd_cgc_outorgante_w = cd_cgc_congenere_w) or (coalesce(cd_cgc_congenere_w::text, '') = '') then
				/*Obter operadora/sequencia/estado congenere do beneficiario*/

				begin
					select 	a.cd_cgc,
						a.nr_sequencia
					into STRICT	cd_cgc_cong_seg_w,
						nr_seq_cong_seg_w
					from	pls_congenere	a,
						pls_segurado	b
					where	a.nr_sequencia = b.nr_seq_congenere
					and	b.nr_sequencia = nr_seq_segurado_w;
					
				exception
				when others then
					cd_cgc_cong_seg_w	:= null;
					nr_seq_cong_seg_w	:= null;
				end;

				begin
					select	sg_estado
					into STRICT	sg_estado_cong_seg_w
					from	pessoa_juridica
					where	cd_cgc = cd_cgc_cong_seg_w;
				exception
				when others then
					sg_estado_cong_seg_w := null;
				end;
				
				/*Obter tipo de intercambio entre operadora do estabelecimento e operadora executora do beneficiario*/

				ie_tipo_intercambio_w := pls_obter_tipo_intercambio(nr_seq_cong_seg_w,cd_estabelecimento_w);
			else
				/*Obter tipo de intercambio  entre operadora estabelecimento e operadora executora*/
				
				ie_tipo_intercambio_w := pls_obter_tipo_intercambio(nr_seq_uni_exec_w,cd_estabelecimento_w);				
			end if;
		else	
			ie_tipo_intercambio_w := 'A';
		end if;		

		/* Obter dados do plano */

		select	ie_tipo_contratacao
		into STRICT	ie_tipo_contratacao_w
		from	pls_plano
		where	nr_sequencia	= nr_seq_plano_w;

		/* Obter dados do prestador */

		begin
			select	nr_seq_classificacao
			into STRICT	nr_seq_classificacao_prest_w
			from	pls_prestador
			where	nr_sequencia = nr_seq_prestador_w;
		exception
		when others then
			nr_seq_classificacao_prest_w := null;
		end;		

		/* Obter a categoria do tipo de acomodacao */

		if (nr_seq_tipo_acomodacao_w IS NOT NULL AND nr_seq_tipo_acomodacao_w::text <> '') then
			select	max(nr_seq_categoria)
			into STRICT	nr_seq_categoria_w
			from	pls_regra_categoria
			where	nr_seq_tipo_acomodacao	= nr_seq_tipo_acomodacao_w;
		end if;

		/*Obter dados segurado*/

		begin
		select	coalesce(nr_seq_contrato,0),
			pls_obter_conv_cat_segurado(nr_sequencia, 1),
			pls_obter_conv_cat_segurado(nr_sequencia, 2)
		into STRICT	nr_seq_contrato_w,
			cd_convenio_w,
			cd_categoria_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_segurado_w;
		exception
			when others then
			nr_seq_plano_w	:= null;
			CALL pls_gravar_motivo_glosa('1013',nr_seq_guia_w, null,
						null,'',nm_usuario_p,
						'','CG',nr_seq_prestador_w, 
						null,null);
		end;

		if (nr_seq_requisicao_w IS NOT NULL AND nr_seq_requisicao_w::text <> '') then
			select	coalesce(max(ie_prestador_preco),'N')
			into STRICT	ie_prestador_preco_w
			from	pls_param_requisicao
			where	cd_estabelecimento = cd_estabelecimento_w;
			
			if (ie_prestador_preco_w = 'S') then
				select	coalesce(nr_seq_prestador_exec, nr_seq_prestador)
				into STRICT	nr_seq_prestador_w
				from	pls_requisicao
				where	nr_sequencia = nr_seq_requisicao_w;
			end if;
			
			/* Obter dados do prestador */

			begin
				select	nr_seq_classificacao
				into STRICT	nr_seq_classificacao_prest_w
				from	pls_prestador
				where	nr_sequencia = nr_seq_prestador_w;
			exception
			when others then
				nr_seq_classificacao_prest_w := null;
			end;
		end if;
		
		dados_regra_preco_proc_w := pls_define_preco_proc(	cd_estabelecimento_w, nr_seq_prestador_w, nr_seq_categoria_w, dt_solicitacao_w, null, cd_procedimento_w, ie_origem_proced_w, nr_seq_tipo_acomodacao_w, null, nr_seq_clinica_w, nr_seq_plano_w, 'A', nr_seq_contrato_w, 0, null, 'N', cd_convenio_w, cd_categoria_w, ie_tipo_contratacao_w, 0, nr_seq_segurado_w, null, null, nr_seq_classificacao_prest_w, cd_medico_solicitante_w, 'N', null, null, coalesce(ie_tipo_intercambio_w,'A'), 'X', null, ie_carater_internacao_w, dt_procedimento_w, null, null, null, dados_guia_w, null, dados_regra_preco_proc_w, null, null, ie_regime_atendimento_w, null, ie_saude_ocupacional_w);
					
		vl_procedimento_w		:= dados_regra_preco_proc_w.vl_procedimento;
		vl_custo_operacional_w		:= dados_regra_preco_proc_w.vl_custo_operacional;
		vl_anestesista_w		:= dados_regra_preco_proc_w.vl_anestesista;
		vl_medico_w			:= dados_regra_preco_proc_w.vl_medico;
		vl_filme_w			:= dados_regra_preco_proc_w.vl_filme;
		vl_auxiliares_w			:= dados_regra_preco_proc_w.vl_auxiliares;
		nr_seq_regra_w			:= dados_regra_preco_proc_w.nr_sequencia;
		cd_edicao_amb_w			:= dados_regra_preco_proc_w.cd_edicao_amb;
		ie_preco_informado_w		:= dados_regra_preco_proc_w.ie_valor_informado;
		cd_porte_anestesico_w		:= dados_regra_preco_proc_w.cd_porte_anestesico;
		nr_aux_regra_w			:= dados_regra_preco_proc_w.nr_auxiliares;
		nr_seq_regra_autogerado_w	:= dados_regra_preco_proc_w.nr_seq_regra_autogerado;
		cd_moeda_autogerado_w		:= dados_regra_preco_proc_w.cd_moeda_autogerado;
		vl_ch_honorarios_w		:= dados_regra_preco_proc_w.vl_ch_honorarios;
		vl_ch_custo_oper_w		:= dados_regra_preco_proc_w.vl_ch_custo_oper;
		vl_ch_custo_filme_w		:= dados_regra_preco_proc_w.vl_ch_custo_filme;
		vl_ch_anestesista_w		:= dados_regra_preco_proc_w.vl_ch_anestesista;
				
		update	ptu_pedido_compl_aut_serv
		set	vl_servico		= vl_procedimento_w
		where	nr_sequencia		= nr_seq_procedimento_p;
	end if;
elsif (ie_tipo_p	in ('A','AA')) then
	begin
	/*Obter dados dos procedimentos*/

	if (ie_tipo_p = 'A') then
		select	nr_seq_guia,
			cd_procedimento,
			ie_origem_proced,
			nr_seq_pacote
		into STRICT	nr_seq_guia_w,
			cd_procedimento_w,
			ie_origem_proced_w,
			nr_seq_pacote_w
		from	pls_guia_plano_proc
		where	nr_sequencia	= nr_seq_procedimento_p;
		
		
		open C01;
		loop
		fetch C01 into	
			nr_seq_proc_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			CALL pls_atualiza_valor_pacote(nr_seq_proc_w, 'G', nm_usuario_p, 'S', 'N');
			end;
		end loop;
		close C01;
		
	elsif (ie_tipo_p = 'AA') then
		select	a.nr_seq_guia,
			b.cd_procedimento,
			b.ie_origem_proced
		into STRICT	nr_seq_guia_w,
			cd_procedimento_w,
			ie_origem_proced_w
		from	pls_auditoria_item	b,
			pls_auditoria		a			
		where	b.nr_sequencia	= nr_seq_procedimento_p
		and	a.nr_sequencia	= b.nr_seq_auditoria;
				
		select	max(nr_sequencia)
		into STRICT	nr_seq_pacote_w
		from	pls_pacote
		where	cd_procedimento		= cd_procedimento_w
		and	ie_origem_proced	= ie_origem_proced_w
		and	ie_situacao		= 'A';
		
		/* Francisco - 16/05/2012 - OS 447352 */

		if (nr_seq_pacote_w IS NOT NULL AND nr_seq_pacote_w::text <> '') then
			select	coalesce(ie_regra_preco,'N')
			into STRICT	ie_regra_preco_w
			from	pls_pacote a
			where	a.nr_sequencia = nr_seq_pacote_w;
			
			if (ie_regra_preco_w = 'S') then
				SELECT * FROM pls_obter_regra_preco_pacote(cd_procedimento_w, ie_origem_proced_w, 'AA', nr_seq_procedimento_p, nm_usuario_p, nr_seq_pacote_w, nr_seq_regra_preco_pac_w) INTO STRICT nr_seq_pacote_w, nr_seq_regra_preco_pac_w;
			end if;
		end if;
	end if;	
	exception
	when others then
		nr_seq_guia_w := null;
	end;

	if (nr_seq_pacote_w IS NOT NULL AND nr_seq_pacote_w::text <> '') then
		if (ie_tipo_p	= 'A') then
			CALL pls_atualiza_valor_pacote(nr_seq_procedimento_p, 'G', nm_usuario_p, 'S', 'N');
		elsif (ie_tipo_p	= 'AA') then
			CALL pls_atualiza_valor_pacote(nr_seq_procedimento_p, 'AA', nm_usuario_p, 'S', 'N');
		end if;
	elsif (nr_seq_guia_w IS NOT NULL AND nr_seq_guia_w::text <> '') then
		/*Obter dados guia*/

		select	a.dt_solicitacao,
			a.nr_seq_segurado,
			a.cd_medico_solicitante,
			a.nr_seq_prestador,
			a.nr_seq_plano,
			a.nr_seq_tipo_acomodacao,
			a.nr_seq_clinica,
			a.cd_estabelecimento,
			a.ie_tipo_consulta,
			a.nr_seq_uni_exec,
			a.ie_tipo_processo,
			a.ie_regime_atendimento,
			a.ie_saude_ocupacional
		into STRICT	dt_solicitacao_w,
			nr_seq_segurado_w,
			cd_medico_solicitante_w,
			nr_seq_prestador_w,
			nr_seq_plano_w,
			nr_seq_tipo_acomodacao_w,
			nr_seq_clinica_w,
			cd_estabelecimento_w,
			dados_guia_w.ie_tipo_consulta_guia,
			nr_seq_uni_exec_w,
			ie_tipo_processo_w,
			ie_regime_atendimento_w,
			ie_saude_ocupacional_w
		from	pls_guia_plano a
		where	a.nr_sequencia = nr_seq_guia_w;

		/*Define o tipo de intercambio caso o tipo processo  = 'I'*/

		if (ie_tipo_processo_w = 'I') then
			/*Obter operadora do estabelecimento*/

			begin
				select	b.cd_cgc_outorgante
				into STRICT	cd_cgc_outorgante_w
				from	pls_outorgante	b
				where	b.cd_estabelecimento = cd_estabelecimento_w;
			exception
			when others then
				cd_cgc_outorgante_w	:= null;
			end;
			/*Obter estado do estabelecimento*/

			begin
				select	a.sg_estado
				into STRICT	sg_estado_outorgante_w	
				from	pessoa_juridica	a
				where	a.cd_cgc = cd_cgc_outorgante_w;
			exception
			when others then
				sg_estado_outorgante_w	:= null;
			end;
			/*Obter operadora executora*/

			begin
				select	cd_cgc
				into STRICT	cd_cgc_congenere_w
				from	pls_congenere
				where	nr_sequencia = nr_seq_uni_exec_w;
			exception
			when others then
				cd_cgc_congenere_w	:= null;
			end;
			/*Obter estado da operadora executora*/

			begin
				select	sg_estado
				into STRICT	sg_estado_congenere_w
				from	pessoa_juridica
				where	cd_cgc = cd_cgc_congenere_w;
			exception
			when others then
				sg_estado_congenere_w	:= null;
			end;
			
			/*Comparando operadora estabelecimento com operadora executora*/

			if (cd_cgc_outorgante_w = cd_cgc_congenere_w) or (coalesce(cd_cgc_congenere_w::text, '') = '') then
				/*Obter operadora/sequencia/estado congenere do beneficiario*/

				begin
					select 	a.cd_cgc,
						a.nr_sequencia
					into STRICT	cd_cgc_cong_seg_w,
						nr_seq_cong_seg_w
					from	pls_congenere	a,
						pls_segurado	b
					where	a.nr_sequencia = b.nr_seq_congenere
					and	b.nr_sequencia = nr_seq_segurado_w;
					
				exception
				when others then
					cd_cgc_cong_seg_w	:= null;
					nr_seq_cong_seg_w	:= null;
				end;

				begin
					select	sg_estado
					into STRICT	sg_estado_cong_seg_w
					from	pessoa_juridica
					where	cd_cgc = cd_cgc_cong_seg_w;
				exception
				when others then
					sg_estado_cong_seg_w := null;
				end;
				
				/*Obter tipo de intercambio entre operadora do estabelecimento e operadora executora do beneficiario*/

				ie_tipo_intercambio_w := pls_obter_tipo_intercambio(nr_seq_cong_seg_w,cd_estabelecimento_w);
			else
				/*Obter tipo de intercambio  entre operadora estabelecimento e operadora executora*/
				
				ie_tipo_intercambio_w := pls_obter_tipo_intercambio(nr_seq_uni_exec_w,cd_estabelecimento_w);
			end if;
		else	
			ie_tipo_intercambio_w := 'A';
		end if;	
		
		/* Obter dados do plano */
 /*Diether 28/02/2011 estava indicando no data found*/

		select	max(ie_tipo_contratacao)
		into STRICT	ie_tipo_contratacao_w
		from	pls_plano
		where	nr_sequencia	= nr_seq_plano_w;

		/* Obter dados do prestador */

		begin
		select	nr_seq_classificacao
		into STRICT	nr_seq_classificacao_prest_w
		from	pls_prestador
		where	nr_sequencia = nr_seq_prestador_w;
		exception
		when others then
			nr_seq_classificacao_prest_w := null;
		end;

		/* Obter a categoria do tipo de acomodacao */

		if (nr_seq_tipo_acomodacao_w IS NOT NULL AND nr_seq_tipo_acomodacao_w::text <> '') then
			select	max(nr_seq_categoria)
			into STRICT	nr_seq_categoria_w
			from	pls_regra_categoria
			where	nr_seq_tipo_acomodacao	= nr_seq_tipo_acomodacao_w;
		end if;

		/*Obter dados segurado*/

		begin
		select	coalesce(nr_seq_contrato,0),
			pls_obter_conv_cat_segurado(nr_sequencia, 1),
			pls_obter_conv_cat_segurado(nr_sequencia, 2)
		into STRICT	nr_seq_contrato_w,
			cd_convenio_w,
			cd_categoria_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_segurado_w;
		exception
			when others then
			nr_seq_plano_w	:= null;
			CALL pls_gravar_motivo_glosa('1013',nr_seq_guia_w, null,
						null,'',nm_usuario_p,
						'','CG',nr_seq_prestador_w, 
						null,null);
		end;
		
		dados_regra_preco_proc_w := pls_define_preco_proc(	cd_estabelecimento_w, nr_seq_prestador_w, nr_seq_categoria_w, dt_solicitacao_w, null, cd_procedimento_w, ie_origem_proced_w, nr_seq_tipo_acomodacao_w, null, nr_seq_clinica_w, nr_seq_plano_w, 'A', nr_seq_contrato_w, 0, null, 'N', cd_convenio_w, cd_categoria_w, ie_tipo_contratacao_w, 0, nr_seq_segurado_w, null, null, nr_seq_classificacao_prest_w, cd_medico_solicitante_w, 'N', null, null, coalesce(ie_tipo_intercambio_w,'A'), 'X', null, ie_carater_internacao_w, dt_procedimento_w, null, null, null, dados_guia_w, null, dados_regra_preco_proc_w, null, null, ie_regime_atendimento_w, null, ie_saude_ocupacional_w);
					
		vl_procedimento_w		:= dados_regra_preco_proc_w.vl_procedimento;
		vl_custo_operacional_w		:= dados_regra_preco_proc_w.vl_custo_operacional;
		vl_anestesista_w		:= dados_regra_preco_proc_w.vl_anestesista;
		vl_medico_w			:= dados_regra_preco_proc_w.vl_medico;
		vl_filme_w			:= dados_regra_preco_proc_w.vl_filme;
		vl_auxiliares_w			:= dados_regra_preco_proc_w.vl_auxiliares;
		nr_seq_regra_w			:= dados_regra_preco_proc_w.nr_sequencia;
		cd_edicao_amb_w			:= dados_regra_preco_proc_w.cd_edicao_amb;
		ie_preco_informado_w		:= dados_regra_preco_proc_w.ie_valor_informado;
		cd_porte_anestesico_w		:= dados_regra_preco_proc_w.cd_porte_anestesico;
		nr_aux_regra_w			:= dados_regra_preco_proc_w.nr_auxiliares;
		nr_seq_regra_autogerado_w	:= dados_regra_preco_proc_w.nr_seq_regra_autogerado;
		cd_moeda_autogerado_w		:= dados_regra_preco_proc_w.cd_moeda_autogerado;
		vl_ch_honorarios_w		:= dados_regra_preco_proc_w.vl_ch_honorarios;
		vl_ch_custo_oper_w		:= dados_regra_preco_proc_w.vl_ch_custo_oper;
		vl_ch_custo_filme_w		:= dados_regra_preco_proc_w.vl_ch_custo_filme;
		vl_ch_anestesista_w		:= dados_regra_preco_proc_w.vl_ch_anestesista;
		
		if (ie_tipo_p = 'A') then
			update	pls_guia_plano_proc
			set	vl_procedimento		= vl_procedimento_w,
				vl_custo_operacional	= vl_custo_operacional_w,
				vl_anestesista		= vl_anestesista_w,
				vl_medico		= vl_medico_w,
				vl_auxiliares		= vl_auxiliares_w,
				vl_materiais		= vl_filme_w,
				nr_seq_regra		= nr_seq_regra_w,
				cd_porte_anestesico	= cd_porte_anestesico_w
			where	nr_sequencia		= nr_seq_procedimento_p;
		elsif (ie_tipo_p = 'AA') then
			update	pls_auditoria_item
			set	vl_item		= vl_procedimento_w
			where	nr_sequencia	= nr_seq_procedimento_p;
		end if;
	end if;
elsif (ie_tipo_p	= 'R') then
	/*Obter dados da requisicao e do procedimento*/

	begin
		select	a.nr_sequencia,
			a.nr_seq_prestador,
			a.ie_tipo_guia,
			a.cd_estabelecimento,
			a.dt_requisicao,
			a.nr_seq_segurado,
			a.cd_medico_solicitante,
			a.nr_seq_plano,
			a.nr_seq_tipo_acomodacao,
			a.nr_seq_clinica,
			b.cd_procedimento,
			b.ie_origem_proced,
			b.nr_seq_pacote,
			b.nr_seq_preco_pacote,
			a.ie_tipo_consulta,
			a.nr_seq_uni_exec,
			a.ie_tipo_processo,
			a.ie_regime_atendimento,
			a.ie_saude_ocupacional
		into STRICT	nr_seq_requisicao_w,
			nr_seq_prestador_w,
			ie_tipo_guia_w,
			cd_estabelecimento_w,
			dt_solicitacao_w,
			nr_seq_segurado_w,
			cd_medico_solicitante_w,
			nr_seq_plano_w,
			nr_seq_tipo_acomodacao_w,
			nr_seq_clinica_w,
			cd_procedimento_w,
			ie_origem_proced_w,
			nr_seq_pacote_w,
			nr_seq_preco_pacote_w,
			dados_guia_w.ie_tipo_consulta_req,
			nr_seq_uni_exec_w,
			ie_tipo_processo_w,
			ie_regime_atendimento_w,
			ie_saude_ocupacional_w
		from	pls_requisicao_proc	b,
			pls_requisicao		a
		where	a.nr_sequencia = b.nr_seq_requisicao
		and	b.nr_sequencia = nr_seq_procedimento_p;
	exception
	when others then
		nr_seq_requisicao_w		:= 0;
		nr_seq_prestador_w		:= 0;
		ie_tipo_guia_w			:= 'X';
		cd_estabelecimento_w		:= 0;	
		dt_solicitacao_w		:= null;
		nr_seq_segurado_w		:= 0;
		cd_medico_solicitante_w		:= 0;
		nr_seq_plano_w			:= 0;
		nr_seq_tipo_acomodacao_w	:= 0;
		nr_seq_clinica_w		:= 0;
		cd_procedimento_w		:= 0;
		ie_origem_proced_w		:= 0;
		nr_seq_pacote_w			:= 0;
		nr_seq_preco_pacote_w		:= 0;
	end;

	CALL pls_gerar_conversao_pacote(null,nr_seq_procedimento_p,'P','R', nm_usuario_p, cd_estabelecimento_w);
	
	open C02;
	loop
	fetch C02 into	
		nr_seq_proc_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		CALL pls_atualiza_valor_pacote(nr_seq_proc_w, 'R', nm_usuario_p,'S', 'N');
		end;
	end loop;
	close C02;
	
	if (coalesce(nr_seq_pacote_w,0)	<> 0) then		
		CALL pls_atualiza_valor_pacote(nr_seq_procedimento_p, 'R', nm_usuario_p, 'S', 'N');
		CALL pls_abrir_proc_pacote(nr_seq_preco_pacote_w, null, null, nr_seq_requisicao_w, 'R', nr_seq_prestador_w, ie_tipo_guia_w, dt_solicitacao_w, nm_usuario_p);
		
		begin
			select	ie_excluir_proc_pacote
			into STRICT	ie_excluir_proc_pacote_w
			from	pls_pacote_tipo_acomodacao
			where	nr_sequencia	= nr_seq_preco_pacote_w;
		exception
		when others then
			ie_excluir_proc_pacote_w	:= 'N';
		end;

		select	cd_pacote_item,
			ie_origem_pacote_item
		into STRICT	cd_pacote_item_w,
			ie_origem_pacote_item_w
		from	pls_requisicao_proc
		where	nr_sequencia	= nr_seq_procedimento_p;
		
		select	count(1)
		into STRICT	qt_reg_convertidos_w
		from	pls_requisicao_proc
		where	nr_seq_requisicao	= nr_seq_requisicao_w
		and	(cd_pacote_item IS NOT NULL AND cd_pacote_item::text <> '')
		and	cd_pacote_item		= cd_pacote_item_w
		and	ie_origem_pacote_item	= ie_origem_pacote_item_w;
		
		
		if (coalesce(ie_excluir_proc_pacote_w,'N')	= 'S') and (qt_reg_convertidos_w	> 0) then
			delete from pls_requisicao_proc	where nr_sequencia = nr_seq_procedimento_p;
		end if;
	else
		/* Obter dados do plano */
 /*Diether 28/02/2011 estava indicando no data found*/

		select	max(ie_tipo_contratacao)
		into STRICT	ie_tipo_contratacao_w
		from	pls_plano
		where	nr_sequencia	= nr_seq_plano_w;

		select	coalesce(max(ie_prestador_preco),'N')
		into STRICT	ie_prestador_preco_w
		from	pls_param_requisicao
		where	cd_estabelecimento = cd_estabelecimento_w;
		
		if (ie_prestador_preco_w = 'S') then
			select	coalesce(nr_seq_prestador_exec, nr_seq_prestador)
			into STRICT	nr_seq_prestador_w
			from	pls_requisicao
			where	nr_sequencia = nr_seq_requisicao_w;
		end if;
		
		/* Obter dados do prestador */

		begin
			select	nr_seq_classificacao
			into STRICT	nr_seq_classificacao_prest_w
			from	pls_prestador
			where	nr_sequencia = nr_seq_prestador_w;
		exception
		when others then
			nr_seq_classificacao_prest_w := null;
		end;

		/* Obter a categoria do tipo de acomodacao */

		if (coalesce(nr_seq_tipo_acomodacao_w,0)	<> 0) then
			select	max(nr_seq_categoria)
			into STRICT	nr_seq_categoria_w
			from	pls_regra_categoria
			where	nr_seq_tipo_acomodacao	= nr_seq_tipo_acomodacao_w;
		end if;

		/*Obter dados segurado*/

		begin
			select	coalesce(nr_seq_contrato,0),
				pls_obter_conv_cat_segurado(nr_sequencia, 1),
				pls_obter_conv_cat_segurado(nr_sequencia, 2)
			into STRICT	nr_seq_contrato_w,
				cd_convenio_w,
				cd_categoria_w
			from	pls_segurado
			where	nr_sequencia	= nr_seq_segurado_w;
		exception
			when others then
			nr_seq_plano_w	:= null;
			
			if (coalesce(nr_seq_requisicao_w,0)	<> 0) then
				CALL pls_gravar_requisicao_glosa(	'1013', nr_seq_requisicao_w, null,
								null, '', nm_usuario_p,
								nr_seq_prestador_w, cd_estabelecimento_w, null,
								null);
			end if;
		end;

		/*Define o tipo de intercambio caso o tipo processo  = 'I'*/

		if (ie_tipo_processo_w = 'I') then
			/*Obter operadora do estabelecimento*/

			begin
				select	b.cd_cgc_outorgante
				into STRICT	cd_cgc_outorgante_w
				from	pls_outorgante	b
				where	b.cd_estabelecimento = cd_estabelecimento_w;
			exception
			when others then
				cd_cgc_outorgante_w	:= null;
			end;
			/*Obter estado do estabelecimento*/

			begin
				select	a.sg_estado
				into STRICT	sg_estado_outorgante_w	
				from	pessoa_juridica	a
				where	a.cd_cgc = cd_cgc_outorgante_w;
			exception
			when others then
				sg_estado_outorgante_w	:= null;
			end;
			/*Obter operadora executora*/

			begin
				select	cd_cgc
				into STRICT	cd_cgc_congenere_w
				from	pls_congenere
				where	nr_sequencia = nr_seq_uni_exec_w;
			exception
			when others then
				cd_cgc_congenere_w	:= null;
			end;
			/*Obter estado da operadora executora*/

			begin
				select	sg_estado
				into STRICT	sg_estado_congenere_w
				from	pessoa_juridica
				where	cd_cgc = cd_cgc_congenere_w;
			exception
			when others then
				sg_estado_congenere_w	:= null;
			end;
			
			/*Comparando operadora estabelecimento com operadora executora*/

			if (cd_cgc_outorgante_w = cd_cgc_congenere_w) or (coalesce(cd_cgc_congenere_w::text, '') = '') then
				/*Obter operadora/sequencia/estado congenere do beneficiario*/

				begin
					select 	a.cd_cgc,
						a.nr_sequencia
					into STRICT	cd_cgc_cong_seg_w,
						nr_seq_cong_seg_w
					from	pls_congenere	a,
						pls_segurado	b
					where	a.nr_sequencia = b.nr_seq_congenere
					and	b.nr_sequencia = nr_seq_segurado_w;
					
				exception
				when others then
					cd_cgc_cong_seg_w	:= null;
					nr_seq_cong_seg_w	:= null;
				end;

				begin
					select	sg_estado
					into STRICT	sg_estado_cong_seg_w
					from	pessoa_juridica
					where	cd_cgc = cd_cgc_cong_seg_w;
				exception
				when others then
					sg_estado_cong_seg_w := null;
				end;
				
				/*Obter tipo de intercambio entre operadora do estabelecimento e operadora executora do beneficiario*/

				ie_tipo_intercambio_w := pls_obter_tipo_intercambio(nr_seq_cong_seg_w,cd_estabelecimento_w);
			else
				/*Obter tipo de intercambio  entre operadora estabelecimento e operadora executora*/
				
				ie_tipo_intercambio_w := pls_obter_tipo_intercambio(nr_seq_uni_exec_w,cd_estabelecimento_w);
			end if;
		else	
			ie_tipo_intercambio_w := 'A';
		end if;	
		
		dados_regra_preco_proc_w := pls_define_preco_proc(	cd_estabelecimento_w, nr_seq_prestador_w, nr_seq_categoria_w, dt_solicitacao_w, null, cd_procedimento_w, ie_origem_proced_w, nr_seq_tipo_acomodacao_w, null, nr_seq_clinica_w, nr_seq_plano_w, 'A', nr_seq_contrato_w, 0, null, 'N', cd_convenio_w, cd_categoria_w, ie_tipo_contratacao_w, 0, nr_seq_segurado_w, null, null, nr_seq_classificacao_prest_w, cd_medico_solicitante_w, 'N', null, null, coalesce(ie_tipo_intercambio_w,'A'), 'X', null, ie_carater_internacao_w, dt_procedimento_w, null, null, null, dados_guia_w, null, dados_regra_preco_proc_w, null, null, ie_regime_atendimento_w, null, ie_saude_ocupacional_w);
					
		vl_procedimento_w		:= dados_regra_preco_proc_w.vl_procedimento;
		vl_custo_operacional_w		:= dados_regra_preco_proc_w.vl_custo_operacional;
		vl_anestesista_w		:= dados_regra_preco_proc_w.vl_anestesista;
		vl_medico_w			:= dados_regra_preco_proc_w.vl_medico;
		vl_filme_w			:= dados_regra_preco_proc_w.vl_filme;
		vl_auxiliares_w			:= dados_regra_preco_proc_w.vl_auxiliares;
		nr_seq_regra_w			:= dados_regra_preco_proc_w.nr_sequencia;
		cd_edicao_amb_w			:= dados_regra_preco_proc_w.cd_edicao_amb;
		ie_preco_informado_w		:= dados_regra_preco_proc_w.ie_valor_informado;
		cd_porte_anestesico_w		:= dados_regra_preco_proc_w.cd_porte_anestesico;
		nr_aux_regra_w			:= dados_regra_preco_proc_w.nr_auxiliares;
		nr_seq_regra_autogerado_w	:= dados_regra_preco_proc_w.nr_seq_regra_autogerado;
		cd_moeda_autogerado_w		:= dados_regra_preco_proc_w.cd_moeda_autogerado;
		vl_ch_honorarios_w		:= dados_regra_preco_proc_w.vl_ch_honorarios;
		vl_ch_custo_oper_w		:= dados_regra_preco_proc_w.vl_ch_custo_oper;
		vl_ch_custo_filme_w		:= dados_regra_preco_proc_w.vl_ch_custo_filme;
		vl_ch_anestesista_w		:= dados_regra_preco_proc_w.vl_ch_anestesista;
		
		update	pls_requisicao_proc
		set	vl_procedimento		= vl_procedimento_w,
			nr_seq_regra		= nr_seq_regra_w,
			cd_porte_anestesico	= cd_porte_anestesico_w
		where	nr_sequencia		= nr_seq_procedimento_p;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualiza_valor_proc_aut ( nr_seq_procedimento_p bigint, ie_tipo_p text, nm_usuario_p text) FROM PUBLIC;
