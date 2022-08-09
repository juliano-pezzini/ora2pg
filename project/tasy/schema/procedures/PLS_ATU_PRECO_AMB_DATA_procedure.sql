-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atu_preco_amb_data () AS $body$
DECLARE

 
tb_sequencia_w		pls_util_cta_pck.t_number_table;
nr_seq_ultimo_reg_w	bigint;
nr_seq_inicial_w	bigint;
nr_seq_final_w		bigint;

c01 CURSOR(	nr_seq_inicial_pc	bigint, 
		nr_seq_final_pc		bigint) FOR 
	SELECT	nr_sequencia 
	from	preco_amb 
	where	nr_sequencia between nr_seq_inicial_pc and nr_seq_final_pc;

BEGIN
 
pls_util_cta_pck.ie_grava_log_w := 'N';
CALL wheb_usuario_pck.set_ie_executar_trigger('N');
CALL wheb_usuario_pck.set_nm_usuario('tasy');
 
select	max(nr_sequencia), 
	min(nr_sequencia) 
into STRICT	nr_seq_ultimo_reg_w, 
	nr_seq_inicial_w 
from	preco_amb;
 
nr_seq_final_w := nr_seq_inicial_w + 500;
 
-- menor igual a um number de 10 
while(nr_seq_final_w <= nr_seq_ultimo_reg_w or nr_seq_inicial_w <= nr_seq_ultimo_reg_w) loop 
 
	-- Abrimos o cursor 
	open c01(nr_seq_inicial_w, nr_seq_final_w);
 
	-- abrimos um loop para iterar enquanto ouverem registro do cursor. 
	loop 
 
	-- Limpamos os registros das listas para que não seja processado o mesmo registro mais de uma vez. 
	tb_sequencia_w.delete;
 
	-- Executamos o fetch de um número determinado de linhas do cursor nas listas definidas, uma para cada campo da consulta. 
	fetch c01 bulk collect into tb_sequencia_w limit 2000;
 
	-- Quando o cursor não tiver mais linhas então sai do loop. 
	exit when tb_sequencia_w.count = 0;
 
	-- executamos as operações necessárias. 
	forall	i in tb_sequencia_w.first..tb_sequencia_w.last 
		-- faz disparar a trigger responsável por resolver tudo 
		update 	preco_amb set 
			cd_edicao_amb = cd_edicao_amb 
		where	nr_sequencia = tb_sequencia_w(i);
	commit;
	 
	end loop;
	 
	-- Ao terminar fechamos o cursor. 
	close c01;
	 
	nr_seq_inicial_w := nr_seq_final_w + 1;
	nr_seq_final_w := nr_seq_inicial_w + 500;
end loop;
 
pls_util_cta_pck.ie_grava_log_w := 'S';
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atu_preco_amb_data () FROM PUBLIC;
