-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_altera_cod_guia_prest_ans ( nr_seq_lote_monitor_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


ie_guia_alterada_w		bigint;


BEGIN

ie_guia_alterada_w := pls_gerencia_envio_ans_pck.altera_cod_guia_prestador_ans(nr_seq_lote_monitor_p, nm_usuario_p, ie_guia_alterada_w);

if (coalesce(ie_guia_alterada_w, 0) = 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(446220);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_altera_cod_guia_prest_ans ( nr_seq_lote_monitor_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

