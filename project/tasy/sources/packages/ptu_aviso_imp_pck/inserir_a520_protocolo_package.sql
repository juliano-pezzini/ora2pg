-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ptu_aviso_imp_pck.inserir_a520_protocolo ( nr_sequencia_p INOUT ptu_aviso_protocolo.nr_sequencia%type, nm_usuario_p ptu_aviso_protocolo.nm_usuario%type, nr_seq_arquivo_p ptu_aviso_protocolo.nr_seq_arquivo%type, nr_seq_protocolo_p ptu_aviso_protocolo.nr_seq_protocolo%type, ie_tipo_guia_p ptu_aviso_protocolo.ie_tipo_guia%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Insere os dados do A520 e devolve a chave primaria gerada
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[ ]  Objetos do dicionario [X] Tasy (Delphi/Java) [ X] Portal [ X]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atencao:

Alteracoes:
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

insert into ptu_aviso_protocolo(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_arquivo,
				nr_seq_protocolo,
				ie_tipo_guia)
values (nextval('ptu_aviso_protocolo_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_arquivo_p,
	nr_seq_protocolo_p,
	ie_tipo_guia_p) returning nr_sequencia into nr_sequencia_p;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_aviso_imp_pck.inserir_a520_protocolo ( nr_sequencia_p INOUT ptu_aviso_protocolo.nr_sequencia%type, nm_usuario_p ptu_aviso_protocolo.nm_usuario%type, nr_seq_arquivo_p ptu_aviso_protocolo.nr_seq_arquivo%type, nr_seq_protocolo_p ptu_aviso_protocolo.nr_seq_protocolo%type, ie_tipo_guia_p ptu_aviso_protocolo.ie_tipo_guia%type) FROM PUBLIC;
