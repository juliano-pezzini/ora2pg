-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Gerar o lote de retorno do arquivo XML enviado para ANS pela Operadora



CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.gerar_lote_ret_monitor ( cd_ans_p pls_monitor_tiss_lote_ret.cd_ans%type, cd_versao_tiss_p pls_monitor_tiss_lote_ret.cd_versao_tiss%type, dt_geracao_lote_p pls_monitor_tiss_lote_ret.dt_geracao_lote%type, dt_mes_competencia_p pls_monitor_tiss_lote_ret.dt_mes_competencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_lote_p pls_monitor_tiss_lote_ret.nr_lote%type, cd_glosa_p pls_monitor_tiss_glosa.cd_glosa%type, nm_arquivo_p pls_monitor_tiss_lote_ret.nm_arquivo%type, qt_incluido_p pls_monitor_tiss_lote_ret.qt_total_incluido%type, qt_alterado_p pls_monitor_tiss_lote_ret.qt_total_alterado%type, qt_erros_p pls_monitor_tiss_lote_ret.qt_total_erro%type, qt_excluido_p pls_monitor_tiss_lote_ret.qt_total_excluido%type, nr_seq_lote_monitor_ret_p INOUT pls_monitor_tiss_lote_ret.nr_sequencia%type) AS $body$
DECLARE


nr_seq_lote_monitor_w	pls_monitor_tiss_lote.nr_sequencia%type;
nr_seq_lote_com_w	pls_monitor_tiss_lote_com.nr_sequencia%type;
nr_seq_arquivo_w	pls_monitor_tiss_lote_ret.nr_seq_arquivo%type;
nm_arquivo_w		pls_monitor_tiss_lote_ret.nm_arquivo%type;


BEGIN

nm_arquivo_w := UPPER(replace(nm_arquivo_p,'ZTE','XTE'));

-- busca o lote do arquivo

select	max(a.nr_sequencia)
into STRICT	nr_seq_lote_monitor_w
from	pls_monitor_tiss_lote a,
	pls_monitor_tiss_arquivo b
where	a.ie_status = 'LG'
and	b.nr_seq_lote_monitor = a.nr_sequencia
and	b.nm_arquivo = nm_arquivo_w;

-- se no encontrou o lote de origem levando em considerao o arquivo, ento lana uma mensagem de erro

if (coalesce(nr_seq_lote_monitor_w::text, '') = '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(333805);
end if;

select	max(nr_sequencia)
into STRICT	nr_seq_lote_com_w
from	pls_monitor_tiss_lote_com
where	nr_seq_lote_monitor	= nr_seq_lote_monitor_w;

if (coalesce(nr_seq_lote_com_w::text, '') = '') then

	select	nextval('pls_monitor_tiss_lote_com_seq')
	into STRICT	nr_seq_lote_com_w
	;

	insert into pls_monitor_tiss_lote_com(	nr_sequencia,nm_usuario,dt_atualizacao,nm_usuario_nrec,dt_atualizacao_nrec,
			dt_mes_competencia,nr_seq_lote_monitor,cd_estabelecimento,ie_origem_lote)
	values (	nr_seq_lote_com_w,nm_usuario_p,clock_timestamp(),nm_usuario_p,clock_timestamp(),
			dt_mes_competencia_p,nr_seq_lote_monitor_w,cd_estabelecimento_p,'PM');
end if;

select	max(b.nr_sequencia)
into STRICT	nr_seq_arquivo_w
from	pls_monitor_tiss_lote a,
	pls_monitor_tiss_arquivo b
where	a.ie_status = 'LG'
and	b.nr_seq_lote_monitor = a.nr_sequencia
and	b.nm_arquivo = nm_arquivo_w;

insert into pls_monitor_tiss_lote_ret(
	nr_sequencia, cd_ans, cd_versao_tiss,
	dt_atualizacao, dt_atualizacao_nrec, dt_geracao_lote,
	dt_mes_competencia, nm_usuario, nm_usuario_nrec,
	nr_lote, cd_estabelecimento, nr_seq_lote_monitor,
	nm_arquivo, qt_total_alterado, qt_total_erro,
	qt_total_excluido, qt_total_incluido,nr_seq_lote_com,nr_seq_arquivo
) values (
	nextval('pls_monitor_tiss_lote_ret_seq'), cd_ans_p, cd_versao_tiss_p,
	clock_timestamp(), clock_timestamp(), dt_geracao_lote_p,
	dt_mes_competencia_p, nm_usuario_p, nm_usuario_p,
	nr_lote_p, cd_estabelecimento_p, nr_seq_lote_monitor_w,
	nm_arquivo_w, qt_alterado_p, qt_erros_p,
	qt_excluido_p, qt_incluido_p,nr_seq_lote_com_w,nr_seq_arquivo_w)
	returning nr_sequencia into nr_seq_lote_monitor_ret_p;
commit;

-- Quando vier o cdigo de glosa negando o Lote ser salvo nesta rotina

if (cd_glosa_p IS NOT NULL AND cd_glosa_p::text <> '') then
	CALL pls_gerencia_envio_ans_pck.gerar_glosa_ret_monitor( null, null, nr_seq_lote_monitor_ret_p, cd_glosa_p, null, nm_usuario_p);
end if;

CALL pls_gerencia_envio_ans_pck.atualiza_dados_ret_lote_com(nr_seq_lote_com_w,nm_usuario_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.gerar_lote_ret_monitor ( cd_ans_p pls_monitor_tiss_lote_ret.cd_ans%type, cd_versao_tiss_p pls_monitor_tiss_lote_ret.cd_versao_tiss%type, dt_geracao_lote_p pls_monitor_tiss_lote_ret.dt_geracao_lote%type, dt_mes_competencia_p pls_monitor_tiss_lote_ret.dt_mes_competencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_lote_p pls_monitor_tiss_lote_ret.nr_lote%type, cd_glosa_p pls_monitor_tiss_glosa.cd_glosa%type, nm_arquivo_p pls_monitor_tiss_lote_ret.nm_arquivo%type, qt_incluido_p pls_monitor_tiss_lote_ret.qt_total_incluido%type, qt_alterado_p pls_monitor_tiss_lote_ret.qt_total_alterado%type, qt_erros_p pls_monitor_tiss_lote_ret.qt_total_erro%type, qt_excluido_p pls_monitor_tiss_lote_ret.qt_total_excluido%type, nr_seq_lote_monitor_ret_p INOUT pls_monitor_tiss_lote_ret.nr_sequencia%type) FROM PUBLIC;
