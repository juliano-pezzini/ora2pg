-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_lote_pagamento ( nr_seq_lote_p pls_lote_pagamento.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

				
ie_status_w			varchar(1);
nr_seq_lote_evento_w		bigint;
nr_seq_lote_plant_w		bigint;
nr_seq_franq_pag_w 		pls_franq_pag_prest.nr_seq_franq_pag%type;
qt_lote_evento_pag_w		integer;
nr_seq_conta_com_rec_w		pls_conta.nr_sequencia%type;

c01 CURSOR FOR
	SELECT	a.nr_sequencia nr_seq_nota,
		a.ie_situacao,
		b.nr_sequencia nr_seq_pag_prest
	from	pls_pagamento_prestador b,
		nota_fiscal a
	where	a.nr_seq_pgto_prest	= b.nr_sequencia
	and	b.nr_seq_lote		= nr_seq_lote_p;

C02 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_pagamento_prestador a
	where	a.nr_seq_lote		= nr_seq_lote_p;
	
C03 CURSOR FOR		
	SELECT	a.nr_sequencia,
		a.nr_seq_lote_plant
	from	pls_lote_evento a
	where	nr_seq_lote_pagamento	= nr_seq_lote_p
	and	ie_origem 		= 'A';
	
c04 CURSOR FOR
	SELECT	c.nr_titulo,
		c.nr_sequencia,
		d.vl_titulo,
		d.vl_saldo_titulo
	from	titulo_receber 		d,
		titulo_receber_liq	c,
		pls_pagamento_item 	b,
		pls_pagamento_prestador a
	where	a.nr_sequencia		= b.nr_seq_pagamento
	and	b.nr_sequencia		= c.nr_seq_pag_item
	and	c.nr_titulo		= d.nr_titulo
	and	a.nr_seq_lote 		= nr_seq_lote_p;

c05 CURSOR FOR
	SELECT	a.nr_sequencia
	from 	pls_pagamento_item a
	where	a.nr_seq_pagamento in (	SELECT x.nr_sequencia
					from pls_pagamento_prestador x 
					where x.nr_seq_lote = nr_seq_lote_p);
BEGIN
dbms_application_info.SET_ACTION('PLS_DESFAZER_LOTE_PAGAMENTO');

-- levanta se existe alguma conta do lote com um recurso de glosa nao cancelado
select	max(a.nr_seq_conta)
into STRICT	nr_seq_conta_com_rec_w
from	pls_conta_medica_resumo	a
where	a.nr_seq_lote_pgto	= nr_seq_lote_p
and	a.ie_situacao		= 'A'
and	exists (	SELECT	1
		from	pls_rec_glosa_conta	x
		where	x.nr_seq_conta		= a.nr_seq_conta
		and	x.ie_status		in ('1','2'));
		
if (nr_seq_conta_com_rec_w IS NOT NULL AND nr_seq_conta_com_rec_w::text <> '') then

	CALL wheb_mensagem_pck.exibir_mensagem_abort(991405, 'NR_SEQ_CONTA='||to_char(nr_seq_conta_com_rec_w));
end if;

for r_c02_w in c02 loop

	delete 	FROM pls_pagamento_item_log a
	where	a.nr_seq_pag_prest = r_c02_w.nr_sequencia;
	
	delete	FROM pls_pagamento_anexo
	where	nr_seq_pagamento	= r_c02_w.nr_sequencia;
	
	delete	from pls_escrit_quota_parcela a
	where	exists (SELECT	1
			from	pls_pagamento_item x
			where	x.nr_seq_pagamento 	= r_c02_w.nr_sequencia
			and	a.nr_seq_pag_item	= x.nr_sequencia);
end loop;

select	max(ie_status)
into STRICT	ie_status_w
from	pls_lote_pagamento
where	nr_sequencia	= nr_seq_lote_p;

if (ie_status_w	= 'D') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(203266);
end if;

update	pls_conta_medica_resumo
set	nr_seq_pag_item			 = NULL,
	nr_seq_lote_pgto		 = NULL,
	nr_seq_prest_venc_trib		 = NULL,
	nr_seq_prestador_pgto		= coalesce(nr_seq_prestador_pgto_orig, nr_seq_prestador_pgto),
	nr_seq_prestador_pgto_orig	 = NULL
where	nr_seq_lote_pgto		= nr_seq_lote_p;

update	pls_rec_glosa_proc
set	nr_seq_pag_prest	 = NULL,
	nr_seq_lote_pgto	 = NULL
where	nr_seq_lote_pgto	= nr_seq_lote_p;

update	pls_rec_glosa_mat
set	nr_seq_pag_prest	 = NULL,
	nr_seq_lote_pgto	 = NULL
where	nr_seq_lote_pgto	= nr_seq_lote_p;

update	pls_conta_rec_resumo_item
set	nr_seq_pag_item		 = NULL,
	nr_seq_lote_pgto	 = NULL
where	nr_seq_lote_pgto	= nr_seq_lote_p;
--and	ie_situacao		= 'A';
update	titulo_receber
set	nr_seq_pag_conta_evento	 = NULL
where	nr_seq_pag_conta_evento in (	SELECT	y.nr_sequencia
					from	pls_pagamento_item	y,
						pls_pagamento_prestador x
					where 	x.nr_sequencia	= y.nr_seq_pagamento
					and	x.nr_seq_lote	= nr_seq_lote_p);	

for r_c04_w in c04 loop

	if (r_c04_w.vl_titulo != r_c04_w.vl_saldo_titulo) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(219696, 'NR_TITULO=' || r_c04_w.nr_titulo);
	else
		update	titulo_receber_liq
		set	nr_seq_pag_item	 = NULL
		where	nr_titulo	= r_c04_w.nr_titulo
		and	nr_sequencia	= r_c04_w.nr_sequencia;
		
		CALL cancelar_titulo_receber(r_c04_w.nr_titulo, nm_usuario_p, 'N',clock_timestamp());
	end if;
end loop;

delete	FROM pls_pag_prest_item_resumo a
where	exists (SELECT	1
		from	pls_pagamento_item	x,
			pls_pagamento_prestador	y
		where	y.nr_sequencia 	= x.nr_seq_pagamento
		and	x.nr_sequencia 	= a.nr_seq_item_pagamento
		and	y.nr_seq_lote 	= nr_seq_lote_p);

update 	titulo_pagar_baixa a
set	nr_seq_pag_item  = NULL
where	exists (SELECT	1
		from	pls_pagamento_item	y,
			pls_pagamento_prestador x
		where 	x.nr_sequencia	= y.nr_seq_pagamento		
		and	y.nr_sequencia 	= a.nr_seq_pag_item
		and	x.nr_seq_lote	= nr_seq_lote_p);

update	pls_franq_pag_prest a
set	a.nr_seq_pag_item	 = NULL
where	a.nr_seq_pag_item	in (SELECT	x.nr_sequencia
	from	pls_pagamento_item x
	where	x.nr_seq_pagamento in (select	y.nr_sequencia
			from	pls_pagamento_prestador y
			where 	y.nr_seq_lote = nr_seq_lote_p));

/* Desvincular as notas caso estejam canceladas */

for r_c01_w in c01 loop
	
	if (r_c01_w.ie_situacao = '1') then

		CALL estornar_nota_fiscal(r_c01_w.nr_seq_nota, nm_usuario_p);
	end if;
	
	update	nota_fiscal
	set	nr_seq_pgto_prest	 = NULL
	where	nr_sequencia		= r_c01_w.nr_seq_nota;
	
	update	pls_pagamento_prestador
	set	nr_nota_fiscal	 = NULL
	where	nr_sequencia	= r_c01_w.nr_seq_pag_prest;
end loop;

delete	FROM pls_evento_movimento_log a
where	a.nr_seq_lote	= nr_seq_lote_p;

delete	from pls_lote_pagamento_envio
where	nr_seq_pagamento in (
				SELECT	nr_sequencia
				from	pls_pagamento_prestador	a
				where	a.nr_seq_lote 	= nr_seq_lote_p);

delete  FROM pls_lote_pagamento_hist a
where	exists (SELECT	1
		from	pls_pagamento_prestador	x
		where	x.nr_seq_lote	= nr_seq_lote_p
		and	x.nr_sequencia 	= a.nr_seq_pagamento);

delete  FROM pls_pagamento_nota a
where	exists (SELECT	1
		from	pls_pagamento_prestador	x
		where	x.nr_sequencia 	= a.nr_seq_pagamento
		and	x.nr_seq_lote	= nr_seq_lote_p);
		
select	max(b.nr_seq_franq_pag)
into STRICT	nr_seq_franq_pag_w
from	pls_franq_pag_prest b,
	pls_franq_pag_prest_prod a
where	a.nr_seq_franq_pag_prest	= b.nr_sequencia
and	a.nr_seq_pag_prest in (SELECT	x.nr_sequencia
	from	pls_pagamento_prestador x
	where	x.nr_seq_lote	= nr_seq_lote_p);

if (nr_seq_franq_pag_w IS NOT NULL AND nr_seq_franq_pag_w::text <> '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(283036,'NR_SEQ_FRANQ_PAG=' || nr_seq_franq_pag_w);
end if;

update	pls_conta_medica_resumo
set	nr_seq_lote_pgto	 = NULL
where	nr_seq_lote_pgto	= nr_seq_lote_p
and	ie_situacao = 'A';

update	pls_evento_movimento a					-- desvincular todos os eventos que nao foram gerados automaticamente
set	nr_seq_lote_pgto	 = NULL,
	nr_seq_pagamento_item	 = NULL
where	nr_seq_lote_pgto	= nr_seq_lote_p
and	exists (SELECT 	1
		from	pls_lote_evento x
		where	x.nr_sequencia 	= a.nr_seq_lote
		and	x.ie_origem 	<> 'A');

update	pls_lote_pagamento
set	vl_lote			= 0,
	nr_seq_lote_ret_trib	 = NULL
where	nr_sequencia		= nr_seq_lote_p;

/* Desfazer a geracao de lote de movimento gerado automatico */

open C03;
loop
fetch C03 into	
	nr_seq_lote_evento_w,
	nr_seq_lote_plant_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin
	if (coalesce(nr_seq_lote_plant_w::text, '') = '') then
		CALL pls_liberar_lote_evento(nr_seq_lote_evento_w,'D',nm_usuario_p,nr_seq_lote_p,'N');
		
		CALL pls_desfazer_lanc_programados(nr_seq_lote_evento_w, nr_seq_lote_p, nm_usuario_p, 'N');
		
		delete from pls_evento_movimento_log
		where nr_seq_lote = nr_seq_lote_evento_w;
		
		delete from pls_pagamento_item_log
		where nr_seq_lote_pagamento = nr_seq_lote_p;
		
		delete from pls_lote_evento
		where nr_sequencia = nr_seq_lote_evento_w;
	else
		update	pls_lote_evento
		set	nr_seq_lote_pagamento	 = NULL
		where	nr_sequencia 		= nr_seq_lote_evento_w;
		
		update	pls_evento_movimento
		set	nr_seq_lote_pgto 	 = NULL,
			nr_seq_pagamento_item	 = NULL
		where	nr_seq_lote 		= nr_seq_lote_evento_w;
	end if;
	end;
end loop;
close C03;

update	pls_evento_movimento					-- desvincular todos os movimentos de distribuicao de plantonistas, pois o lote de pagamento nao gera evento_movimento de plantonista		
set	nr_seq_lote_pgto	 = NULL,
	nr_seq_pagamento_item	 = NULL
where	nr_seq_lote_pgto	= nr_seq_lote_p
and	(nr_seq_prest_plant_item IS NOT NULL AND nr_seq_prest_plant_item::text <> '');

update	pls_evento_movimento a
set	nr_seq_lote_pgto	 = NULL,
	nr_seq_pagamento_item	 = NULL
where	nr_seq_lote_pgto	= nr_seq_lote_p
and	exists (SELECT 1
		from	pls_lote_evento x
		where	x.nr_sequencia 	= a.nr_seq_lote
		and	x.ie_origem 	= 'M'
		and	coalesce(x.nr_seq_lote_plant::text, '') = '');

update	pls_evento_movimento a
set	nr_seq_lote_pgto	 = NULL,
	nr_seq_pagamento_item	 = NULL
where	nr_seq_lote_pgto	= nr_seq_lote_p
and	exists (SELECT 1
		from	pls_lote_evento x
		where	x.nr_sequencia 	= a.nr_seq_lote
		and	x.ie_origem 	= 'A'
		and	coalesce(x.nr_seq_lote_plant::text, '') = '')
and	coalesce(nr_seq_prest_plant_item::text, '') = '';			-- Edgar, 26/02/2014, ocorrencias de plantonistas nao devem ser deletadas, pois foram geradas ao fechar o lote de distribuicao
		
delete 	from pls_evento_movimento a
where	nr_seq_lote_pgto = nr_seq_lote_p
and	exists (SELECT 1
		from	pls_lote_evento x
		where	x.nr_sequencia 	= a.nr_seq_lote
		and	x.ie_origem 	= 'A'
		and	coalesce(x.nr_seq_lote_plant::text, '') = '')
and	coalesce(nr_seq_prest_plant_item::text, '') = '';			-- Edgar, 26/02/2014, ocorrencias de plantonistas nao devem ser deletadas, pois foram geradas ao fechar o lote de distribuicao

-- percorre todos os itens do pagamento e limpa o vinculo com a tabela evento movimento
for r_c05_w in c05 loop
	update	pls_evento_movimento
	set	nr_seq_lote_pgto	 = NULL,
		nr_seq_pagamento_item	 = NULL
	where	nr_seq_pagamento_item = r_c05_w.nr_sequencia;
end loop;

-- verifica se no lote de evento que foi gerado para este pagamento, existe pelo menos

-- um movimento, caso nao existir deletamos o lote para que o usuario possa excluir o 

-- lote de pagamento quando necessario
select	count(1)
into STRICT	qt_lote_evento_pag_w
from	pls_lote_evento a
where	a.nr_seq_lote_pagamento = nr_seq_lote_p
and	exists (	SELECT 	1
		from	pls_evento_movimento x
		where 	x.nr_seq_lote = a.nr_sequencia)  LIMIT 1;

if (qt_lote_evento_pag_w = 0) then
	select	max(nr_sequencia)
	into STRICT	nr_seq_lote_evento_w
	from	pls_lote_evento
	where	nr_seq_lote_pagamento = nr_seq_lote_p;
	
	update	pls_lote_evento
	set	nr_seq_lote_pagamento  = NULL
	where	nr_sequencia = nr_seq_lote_evento_w;
	
	delete
	from	pls_lote_evento
	where	nr_sequencia = nr_seq_lote_evento_w;
end if;

/* Desfazer os pagamentos, apos a desvinculacao dos movimentos de ocorrencias financeiras */

delete	FROM pls_pagamento_item	a
where	a.nr_seq_pagamento in (	SELECT 	x.nr_sequencia
				from 	pls_pagamento_prestador x 
				where 	x.nr_seq_lote = nr_seq_lote_p);

delete	FROM pls_pagamento_prestador	a
where	a.nr_seq_lote 	= nr_seq_lote_p;

dbms_application_info.SET_ACTION('');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_lote_pagamento ( nr_seq_lote_p pls_lote_pagamento.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

