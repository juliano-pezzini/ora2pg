-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_transferir_titular ( nr_seq_titular_p bigint, nr_seq_titular_novo_p bigint, ie_tipo_alteracao_p text, dt_geracao_sib_p timestamp, ie_rescindir_titular_p text, dt_rescisao_titular_p timestamp, dt_limite_util_titular_p timestamp, nr_seq_motivo_cancel_titular_p bigint, nr_cert_obito_titular_p text, dt_obito_titular_p timestamp, ds_obs_resc_titular_p text, cd_estabelecimento_p bigint, nr_seq_regra_obito_p bigint, ie_gerar_novo_pagador_p text, qt_anos_validade_p bigint, nr_seq_motivo_alt_pag_p bigint, ie_tipo_rescisao_p text default null, nm_usuario_p text DEFAULT NULL, ie_commit_p text DEFAULT NULL) AS $body$
DECLARE


/*	ie_tipo_alteracao_p
	D - Alterar titularidade dos dependetes para o novo titular
	T - Identifica cada dependente como titular
*/
nr_seq_dependente_w		bigint;
ie_tipo_alteracao_w		varchar(1);
nm_titular_ant_w		varchar(255);
nm_titular_novo_w		varchar(255);
nr_seq_titular_ant_w		bigint;
nr_seq_pagador_w		bigint;
nr_seq_pagador_novo_w		bigint;
cd_pessoa_pagador_w		varchar(10);
nr_seq_contrato_w		bigint;
ds_erro_w			varchar(255)	:= '';
ie_consistir_sib_w		varchar(1);
ie_dt_adesao_w			varchar(10);
dt_contratacao_titular_w	timestamp;
ie_alterar_cart_benef_w		varchar(10);
ie_contrato_pj_w		varchar(10);
dt_contratacao_w		timestamp;
ie_alterar_matricula_benef_w	varchar(10);
ie_titular_pf_w			varchar(10);
ie_geracao_valores_w		pls_contrato.ie_geracao_valores%type;
ie_permite_tab_dif_w		varchar(10);
ie_consiste_tab_contr_w		varchar(10);
nr_seq_parentesco_tit_w		bigint;
nr_seq_pagador_ant_w		pls_segurado.nr_seq_pagador%type;
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
nr_seq_pagador_tit_ant_w	pls_segurado.nr_seq_pagador%type;
dt_rescisao_w			pls_segurado.dt_rescisao%type;
nr_seq_contrato_ww		pls_contrato.nr_sequencia%type;
nr_seq_parentesco_w		pls_segurado.nr_seq_parentesco%type;
ie_tipo_parentesco_w		pls_segurado.ie_tipo_parentesco%type;

c01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_pagador,
		cd_pessoa_fisica,
		nr_seq_contrato,
		dt_rescisao,
		nr_seq_parentesco
	from	pls_segurado
	where	((nr_sequencia	= nr_seq_titular_p)
	or	 ((nr_seq_titular = nr_seq_titular_p) and (coalesce(dt_rescisao::text, '') = '' or dt_rescisao >= dt_geracao_sib_p or nr_sequencia = nr_seq_titular_novo_p))) --Nao deve realizar alteracoes em beneficiarios rescindidos, pois ocorre problemas no SIB
	order by CASE WHEN nr_seq_titular_novo_p=nr_sequencia THEN -1  ELSE 1 END;

C02 CURSOR FOR
	SELECT	nr_sequencia nr_seq_segurado,
		nr_seq_pagador,
		dt_rescisao
	from	pls_segurado
	where	nr_seq_titular	= nr_seq_titular_p
	and	nr_sequencia	<> nr_seq_titular_p
	and	nr_sequencia	<> nr_seq_titular_novo_p;

TYPE 		fetch_array IS TABLE OF c02%ROWTYPE;
s_array 	fetch_array;
i		integer := 1;
type Vetor is table of fetch_array index by integer;
Vetor_c02_w			Vetor;

BEGIN
ie_tipo_alteracao_w		:= coalesce(ie_tipo_alteracao_p,'X');
ie_alterar_cart_benef_w		:= coalesce(obter_valor_param_usuario(1202, 119, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p),'N');
ie_titular_pf_w			:= coalesce(obter_valor_param_usuario(1202, 48, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p), 'N');
ie_permite_tab_dif_w		:= obter_valor_param_usuario(1202,9,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p);
ie_consiste_tab_contr_w		:= obter_valor_param_usuario(1202,10,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p);

select	max(nr_seq_parentesco),
	max(nr_seq_pagador)
into STRICT	nr_seq_parentesco_tit_w,
	nr_seq_pagador_tit_ant_w
from	pls_segurado
where	nr_sequencia	= nr_seq_titular_novo_p;

if (nr_seq_titular_p IS NOT NULL AND nr_seq_titular_p::text <> '') then
	open c01;
	loop
	fetch c01 into
		nr_seq_dependente_w,
		nr_seq_pagador_w,
		cd_pessoa_pagador_w,
		nr_seq_contrato_w,
		dt_rescisao_w,
		nr_seq_parentesco_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		nr_seq_pagador_novo_w	:= null;
		
		select	CASE WHEN coalesce(cd_cgc_estipulante::text, '') = '' THEN 'PF'  ELSE 'PJ' END ,
			ie_geracao_valores
		into STRICT	ie_contrato_pj_w,
			ie_geracao_valores_w
		from	pls_contrato
		where	nr_sequencia	= nr_seq_contrato_w;
		
		--Deve apenas alterar a matricula, quando permitir mais de 1 titular no contrato PF, para contratos PJ pode ser alterado
		if (ie_titular_pf_w = 'S') and (ie_contrato_pj_w = 'PF') then
			ie_alterar_matricula_benef_w	:= 'N';
		else
			if (ie_tipo_alteracao_p = 'D') then --Se for alterar somente o titular da familia, nao deve gerar uma nova matricula
				ie_alterar_matricula_benef_w	:= 'N';
			else
				ie_alterar_matricula_benef_w	:= 'S';
			end if;
		end if;
		
		if (ie_tipo_alteracao_w <> 'X') then
			CALL pls_consiste_data_sib(dt_geracao_sib_p, nm_usuario_p, cd_estabelecimento_p);
			
			select	substr(pls_obter_dados_segurado(nr_seq_titular_p,'N'),1,255)
			into STRICT	nm_titular_ant_w
			;
			
			select	substr(pls_obter_dados_segurado(nr_seq_titular_novo_p,'N'),1,255)
			into STRICT	nm_titular_novo_w
			;
			
			if (ie_tipo_alteracao_p = 'D') then
				select	cd_pessoa_fisica,
					nr_seq_pagador
				into STRICT	cd_pessoa_pagador_w,
					nr_seq_pagador_w
				from	pls_segurado
				where	nr_sequencia	= nr_seq_titular_novo_p;
				
				--Cria um novo pagador para todos os beneficiarios
				if (ie_gerar_novo_pagador_p = 'S') then
					select	max(nr_sequencia)
					into STRICT	nr_seq_pagador_novo_w
					from	pls_contrato_pagador
					where	nr_seq_contrato	= nr_seq_contrato_w
					and	cd_pessoa_fisica	= cd_pessoa_pagador_w;
					
					if (coalesce(nr_seq_pagador_novo_w::text, '') = '') then
						select	nextval('pls_contrato_pagador_seq')
						into STRICT	nr_seq_pagador_novo_w
						;
						
						insert into pls_contrato_pagador(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec, nm_usuario_nrec,
								nr_seq_contrato,cd_pessoa_fisica,ie_tipo_pagador,ie_envia_cobranca,
								ie_endereco_boleto,ie_pessoa_comprovante,ie_notificacao,ie_taxa_emissao_boleto,
								ie_calc_primeira_mens,ie_calculo_proporcional,ie_inadimplencia_via_adic,nr_seq_regra_obito,
								nr_seq_classif_itens, ie_receber_sms)
							(SELECT	nr_seq_pagador_novo_w,clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
								nr_seq_contrato,cd_pessoa_pagador_w,'S','N',
								ie_endereco_boleto,ie_pessoa_comprovante,ie_notificacao,ie_taxa_emissao_boleto,
								ie_calc_primeira_mens,ie_calculo_proporcional,ie_inadimplencia_via_adic,nr_seq_regra_obito_p,
								nr_seq_classif_itens, 'S'
							from	pls_contrato_pagador
							where	nr_sequencia	= nr_seq_pagador_w);
						
						insert into pls_contrato_pagador_fin(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
								nr_seq_pagador,dt_inicio_vigencia,dt_dia_vencimento,dt_fim_vigencia,nr_seq_forma_cobranca,
								cd_condicao_pagamento,cd_tipo_portador,cd_portador,nr_seq_conta_banco,cd_banco,
								cd_agencia_bancaria,ie_digito_agencia,cd_conta,ie_digito_conta,nr_seq_empresa,
								cd_profissao,nr_seq_vinculo_empresa,cd_matricula,nr_seq_carteira_cobr,nr_seq_dia_vencimento,
								ie_geracao_nota_titulo,ie_destacar_reajuste,ie_gerar_cobr_escrit)
							
							(SELECT	nextval('pls_contrato_pagador_fin_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
								nr_seq_pagador_novo_w,trunc(dt_rescisao_titular_p,'Month'),dt_dia_vencimento,dt_fim_vigencia,nr_seq_forma_cobranca,
								cd_condicao_pagamento,cd_tipo_portador,cd_portador,nr_seq_conta_banco,cd_banco,
								cd_agencia_bancaria,ie_digito_agencia,cd_conta,ie_digito_conta,nr_seq_empresa,
								cd_profissao,nr_seq_vinculo_empresa,cd_matricula,nr_seq_carteira_cobr,nr_seq_dia_vencimento,
								ie_geracao_nota_titulo,'N','S'
							from	pls_contrato_pagador_fin
							where	nr_seq_pagador	= nr_seq_pagador_w);
					end if;
				end if;
				
				if (coalesce(ie_rescindir_titular_p,'N') = 'N') then
					select	max(nr_seq_pagador)
					into STRICT	nr_seq_pagador_ant_w
					from 	pls_segurado
					where	nr_sequencia = nr_seq_dependente_w;
					
					select	CASE WHEN coalesce(nr_seq_parentesco_w::text, '') = '' THEN  nr_seq_parentesco_tit_w  ELSE nr_seq_parentesco_w END
					into STRICT	nr_seq_parentesco_w
					;
					
					if (nr_seq_parentesco_w IS NOT NULL AND nr_seq_parentesco_w::text <> '') then
						select	max(ie_tipo_parentesco)
						into STRICT	ie_tipo_parentesco_w
						from	grau_parentesco
						where	nr_sequencia	= nr_seq_parentesco_w;
					end if;
					
					update	pls_segurado
					set	nr_seq_titular		= nr_seq_titular_novo_p,
						nm_usuario		= nm_usuario_p,
						dt_atualizacao		= clock_timestamp(),
						--nr_seq_pagador		= decode(nr_seq_pagador_novo_w,null,nr_seq_pagador,nr_seq_pagador_novo_w),
						cd_matricula_familia	= CASE WHEN ie_alterar_matricula_benef_w='S' THEN null  ELSE cd_matricula_familia END ,
						nr_seq_parentesco	= nr_seq_parentesco_w,
						ie_tipo_parentesco	= CASE WHEN nr_seq_parentesco_w = NULL THEN  null  ELSE ie_tipo_parentesco_w END
					where	nr_sequencia		= nr_seq_dependente_w
					and	nr_sequencia		<> nr_seq_titular_novo_p;
					--and	nr_sequencia		<> nr_seq_titular_p;
					
					if (nr_seq_dependente_w <> nr_seq_titular_novo_p) and (nr_seq_dependente_w <> nr_seq_titular_p) and (nr_seq_pagador_novo_w IS NOT NULL AND nr_seq_pagador_novo_w::text <> '') and (nr_seq_pagador_ant_w IS NOT NULL AND nr_seq_pagador_ant_w::text <> '') then
						ds_erro_w := pls_alterar_pagador_benef(nr_seq_contrato_w, nr_seq_dependente_w, nr_seq_pagador_novo_w, 'B', cd_estabelecimento_p, nm_usuario_p, clock_timestamp(), nr_seq_motivo_alt_pag_p, null, 'N', null, 'N', 'N', ds_erro_w);
						--pls_alterar_pagador_segurado(nr_seq_dependente_w,nr_seq_pagador_ant_w,nr_seq_pagador_novo_w,sysdate,'N',nm_usuario_p);
					end if;
				else
					if (c01%rowcount = 1) then
						open c02;
						loop
						fetch C02 bulk collect into s_array limit 1000;
							Vetor_c02_w(i) := s_array;
							i := i + 1;
						EXIT WHEN NOT FOUND; /* apply on C02 */
						end loop;
						close C02;
						
						update	pls_segurado
						set	nr_seq_titular		= nr_seq_titular_novo_p,
							nm_usuario		= nm_usuario_p,
							dt_atualizacao		= clock_timestamp(),
							--nr_seq_pagador		= decode(nr_seq_pagador_novo_w,null,nr_seq_pagador,nr_seq_pagador_novo_w),
							cd_matricula_familia	= CASE WHEN ie_alterar_matricula_benef_w='S' THEN null  ELSE cd_matricula_familia END ,
							nr_seq_parentesco	= CASE WHEN nr_seq_parentesco = NULL THEN nr_seq_parentesco_tit_w  ELSE nr_seq_parentesco END
						where	nr_seq_titular	= nr_seq_titular_p
						and	nr_sequencia	<> nr_seq_titular_p
						and	nr_sequencia	<> nr_seq_titular_novo_p
						and (coalesce(dt_rescisao::text, '') = '' or dt_rescisao >= dt_geracao_sib_p);
						
						for i in 1..Vetor_c02_w.count loop
							s_array := Vetor_c02_w(i);
							for z in 1..s_array.count loop
							begin
							if ((nr_seq_pagador_novo_w IS NOT NULL AND nr_seq_pagador_novo_w::text <> '') and s_array[z](.nr_seq_pagador IS NOT NULL AND .nr_seq_pagador::text <> '')) then
								ds_erro_w := pls_alterar_pagador_benef(nr_seq_contrato_w, s_array[z].nr_seq_segurado, nr_seq_pagador_novo_w, 'B', cd_estabelecimento_p, nm_usuario_p, clock_timestamp(), nr_seq_motivo_alt_pag_p, null, 'N', null, 'N', 'N', ds_erro_w);
								--pls_alterar_pagador_segurado(s_array(z).nr_seq_segurado,s_array(z).nr_seq_pagador,nr_seq_pagador_novo_w,sysdate,'N',nm_usuario_p);
							end if;
							end;
							end loop;
						end loop;
					end if;
				end if;
				
				if (nr_seq_titular_novo_p = nr_seq_dependente_w) then
					update	pls_segurado
					set	nr_seq_titular		 = NULL,
						nr_seq_parentesco	 = NULL,
						ie_tipo_parentesco	= '',
						nm_usuario		= nm_usuario_p,
						dt_atualizacao		= clock_timestamp(),
						--nr_seq_pagador		= decode(nr_seq_pagador_novo_w,null,nr_seq_pagador,nr_seq_pagador_novo_w),
						cd_matricula_familia	= CASE WHEN ie_alterar_matricula_benef_w='S' THEN null  ELSE cd_matricula_familia END
					where	nr_sequencia		= nr_seq_titular_novo_p;
					
					--Caso o dependente esteja rescindido, entao deve ser reativado
					if (dt_rescisao_w IS NOT NULL AND dt_rescisao_w::text <> '') then
						CALL pls_reativar_segurado(	nr_seq_dependente_w,dt_geracao_sib_p,wheb_mensagem_pck.get_texto(1159070)||'.',
									'S', nm_usuario_p);
					end if;
					if (nr_seq_pagador_novo_w IS NOT NULL AND nr_seq_pagador_novo_w::text <> '') then
						ds_erro_w := pls_alterar_pagador_benef(nr_seq_contrato_w, nr_seq_dependente_w, nr_seq_pagador_novo_w, 'B', cd_estabelecimento_p, nm_usuario_p, clock_timestamp(), nr_seq_motivo_alt_pag_p, null, 'N', null, 'N', 'N', ds_erro_w);
						--pls_alterar_pagador_segurado(nr_seq_titular_novo_p,nr_seq_pagador_tit_ant_w,nr_seq_pagador_novo_w,sysdate,'N',nm_usuario_p);
					end if;
				elsif (nr_seq_titular_p = nr_seq_dependente_w) and (nr_seq_pagador_novo_w IS NOT NULL AND nr_seq_pagador_novo_w::text <> '') then
					ds_erro_w := pls_alterar_pagador_benef(nr_seq_contrato_w, nr_seq_dependente_w, nr_seq_pagador_novo_w, 'B', cd_estabelecimento_p, nm_usuario_p, clock_timestamp(), nr_seq_motivo_alt_pag_p, null, 'N', null, 'N', 'N', ds_erro_w);
				end if;
			elsif (ie_tipo_alteracao_p = 'T') then
				--Cria um novo pagador para todos os beneficiarios
				if (ie_gerar_novo_pagador_p = 'S') then
					select	max(nr_sequencia)
					into STRICT	nr_seq_pagador_novo_w
					from	pls_contrato_pagador
					where	nr_seq_contrato	= nr_seq_contrato_w
					and	cd_pessoa_fisica	= cd_pessoa_pagador_w;
					
					if (coalesce(nr_seq_pagador_novo_w::text, '') = '') then
						select	nextval('pls_contrato_pagador_seq')
						into STRICT	nr_seq_pagador_novo_w
						;
						
						insert into pls_contrato_pagador(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec, nm_usuario_nrec,
								nr_seq_contrato,cd_pessoa_fisica,ie_tipo_pagador,ie_envia_cobranca,
								ie_endereco_boleto,ie_pessoa_comprovante,ie_notificacao,ie_taxa_emissao_boleto,
								ie_calc_primeira_mens,ie_calculo_proporcional,ie_inadimplencia_via_adic,nr_seq_regra_obito,
								nr_seq_classif_itens, ie_receber_sms)
							(SELECT	nr_seq_pagador_novo_w,clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
								nr_seq_contrato,cd_pessoa_pagador_w,'S','N',
								ie_endereco_boleto,ie_pessoa_comprovante,ie_notificacao,ie_taxa_emissao_boleto,
								ie_calc_primeira_mens,ie_calculo_proporcional,ie_inadimplencia_via_adic,nr_seq_regra_obito_p,
								nr_seq_classif_itens, 'S'
							from	pls_contrato_pagador
							where	nr_sequencia	= nr_seq_pagador_w);
						
						insert into pls_contrato_pagador_fin(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
								nr_seq_pagador,dt_inicio_vigencia,dt_dia_vencimento,dt_fim_vigencia,nr_seq_forma_cobranca,
								cd_condicao_pagamento,cd_tipo_portador,cd_portador,nr_seq_conta_banco,cd_banco,
								cd_agencia_bancaria,ie_digito_agencia,cd_conta,ie_digito_conta,nr_seq_empresa,
								cd_profissao,nr_seq_vinculo_empresa,cd_matricula,nr_seq_carteira_cobr,nr_seq_dia_vencimento,
								ie_geracao_nota_titulo,ie_destacar_reajuste,ie_gerar_cobr_escrit)
							
							(SELECT	nextval('pls_contrato_pagador_fin_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
								nr_seq_pagador_novo_w,trunc(dt_rescisao_titular_p,'Month'),dt_dia_vencimento,dt_fim_vigencia,nr_seq_forma_cobranca,
								cd_condicao_pagamento,cd_tipo_portador,cd_portador,nr_seq_conta_banco,cd_banco,
								cd_agencia_bancaria,ie_digito_agencia,cd_conta,ie_digito_conta,nr_seq_empresa,
								cd_profissao,nr_seq_vinculo_empresa,cd_matricula,nr_seq_carteira_cobr,nr_seq_dia_vencimento,
								ie_geracao_nota_titulo,'N','S'
							from	pls_contrato_pagador_fin
							where	nr_seq_pagador	= nr_seq_pagador_w);
					end if;
				end if;
				
				select	max(nr_seq_pagador)
				into STRICT	nr_seq_pagador_ant_w
				from 	pls_segurado
				where	nr_sequencia = nr_seq_dependente_w;
				
				update	pls_segurado
				set	nr_seq_titular		 = NULL,
					nm_usuario		= nm_usuario_p,
					dt_atualizacao		= clock_timestamp(),
					ie_tipo_parentesco	= '',
					--nr_seq_pagador		= decode(nr_seq_pagador_novo_w,null,nr_seq_pagador,nr_seq_pagador_novo_w),
					cd_matricula_familia	= CASE WHEN ie_alterar_matricula_benef_w='S' THEN null  ELSE cd_matricula_familia END
				where	nr_sequencia		= nr_seq_dependente_w
				and	nr_sequencia		<> nr_seq_titular_p;
				
				CALL pls_consistir_titular_benef(nr_seq_contrato_w, nm_usuario_p);
				
				if (nr_seq_dependente_w <> nr_seq_titular_p and (nr_seq_pagador_novo_w IS NOT NULL AND nr_seq_pagador_novo_w::text <> '')) then
					ds_erro_w := pls_alterar_pagador_benef(nr_seq_contrato_w, nr_seq_dependente_w, nr_seq_pagador_novo_w, 'B', cd_estabelecimento_p, nm_usuario_p, clock_timestamp(), nr_seq_motivo_alt_pag_p, null, 'N', null, 'N', 'N', ds_erro_w);
					--pls_alterar_pagador_segurado(nr_seq_dependente_w,nr_seq_pagador_ant_w,nr_seq_pagador_novo_w,sysdate,'N',nm_usuario_p);
				end if;
			end if;
			
			--if	(nvl(ie_geracao_valores_w,'B') <> 'B') then
				CALL pls_gerar_valor_segurado(
						null, nr_seq_dependente_w, 'T',
						cd_estabelecimento_p, nm_usuario_p, 'S',
						clock_timestamp(), ie_permite_tab_dif_w, ie_consiste_tab_contr_w,
						'N', 'N');
			--end if;
			
			CALL pls_gerar_valor_sca_segurado(nr_seq_dependente_w, 'T', clock_timestamp(), nm_usuario_p, cd_estabelecimento_p);
			
			if (dt_rescisao_w IS NOT NULL AND dt_rescisao_w::text <> '') then
				CALL pls_reativar_contrato(nr_seq_contrato_w,'','','',clock_timestamp(),'','S','S','S','S','S',nm_usuario_p,cd_estabelecimento_p,'N');
			end if;
			
			if (nr_seq_dependente_w <> nr_seq_titular_p) then
				CALL pls_gerar_segurado_historico(
					nr_seq_dependente_w, '8', clock_timestamp(),
					'pls_transferir_titular', 'Titular anterior: '||to_char(nr_seq_titular_p)||' - '||nm_titular_ant_w, null,
					null, null, null,
					dt_geracao_sib_p, null, null,
					nr_seq_titular_p, null, null,
					null, nm_usuario_p, 'N');
			elsif (nr_seq_dependente_w = nr_seq_titular_p) then
				CALL pls_gerar_segurado_historico(
					nr_seq_dependente_w, '8', clock_timestamp(),
					'pls_transferir_titular', 'Novo titular : '||to_char(nr_seq_titular_novo_p)||' - '||nm_titular_novo_w, null,
					null, null, null,
					dt_geracao_sib_p, null, null,
					nr_seq_titular_p, null, null,
					null, nm_usuario_p, 'N');
			end if;
			
			--Gera regra de obito
			if (nr_seq_regra_obito_p IS NOT NULL AND nr_seq_regra_obito_p::text <> '') and (nr_seq_titular_p <> nr_seq_dependente_w)  then
				CALL pls_gerar_bonific_obito_seg(nr_seq_dependente_w,nr_seq_regra_obito_p,dt_rescisao_titular_p,qt_anos_validade_p,cd_estabelecimento_p,nm_usuario_p);
			end if;
			
			--Atualizar a familia do beneficiario
			if (ie_alterar_matricula_benef_w = 'S') and (nr_seq_titular_p <> nr_seq_dependente_w)  then
				
				CALL pls_atualizar_familia_pf(nr_seq_dependente_w,cd_estabelecimento_p,nm_usuario_p);
						
				CALL pls_gerar_segurado_historico(	nr_seq_dependente_w, '28', clock_timestamp(), wheb_mensagem_pck.get_texto(1159072),
								wheb_mensagem_pck.get_texto(1159073), null, null, null,
								null, clock_timestamp(), null, null,
								null, null, null, null,
								nm_usuario_p, 'N');						
			end if;
			
			if	((ie_alterar_cart_benef_w = 'S') or (ie_alterar_cart_benef_w = ie_contrato_pj_w)) and (nr_seq_titular_p <> nr_seq_dependente_w)  then
				CALL pls_alterar_cartao_ident_benef(nr_seq_dependente_w,dt_geracao_sib_p,cd_estabelecimento_p,nm_usuario_p);
			end if;
		end if;
		end;
	end loop;
	close c01;
	
	if (coalesce(ie_rescindir_titular_p,'N') = 'S') then
		ie_consistir_sib_w := Obter_Param_Usuario(1202, 44, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_consistir_sib_w);
		
		if (nr_seq_motivo_cancel_titular_p = 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(289030);
		end if;
		
		ds_erro_w := pls_rescindir_contrato(null, nr_seq_titular_p, null, null, null, dt_rescisao_titular_p, dt_limite_util_titular_p, nr_seq_motivo_cancel_titular_p, ds_obs_resc_titular_p, cd_estabelecimento_p, ie_consistir_sib_w, nm_usuario_p, nr_cert_obito_titular_p, dt_obito_titular_p, 'S', null, ds_erro_w, null, 'N', coalesce(ie_tipo_rescisao_p, 'TT'));
		
		if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(182314,'DS_ERRO='||ds_erro_w);
		end if;
	end if;
	
	if (ie_tipo_alteracao_p = 'D') and (nr_seq_titular_novo_p IS NOT NULL AND nr_seq_titular_novo_p::text <> '')  then
		if (nr_seq_regra_obito_p IS NOT NULL AND nr_seq_regra_obito_p::text <> '') then
			CALL pls_gerar_bonific_obito_seg(nr_seq_titular_novo_p,nr_seq_regra_obito_p,dt_rescisao_titular_p,qt_anos_validade_p,cd_estabelecimento_p,nm_usuario_p);
		end if;

		CALL pls_att_classif_dependencia(nr_seq_titular_novo_p,nm_usuario_p,'N');
	end if;
	
	select	max(nr_seq_contrato)
	into STRICT	nr_seq_contrato_ww
	from	pls_segurado
	where	nr_sequencia = nr_seq_titular_p;
	
	if (nr_seq_contrato_ww IS NOT NULL AND nr_seq_contrato_ww::text <> '') then
		CALL pls_preco_beneficiario_pck.atualizar_preco_beneficiarios(null, nr_seq_contrato_ww, null, null, clock_timestamp(), null, 'N', nm_usuario_p, cd_estabelecimento_p);
	end if;
end if;

if (ie_commit_p = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_transferir_titular ( nr_seq_titular_p bigint, nr_seq_titular_novo_p bigint, ie_tipo_alteracao_p text, dt_geracao_sib_p timestamp, ie_rescindir_titular_p text, dt_rescisao_titular_p timestamp, dt_limite_util_titular_p timestamp, nr_seq_motivo_cancel_titular_p bigint, nr_cert_obito_titular_p text, dt_obito_titular_p timestamp, ds_obs_resc_titular_p text, cd_estabelecimento_p bigint, nr_seq_regra_obito_p bigint, ie_gerar_novo_pagador_p text, qt_anos_validade_p bigint, nr_seq_motivo_alt_pag_p bigint, ie_tipo_rescisao_p text default null, nm_usuario_p text DEFAULT NULL, ie_commit_p text DEFAULT NULL) FROM PUBLIC;
