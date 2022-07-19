-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualiza_status_pendencia ( nr_seq_pendencia_p pls_pendencias_prestador.nr_sequencia%type, nr_seq_chamado_p pls_pendencias_prestador.nr_seq_chamado%type, nm_usuario_p pls_pendencias_prestador.nm_usuario%type, ie_status_p pls_pendencias_prestador.ie_status%type ) AS $body$
BEGIN
    update pls_pendencias_prestador set
        nm_usuario = nm_usuario_p,
        nm_usuario_responsavel = nm_usuario_p,
        ie_status = ie_status_p,
        nr_seq_chamado = nr_seq_chamado_p,
        dt_atualizacao = clock_timestamp()
    where
        nr_sequencia = nr_seq_pendencia_p;

    update pls_chamados_solic set
        ie_status = ie_status_p,
        nm_usuario = nm_usuario_p,
        dt_atualizacao = clock_timestamp()
    where
        nr_sequencia = nr_seq_chamado_p;

    commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualiza_status_pendencia ( nr_seq_pendencia_p pls_pendencias_prestador.nr_sequencia%type, nr_seq_chamado_p pls_pendencias_prestador.nr_seq_chamado%type, nm_usuario_p pls_pendencias_prestador.nm_usuario%type, ie_status_p pls_pendencias_prestador.ie_status%type ) FROM PUBLIC;

