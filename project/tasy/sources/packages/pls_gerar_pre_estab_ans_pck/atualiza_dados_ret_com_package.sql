-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Rotina responsável por atualizar os totalizadores do lote de retorno
CREATE OR REPLACE PROCEDURE pls_gerar_pre_estab_ans_pck.atualiza_dados_ret_com ( nr_seq_lote_com_p pls_monitor_tiss_lote_com.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


qt_arquivo_w					pls_monitor_tiss_lote_com.qt_arquivo%type;
qt_total_incluido_w				pls_monitor_tiss_lote_com.qt_total_incluido%type;
qt_total_alterado_w				pls_monitor_tiss_lote_com.qt_total_alterado%type;
qt_total_excluido_w				pls_monitor_tiss_lote_com.qt_total_excluido%type;
qt_total_erro_w					pls_monitor_tiss_lote_com.qt_total_erro%type;


BEGIN

select	count(1)
into STRICT	qt_arquivo_w
from	pls_monitor_tiss_lote_ret
where	nr_seq_lote_com	= nr_seq_lote_com_p;

select	sum(coalesce(qt_total_incluido,0)),
	sum(coalesce(qt_total_alterado,0)),
	sum(coalesce(qt_total_excluido,0)),
	sum(coalesce(qt_total_erro,0))
into STRICT	qt_total_incluido_w,
	qt_total_alterado_w,
	qt_total_excluido_w,
	qt_total_erro_w
from	pls_monitor_tiss_lote_ret
where	nr_seq_lote_com	= nr_seq_lote_com_p;

update	pls_monitor_tiss_lote_com
set	qt_arquivo		= qt_arquivo_w,
	qt_total_incluido	= qt_total_incluido_w,
	qt_total_alterado	= qt_total_alterado_w,
	qt_total_excluido	= qt_total_excluido_w,
	qt_total_erro		= qt_total_erro_w,
	nm_usuario		= nm_usuario_p
where	nr_sequencia		= nr_seq_lote_com_p;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_pre_estab_ans_pck.atualiza_dados_ret_com ( nr_seq_lote_com_p pls_monitor_tiss_lote_com.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
