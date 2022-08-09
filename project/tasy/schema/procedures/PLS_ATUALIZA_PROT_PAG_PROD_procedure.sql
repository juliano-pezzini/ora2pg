-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualiza_prot_pag_prod ( nr_titulo_p titulo_pagar.nr_titulo%type, nr_seq_vencimento_p pls_pag_prest_vencimento.nr_sequencia%type, nm_usuario_p text) AS $body$
DECLARE



nr_seq_protocolo_w		bigint;
nr_seq_pag_prestador_w		bigint;
vl_saldo_titulos_w		double precision;
ie_status_w			varchar(2);
nr_seq_lote_w			bigint;
qt_conta_sem_pagto_w		integer;
qt_contas_fechadas_w		bigint;
nr_seq_prot_referencia_w	pls_protocolo_conta.nr_seq_prot_referencia%type;
qt_registros_w			integer;

C01 CURSOR FOR
	SELECT nr_sequencia
	from pls_protocolo_conta p
	where exists (
			SELECT	1
				from	pls_conta_medica_resumo		c,
					pls_pagamento_prestador		b,
					pls_pag_prest_vencimento	a
				where	c.nr_seq_prestador_pgto	= b.nr_seq_prestador
				and	b.nr_seq_lote           = c.nr_seq_lote_pgto
				and	a.nr_seq_pag_prestador	= b.nr_sequencia
				and	a.nr_titulo		= nr_titulo_p
				and	c.ie_situacao = 'A'
				and	(nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '')
				and 	p.nr_sequencia = c.nr_seq_protocolo
				
union all

				select	 1
				from	pls_conta_medica_resumo		c,
					pls_pagamento_prestador		b,
					pls_pag_prest_vencimento	a
				where	c.nr_seq_prestador_pgto	= b.nr_seq_prestador
				and	b.nr_seq_lote           = c.nr_seq_lote_pgto
				and	a.nr_seq_pag_prestador	= b.nr_sequencia
				and	a.nr_sequencia		= nr_seq_vencimento_p
				and	c.ie_situacao = 'A'
				and	(nr_seq_vencimento_p IS NOT NULL AND nr_seq_vencimento_p::text <> '')
				and 	p.nr_sequencia = c.nr_seq_protocolo);



BEGIN

open C01;
loop
fetch C01 into
	nr_seq_protocolo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	vl_saldo_titulos_w := 0;

	select	coalesce(sum(d.vl_saldo_titulo),0)
	into STRICT	vl_saldo_titulos_w
	from	titulo_pagar			d,
		pls_pag_prest_vencimento	a,
		pls_pagamento_prestador		b,
		pls_conta_medica_resumo		c
	where	a.nr_seq_pag_prestador	= b.nr_sequencia
	and	c.nr_seq_prestador_pgto	= b.nr_seq_prestador
	and	a.nr_titulo		= d.nr_titulo
	and	b.nr_seq_lote           = c.nr_seq_lote_pgto
	and	c.nr_seq_protocolo	= nr_seq_protocolo_w
	and	c.ie_situacao 		= 'A';

	select	count(1)
	into STRICT	qt_conta_sem_pagto_w
	from	pls_conta_medica_resumo a,
		pls_conta b
	where	b.nr_sequencia		= a.nr_seq_conta
	and	b.nr_seq_protocolo	= nr_seq_protocolo_w
	and	b.ie_status		!= 'C'
	and	a.ie_situacao		= 'A'
	and	a.ie_tipo_item		!= 'I'
	and	coalesce(a.nr_seq_lote_pgto::text, '') = '';

	--aaschlote 19/03/2015 OS 860619 - Não permite mudar o status para pago caso tenha contas que não estejam fechadas, canceladas ou A700 finalizado
	select	count(1)
	into STRICT	qt_contas_fechadas_w
	from	pls_conta
	where	nr_seq_protocolo	= nr_seq_protocolo_w
	and	ie_status		not in ('F','C','S');

	if (qt_conta_sem_pagto_w = 0) and (qt_contas_fechadas_w = 0) then
		if (vl_saldo_titulos_w = 0) then
			update	pls_protocolo_conta
			set	ie_status	= '6' --pago
			where	nr_sequencia	= nr_seq_protocolo_w
			and	ie_status	<> '4'; -- 4 = Encerrado sem pagamento
			--Verifica se o protocolo tem um protocolo principal
			select	max(nr_seq_prot_referencia)
			into STRICT	nr_seq_prot_referencia_w
			from	pls_protocolo_conta
			where	nr_sequencia	= nr_seq_protocolo_w;

			--Verifica se o protocolo o protocolo principal tem contá médica resumo
			if (nr_seq_prot_referencia_w IS NOT NULL AND nr_seq_prot_referencia_w::text <> '') then
				select	count(1)
				into STRICT	qt_registros_w
				from	pls_conta_medica_resumo
				where	nr_seq_protocolo	= nr_seq_prot_referencia_w
				and	ie_situacao		= 'A';

				if (qt_registros_w = 0) then
					update	pls_protocolo_conta
					set	ie_status	= '6' --pago
					where	nr_sequencia	= nr_seq_prot_referencia_w
					and	ie_status	<> '4'; -- 4 = Encerrado sem pagamento
				end if;
			end if;
		else
			update	pls_protocolo_conta
			set	ie_status	= '3' --Liberado pagamento
			where	nr_sequencia	= nr_seq_protocolo_w
			and	ie_status	<> '4'; -- 4 = Encerrado sem pagamento
			--Verifica se o protocolo tem um protocolo principal
			select	max(nr_seq_prot_referencia)
			into STRICT	nr_seq_prot_referencia_w
			from	pls_protocolo_conta
			where	nr_sequencia	= nr_seq_protocolo_w;

			--Verifica se o protocolo o protocolo principal tem contá médica resumo
			if (nr_seq_prot_referencia_w IS NOT NULL AND nr_seq_prot_referencia_w::text <> '') then
				select	count(1)
				into STRICT	qt_registros_w
				from	pls_conta_medica_resumo
				where	nr_seq_protocolo	= nr_seq_prot_referencia_w
				and	ie_situacao		= 'A';

				if (qt_registros_w = 0) then
					update	pls_protocolo_conta
					set	ie_status	= '3' --Liberado pagamento
					where	nr_sequencia	= nr_seq_prot_referencia_w
					and	ie_status	<> '4'; -- 4 = Encerrado sem pagamento
				end if;
			end if;

		end if;
	end if;

	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualiza_prot_pag_prod ( nr_titulo_p titulo_pagar.nr_titulo%type, nr_seq_vencimento_p pls_pag_prest_vencimento.nr_sequencia%type, nm_usuario_p text) FROM PUBLIC;
