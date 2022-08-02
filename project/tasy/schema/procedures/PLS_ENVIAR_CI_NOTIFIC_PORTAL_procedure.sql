-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_enviar_ci_notific_portal ( nr_seq_prest_doc_venc_p pls_prestador_doc_venc.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Chamada para a PCK
---------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [  ] Outros:
 --------------------------------------------------------------------------------------------------------------------------------
 Alterações:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

CALL pls_env_aviso_ven_doc_pres_pck.enviar_ci_notific_portal(nr_seq_prest_doc_venc_p,nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_enviar_ci_notific_portal ( nr_seq_prest_doc_venc_p pls_prestador_doc_venc.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

