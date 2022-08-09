-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE recalcular_titulo_rec_liq_cc (nr_titulo_p bigint, nr_seq_baixa_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
cd_estabelecimento_w	bigint;
nr_seq_baixa_w		integer;
nr_titulo_contab_w	bigint;
nr_seq_liq_origem_w	titulo_receber_liq.nr_seq_liq_origem%type;
count_w			bigint;
ie_baixa_estornada_w	varchar(1);

C01 CURSOR FOR 
SELECT	nr_sequencia 
from	titulo_receber_liq 
where	nr_titulo = nr_titulo_p 
and (coalesce(nr_seq_baixa_p,0) = 0 or nr_sequencia = nr_seq_baixa_p);


BEGIN 
 
select	cd_estabelecimento 
into STRICT	cd_estabelecimento_w 
from	titulo_receber 
where	nr_titulo	= nr_titulo_p;
 
open C01;
loop 
fetch C01 into	 
	nr_seq_baixa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	select	obter_se_baixa_estornada(nr_titulo_p, nr_seq_baixa_w, 'R') 
	into STRICT	ie_baixa_estornada_w 
	;
	/*OS 1321467 - Somente fazer o processo se não for uma baixa estornada.*/
 
	if (coalesce(ie_baixa_estornada_w,'N') = 'N') then 
	 
		select	max(a.nr_seq_liq_origem) 
		into STRICT	nr_seq_liq_origem_w 
		from	titulo_receber_liq a 
		where	a.nr_titulo		= nr_titulo_p 
		and		a.nr_sequencia	= nr_seq_baixa_w;
		 
		delete	from titulo_rec_liq_cc 
		where	nr_titulo	= nr_titulo_p 
		and	nr_seq_baixa	= nr_seq_baixa_w;
 
		CALL gerar_titulo_rec_liq_cc(cd_estabelecimento_w, null, nm_usuario_p, nr_titulo_p, nr_seq_baixa_w);
		nr_titulo_contab_w := pls_gerar_tit_rec_liq_mens(nr_titulo_p, nr_seq_baixa_w, nm_usuario_p, nr_titulo_contab_w);
		 
		select	count(*) 
		into STRICT	count_w 
		from	titulo_rec_liq_cc 
		where	nr_titulo 		= nr_titulo_p 
		and		nr_seq_baixa 	= nr_seq_baixa_w;
		 
		/*se for recalculo de uma baixa de estorno, pegar os dados da baixa que foi estornada e lançar negativo, igual ocorre na ESTORNAR_TIT_RECEBER_LIQ */
 
		if (nr_seq_liq_origem_w IS NOT NULL AND nr_seq_liq_origem_w::text <> '') and (count_w = 0) then 
		 
			insert into titulo_rec_liq_cc(NR_SEQUENCIA, 
						NR_TITULO, 
						NR_SEQ_BAIXA, 
						DT_ATUALIZACAO, 
						NM_USUARIO, 
						CD_CENTRO_CUSTO, 
						VL_BAIXA, 
						VL_AMAIOR, 
						DT_ATUALIZACAO_NREC, 
						NM_USUARIO_NREC, 
						CD_CTA_CTB_ORIGEM, 
						CD_CONTA_CONTABIL, 
						VL_RECEBIDO, 
						CD_CONTA_DEB_PLS, 
						CD_CONTA_REC_PLS, 
						NR_SEQ_MENS_SEG_ITEM, 
						CD_HISTORICO_PLS, 
						NR_SEQ_CONTA_PLS, 
						NR_SEQ_PRODUTO, 
						cd_conta_antec_pls, 
						cd_historico_antec_pls, 
						vl_antecipacao_mens, 
						vl_pro_rata, 
						ie_lote_pro_rata, 
						vl_contab_pro_rata, 
						cd_conta_rec_antecip, 
						cd_conta_deb_antecip, 
						cd_historico_rev_antec, 
						ie_origem_classif, 
						vl_perdas, 
						vl_recebido_estrang, 
						vl_complemento, 
						vl_cotacao, 
						cd_moeda, 
						vl_desconto, 
						vl_juros, 
						vl_multa) 
					SELECT	nextval('titulo_rec_liq_cc_seq'), 
						nr_titulo_p, 
						nr_seq_baixa_w, 
						clock_timestamp(), 
						nm_usuario_p, 
						cd_centro_custo, 
						vl_baixa * -1, 
						vl_amaior * -1, 
						clock_timestamp(), 
						nm_usuario_p, 
						cd_cta_ctb_origem, 
						cd_conta_contabil, 
						vl_recebido * -1, 
						cd_conta_deb_pls, 
						cd_conta_rec_pls, 
						nr_seq_mens_seg_item, 
						cd_historico_pls, 
						nr_seq_conta_pls, 
						nr_seq_produto, 
						cd_conta_antec_pls, 
						cd_historico_antec_pls, 
						vl_antecipacao_mens * - 1, 
						vl_pro_rata * - 1, 
						ie_lote_pro_rata, 
						vl_contab_pro_rata * - 1, 
						cd_conta_rec_antecip, 
						cd_conta_deb_antecip, 
						cd_historico_rev_antec, 
						ie_origem_classif, 
						CASE WHEN coalesce(vl_perdas::text, '') = '' THEN null  ELSE (vl_perdas*-1) END , 
						CASE WHEN coalesce(vl_recebido_estrang::text, '') = '' THEN null  ELSE (vl_recebido_estrang * -1) END , --Projeto Multimoeda - grava os valores em moeda estrangeira 
						CASE WHEN coalesce(vl_recebido_estrang::text, '') = '' THEN null  ELSE (vl_complemento * -1) END , 
						CASE WHEN coalesce(vl_recebido_estrang::text, '') = '' THEN null  ELSE vl_cotacao END , 
						CASE WHEN coalesce(vl_recebido_estrang::text, '') = '' THEN null  ELSE cd_moeda END , 
						vl_desconto * -1, 
						vl_juros * -1, 
						vl_multa * -1 
					from	titulo_rec_liq_cc 
					where	nr_titulo	= nr_titulo_p 
					and	nr_seq_baixa	= nr_seq_liq_origem_w;
		 
		end if;
	 
	end if;
	 
	/*if	(nr_titulo_contab_w is not null) then Retirado essa consistencia devido a ter sido criad a rotina consiste_recalc_classif_tit para consistir sem abortar o recalculo. 
		wheb_mensagem_pck.exibir_mensagem_abort(236517, 'NR_TITULO=' || nr_titulo_contab_w); 
	end if;*/
 
		 
	end;
end loop;
close C01;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE recalcular_titulo_rec_liq_cc (nr_titulo_p bigint, nr_seq_baixa_p bigint, nm_usuario_p text) FROM PUBLIC;
