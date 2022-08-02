-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_estornar_amortizacao ( nr_titulo_p bigint, nr_seq_baixa_estornada_p bigint, nr_seq_baixa_estorno_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_sequencia_w			integer;
nr_seq_liq_amortizacao_w	integer;
nr_seq_amortiz_anterior_w	bigint;
nr_seq_amortizacao_w		bigint;


BEGIN 
 
if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') and (nr_seq_baixa_estornada_p IS NOT NULL AND nr_seq_baixa_estornada_p::text <> '') and (nr_seq_baixa_estorno_p IS NOT NULL AND nr_seq_baixa_estorno_p::text <> '') then 
	 
	select	max(nr_seq_liq_amortizacao), 
		max(nr_seq_amortizacao) 
	into STRICT	nr_seq_liq_amortizacao_w, 
		nr_seq_amortiz_anterior_w 
	from	titulo_receber_liq a 
	where	a.nr_titulo	= nr_titulo_p 
	and	a.nr_sequencia	= nr_seq_baixa_estornada_p;
	 
	if (nr_seq_liq_amortizacao_w IS NOT NULL AND nr_seq_liq_amortizacao_w::text <> '') or (nr_seq_amortiz_anterior_w IS NOT NULL AND nr_seq_amortiz_anterior_w::text <> '') then -- Caso seja estornada a própria baixa de amortização 
	 
		if (coalesce(nr_seq_amortiz_anterior_w::text, '') = '') then 
			select	max(nr_seq_amortizacao) 
			into STRICT	nr_seq_amortiz_anterior_w 
			from	titulo_receber_liq a 
			where	a.nr_titulo	= nr_titulo_p 
			and	a.nr_sequencia	= nr_seq_liq_amortizacao_w;
		end if;
		 
		-- Gerar amortização 
		select	nextval('pls_pagador_amortizacao_seq') 
		into STRICT	nr_seq_amortizacao_w 
		;
 
		insert	into	pls_pagador_amortizacao(nr_sequencia, 
			nm_usuario, 
			dt_atualizacao, 
			nm_usuario_nrec, 
			dt_atualizacao_nrec, 
			nr_seq_contrato, 
			nr_seq_pagador, 
			nr_titulo_origem, 
			dt_amortizacao, 
			vl_amortizado) 
		SELECT	nr_seq_amortizacao_w, 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nr_seq_contrato, 
			nr_seq_pagador, 
			nr_titulo_p, 
			dt_amortizacao, 
			vl_amortizado * -1 
		from	pls_pagador_amortizacao 
		where	nr_sequencia	= nr_seq_amortiz_anterior_w;
		 
		if (nr_seq_liq_amortizacao_w IS NOT NULL AND nr_seq_liq_amortizacao_w::text <> '') then 
			select	coalesce(max(nr_sequencia),0) + 1 
			into STRICT	nr_sequencia_w 
			from	titulo_receber_liq 
			where	nr_titulo	= nr_titulo_p;
		 
			insert into titulo_receber_liq(nr_titulo, 
				nr_sequencia, 
				nm_usuario, 
				dt_atualizacao, 
				dt_recebimento, 
				vl_recebido, 
				vl_descontos, 
				vl_juros, 
				vl_multa, 
				cd_moeda, 
				cd_tipo_recebimento, 
				vl_rec_maior, 
				vl_glosa, 
				ie_lib_caixa, 
				ds_observacao, 
				nr_seq_amortizacao, 
				ie_acao, 
				nr_seq_trans_fin, 
				nr_lote_contab_antecip, 
				nr_lote_contab_pro_rata, 
				nr_lote_contabil) 
			SELECT	nr_titulo_p, 
				nr_sequencia_w, 
				nm_usuario_p, 
				clock_timestamp(), 
				dt_recebimento, 
				vl_recebido * -1, 
				0, 
				0, 
				0, 
				cd_moeda, 
				cd_tipo_recebimento, 
				0, 
				0, 
				'S', 
				substr(wheb_mensagem_pck.get_texto(303775),1,255), 
				nr_seq_amortizacao_w, 
				'I', 
				nr_seq_trans_fin, 
				0, 
				0, 
				0 
			from	titulo_receber_liq a 
			where	a.nr_titulo	= nr_titulo_p 
			and	a.nr_sequencia	= nr_seq_liq_amortizacao_w;
			 
			CALL atualizar_saldo_tit_rec(nr_titulo_p, nm_usuario_p); -- AAMFIRMO OS 624010 atualizar saldo do titulo quando a baixa de amortização for estornada. 
									--Dentro desta procedure chama outras procedures que possuem commit, mas recebem parametros como N, para n comitar. 
		end if;
	end if;
end if;
 
/* Não pode commitar */
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_estornar_amortizacao ( nr_titulo_p bigint, nr_seq_baixa_estornada_p bigint, nr_seq_baixa_estorno_p bigint, nm_usuario_p text) FROM PUBLIC;

