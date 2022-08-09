-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gravar_classif_w_dlp ( nr_seq_w_preexistencia_p bigint, ia_acao_preexistencia_p text, ie_classif_preexistencia_p text, ds_observacao_p text, nm_usuario_p text) AS $body$
BEGIN

update	w_pls_preexistencia
set	ie_acao_preexistencia	= ia_acao_preexistencia_p,
	ie_classificacao_dlp	= ie_classif_preexistencia_p,
	ds_observacao		= ds_observacao_p
where	nr_sequencia		= nr_seq_w_preexistencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gravar_classif_w_dlp ( nr_seq_w_preexistencia_p bigint, ia_acao_preexistencia_p text, ie_classif_preexistencia_p text, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;
