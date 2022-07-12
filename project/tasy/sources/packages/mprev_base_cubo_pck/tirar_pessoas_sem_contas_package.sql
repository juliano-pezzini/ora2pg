-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

-- final do procedimento de guias --








CREATE OR REPLACE PROCEDURE mprev_base_cubo_pck.tirar_pessoas_sem_contas ( nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Limpar da base as pessoas que nao tiveram movimentacao.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
------------------------------------------------------------------------------------------------------------------

jjung 01/04/2014 - Criacao da rotina
------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


cs_benef_conta_guia CURSOR FOR
	SELECT	nr_sequencia
	from	mprev_benef_cubo_ops
	EXCEPT(SELECT	nr_seq_benef_cubo
	from	mprev_conta_cubo_ops
	
union all

	select	nr_seq_benef_cubo
	from	mprev_guia_plano_cubo_ops);
	
cs_pessoa_benef CURSOR FOR
	SELECT	nr_sequencia
	from	mprev_pessoa_cubo_ops
	EXCEPT
	SELECT	nr_seq_pessoa_cubo
	from	mprev_benef_cubo_ops;
	
table_sequencia_w	pls_util_cta_pck.t_number_table;


BEGIN

-- Remover beneficiarios sem conta e sem gua

open cs_benef_conta_guia;
loop
	fetch cs_benef_conta_guia
	bulk collect into table_sequencia_w
	limit current_setting('mprev_base_cubo_pck.qt_reg_commit_w')::integer;
	
	exit when table_sequencia_w.count = 0;
	
	forall i in table_sequencia_w.first .. table_sequencia_w.last
		delete	FROM mprev_benef_cubo_ops
		where	nr_sequencia = table_sequencia_w(i);
	commit;
end loop;
close cs_benef_conta_guia;

-- Remover pessoas sem beneficiario

open cs_pessoa_benef;
loop	
	fetch cs_pessoa_benef
	bulk collect into table_sequencia_w
	limit current_setting('mprev_base_cubo_pck.qt_reg_commit_w')::integer;
	
	exit when table_sequencia_w.count = 0;
	
	forall i in table_sequencia_w.first .. table_sequencia_w.last
		delete	FROM mprev_pessoa_cubo_ops
		where	nr_sequencia = table_sequencia_w(i);
	
	commit;
end loop;
close cs_pessoa_benef;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_base_cubo_pck.tirar_pessoas_sem_contas ( nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
