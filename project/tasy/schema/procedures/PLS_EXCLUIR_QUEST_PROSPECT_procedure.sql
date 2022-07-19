-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_excluir_quest_prospect ( nr_seq_questionario_p pls_questionario_cliente.nr_sequencia%type) AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 	Excluir questionario e respostas do prospect
Função: 	OPS - Gestão Comercial
*/BEGIN

delete	FROM pls_quest_cliente_resposta
where	nr_seq_questionario = nr_seq_questionario_p;

delete	FROM pls_questionario_cliente
where	nr_sequencia = nr_seq_questionario_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_excluir_quest_prospect ( nr_seq_questionario_p pls_questionario_cliente.nr_sequencia%type) FROM PUBLIC;

