-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE mprev_base_cubo_pck.atualizar_procedimentos_guia ( nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Atualizar a base do cubo para os procedimentos realizados.s
	Tabela mprev_guia_proc_cubo_ops
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
------------------------------------------------------------------------------------------------------------------

kcboeck 07/10/2015 - Inclusao de procedimento  atualizar_procedimentos_guia
------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


c_procedimento_guia CURSOR FOR
	SELECT  b.nr_seq_guia_cubo_ops,
		a.cd_procedimento,
		a.ie_origem_proced,
		a.dt_liberacao dt_procedimento,
		a.qt_solicitada qt_procedimento,
		(SELECT c.ds_procedimento
			from procedimento c
			where c.ie_origem_proced		= a.ie_origem_proced
			and	    c.cd_procedimento		= a.cd_procedimento) ds_procedimento
	from mprev_guia_cubo_ref b,
		pls_guia_plano_proc a
	where b.nr_seq_guia_plano  = a.nr_seq_guia
	and	(a.cd_procedimento IS NOT NULL AND a.cd_procedimento::text <> '');

table_procedimento_guias_w	mprev_base_cubo_pck.table_procedimento_guia;


BEGIN

open c_procedimento_guia;
loop
	fetch c_procedimento_guia
	bulk collect into table_procedimento_guias_w.nr_seq_guia_cubo_ops,
			  table_procedimento_guias_w.cd_procedimento,
			  table_procedimento_guias_w.ie_origem_proced, 
			  table_procedimento_guias_w.dt_procedimento,
			  table_procedimento_guias_w.qt_procedimento, 
			  table_procedimento_guias_w.ds_procedimento
	limit current_setting('mprev_base_cubo_pck.qt_reg_commit_w')::integer;
	
	exit when table_procedimento_guias_w.nr_seq_guia_cubo_ops.count = 0;
	
	forall i in table_procedimento_guias_w.nr_seq_guia_cubo_ops.first .. table_procedimento_guias_w.nr_seq_guia_cubo_ops.last		
		insert into mprev_guia_proc_cubo_ops(nr_sequencia,
			nm_usuario, 
			dt_atualizacao,
			nr_seq_guia_cubo,
			cd_procedimento, 
			ie_origem_proced,
			dt_procedimento, 
			qt_procedimento, 
			ds_procedimento)
		values (nextval('mprev_conta_proc_cubo_ops_seq'), 
			nm_usuario_p, 
			clock_timestamp(),
			table_procedimento_guias_w.nr_seq_guia_cubo_ops(i),  
			table_procedimento_guias_w.cd_procedimento(i), 
			table_procedimento_guias_w.ie_origem_proced(i), 
			table_procedimento_guias_w.dt_procedimento(i), 
			table_procedimento_guias_w.qt_procedimento(i), 
			table_procedimento_guias_w.ds_procedimento(i));
	commit;
end loop;
close c_procedimento_guia;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_base_cubo_pck.atualizar_procedimentos_guia ( nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;