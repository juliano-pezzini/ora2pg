-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_pacote_inativar_composicao ( nr_seq_composicao_p pls_pacote_composicao.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade:	Inativar a composição do pacote selecionada. Irá inativar todos os procedimentos 
	e materiais do pacote também. 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
 
Alterações 
------------------------------------------------------------------------------------------------------------------ 
jjung OS 614334 25/07/2013 
 
Alteração:	Adicionado às atualizações os campos NM_USUARIO e DT_ATUALIZACAO. 
 
Motivo:	Foi identificado que o mesmo não estava sendo gravado e não seria possível identificar 
	quem inativou a composição. 
------------------------------------------------------------------------------------------------------------------ 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 

BEGIN 
 
update	pls_pacote_composicao 
set	ie_situacao		= 'I', 
	dt_atualizacao_nrec	= dt_atualizacao, 
	nm_usuario_nrec		= nm_usuario, 
	dt_atualizacao		= clock_timestamp(), 
	nm_usuario		= nm_usuario_p 
where	nr_sequencia		= nr_seq_composicao_p;
 
update	pls_pacote_procedimento 
set	ie_situacao		= 'I', 
	dt_atualizacao_nrec	= dt_atualizacao, 
	nm_usuario_nrec		= nm_usuario, 
	dt_atualizacao		= clock_timestamp(), 
	nm_usuario		= nm_usuario_p 
where	nr_seq_composicao	= nr_seq_composicao_p;
 
update	pls_pacote_material 
set	ie_situacao		= 'I', 
	dt_atualizacao_nrec	= dt_atualizacao, 
	nm_usuario_nrec		= nm_usuario, 
	dt_atualizacao		= clock_timestamp(), 
	nm_usuario		= nm_usuario_p 
where	nr_seq_composicao	= nr_seq_composicao_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pacote_inativar_composicao ( nr_seq_composicao_p pls_pacote_composicao.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

