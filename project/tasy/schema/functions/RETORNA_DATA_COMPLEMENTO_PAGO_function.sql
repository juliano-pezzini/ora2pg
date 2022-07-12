-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION retorna_data_complemento_pago (nr_seq_nota_p bigint, nr_titulo_p bigint, nr_seq_liq_p bigint, nr_item_p bigint default 0) RETURNS varchar AS $body$
DECLARE

data_complemento_pago varchar(255);
nr_seq_retorno_w bigint;
nr_seq_cheque_w bigint;
nr_seq_nota_original_w 	nota_fiscal.nr_sequencia%type;
qt_baixa_nao_ident_w	bigint;


BEGIN
	/*verifica convenio*/
	select 	coalesce(b.nr_seq_retorno,0)
		into STRICT	nr_seq_retorno_w
	from   	titulo_receber a,
		titulo_receber_liq b
	where	a.nr_titulo = b.nr_titulo
	and     a.nr_titulo = nr_titulo_p
	and     b.nr_sequencia = nr_seq_liq_p;
	/*verifica cheque*/

	SELECT	coalesce(MAX(NR_SEQ_CHEQUE),0)
	into STRICT	nr_seq_cheque_w
	FROM	titulo_receber_liq a,
	caixa_receb b,
	CHEQUE_CR c
	WHERE	a.nr_seq_caixa_rec = b.nr_sequencia
	AND	c.nr_seq_caixa_rec = b.nr_sequencia
	AND a.nr_sequencia = nr_seq_liq_p
	AND a.nr_titulo = nr_titulo_p;
	
	select	nr_sequencia_ref
	into STRICT	nr_seq_nota_original_w
	from	nota_fiscal
	where	nr_sequencia = nr_seq_nota_p;
	
	select 	count(*)
	into STRICT	qt_baixa_nao_ident_w
	from 	titulo_receber a,
		titulo_receber_liq b,
		movto_banco_pend_baixa c,
		movto_banco_pend  d		
	where	nr_seq_nf_saida = nr_seq_nota_original_w
	and	a.nr_titulo = b.nr_titulo
	and	b.nr_titulo = c.nr_titulo
	and	c.nr_seq_baixa = b.nr_sequencia
	and	c.nr_seq_movto_pend = d.nr_sequencia;
	
	if (qt_baixa_nao_ident_w > 0)then
		select 	TO_CHAR(max(d.dt_credito), 'yyyy-mm-dd') || 'T' || TO_CHAR(max(d.dt_credito), 'hh24:mi:ss')
		into STRICT	data_complemento_pago
		from 	titulo_receber a,
			titulo_receber_liq b,
			movto_banco_pend_baixa c,
			movto_banco_pend  d		
		where	nr_seq_nf_saida = nr_seq_nota_original_w
		and	a.nr_titulo = b.nr_titulo
		and	b.nr_titulo = c.nr_titulo
		and	c.nr_seq_baixa = b.nr_sequencia
		and	c.nr_seq_movto_pend = d.nr_sequencia;
	elsif (nr_seq_retorno_w > 0) then		
		select To_char(max(a.dt_recebimento), 'yyyy-mm-dd') || 'T' || To_char(max(a.dt_recebimento), 'hh24:mi:ss') data
		into STRICT data_complemento_pago
		from CONVENIO_RECEB a,
		CONVENIO_RET_RECEB b
		where b.nr_seq_retorno = nr_seq_retorno_w
		and  a.nr_sequencia = b.nr_seq_receb;		
	elsif (nr_seq_cheque_w > 0) then
		SELECT	To_char(b.DT_RECEBIMENTO, 'yyyy-mm-dd') || 'T' || To_char(b.DT_RECEBIMENTO, 'hh24:mi:ss') data
		into STRICT	data_complemento_pago
		FROM	titulo_receber_liq a,
		caixa_receb b,
		CHEQUE_CR c
		WHERE	a.nr_seq_caixa_rec = b.nr_sequencia
		AND	c.nr_seq_caixa_rec = b.nr_sequencia
		AND a.nr_sequencia = nr_seq_liq_p
		AND a.nr_titulo = nr_titulo_p;
	else	
		
		select 	max(data_w)
			into STRICT data_complemento_pago
		from (
			
			SELECT  TO_CHAR(d.dt_recebimento, 'yyyy-mm-dd') || 'T' || TO_CHAR(d.dt_recebimento, 'hh24:mi:ss') data_w
			FROM  	nota_fiscal  a,
				nota_fiscal  b,
				titulo_receber c,
				titulo_receber_liq d,
				tipo_recebimento e
			WHERE 	a.nr_sequencia    = b.nr_sequencia_ref
			AND     c.nr_seq_nf_saida = a.nr_sequencia
			AND     c.nr_titulo       = d.nr_titulo
			AND     d.nr_sequencia    = b.nr_seq_baixa_tit
			AND	d.cd_tipo_recebimento = e.cd_tipo_recebimento
			AND   	b.nr_sequencia    = nr_seq_nota_p
			
union

			SELECT  TO_CHAR(d.dt_recebimento, 'yyyy-mm-dd') || 'T' || TO_CHAR(d.dt_recebimento, 'hh24:mi:ss') data_w
			FROM  	nota_fiscal_item b,
				titulo_receber c,
				titulo_receber_liq d,
				tipo_recebimento e
			WHERE 	c.nr_titulo     = d.nr_titulo
			AND	d.cd_tipo_recebimento = e.cd_tipo_recebimento
			AND   	d.nr_sequencia  = nr_seq_liq_p
			and	c.nr_titulo 	= nr_titulo_p
			and	c.nr_titulo	= b.nr_titulo
			and	b.nr_sequencia  = nr_seq_nota_p
			and	b.nr_item_nf	= nr_item_p
				
		) alias5;
		
		
	end if;
return data_complemento_pago;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION retorna_data_complemento_pago (nr_seq_nota_p bigint, nr_titulo_p bigint, nr_seq_liq_p bigint, nr_item_p bigint default 0) FROM PUBLIC;
