-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ptu_aviso_pck.atualiza_mat_conv ( tb_cd_mat_convertido_p INOUT dbms_sql.varchar2_table, tb_ds_mat_convertido_p INOUT dbms_sql.varchar2_table, tb_nr_seq_aviso_mat_p INOUT dbms_sql.number_table, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Manda para o banco os procedimentos convertidos
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ ]  Objetos do dicionario [X] Tasy (Delphi/Java) [ X] Portal [ X]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


BEGIN

forall i in tb_nr_seq_aviso_mat_p.first..tb_nr_seq_aviso_mat_p.last
	update	ptu_aviso_material
	set	cd_mat_envio	= tb_cd_mat_convertido_p(i),
		ds_material	= replace(ptu_somente_caracter_permitido(tb_ds_mat_convertido_p(i), 'ANSE'), chr(38) , 'e'),
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= tb_nr_seq_aviso_mat_p(i);
	
tb_cd_mat_convertido_p.delete;
tb_ds_mat_convertido_p.delete;
tb_nr_seq_aviso_mat_p.delete;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_aviso_pck.atualiza_mat_conv ( tb_cd_mat_convertido_p INOUT dbms_sql.varchar2_table, tb_ds_mat_convertido_p INOUT dbms_sql.varchar2_table, tb_nr_seq_aviso_mat_p INOUT dbms_sql.number_table, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;