-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_titulo_ir (NR_TITULO_P bigint, NR_SEQ_BAIXA_P bigint, NM_USUARIO_P text, IE_COMMIT_P text default 'S') AS $body$
DECLARE

 
CD_BENEFICIARIO_IR_W			varchar(0014)	:= '';
CD_ESTABELECIMENTO_W			smallint	:= 0;
cd_estab_financeiro_w			smallint	:= 0;

CD_MOEDA_W				integer	:= 0;
VL_IR_W				double precision	:= 0;
NR_TITULO_W				bigint	:= 0;

 

BEGIN 
 
SELECT	a.VL_IR, 
	b.cd_estabelecimento, 
	c.CD_BENEFICIARIO_IR, 
	c.CD_MOEDA_PADRAO 
INTO STRICT	VL_IR_W, 
	cd_estabelecimento_w, 
	CD_BENEFICIARIO_IR_W, 
	CD_MOEDA_W 
FROM	PARAMETROS_CONTAS_PAGAR c, 
	titulo_pagar b, 
	TITULO_PAGAR_BAIXA a 
WHERE	a.NR_TITULO		= NR_TITULO_P 
AND	a.NR_SEQUENCIA	= NR_SEQ_BAIXA_P 
and	a.nr_titulo		= b.nr_titulo 
and	c.cd_estabelecimento	= b.cd_estabelecimento;
 
select	coalesce(cd_estab_financeiro, cd_estabelecimento) 
into STRICT	cd_estab_financeiro_w 
from	estabelecimento 
where	cd_estabelecimento	= cd_estabelecimento_w;
 
IF (VL_IR_W <> 0) THEN 
  BEGIN 
  SELECT nextval('titulo_pagar_seq') 
  INTO STRICT NR_TITULO_W 
;	
	 
  /* Ricardo 05/04/2006 - A pedido do Marcus, incluí em todos os inserts da Titulo Pagar o campo NR_LOTE_TRANSF_TRIB como 0 (zero) */
 
 
  INSERT INTO TITULO_PAGAR( 
		NR_TITULO, 
		CD_ESTABELECIMENTO, 
		DT_ATUALIZACAO, 
		NM_USUARIO, 
		DT_EMISSAO, 
		DT_VENCIMENTO_ORIGINAL, 
		DT_VENCIMENTO_ATUAL, 
		VL_TITULO, 
		VL_SALDO_TITULO, 
		VL_SALDO_JUROS, 
		VL_SALDO_MULTA, 
		CD_MOEDA, 
		TX_JUROS, 
		TX_MULTA, 
		CD_TIPO_TAXA_JURO, 
		CD_TIPO_TAXA_MULTA, 
		TX_DESC_ANTECIPACAO, 
		DT_LIMITE_ANTECIPACAO, 
		VL_DIA_ANTECIPACAO, 
		CD_TIPO_TAXA_ANTECIPACAO, 
		IE_SITUACAO, 
		IE_ORIGEM_TITULO, 
		IE_TIPO_TITULO, 
		NR_SEQ_NOTA_FISCAL, 
		CD_PESSOA_FISICA, 
		CD_CGC, 
		NR_DOCUMENTO, 
		NR_BLOQUETO, 
		DT_LIQUIDACAO, 
		NR_LOTE_CONTABIL, 
		DS_OBSERVACAO_TITULO, 
		NR_BORDERO, 
		VL_BORDERO, 
		VL_JUROS_BORDERO, 
		VL_MULTA_BORDERO, 
		VL_DESCONTO_BORDERO, 
		IE_DESCONTO_DIA, 
		NR_TITULO_ORIGINAL, 
		NR_PARCELAS, 
		NR_TOTAL_PARCELAS, 
		DT_CONTABIL, 
		ie_status_tributo, 
		NR_LOTE_TRANSF_TRIB, 
		cd_estab_financeiro, 
		ie_status) 
	VALUES (NR_TITULO_W, 
		CD_ESTABELECIMENTO_W, 
		TRUNC(clock_timestamp()), 
		NM_USUARIO_P, 
		TRUNC(clock_timestamp()), 
		TRUNC(clock_timestamp()), 
		TRUNC(clock_timestamp()), 
		VL_IR_W, 
		VL_IR_W, 
		0, 
		0, 
		CD_MOEDA_W, 
		0, 
		0, 
		1, 
		1, 
		0, 
		NULL, 
		NULL, 
		1, 
		'A', 
		2, 
		1, 
		NULL, 
		NULL, 
		CD_BENEFICIARIO_IR_W, 
		NULL, 
		NULL, 
		NULL, 
		NULL, 
		NULL, 
		NULL, 
		NULL, 
		NULL, 
		NULL, 
		NULL, 
		'S', 
		NR_TITULO_P, 
		NULL, 
		NULL, 
		TRUNC(clock_timestamp()), 
		'NT', 
		0, 
		cd_estab_financeiro_w, 
		'D');
	CALL ATUALIZAR_INCLUSAO_TIT_PAGAR(NR_TITULO_W, nm_usuario_p);
  END;
END IF;
 
if (coalesce(IE_COMMIT_P,'S') = 'S') then 
	COMMIT;
end if;	
	 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_titulo_ir (NR_TITULO_P bigint, NR_SEQ_BAIXA_P bigint, NM_USUARIO_P text, IE_COMMIT_P text default 'S') FROM PUBLIC;

