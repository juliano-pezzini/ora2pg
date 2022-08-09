-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_lote_portador ( nr_seq_lote_p pls_lote_portador_alt.nr_sequencia%type, cd_tipo_portador_p bigint, cd_portador_p bigint, nr_seq_conta_banco_p bigint, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


nr_seq_pag_fin_ant_w	pls_contrato_pagador_fin.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	nr_seq_pagador,
		nr_sequencia nr_seq_portador_alteracao,
		pls_obter_dados_pagador_fin(nr_seq_pagador,'TP') cd_tipo_portador_ant,
		pls_obter_dados_pagador_fin(nr_seq_pagador,'CP') cd_portador_ant
	from	pls_portador_alteracao
	where	nr_seq_lote	= nr_seq_lote_p;

BEGIN

for r_c01_w in c01 loop
	begin
	select	max(nr_sequencia)
	into STRICT	nr_seq_pag_fin_ant_w
	from	pls_contrato_pagador_fin
	where	nr_seq_pagador	= r_c01_w.nr_seq_pagador
	and	clock_timestamp() between dt_inicio_vigencia and coalesce(dt_fim_vigencia, clock_timestamp());
	
	if (nr_seq_pag_fin_ant_w IS NOT NULL AND nr_seq_pag_fin_ant_w::text <> '') then
		update	pls_contrato_pagador_fin
		set	dt_fim_vigencia	= clock_timestamp(),
			nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp()
		where	nr_sequencia	= nr_seq_pag_fin_ant_w;
		
		insert into pls_contrato_pagador_fin(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
				nr_seq_pagador,nr_seq_forma_cobranca,dt_inicio_vigencia,dt_fim_vigencia,
				cd_banco,nr_seq_conta_banco,cd_agencia_bancaria,ie_digito_agencia,
				cd_conta,ie_digito_conta,dt_dia_vencimento,nr_seq_empresa,
				cd_matricula,cd_condicao_pagamento,cd_profissao,nr_seq_vinculo_est,
				cd_tipo_portador,cd_portador,ie_portador_exclusivo,nr_seq_vinculo_empresa,
				ie_mes_vencimento,ie_geracao_nota_titulo,ie_gerar_cobr_escrit,
				cd_autenticidade,ie_boleto_email, ie_destacar_reajuste,
				nr_seq_carteira_cobr, nr_seq_dia_vencimento, nr_pensionista,
				cd_tipo_portador_deb_aut, cd_portador_deb_aut, nr_seq_conta_banco_deb_aut,
				nr_seq_mot_cob, nr_cartao_credito, nr_seq_bandeira,
				nm_titular_cartao, ds_token, qt_meses_vencimento,
				ie_data_referencia_nf, ie_linha_digitavel, ie_indice_correcao)
			(SELECT	nextval('pls_contrato_pagador_fin_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
				r_c01_w.nr_seq_pagador,nr_seq_forma_cobranca,clock_timestamp(),null,
				cd_banco,nr_seq_conta_banco_p,cd_agencia_bancaria,ie_digito_agencia,
				cd_conta,ie_digito_conta,dt_dia_vencimento,nr_seq_empresa,
				cd_matricula,cd_condicao_pagamento,cd_profissao,nr_seq_vinculo_est,
				cd_tipo_portador_p,cd_portador_p,'S',nr_seq_vinculo_empresa,
				ie_mes_vencimento,ie_geracao_nota_titulo,ie_gerar_cobr_escrit,
				cd_autenticidade,ie_boleto_email, ie_destacar_reajuste,
				nr_seq_carteira_cobr, nr_seq_dia_vencimento, nr_pensionista,
				cd_tipo_portador_deb_aut, cd_portador_deb_aut, nr_seq_conta_banco_deb_aut,
				nr_seq_mot_cob, nr_cartao_credito, nr_seq_bandeira,
				nm_titular_cartao, ds_token, qt_meses_vencimento,
				ie_data_referencia_nf, ie_linha_digitavel, ie_indice_correcao
			from	pls_contrato_pagador_fin
			where	nr_sequencia	= nr_seq_pag_fin_ant_w);

		insert into pls_pagador_historico(	nr_sequencia, nr_seq_pagador, cd_estabelecimento,
				dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
				nm_usuario_nrec, ds_historico, dt_historico,
				nm_usuario_historico, ds_titulo, ie_tipo_historico)
		values (	nextval('pls_pagador_historico_seq'), r_c01_w.nr_seq_pagador, cd_estabelecimento_p,
				clock_timestamp(), nm_usuario_p, clock_timestamp(),
				nm_usuario_p, wheb_mensagem_pck.get_texto(1175335,'DS_TIPO_PORTADOR_ANT='||obter_valor_dominio(703,r_c01_w.cd_tipo_portador_ant)||
										  ';DS_TIPO_PORTADOR='||obter_valor_dominio(703,cd_tipo_portador_p)||
										  ';DS_PORTADOR_ANT='||obter_desc_portador(r_c01_w.cd_tipo_portador_ant,r_c01_w.cd_portador_ant)||
										  ';DS_PORTADOR='||obter_desc_portador(cd_tipo_portador_p,cd_portador_p)), clock_timestamp(),
				nm_usuario_p, wheb_mensagem_pck.get_texto(1175336), 'S');
		
		update	pls_portador_alteracao
		set	cd_tipo_portador	= cd_tipo_portador_p,
			cd_portador		= cd_portador_p,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
		where	nr_sequencia		= r_c01_w.nr_seq_portador_alteracao;
	end if;
	end;
end loop;

update	pls_lote_portador_alt
set	dt_alteracao_lote	= clock_timestamp(),
	nm_usuario_alteracao	= nm_usuario_p,
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp()
where	nr_sequencia		= nr_seq_lote_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_lote_portador ( nr_seq_lote_p pls_lote_portador_alt.nr_sequencia%type, cd_tipo_portador_p bigint, cd_portador_p bigint, nr_seq_conta_banco_p bigint, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
