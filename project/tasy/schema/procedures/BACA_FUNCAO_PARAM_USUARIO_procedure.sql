-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_funcao_param_usuario () AS $body$
DECLARE


/*  Este  objeto foi documento dia: 25/03/2011 e podera ser removido daqui uns 6 meses */

dt_versao_atual_cliente_w	timestamp;
qt_registro_w			integer;


BEGIN
dt_versao_atual_cliente_w	:= coalesce(to_date(to_char(obter_data_geracao_versao-1,'dd/mm/yyyy') ||' 23:59:59','dd/mm/yyyy hh24:mi:ss'),clock_timestamp() - interval '90 days');
if (dt_versao_atual_cliente_w < to_date('25/03/2011','dd/mm/yyyy')) then

	-- Remover constraint
	select	count(*)
	into STRICT	qt_registro_w
	from	user_cons_columns
	where	table_name	= 'FUNCAO_PARAM_USUARIO'
	and	constraint_name	= 'FUNPAUS_PK';

	if (qt_registro_w > 1) then
		CALL Exec_Sql_Dinamico('Fernando','alter table FUNCAO_PARAM_USUARIO drop constraint FUNPAUS_PK');
	end	if;

	-- Remover Indice
	select	count(*)
	into STRICT	qt_registro_w
	from	user_ind_columns
	where	index_name = 'FUNPAUS_PK';
	if (qt_registro_w > 1) then
		CALL Exec_Sql_Dinamico('Fernando','drop index FUNPAUS_PK');
	end	if;

	-- Criar o campo NR_SEQ_INTERNO
	select	count(*)
	into STRICT	qt_registro_w
	from	user_tab_columns
	where	table_name = 'FUNCAO_PARAM_USUARIO'
	and	column_name = 'NR_SEQ_INTERNO';
	if (qt_registro_w = 0) then
		CALL Exec_Sql_Dinamico('Fernando','alter table FUNCAO_PARAM_USUARIO add NR_SEQ_INTERNO number(10)');
	end	if;

	-- Criar sequence
	select	count(*)
	into STRICT	qt_registro_w
	from	user_sequences
	where	sequence_name = 'FUNCAO_PARAM_USUARIO_SEQ';
	if (qt_registro_w = 0) then
		CALL Exec_Sql_Dinamico('Fernando','Create Sequence FUNCAO_PARAM_USUARIO_SEQ Increment by 1 Start With 1 MaxValue 9999999999 Cycle  NoCache');
	end	if;

	-- Atualizar o campo NR_SEQ_INTERNO
	select	count(*)
	into STRICT	qt_registro_w
	from	user_tab_columns
	where	table_name = 'FUNCAO_PARAM_USUARIO'
	and	column_name = 'NR_SEQ_INTERNO';
	if (qt_registro_w > 0) then
		CALL Exec_Sql_Dinamico('Fernando','update funcao_param_usuario set nr_seq_interno = funcao_param_usuario_seq.nextval where nr_seq_interno is null');
	end	if;

	-- Alterar campo NR_SEQ_INTERNO para NOT NULL
	select	count(*)
	into STRICT	qt_registro_w
	from	user_tab_columns
	where	table_name = 'FUNCAO_PARAM_USUARIO'
	and	column_name = 'NR_SEQ_INTERNO'
	and	nullable = 'Y';
	if (qt_registro_w > 0) then
		CALL Exec_Sql_Dinamico('Fernando','alter table FUNCAO_PARAM_USUARIO modify NR_SEQ_INTERNO not null');
	end	if;

	-- Criar Constraint da PK
	select	count(*)
	into STRICT	qt_registro_w
	from	user_constraints
	where	constraint_name	= 'FUNPAUS_PK';
	if (qt_registro_w = 0) then
		CALL Exec_Sql_Dinamico('Fernando','Alter Table FUNCAO_PARAM_USUARIO add ( Constraint FUNPAUS_PK Primary Key (NR_SEQ_INTERNO))');
	end	if;

	-- Criar UK
	select	count(*)
	into STRICT	qt_registro_w
	from	user_indexes
	where	index_name = 'FUNPAUS_UK';
	if (qt_registro_w = 0) then
		CALL Exec_Sql_Dinamico('Fernando','Create unique Index FUNPAUS_UK on FUNCAO_PARAM_USUARIO(CD_FUNCAO, NR_SEQUENCIA, NM_USUARIO_PARAM, CD_ESTABELECIMENTO)');
	end	if;

	-- Criar Constraint da UK
	select	count(*)
	into STRICT	qt_registro_w
	from	user_constraints
	where	constraint_name	= 'FUNPAUS_UK';
	if (qt_registro_w = 0) then
		CALL Exec_Sql_Dinamico('Fernando','Alter Table FUNCAO_PARAM_USUARIO add ( Constraint FUNPAUS_UK unique (CD_FUNCAO, NR_SEQUENCIA,  nm_usuario_param,cd_estabelecimento))');
	end	if;

	CALL valida_objetos_sistema();
end	if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_funcao_param_usuario () FROM PUBLIC;

