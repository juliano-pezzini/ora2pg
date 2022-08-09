-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixar_titulo_rec_carta ( nr_seq_carta_p carta_compromisso.nr_sequencia%type, nr_titulo_pf_p titulo_receber.nr_titulo%type, ie_commit_p text default 'N', cd_estabelecimento_p estabelecimento.cd_estabelecimento%type DEFAULT NULL, nm_usuario_p usuario.nm_usuario%type DEFAULT NULL) AS $body$
DECLARE


cd_moeda_padrao_w		parametro_contas_receber.cd_moeda_padrao%type;
cd_tipo_recebimento_w		parametro_contas_receber.cd_tipo_receb_carta%type;
nr_seq_trans_fin_w			transacao_financeira.nr_sequencia%type;
vl_carta_w			carta_compromisso.vl_editado%type;
cd_cgc_w			carta_compromisso.cd_cgc_emitente%type;
nr_titulo_gerado_w			carta_compromisso.nr_titulo_gerado%type;
nr_seq_baixa_w			titulo_receber_liq.nr_sequencia%type;


BEGIN	

select	max(cd_tipo_receb_carta),
	max(cd_moeda_padrao)
into STRICT	cd_tipo_recebimento_w,
	cd_moeda_padrao_w
from	parametro_contas_receber
where	cd_estabelecimento = cd_estabelecimento_p;

if (coalesce(cd_tipo_recebimento_w::text, '') = '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1085872);
	/*	Não há tipo de recebimento padrão cadastrado para o processo de cartas de compromisso de pagamento. 
		Verifique na função "Parâmetros do Contas a Receber", aba "Título".*/
end if;
		
select	max(nr_seq_trans_fin)
into STRICT	nr_seq_trans_fin_w
from	tipo_recebimento
where	cd_tipo_recebimento = cd_tipo_recebimento_w;

if (nr_seq_carta_p IS NOT NULL AND nr_seq_carta_p::text <> '') then
	begin
		
		select 	max(coalesce(vl_editado, vl_original)),
			max(cd_cgc_emitente),
			max(nr_titulo_gerado)
		into STRICT	vl_carta_w,
			cd_cgc_w,
			nr_titulo_gerado_w
		from	carta_compromisso
		where	nr_sequencia = nr_seq_carta_p;
		
		select	coalesce(max(nr_sequencia),0) + 1
		into STRICT	nr_seq_baixa_w
		from	titulo_receber_liq
		where	nr_titulo = nr_titulo_pf_p;

		insert into titulo_receber_liq(	nr_titulo, 								
					nr_sequencia,
					dt_recebimento,
					vl_recebido,
					cd_tipo_recebimento,
					nr_seq_trans_fin,
					nr_seq_carta,
					ds_observacao,
					cd_moeda,
					ie_acao,
					vl_descontos,
					vl_rec_maior,
					vl_glosa,
					vl_juros,
					vl_multa,
					ie_lib_caixa,
					dt_atualizacao,
					nm_usuario)
				values (	nr_titulo_pf_p,
					nr_seq_baixa_w,
					clock_timestamp(),
					vl_carta_w,
					cd_tipo_recebimento_w, 
					nr_seq_trans_fin_w,
					nr_seq_carta_p,
					expressao_pck.obter_desc_expressao(948268) || ': ' || nr_titulo_gerado_w, -- Título a receber gerado para a instituição emissora da carta
					cd_moeda_padrao_w,
					'I',
					0,
					0,
					0,
					0,
					0,
					'S',
					clock_timestamp(),
					nm_usuario_p);
		
		CALL Atualizar_Saldo_Tit_Rec(nr_titulo_pf_p, nm_usuario_p);
		
		update 	carta_compromisso
		set 	nr_titulo_baixa = nr_titulo_pf_p,
			nr_seq_baixa = nr_seq_baixa_w
		where 	nr_sequencia = nr_seq_carta_p;

	end;
end if;

if (coalesce(ie_commit_p,'N') = 'S') then
	commit;
end if;										
			
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixar_titulo_rec_carta ( nr_seq_carta_p carta_compromisso.nr_sequencia%type, nr_titulo_pf_p titulo_receber.nr_titulo%type, ie_commit_p text default 'N', cd_estabelecimento_p estabelecimento.cd_estabelecimento%type DEFAULT NULL, nm_usuario_p usuario.nm_usuario%type DEFAULT NULL) FROM PUBLIC;
