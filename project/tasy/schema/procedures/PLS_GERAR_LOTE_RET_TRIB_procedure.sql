-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_lote_ret_trib ( nr_seq_lote_p bigint, ie_acao_p text, nm_usuario_p text) AS $body$
DECLARE


cd_pessoa_fisica_w		varchar(10);
vl_liquido_w			double precision;
dt_mes_referencia_w		timestamp;

C01 CURSOR FOR
	SELECT	e.cd_pessoa_fisica,
		sum(b.vl_liquido)
	from	pls_prestador			e,
		pls_lote_pagamento		d,
		pls_pagamento_prestador		c,
		pls_pag_prest_vencimento	b,
		pls_pag_prest_venc_trib		a,
		tributo				z
	where	a.nr_seq_vencimento	= b.nr_sequencia
	and	b.nr_seq_pag_prestador	= c.nr_sequencia
	and	c.nr_seq_lote		= d.nr_sequencia
	and	c.nr_seq_prestador	= e.nr_sequencia
	and	z.cd_tributo		= a.cd_tributo
	and	z.ie_situacao		= 'A'
	and	z.ie_tipo_tributo in ('INSS','IR','IRPF')
	and	(e.cd_pessoa_fisica IS NOT NULL AND e.cd_pessoa_fisica::text <> '')
	and	(d.dt_geracao_titulos IS NOT NULL AND d.dt_geracao_titulos::text <> '')
	and	(((z.ie_venc_pls_pag_prod IS NOT NULL AND z.ie_venc_pls_pag_prod::text <> '') and (CASE WHEN ie_venc_pls_pag_prod='V' THEN b.dt_vencimento  ELSE d.dt_mes_competencia END  between trunc(dt_mes_referencia_w,'month') and fim_dia(last_day(dt_mes_referencia_w)))) or
		CASE WHEN z.ie_vencimento='V' THEN b.dt_vencimento WHEN z.ie_vencimento='C' THEN b.dt_vencimento  ELSE d.dt_mes_competencia END  between trunc(dt_mes_referencia_w,'month') and fim_dia(last_day(dt_mes_referencia_w)))
	group by
		e.cd_pessoa_fisica;


BEGIN

if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then
	select	a.dt_mes_referencia
	into STRICT	dt_mes_referencia_w
	from	pls_lote_retencao_trib a
	where	a.nr_sequencia	= nr_seq_lote_p;

	if (ie_acao_p = 'G') then
		open C01;
		loop
		fetch C01 into
			cd_pessoa_fisica_w,
			vl_liquido_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			insert into pls_lote_ret_trib_prest(nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nr_seq_lote,
				nr_seq_prestador,
				cd_pessoa_fisica)
			values (nextval('pls_lote_ret_trib_prest_seq'),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nr_seq_lote_p,
				null,
				cd_pessoa_fisica_w);
			end;
		end loop;
		close C01;
	else
		update	pls_pag_prest_venc_trib a
		set	nr_seq_lote_ret_trib_valor 	 = NULL,
			nm_usuario			= nm_usuario_p,
			dt_atualizacao			= clock_timestamp()
		where	exists (SELECT	1
				from	pls_lote_ret_trib_valor x,
					pls_lote_ret_trib_prest y
				where	y.nr_sequencia 	= x.nr_seq_trib_prest
				and	x.nr_sequencia 	= a.nr_seq_lote_ret_trib_valor
				and	y.nr_seq_lote 	= nr_seq_lote_p);

		delete from pls_lote_ret_trib_val_dif a
		where	exists (SELECT	1
				from	pls_lote_ret_trib_prest x
				where	x.nr_seq_lote	= nr_seq_lote_p
				and	x.nr_sequencia	= a.nr_seq_trib_prest);

		delete from pls_lote_ret_trib_valor a
		where	exists (SELECT	1
				from	pls_lote_ret_trib_prest x
				where	x.nr_seq_lote	= nr_seq_lote_p
				and	x.nr_sequencia	= a.nr_seq_trib_prest);

		delete from pls_lote_ret_trib_prest
		where nr_seq_lote	= nr_seq_lote_p;
	end if;

	update	pls_lote_retencao_trib
	set	dt_geracao	= CASE WHEN ie_acao_p='G' THEN clock_timestamp()  ELSE null END
	where	nr_sequencia	= nr_seq_lote_p;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_lote_ret_trib ( nr_seq_lote_p bigint, ie_acao_p text, nm_usuario_p text) FROM PUBLIC;
