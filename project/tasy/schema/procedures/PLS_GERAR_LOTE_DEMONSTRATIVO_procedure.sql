-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_lote_demonstrativo ( nr_seq_demonstrativo_p pls_prot_conta_titulo.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


nr_seq_protocolo_w		pls_protocolo_conta.nr_sequencia%type;
dt_mes_competencia_w		timestamp;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
nr_seq_lote_w			pls_lote_protocolo.nr_sequencia%type;
nr_seq_lote_ww			pls_lote_protocolo.nr_sequencia%type;
nr_seq_prestador_w		pls_prestador.nr_sequencia%type;
vl_total_protocolo_w		double precision := 0;
qt_lote_pagto_prot_w		integer;


BEGIN

/* Obter dados do demonstrativo */

select	nr_seq_protocolo,
	nr_seq_prestador,
	coalesce(nr_seq_lote,0)
into STRICT	nr_seq_protocolo_w,
	nr_seq_prestador_w,
	nr_seq_lote_ww
from	pls_prot_conta_titulo
where	nr_sequencia = nr_seq_demonstrativo_p;

if (nr_seq_lote_ww	> 0) then
	--'Já existe lote de pagamento gerado para o demonstrativo! #@#@');
	CALL wheb_mensagem_pck.exibir_mensagem_abort(211295);
end if;

begin
	select 	dt_mes_competencia,
		cd_estabelecimento
	into STRICT	dt_mes_competencia_w,
		cd_estabelecimento_w
	from	pls_protocolo_conta
	where	nr_sequencia = nr_seq_protocolo_w;
exception
	when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(211297,'NR_SEQ_PROTOCOLO=' || nr_seq_protocolo_w);
	--'Protocolo não encontrado (' || nr_seq_protocolo_w || ')#@#@');
end;

select	sum(vl_total)
into STRICT	vl_total_protocolo_w
from	pls_conta
where	nr_seq_protocolo = nr_seq_protocolo_w
and	(vl_total IS NOT NULL AND vl_total::text <> '');

if (vl_total_protocolo_w = 0) then

	CALL wheb_mensagem_pck.exibir_mensagem_abort(211305);
end if;

select	sum(qt)
into STRICT	qt_lote_pagto_prot_w
from (	SELECT	count(1) qt
		from	pls_conta_medica_resumo	y,
			pls_lote_pagamento b
		where	y.nr_seq_protocolo = nr_seq_protocolo_w
		and	y.ie_situacao = 'A'
		and	b.nr_sequencia = y.nr_seq_lote_pgto
		
union all

		SELECT	count(1) qt
		from	pls_conta_medica_resumo	y,
			pls_pp_lote b
		where	y.nr_seq_protocolo = nr_seq_protocolo_w
		and	y.ie_situacao = 'A'
		and	b.nr_sequencia = y.nr_seq_pp_lote 
 LIMIT 1) alias3;

if (qt_lote_pagto_prot_w = 0) then

	insert into pls_lote_protocolo(
		nr_sequencia, cd_estabelecimento, dt_mes_competencia,
		ie_status, dt_atualizacao, nm_usuario,
		dt_atualizacao_nrec, nm_usuario_nrec, nm_lote,
		nr_seq_prestador, nr_nota_fiscal
	) values (
		nextval('pls_lote_protocolo_seq'), cd_estabelecimento_w, dt_mes_competencia_w,
		'P', clock_timestamp(), nm_usuario_p,
		clock_timestamp(), nm_usuario_p, 'Lote gerado para o prestador ' || nr_seq_prestador_w,
		nr_seq_prestador_w, null
	) returning nr_sequencia into nr_seq_lote_w;

	update	pls_prot_conta_titulo
	set	nr_seq_lote	= nr_seq_lote_w
	where	nr_sequencia	= nr_seq_demonstrativo_p;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_lote_demonstrativo ( nr_seq_demonstrativo_p pls_prot_conta_titulo.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
