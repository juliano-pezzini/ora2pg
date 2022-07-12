-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/




CREATE OR REPLACE PROCEDURE pls_gerar_contas_a700_pck.atualiza_dados_protocolo_a700 ( nr_seq_protocolo_p pls_conta.nr_seq_protocolo%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Rotina responsavel por:
		* Atualizas os valores do protocolo gerado;
		* Atualizar a quantidade de contas informadas e o status do protocolo;
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

	

BEGIN

-- Atualiza os valores do protocolo gerado

CALL pls_gerar_valores_protocolo(nr_seq_protocolo_p, nm_usuario_p);

-- Atualiza a quantidade de contas informadas e o status do protocolo

CALL pls_gerar_contas_a700_pck.atualizar_qt_contas_prot_a700(nr_seq_protocolo_p);

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_contas_a700_pck.atualiza_dados_protocolo_a700 ( nr_seq_protocolo_p pls_conta.nr_seq_protocolo%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;