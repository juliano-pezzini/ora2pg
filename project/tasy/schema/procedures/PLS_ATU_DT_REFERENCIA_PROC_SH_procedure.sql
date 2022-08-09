-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atu_dt_referencia_proc_sh () AS $body$
DECLARE

 
tb_sequencia_w		pls_util_cta_pck.t_number_table;
tb_dt_ref_w		pls_util_cta_pck.t_date_table;
qt_registro_w		integer;
ds_sql_w		varchar(4000);
nm_tablespace_index_w	varchar(200);
nr_seq_inicial_w	bigint;
nr_seq_final_w		bigint;

c01 CURSOR(	nr_seq_inicial_pc	bigint, 
		nr_seq_final_pc		bigint) FOR 
	SELECT	nr_sequencia, 
		dt_procedimento_referencia 
	from	pls_conta_proc 
	where	nr_sequencia between nr_seq_inicial_pc and nr_seq_final_pc;

BEGIN
 
pls_util_cta_pck.ie_grava_log_w := 'N';
CALL wheb_usuario_pck.set_ie_executar_trigger('N');
CALL wheb_usuario_pck.set_nm_usuario('tasy');
 
select	min(nr_sequencia) 
into STRICT	nr_seq_inicial_w 
from	pls_conta_proc;
 
nr_seq_final_w := nr_seq_inicial_w + 80000;
	 
select	Obter_Tablespace_Index(null) 
into STRICT	nm_tablespace_index_w
;
 
select	count(1) 
into STRICT	qt_registro_w 
from	user_indexes 
where	table_name = 'PLS_CONTA_PROC' 
and	index_name = 'PLSCOPRO_I32';
 
if (qt_registro_w = 0) then 
	ds_sql_w := 	'Create Index PLSCOPRO_I32 on PLS_CONTA_PROC(DT_PROCEDIMENTO_REFERENCIA, NR_SEQ_CONTA,' || 
			'CD_PROCEDIMENTO, IE_ORIGEM_PROCED, IE_STATUS) Tablespace ' || nm_tablespace_index_w;
	CALL exec_sql_dinamico('Tasy', ds_sql_w);
end if;
 
select	count(1) 
into STRICT	qt_registro_w 
from	user_indexes 
where	table_name = 'PLS_CONTA_PROC' 
and	index_name = 'PLSCOPRO_I33';
 
if (qt_registro_w = 0) then 
	ds_sql_w := 	'Create Index PLSCOPRO_I33 on PLS_CONTA_PROC(DT_PROCEDIMENTO_REFERENCIA_SH, NR_SEQ_CONTA,' || 
			'CD_PROCEDIMENTO, IE_ORIGEM_PROCED, IE_STATUS) Tablespace ' || nm_tablespace_index_w;
	CALL exec_sql_dinamico('Tasy', ds_sql_w);
end if;
 
-- menor igual a um number de 10 
while(nr_seq_final_w <= 9999999999) loop 
 
	-- Abrimos o cursor 
	open c01(nr_seq_inicial_w, nr_seq_final_w);
 
	-- abrimos um loop para iterar enquanto ouverem registro do cursor. 
	loop 
 
	-- Limpamos os registros das listas para que não seja processado o mesmo registro mais de uma vez. 
	tb_sequencia_w.delete;
	tb_dt_ref_w.delete;
 
	-- Executamos o fetch de um número determinado de linhas do cursor nas listas definidas, uma para cada campo da consulta. 
	fetch c01 bulk collect into tb_sequencia_w, tb_dt_ref_w limit 2000;
 
	-- Quando o cursor não tiver mais linhas então sai do loop. 
	exit when tb_sequencia_w.count = 0;
 
	-- executamos as operações necessárias. 
	forall	i in tb_sequencia_w.first..tb_sequencia_w.last 
		-- faz disparar a trigger responsável por resolver tudo 
		update 	pls_conta_proc set 
			dt_procedimento_referencia_sh = trunc(tb_dt_ref_w(i), 'dd') 
		where	nr_sequencia = tb_sequencia_w(i);
 
	commit;
 
	end loop;
	-- Ao terminar fechamos o cursor. 
	close c01;
	 
	nr_seq_inicial_w := nr_seq_final_w + 1;
	nr_seq_final_w := nr_seq_inicial_w + 80000;
end loop;
 
pls_util_cta_pck.ie_grava_log_w := 'S';
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atu_dt_referencia_proc_sh () FROM PUBLIC;
