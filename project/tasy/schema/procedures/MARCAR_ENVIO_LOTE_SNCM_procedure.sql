-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE marcar_envio_lote_sncm ( nr_seq_lote_p controle_mat_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

CALL sncm_controle_mat_pck.marcar_envio_lote(nr_seq_lote_p => nr_seq_lote_p,nm_usuario_p => nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE marcar_envio_lote_sncm ( nr_seq_lote_p controle_mat_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
