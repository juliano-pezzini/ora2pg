-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_pgto_escritutal_prod_med ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_prestador_w		bigint;
nr_seq_conta_banco_w		bigint;
nr_seq_regra_w			bigint;
nr_seq_pagamento_prestador_w	bigint;
cd_agencia_bancaria_w		bigint;
cd_conta_w			bigint;
ie_digito_conta_w		bigint;
nr_titulo_w			bigint;
nr_seq_escritura_w		bigint;
vl_liquido_w			double precision;
cd_camara_compensacao_w		bigint;
cd_banco_w			bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_prestador
	from	pls_pagamento_prestador
	where	nr_seq_lote	= nr_seq_lote_p;

C02 CURSOR FOR
	SELECT	distinct(nr_seq_conta_banco)
	from	pls_pagamento_prestador
	where	nr_seq_lote	= nr_seq_lote_p
	and	coalesce(ie_cancelamento::text, '') = '';

C03 CURSOR FOR
	SELECT	b.nr_titulo,
		b.vl_liquido
	from	pls_pagamento_prestador a,
		pls_pag_prest_vencimento b
	where	b.nr_seq_pag_prestador	= a.nr_sequencia
	and	coalesce(a.ie_cancelamento::text, '') = ''
	and	a.nr_seq_lote		= nr_seq_lote_p
	and	a.nr_seq_conta_banco	= nr_seq_conta_banco_w;


BEGIN

if (pls_obter_existe_pgto_escrit(nr_seq_lote_p) = 'S') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 267209, null ); /* Já existe um pagamento escritural para o lote selecionado. */
end if;

/*Obter os prstadores do lote e atualiza o campo refernte ao banco do mesmo */

open C01;
loop
fetch C01 into
	nr_seq_pagamento_prestador_w,
	nr_seq_prestador_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	SELECT * FROM pls_obter_regra_pgto_prest(nr_seq_prestador_w, nm_usuario_p, cd_estabelecimento_p, nr_seq_conta_banco_w, nr_seq_regra_w) INTO STRICT nr_seq_conta_banco_w, nr_seq_regra_w;

	update	pls_pagamento_prestador
	set	nr_seq_conta_banco = nr_seq_conta_banco_w
	where	nr_sequencia = nr_seq_pagamento_prestador_w;

	end;
end loop;
close C01;


/*Deve-ser criado um lote de pagamento escritural para cada BANCO verificado nos prestador do lote de produção médica*/

open C02;
loop
fetch C02 into
	nr_seq_conta_banco_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin

	select	nextval('banco_escritural_seq')
	into STRICT	nr_seq_escritura_w
	;

	select	max(cd_banco)
	into STRICT	cd_banco_w
	from	banco_estabelecimento
	where	nr_sequencia = nr_seq_conta_banco_w;

	if (coalesce(cd_banco_w::text, '') = '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(158746);
	end if;

	insert into banco_escritural(nr_sequencia, dt_atualizacao, dt_atualizacao_nrec,
		 nm_usuario, nm_usuario_nrec, nr_seq_conta_banco,
		 dt_remessa_retorno, ie_remessa_retorno, cd_banco,
		 cd_estabelecimento, ie_cobranca_pagto, nr_seq_lote_pag_prest)
	values (nr_seq_escritura_w, clock_timestamp(), clock_timestamp(),
		 nm_usuario_p, nm_usuario_p, nr_seq_conta_banco_w,
		 clock_timestamp(), 'R', cd_banco_w,
		 cd_estabelecimento_p, 'C', nr_seq_lote_p);

	/*Pegar os vencimentos dos prestadores do lote de produção  e  incluir naa cobrança escritural*/

	open C03;
	loop
	fetch C03 into
		nr_titulo_w,
		vl_liquido_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		CALL Gerar_Titulo_Escritural(nr_titulo_w, nr_seq_escritura_w, nm_usuario_p);
		end;
	end loop;
	close C03;

	end;
end loop;
close C02;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pgto_escritutal_prod_med ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

