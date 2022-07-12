-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerar_contas_ted.med_ocupacional_arquivo ( nr_seq_lote_p pls_ted_conta_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


ds_local_w			varchar(255) := null;


c01 CURSOR(nr_seq_lote_pc	pls_ted_conta_lote.nr_sequencia%type)  FOR
SELECT	rpad(substr(pls_obter_dados_segurado(b.nr_seq_segurado,'N'),1,40),40,' ')||
	rpad(coalesce(b.cd_matricula_benef, ' '),10,' ')||
	rpad(substr(pls_obter_dados_prestador(nr_seq_prest_exec,'CD'),1,40)||' - '||substr(pls_obter_dados_prestador(nr_seq_prest_exec,'N'),1,40),40,' ')||
	rpad(c.cd_item,10,' ')||
	rpad(to_char(c.dt_item,'dd/mm/yyyy'),10,' ')||
	lpad(replace(campo_mascara_virgula(c.vl_item),'.',''),12,'0')||
	lpad(replace(campo_mascara_virgula(b.valor_total_benef),'.',''),12,'0')||
	lpad(replace(campo_mascara_virgula(a.vl_total_conta),'.',''),12,'0')||
	lpad(replace(campo_mascara_virgula(a.vl_total_reemb),'.',''),12,'0')||
	lpad(replace(campo_mascara_virgula(a.vl_total_geral),'.',''),12,'0')||
	rpad(trim(both replace(a.ds_valor_extenso,'.','')),130,' ') ds_linha
from	pls_ted_conta_lote a,
	pls_ted_conta_benef b,
	pls_ted_conta_dados c
where	b.nr_seq_lote_ted_cta = a.nr_sequencia
and	c.nr_seq_lote_ted_benef = b.nr_sequencia
and	a.nr_sequencia = nr_seq_lote_pc;

BEGIN

begin
ds_local_w := pls_utl_file_pck.novo_arquivo(33, 'med_ocupacional'||to_char(clock_timestamp(), 'ddmmyyyyhh24miss')||'.txt', 'S', null, ds_local_w, 'U');
exception
when others then
	ds_local_w := null;
end;

for r_c01_w in c01( nr_seq_lote_p ) loop
	CALL pls_utl_file_pck.escrever(r_c01_w.ds_linha);
end loop;

CALL pls_utl_file_pck.fechar_arquivo();

update pls_ted_conta_lote
   set dt_geracao_arquivo = clock_timestamp() 
 where nr_sequencia = nr_seq_lote_p 
   and cd_estabelecimento = cd_estabelecimento_p;
commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_contas_ted.med_ocupacional_arquivo ( nr_seq_lote_p pls_ted_conta_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;