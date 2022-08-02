-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_tabela_manutencao ( nr_seq_proposta_p bigint, nr_seq_tabela_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_tabela_nova_p INOUT bigint) AS $body$
DECLARE


nr_seq_tabela_w			bigint;
nr_seq_preco_w			bigint;
qt_registros_w			bigint;
ie_tabela_adap_contr_w		varchar(10);
ie_tipo_proposta_w		varchar(10);
nr_contrato_existente_w		bigint;
nr_seq_contrato_existente_w	bigint;
nr_seq_contrato_w		bigint;
nr_seq_tabela_gerada_w		bigint;
nr_seq_tabela_ww		bigint;
nr_seq_plano_w			bigint;
tx_adaptacao_w			double precision;
nr_seq_reajuste_w		pls_reajuste.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_plano_preco
	where	nr_seq_tabela	= nr_seq_tabela_gerada_w;


BEGIN

select	max(nr_seq_reajuste)
into STRICT	nr_seq_reajuste_w
from (SELECT	coalesce(b.nr_seq_lote_referencia,nr_seq_reajuste) nr_seq_reajuste
	from	pls_reajuste_tabela	a,
		pls_reajuste		b
	where	b.nr_sequencia	= a.nr_seq_reajuste
	and	a.nr_seq_tabela	= nr_seq_tabela_p
	and	coalesce(a.dt_liberacao::text, '') = '') alias3;

if (nr_seq_reajuste_w IS NOT NULL AND nr_seq_reajuste_w::text <> '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(497019,'NR_SEQ_REAJUSTE='||nr_seq_reajuste_w);
end if;

select	max(nr_seq_plano)
into STRICT	nr_seq_plano_w
from	pls_tabela_preco
where	nr_sequencia	= nr_seq_tabela_p;

select	count(*)
into STRICT	qt_registros_w
from	pls_tabela_preco
where	nr_seq_proposta	= nr_seq_proposta_p
and	nr_sequencia	= nr_seq_tabela_p;

if (qt_registros_w = 0) then
	ie_tabela_adap_contr_w	:= coalesce(obter_valor_param_usuario(1232, 72, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p), 'N');
	tx_adaptacao_w		:= 0;
	select	max(ie_tipo_proposta)
	into STRICT	ie_tipo_proposta_w
	from	pls_proposta_adesao
	where	nr_sequencia	= nr_seq_proposta_p;

	/*aaschlote 23/11/2011 OS - 381977*/

	if (ie_tipo_proposta_w	= '9') and (ie_tabela_adap_contr_w	= 'S') then
		select	max(nr_seq_contrato)
		into STRICT	nr_contrato_existente_w
		from	pls_proposta_adesao
		where	nr_sequencia	= nr_seq_proposta_p;

		if (nr_contrato_existente_w IS NOT NULL AND nr_contrato_existente_w::text <> '') then
			select	max(nr_sequencia)
			into STRICT	nr_seq_contrato_w
			from	pls_contrato
			where	nr_contrato	= nr_contrato_existente_w;

			select	max(nr_seq_tabela)
			into STRICT	nr_seq_tabela_ww
			from	pls_contrato_plano
			where	nr_seq_contrato	= nr_seq_contrato_w
			and	ie_situacao	= 'A';

			if (nr_seq_tabela_ww IS NOT NULL AND nr_seq_tabela_ww::text <> '') then
				nr_seq_tabela_gerada_w	:= nr_seq_tabela_ww;
			else
				nr_seq_tabela_gerada_w	:= nr_seq_tabela_p;
			end if;

			select	max(tx_adaptacao)
			into STRICT	tx_adaptacao_w
			from	pls_regra_adaptacao_plano
			where	cd_estabelecimento	= cd_estabelecimento_p
			and	clock_timestamp() between dt_inicio_vigencia and fim_dia(coalesce(dt_fim_vigencia,clock_timestamp()))
			and	((coalesce(nr_seq_grupo_produto::text, '') = '') or (nr_seq_grupo_produto IS NOT NULL AND nr_seq_grupo_produto::text <> '') and (pls_se_grupo_preco_produto(nr_seq_grupo_produto,nr_seq_plano_w)) = 'S');

			if (coalesce(tx_adaptacao_w::text, '') = '') then
				tx_adaptacao_w	:= 0;
			end if;
		else
			CALL wheb_mensagem_pck.exibir_mensagem_abort(126346,'');
		end if;
	else
		nr_seq_tabela_gerada_w	:= nr_seq_tabela_p;
	end if;

	select	nextval('pls_tabela_preco_seq')
	into STRICT	nr_seq_tabela_w
	;

	insert into pls_tabela_preco(	nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, nm_tabela,
					dt_inicio_vigencia, dt_fim_vigencia, nr_seq_plano, dt_liberacao, cd_codigo_ant, ie_tabela_base,
					nr_contrato, ie_tabela_contrato, nr_segurado, nr_seq_tabela_origem, ie_proposta_adesao,
					ie_simulacao_preco, nr_seq_sca, nr_seq_tabela_ant, nr_seq_proposta,nr_seq_tabela_original,
					nr_seq_faixa_etaria, ie_preco_vidas_contrato)
				(SELECT	nr_seq_tabela_w, clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 'Tabela para a proposta ' || nr_seq_proposta_p,
					dt_inicio_vigencia, dt_fim_vigencia, nr_seq_plano_w, dt_liberacao, cd_codigo_ant, ie_tabela_base,
					nr_contrato, ie_tabela_contrato, nr_segurado, nr_seq_tabela_origem, ie_proposta_adesao,
					ie_simulacao_preco, nr_seq_sca, nr_seq_tabela_ant, nr_seq_proposta_p,nr_seq_tabela_gerada_w,
					nr_seq_faixa_etaria, ie_preco_vidas_contrato
				from	pls_tabela_preco
				where	nr_sequencia	= nr_seq_tabela_gerada_w);

	open C01;
	loop
	fetch C01 into
		nr_seq_preco_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		insert into pls_plano_preco(	nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
						nr_seq_tabela, qt_idade_inicial, qt_idade_final, vl_preco_inicial, vl_preco_atual,
						tx_acrescimo, vl_preco_nao_subsidiado, vl_preco_nao_subsid_atual, vl_minimo,
						ie_grau_titularidade, vl_adaptacao,
						qt_vidas_inicial, qt_vidas_final )
					(SELECT	nextval('pls_plano_preco_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p,
						nr_seq_tabela_w, qt_idade_inicial, qt_idade_final, vl_preco_inicial, vl_preco_atual,
						tx_acrescimo, vl_preco_nao_subsidiado, vl_preco_nao_subsid_atual, vl_minimo,
						ie_grau_titularidade,dividir((vl_preco_atual * tx_adaptacao_w), 100),
						qt_vidas_inicial, qt_vidas_final
					from	pls_plano_preco
					where	nr_sequencia = nr_seq_preco_w);
		end;
	end loop;
	close C01;

	update	pls_proposta_plano
	set	nr_seq_tabela	= nr_seq_tabela_w
	where	nr_seq_proposta	= nr_seq_proposta_p
	and	nr_seq_tabela	= nr_seq_tabela_p;

	update	pls_proposta_beneficiario
	set	nr_seq_tabela	= nr_seq_tabela_w
	where	nr_seq_proposta	= nr_seq_proposta_p
	and	nr_seq_tabela	= nr_seq_tabela_p;
else
	nr_seq_tabela_w	:= nr_seq_tabela_p;
end if;

nr_seq_tabela_nova_p	:= nr_seq_tabela_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_tabela_manutencao ( nr_seq_proposta_p bigint, nr_seq_tabela_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_tabela_nova_p INOUT bigint) FROM PUBLIC;

