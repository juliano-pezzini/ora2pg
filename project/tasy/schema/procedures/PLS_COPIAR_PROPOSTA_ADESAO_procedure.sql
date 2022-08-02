-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_copiar_proposta_adesao ( cd_estab_origem_p bigint, cd_estab_destino_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_proposta_inconsist_w	bigint;
nr_seq_proposta_adesao_w	bigint;
nr_seq_proposta_adesao_novo_w	bigint;
nr_seq_proposta_plano_w		bigint;
nr_seq_proposta_pagador_w	bigint;
nr_seq_proposta_benef_w		bigint;
nr_seq_proposta_benef_novo_w	bigint;
nr_seq_benef_bonificacao_w	bigint;
nr_seq_benef_sca_w		bigint;
nr_seq_benef_anexo_w		bigint;
nr_seq_benef_carencia_w		bigint;
nr_seq_regra_desconto_w		bigint;
nr_seq_regra_novo_desconto_w	bigint;
nr_seq_preco_regra_desconto_w	bigint;
nr_seq_validacao_w		bigint;
nr_seq_validacao_novo_w		bigint;
nr_seq_proposta_check_list_w	bigint;
nr_seq_proposta_bonific_w	bigint;
nr_seq_historico_proposta_w	bigint;
nr_seq_proposta_web_w		bigint;
nr_seq_proposta_reprovacao_w	bigint;
nr_seq_incl_benef_reprov_w	bigint;
nr_seq_plano_ant_w		bigint;
nr_seq_tabela_ant_w		bigint;
nr_seq_plano_novo_w		bigint;
nr_seq_tabela_novo_w		bigint;
nr_seq_vendedor_canal_ant_w	bigint;
nr_seq_vendedor_pf_ant_w	bigint;
nr_seq_cliente_ant_w		bigint;
nr_seq_vendedor_canal_novo_w	bigint;
nr_seq_vendedor_pf_novo_w	bigint;
nr_seq_cliente_novo_w		bigint;
nr_seq_plano_benef_ant_w	bigint;
nr_seq_tabela_benef_ant_w	bigint;
nr_seq_titular_ant_w		bigint;
nr_seq_pagador_ant_w		bigint;
nr_seq_motivo_inclusao_ant_w	bigint;
nr_seq_tabela_benef_novo_w	bigint;
nr_seq_plano_benef_novo_w	bigint;
nr_seq_titular_novo_w		bigint;
nr_seq_pagador_novo_w		bigint;
nr_seq_motivo_inclusao_novo_w	bigint;
qt_registro_w			bigint;

C00 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_proposta_inconsist
	where	cd_estabelecimento	= cd_estab_origem_p;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_proposta_adesao
	where	cd_estabelecimento	= cd_estab_origem_p;

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_proposta_plano
	where	nr_seq_proposta	= nr_seq_proposta_adesao_w;

C03 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_proposta_pagador
	where	nr_seq_proposta	= nr_seq_proposta_adesao_w;

C04 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_proposta_beneficiario
	where	nr_seq_proposta	= nr_seq_proposta_adesao_w;

C05 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_bonificacao_vinculo
	where	nr_seq_segurado_prop	= nr_seq_proposta_benef_w;

C06 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_sca_vinculo
	where	nr_seq_benef_proposta	= nr_seq_proposta_benef_w;

C07 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_carencia
	where	nr_seq_pessoa_proposta	= nr_seq_proposta_benef_w;

C08 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_proposta_benef_anexo
	where	nr_seq_beneficiario	= nr_seq_proposta_benef_w;

C09 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_regra_desconto
	where	nr_seq_proposta		= nr_seq_proposta_adesao_w;

C10 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_preco_regra
	where	nr_seq_regra	= nr_seq_regra_desconto_w;

C11 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_bonificacao_vinculo
	where	nr_seq_proposta	= nr_seq_proposta_adesao_w;

C12 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_proposta_historico
	where	nr_seq_proposta	= nr_seq_proposta_adesao_w;

C13 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_proposta_validacao
	where	nr_seq_proposta	= nr_seq_proposta_adesao_w;

C14 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_proposta_check_list
	where	nr_seq_validacao	= nr_seq_validacao_w;

/*
Cursor C15 is
	select	nr_sequencia
	from	pls_proposta_adesao_web
	where	nr_seq_proposta_adesao	= nr_seq_proposta_adesao_w;
*/
C16 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_proposta_reprovacao
	where	cd_estabelecimento	= cd_estab_origem_p;

C17 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_inclusao_benef_reprov
	where	cd_estabelecimento	= cd_estab_origem_p;


BEGIN

open C00;
loop
fetch C00 into
	nr_seq_proposta_inconsist_w;
EXIT WHEN NOT FOUND; /* apply on C00 */
	begin

	select	count(*)
	into STRICT	qt_registro_w
	from	pls_proposta_inconsist
	where	cd_estabelecimento	= cd_estab_destino_p
	and	nr_seq_anterior		= nr_seq_proposta_inconsist_w;

	if (qt_registro_w	= 0) then
		insert into pls_proposta_inconsist(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,cd_estabelecimento,
								ds_inconsistencia, nr_seq_anterior)
							(SELECT	nextval('pls_proposta_inconsist_seq'),clock_timestamp(),nm_usuario_p,dt_atualizacao_nrec,nm_usuario_nrec,cd_estab_destino_p,
								ds_inconsistencia, nr_seq_proposta_inconsist_w
							from	pls_proposta_inconsist
							where	nr_sequencia	= nr_seq_proposta_inconsist_w);
	end if;

	end;
end loop;
close C00;

open C01;
loop
fetch C01 into
	nr_seq_proposta_adesao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	nextval('pls_proposta_adesao_seq')
	into STRICT	nr_seq_proposta_adesao_novo_w
	;

	select	nr_seq_vendedor_canal,
		nr_seq_vendedor_pf,
		nr_seq_cliente
	into STRICT	nr_seq_vendedor_canal_ant_w,
		nr_seq_vendedor_pf_ant_w,
		nr_seq_cliente_ant_w
	from	pls_proposta_adesao
	where	nr_sequencia	= nr_seq_proposta_adesao_w;

	begin
	select	nr_sequencia
	into STRICT	nr_seq_vendedor_canal_novo_w
	from	pls_vendedor
	where	nr_seq_vendedor_ant	= nr_seq_vendedor_canal_ant_w;
	exception
	when others then
		nr_seq_vendedor_canal_novo_w	:= null;
	end;

	begin
	select	nr_sequencia
	into STRICT	nr_seq_vendedor_pf_novo_w
	from	pls_vendedor_vinculado
	where	nr_seq_vinculo_ant	= nr_seq_vendedor_pf_ant_w;
	exception
	when others then
		nr_seq_vendedor_pf_novo_w	:= null;
	end;

	begin
	select	nr_sequencia
	into STRICT	nr_seq_cliente_novo_w
	from	pls_comercial_cliente
	where	nr_seq_cliente_ant	= nr_seq_cliente_ant_w;
	exception
	when others then
		nr_seq_cliente_novo_w	:= null;
	end;

	select	count(*)
	into STRICT	qt_registro_w
	from	pls_proposta_adesao
	where	cd_estabelecimento	= cd_estab_destino_p
	and	nr_seq_proposta_ant	= nr_seq_proposta_adesao_w;

	if (qt_registro_w	= 0) then
		insert into pls_proposta_adesao(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,cd_estabelecimento,
							ie_tipo_contratacao,ie_tipo_beneficiario,nr_seq_contrato,cd_cgc_estipulante,cd_estipulante,ie_estipulante_pagador,
							dt_inicio_proposta,dt_fim_proposta,dt_contratacao,ie_status,nr_seq_vendedor_canal,nr_seq_vendedor_pf,
							vl_proposta,ie_tipo_proposta,cd_motivo_reprovacao,nr_seq_cliente,nr_seq_contrato_mig,nr_seq_congenere,
							dt_limite_utilizacao,dt_reprovacao,nr_seq_proposta_ant)
						(SELECT	nr_seq_proposta_adesao_novo_w,clock_timestamp(),nm_usuario_p,dt_atualizacao_nrec,nm_usuario_nrec,cd_estab_destino_p,
							ie_tipo_contratacao,ie_tipo_beneficiario,nr_seq_contrato,cd_cgc_estipulante,cd_estipulante,ie_estipulante_pagador,
							dt_inicio_proposta,dt_fim_proposta,dt_contratacao,ie_status,nr_seq_vendedor_canal_novo_w,nr_seq_vendedor_pf_novo_w,
							vl_proposta,ie_tipo_proposta,cd_motivo_reprovacao,nr_seq_cliente_novo_w,nr_seq_contrato_mig,nr_seq_congenere,
							dt_limite_utilizacao,dt_reprovacao,nr_seq_proposta_adesao_w
						from	pls_proposta_adesao
						where	nr_sequencia	= nr_seq_proposta_adesao_w);

		open C02;
		loop
		fetch C02 into
			nr_seq_proposta_plano_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin

			select	nr_seq_plano,
				nr_seq_tabela
			into STRICT	nr_seq_plano_ant_w,
				nr_seq_tabela_ant_w
			from	pls_proposta_plano
			where	nr_sequencia	= nr_seq_proposta_plano_w;

			select	max(nr_sequencia)
			into STRICT	nr_seq_plano_novo_w
			from	pls_plano
			where	nr_seq_plano_ant = nr_seq_plano_ant_w;

			begin
			select	nr_sequencia
			into STRICT	nr_seq_tabela_novo_w
			from	pls_tabela_preco
			where	nr_seq_tabela_ant	= nr_seq_tabela_ant_w;
			exception
			when others then
				nr_seq_tabela_novo_w	:= null;
			end;

			insert into pls_proposta_plano(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_proposta,
								nr_seq_plano,nr_seq_tabela,ie_principal)
							(SELECT	nextval('pls_proposta_plano_seq'),clock_timestamp(),nm_usuario_p,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_proposta_adesao_novo_w,
								nr_seq_plano_novo_w,nr_seq_tabela_novo_w,ie_principal
							from	pls_proposta_plano
							where	nr_sequencia	= nr_seq_proposta_plano_w);
			end;
		end loop;
		close C02;

		open C03;
		loop
		fetch C03 into
			nr_seq_proposta_pagador_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin

			insert into pls_proposta_pagador(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_proposta,
									cd_cgc_pagador,cd_pagador,cd_condicao_pagamento,ie_endereco_boleto,dt_dia_vencimento,nr_seq_forma_cobranca,
									cd_banco,cd_agencia_bancaria,ie_digito_agencia,cd_conta,ie_digito_conta,nr_seq_contrato_pagador,
									ie_envia_cobranca,nr_seq_pagador_ant, nr_seq_compl_pf_tel_adic, nr_seq_dia_vencimento,
									nr_seq_tipo_compl_adic)
								(SELECT	nextval('pls_proposta_pagador_seq'),clock_timestamp(),nm_usuario_p,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_proposta_adesao_novo_w,
									cd_cgc_pagador,cd_pagador,cd_condicao_pagamento,ie_endereco_boleto,dt_dia_vencimento,nr_seq_forma_cobranca,
									cd_banco,cd_agencia_bancaria,ie_digito_agencia,cd_conta,ie_digito_conta,nr_seq_contrato_pagador,
									ie_envia_cobranca,nr_seq_proposta_pagador_w, nr_seq_compl_pf_tel_adic, nr_seq_dia_vencimento,
									nr_seq_tipo_compl_adic
								from	pls_proposta_pagador
								where	nr_sequencia	= nr_seq_proposta_pagador_w);
			end;
		end loop;
		close C03;

		open C04;
		loop
		fetch C04 into
			nr_seq_proposta_benef_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
			begin

			select	nextval('pls_proposta_beneficiario_seq')
			into STRICT	nr_seq_proposta_benef_novo_w
			;

			select	nr_seq_plano,
				nr_seq_tabela,
				nr_seq_titular,
				nr_seq_pagador,
				nr_seq_motivo_inclusao
			into STRICT	nr_seq_plano_benef_ant_w,
				nr_seq_tabela_benef_ant_w,
				nr_seq_titular_ant_w,
				nr_seq_pagador_ant_w,
				nr_seq_motivo_inclusao_ant_w
			from	pls_proposta_beneficiario
			where	nr_sequencia	= nr_seq_proposta_benef_w;

			begin
			select	nr_sequencia
			into STRICT	nr_seq_plano_benef_novo_w
			from	pls_plano
			where	nr_seq_plano_ant = nr_seq_plano_ant_w;
			exception
			when others then
				nr_seq_plano_benef_novo_w	:= null;
			end;

			begin
			select	nr_sequencia
			into STRICT	nr_seq_tabela_benef_novo_w
			from	pls_tabela_preco
			where	nr_seq_tabela_ant	= nr_seq_tabela_ant_w;
			exception
			when others then
				nr_seq_tabela_benef_novo_w	:= null;
			end;

			begin
			select	nr_sequencia
			into STRICT	nr_seq_titular_novo_w
			from	pls_proposta_beneficiario
			where	nr_seq_benef_ant	= nr_seq_titular_ant_w;
			exception
			when others then
				nr_seq_titular_novo_w	:= null;
			end;

			begin
			select	nr_sequencia
			into STRICT	nr_seq_pagador_novo_w
			from	pls_proposta_pagador
			where	nr_seq_pagador_ant	= nr_seq_pagador_ant_w;
			exception
			when others then
				nr_seq_pagador_novo_w	:= null;
			end;

			begin
			select	nr_sequencia
			into STRICT	nr_seq_motivo_inclusao_novo_w
			from	pls_motivo_inclusao_seg
			where	nr_seq_motivo_ant	= nr_seq_motivo_inclusao_ant_w;
			exception
			when others then
				nr_seq_motivo_inclusao_novo_w	:= null;
			end;

			insert into pls_proposta_beneficiario(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_proposta,
									cd_beneficiario,nr_seq_pagador,nr_seq_plano,nr_seq_titular,nr_seq_parentesco,nr_seq_tabela,
									vl_mensalidade,nr_seq_regra_desconto,tx_desconto,nr_seq_titular_contrato,ie_nascido_plano,nr_seq_portabilidade,
									dt_admissao,cd_cbo,cd_matricula_est,nr_seq_vinculo_estip,nr_seq_subestipulante,nr_seq_beneficiario,
									nr_seq_inclusao_benef,nr_seq_benef_gerado,nr_seq_motivo_cancelamento,dt_cancelamento,vl_bonificacao,dt_contratacao,
									vl_sca,nr_seq_motivo_inclusao,ie_taxa_inscricao,nr_seq_benef_ant, ie_copiar_sca_plano, vl_inscricao,
									vl_via_carteira)
								(SELECT	nr_seq_proposta_benef_novo_w,clock_timestamp(),nm_usuario_p,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_proposta_adesao_novo_w,
									cd_beneficiario,nr_seq_pagador_novo_w,nr_seq_plano_benef_novo_w,nr_seq_titular_novo_w,nr_seq_parentesco,nr_seq_tabela_benef_novo_w,
									vl_mensalidade,nr_seq_regra_desconto,tx_desconto,nr_seq_titular_contrato,ie_nascido_plano,nr_seq_portabilidade,
									dt_admissao,cd_cbo,cd_matricula_est,nr_seq_vinculo_estip,nr_seq_subestipulante,nr_seq_beneficiario,
									nr_seq_inclusao_benef,nr_seq_benef_gerado,nr_seq_motivo_cancelamento,dt_cancelamento,vl_bonificacao,dt_contratacao,
									vl_sca,nr_seq_motivo_inclusao_novo_w,ie_taxa_inscricao,nr_seq_proposta_benef_w, ie_copiar_sca_plano, vl_inscricao,
									vl_via_carteira
								from	pls_proposta_beneficiario
								where	nr_sequencia	= nr_seq_proposta_benef_w);
			open C05;
			loop
			fetch C05 into
				nr_seq_benef_bonificacao_w;
			EXIT WHEN NOT FOUND; /* apply on C05 */
				begin

				insert into pls_bonificacao_vinculo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_segurado_prop,
										dt_inicio_vigencia,dt_fim_vigencia,tx_bonificacao,vl_bonificacao,nr_seq_bonificacao)
									(SELECT	nextval('pls_bonificacao_vinculo_seq'),clock_timestamp(),nm_usuario_p,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_proposta_benef_novo_w,
										dt_inicio_vigencia,dt_fim_vigencia,tx_bonificacao,vl_bonificacao,nr_seq_bonificacao
									from	pls_bonificacao_vinculo
									where	nr_sequencia	= nr_seq_benef_bonificacao_w);

				end;
			end loop;
			close C05;

			open C06;
			loop
			fetch C06 into
				nr_seq_benef_sca_w;
			EXIT WHEN NOT FOUND; /* apply on C06 */
				begin

				insert into pls_sca_vinculo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_benef_proposta,
									nr_seq_plano,nr_seq_tabela,qt_idade_limite,dt_inicio_vigencia)
								(SELECT	nextval('pls_sca_vinculo_seq'),clock_timestamp(),nm_usuario_p,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_proposta_benef_novo_w,
									nr_seq_plano,nr_seq_tabela,qt_idade_limite,dt_inicio_vigencia
								from	pls_sca_vinculo
								where	nr_sequencia	= nr_seq_benef_sca_w);

				end;
			end loop;
			close C06;

			open C07;
			loop
			fetch C07 into
				nr_seq_benef_carencia_w;
			EXIT WHEN NOT FOUND; /* apply on C07 */
				begin

				insert into pls_carencia(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_pessoa_proposta,
									nr_seq_tipo_carencia,qt_dias,dt_inicio_vigencia,ie_origem_carencia_benef)
								(SELECT	nextval('pls_carencia_seq'),clock_timestamp(),nm_usuario_p,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_proposta_benef_novo_w,
									nr_seq_tipo_carencia,qt_dias,dt_inicio_vigencia,'P'
								from	pls_carencia
								where	nr_sequencia	= nr_seq_benef_carencia_w);
				end;
			end loop;
			close C07;

			open C08;
			loop
			fetch C08 into
				nr_seq_benef_anexo_w;
			EXIT WHEN NOT FOUND; /* apply on C08 */
				begin

				insert into pls_proposta_benef_anexo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_beneficiario,
										dt_anexo,ds_anexo)
									(SELECT	nextval('pls_proposta_benef_anexo_seq'),clock_timestamp(),nm_usuario_p,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_proposta_benef_novo_w,
										dt_anexo,ds_anexo
									from	pls_proposta_benef_anexo
									where	nr_sequencia	= nr_seq_benef_anexo_w);
				end;
			end loop;
			close C08;
			end;
		end loop;
		close C04;

		open C09;
		loop
		fetch C09 into
			nr_seq_regra_desconto_w;
		EXIT WHEN NOT FOUND; /* apply on C09 */
			begin

			select	nextval('pls_regra_desconto_seq')
			into STRICT	nr_seq_regra_novo_desconto_w
			;

			insert into pls_regra_desconto(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,cd_estabelecimento,
								nr_seq_proposta,ds_regra,ie_situacao,dt_inicio_vigencia,dt_fim_vigencia,ie_tipo_regra,nr_seq_desconto_ant)
							(SELECT	nr_seq_regra_novo_desconto_w,clock_timestamp(),nm_usuario_p,dt_atualizacao_nrec,nm_usuario_nrec,cd_estab_destino_p,
								nr_seq_proposta_adesao_novo_w,ds_regra,ie_situacao,dt_inicio_vigencia,dt_fim_vigencia,ie_tipo_regra,nr_seq_regra_desconto_w
							from	pls_regra_desconto
							where	nr_sequencia	= nr_seq_regra_desconto_w);

			open C10;
			loop
			fetch C10 into
				nr_seq_preco_regra_desconto_w;
			EXIT WHEN NOT FOUND; /* apply on C10 */
				begin

				insert into pls_preco_regra(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_regra,
									qt_min_vidas,qt_max_vidas,tx_desconto,ie_tipo_segurado, vl_desconto)
								(SELECT	nextval('pls_preco_regra_seq'),clock_timestamp(),nm_usuario_p,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_regra_novo_desconto_w,
									qt_min_vidas,qt_max_vidas,tx_desconto,ie_tipo_segurado, vl_desconto
								from	pls_preco_regra
								where	nr_sequencia	= nr_seq_preco_regra_desconto_w);
				end;
			end loop;
			close C10;
			end;
		end loop;
		close C09;

		open C11;
		loop
		fetch C11 into
			nr_seq_proposta_bonific_w;
		EXIT WHEN NOT FOUND; /* apply on C11 */
			begin

			insert into pls_bonificacao_vinculo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_proposta,
									dt_inicio_vigencia,dt_fim_vigencia,tx_bonificacao,vl_bonificacao,nr_seq_bonificacao)
								(SELECT	nextval('pls_bonificacao_vinculo_seq'),clock_timestamp(),nm_usuario_p,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_proposta_adesao_novo_w,
									dt_inicio_vigencia,dt_fim_vigencia,tx_bonificacao,vl_bonificacao,nr_seq_bonificacao
								from	pls_bonificacao_vinculo
								where	nr_sequencia	= nr_seq_proposta_bonific_w);
			end;
		end loop;
		close C11;

		open C12;
		loop
		fetch C12 into
			nr_seq_historico_proposta_w;
		EXIT WHEN NOT FOUND; /* apply on C12 */
			begin

			insert into pls_proposta_historico(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_proposta,
									dt_historico,ds_historico, ie_origem_historico)
								(SELECT	nextval('pls_proposta_historico_seq'),clock_timestamp(),nm_usuario_p,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_proposta_adesao_novo_w,
									dt_historico,ds_historico,ie_origem_historico
								from	pls_proposta_historico
								where	nr_sequencia	= nr_seq_historico_proposta_w);
			end;
		end loop;
		close C12;

		open C13;
		loop
		fetch C13 into
			nr_seq_validacao_w;
		EXIT WHEN NOT FOUND; /* apply on C13 */
			begin

			select	nextval('pls_proposta_validacao_seq')
			into STRICT	nr_seq_validacao_novo_w
			;

			insert into pls_proposta_validacao(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_proposta,
									nr_seq_inconsistencia,ie_consistido,dt_liberacao)
								(SELECT	nr_seq_validacao_novo_w,clock_timestamp(),nm_usuario_p,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_proposta_adesao_novo_w,
									nr_seq_inconsistencia,ie_consistido,dt_liberacao
								from	pls_proposta_validacao
								where	nr_sequencia	= nr_seq_validacao_w);

			open C14;
			loop
			fetch C14 into
				nr_seq_proposta_check_list_w;
			EXIT WHEN NOT FOUND; /* apply on C14 */
				begin

				insert into pls_proposta_check_list(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_validacao,
										dt_check_list,ds_check_list,ie_acao)
									(SELECT	nextval('pls_proposta_check_list_seq'),clock_timestamp(),nm_usuario_p,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_validacao_novo_w,
										dt_check_list,ds_check_list,ie_acao
									from	pls_proposta_check_list
									where	nr_sequencia	= nr_seq_proposta_check_list_w);
				end;
			end loop;
			close C14;
			end;
		end loop;
		close C13;

		/*
		open C15;
		loop
		fetch C15 into
			nr_seq_proposta_web_w;
		exit when C15%notfound;
			begin

			insert into pls_proposta_adesao_web	(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_proposta_adesao,
									ds_senha,nm_usuario_web,ie_situacao)
								(select	pls_proposta_adesao_web_seq.nextval,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_proposta_adesao_novo_w,
									ds_senha,nm_usuario_web,ie_situacao
								from	pls_proposta_adesao_web
								where	nr_sequencia	= nr_seq_proposta_web_w);
			end;
		end loop;
		close C15;*/
	end if;
	end;
end loop;
close C01;

open C16;
loop
fetch C16 into
	nr_seq_proposta_reprovacao_w;
EXIT WHEN NOT FOUND; /* apply on C16 */
	begin

	select	count(*)
	into STRICT	qt_registro_w
	from	pls_proposta_reprovacao
	where	cd_estabelecimento	= cd_estab_destino_p
	and	nr_seq_anterior		= nr_seq_proposta_reprovacao_w;

	if (qt_registro_w	= 0) then
		insert into pls_proposta_reprovacao(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,cd_estabelecimento,
								ds_motivo_reprovacao,ie_situacao, nr_seq_anterior)
							(SELECT	nextval('pls_proposta_reprovacao_seq'),clock_timestamp(),nm_usuario_p,dt_atualizacao_nrec,nm_usuario_nrec,cd_estab_destino_p,
								ds_motivo_reprovacao,ie_situacao, nr_seq_proposta_reprovacao_w
							from	pls_proposta_reprovacao
							where	nr_sequencia	= nr_seq_proposta_reprovacao_w);
	end if;

	end;
end loop;
close C16;

open C17;
loop
fetch C17 into
	nr_seq_incl_benef_reprov_w;
EXIT WHEN NOT FOUND; /* apply on C17 */
	begin

	select	count(*)
	into STRICT	qt_registro_w
	from	pls_inclusao_benef_reprov
	where	cd_estabelecimento	= cd_estab_destino_p
	and	nr_seq_anterior		= nr_seq_incl_benef_reprov_w;

	if (qt_registro_w	= 0) then
		insert into pls_inclusao_benef_reprov(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,cd_estabelecimento,
								ds_motivo_reprovacao,ie_situacao, nr_seq_anterior)
							(SELECT	nextval('pls_inclusao_benef_reprov_seq'),clock_timestamp(),nm_usuario_p,dt_atualizacao_nrec,nm_usuario_nrec,cd_estab_destino_p,
								ds_motivo_reprovacao,ie_situacao, nr_seq_incl_benef_reprov_w
							from	pls_inclusao_benef_reprov
							where	nr_sequencia	= nr_seq_incl_benef_reprov_w);
	end if;

	end;
end loop;
close C17;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_copiar_proposta_adesao ( cd_estab_origem_p bigint, cd_estab_destino_p bigint, nm_usuario_p text) FROM PUBLIC;

