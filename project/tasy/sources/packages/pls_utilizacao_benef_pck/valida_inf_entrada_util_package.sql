-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_utilizacao_benef_pck.valida_inf_entrada_util ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, nm_usuario_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Valida as informacoes basicas de entrada.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atencao:
Alteracoes:
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

-- se nao tem beneficiario informado, aborta.
if (coalesce(nr_seq_segurado_p::text, '') = '') then	
	CALL wheb_mensagem_pck.exibir_mensagem_abort(784746);
end if;

-- se nao tem nome de usuario, aborta.
if (coalesce(nm_usuario_p::text, '') = '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(784747);
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_utilizacao_benef_pck.valida_inf_entrada_util ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, nm_usuario_p text) FROM PUBLIC;