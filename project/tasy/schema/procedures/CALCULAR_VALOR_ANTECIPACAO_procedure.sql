-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_valor_antecipacao ( tx_antecipacao_p lote_baixa_cartao_cr.tx_antecipacao%type, nr_seq_lote_p lote_baixa_cartao_cr.nr_sequencia%type, nm_usuario_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Realizar o calculo do valor de antecipação das parcelas/baixas de lotes de cartão que possuem taxa de antecipação 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: Administração de Cartões, opção de mouse "Calcular valores de antecipação" 
[ ] Objetos do dicionário [ x] Tasy Java [ ] Tasy Delphi [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
nr_seq_parcela_w	movto_cartao_cr_parcela.nr_sequencia%type;
vl_liquido_w 	 	movto_cartao_cr_parcela.vl_liquido%type;
vl_antecip_w 		movto_cartao_cr_parcela.vl_antecip%type;

 
obter_parcelas CURSOR FOR 
		SELECT b.nr_sequencia, 
				b.vl_liquido 
		FROM movto_cartao_cr a, movto_cartao_cr_parcela b
LEFT OUTER JOIN movto_cartao_cr_baixa c ON (b.nr_sequencia = c.nr_seq_parcela)
WHERE b.nr_seq_movto = a.nr_sequencia  and b.nr_seq_lote = nr_seq_lote_p and (a.cd_estabelecimento = obter_estab_usuario(nm_usuario_p) or obter_estab_financeiro(a.cd_estabelecimento) = obter_estab_usuario(nm_usuario_p)) group by 
			b.nr_sequencia, 
			a.nr_sequencia, 
			a.dt_transacao, 
			substr(obter_dados_cartao_cr(a.nr_sequencia,'B'),1,200), 
			a.ie_tipo_cartao, 
			a.nr_autorizacao, 
			a.ds_comprovante, 
			substr(obter_dados_cartao_cr(a.nr_sequencia,'NM'),1,30), 
			b.dt_parcela, 
			b.vl_parcela, 
			b.vl_liquido, 
			coalesce(b.vl_saldo_liquido,0), 
			substr(obter_descricao_padrao('CAIXA_RECEB','NR_RECIBO', a.nr_seq_caixa_rec),1,10), 
			substr((obter_qt_parcela_cartao(b.nr_sequencia) || '/' || a.qt_parcela),1,30), 
			b.vl_despesa, 
			obter_saldo_despesa_cartao_cr(null,b.nr_sequencia,clock_timestamp()), 
			a.vl_transacao, 
			a.cd_estabelecimento, 
			coalesce(b.vl_imposto,0), 
			(coalesce(b.vl_despesa,0) - coalesce(b.vl_imposto,0)), 
			b.vl_antecip, 
			a.nr_sequencia 
		order by b.dt_parcela;

 

BEGIN 
 
if (tx_antecipacao_p IS NOT NULL AND tx_antecipacao_p::text <> '') and (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then 
	 
	open obter_parcelas;
	loop 
	fetch obter_parcelas into	 
		nr_seq_parcela_w, 
		vl_liquido_w;
	EXIT WHEN NOT FOUND; /* apply on obter_parcelas */
	begin	 
	 
		vl_antecip_w := coalesce(vl_liquido_w,0) * coalesce(tx_antecipacao_p,0) / 100;
	 
		update	movto_cartao_cr_parcela 
		set		vl_antecip			= vl_antecip_w 
		where	nr_sequencia		= nr_seq_parcela_w;
		 
		CALL Atualizar_saldo_cartao_parcela(nr_seq_parcela_w,nm_usuario_p);
		 
	end;
	end loop;
	close obter_parcelas;
		 
	commit;
	 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_valor_antecipacao ( tx_antecipacao_p lote_baixa_cartao_cr.tx_antecipacao%type, nr_seq_lote_p lote_baixa_cartao_cr.nr_sequencia%type, nm_usuario_p text) FROM PUBLIC;
