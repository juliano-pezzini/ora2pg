-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



-- Dados da regra de pessoas alvo.


    
-- Dados dos beneficiarios alvo



-- Dados do beneficiario com tables.

 

-- Dados das pessoas alvo.



-- Dados das pessoas alvo com table



-- Dados do dignostico de conta.



-- Dados do procedimento.



-- Dados do procedimento da guia



-- Dados dos custos do beneficiario



-- Enderecos da pessoa fisica 




CREATE OR REPLACE PROCEDURE mprev_base_cubo_pck.gerencia_integridade ( nm_tabela_p text, ds_acao_p text) AS $body$
DECLARE

  rw_integridade RECORD;

BEGIN

-- Varrer as integridades que forem FK's da tabela.

for rw_integridade in (	SELECT	cons.constraint_name nm_constraint
			from	user_constraints cons
			where	upper(cons.table_name) = upper(nm_tabela_p)
			and	cons.constraint_type = 'R') loop

	EXECUTE 'alter table ' || nm_tabela_p || ' ' || ds_acao_p || ' constraint ' || rw_integridade.nm_constraint;

end loop; -- Integridades

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_base_cubo_pck.gerencia_integridade ( nm_tabela_p text, ds_acao_p text) FROM PUBLIC;