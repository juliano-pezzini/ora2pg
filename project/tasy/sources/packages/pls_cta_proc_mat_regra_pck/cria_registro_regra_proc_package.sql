-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_cta_proc_mat_regra_pck.cria_registro_regra_proc ( nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Verifica se existe um registro de regra correspondente ao parametro, 
		se nao existir, insere um novo "limpo"(sem outros campos)
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao: 

Alteracoes:

------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

qt_proc_regra_w	integer;

BEGIN

if (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then

	select	count(1)
	into STRICT	qt_proc_regra_w
	from	pls_conta_proc_regra
	where	nr_sequencia	= nr_seq_conta_proc_p;
	
	if (qt_proc_regra_w = 0) then
	
		insert into pls_conta_proc_regra(nr_sequencia, dt_atualizacao, nm_usuario)
		values (nr_seq_conta_proc_p, clock_timestamp(), nm_usuario_p);
	end if;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_proc_mat_regra_pck.cria_registro_regra_proc ( nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
