-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

 
/*Esse método é utilizado quando se deseja informar que o item em questão é ou não glosado. 
O campo ie_glosa funciona basicamente como um valor temporário em processos onde se sabe que não existirá glosas, como por exemplo no "Aceitar valor apresentado". 
Hoje, 30/07/2013 este campo é utilizado para definir se o item é glosado ou não. Acredito que no futuro ele será apenas um sinalizador e que a resposta sobre o item estar 
ou não glosado virá das tabelas pls_conta_glosa e pls_ocorrencia_benef, juntamente com a verificação se existe valor de glosa maior que zero*/
 


CREATE OR REPLACE PROCEDURE pls_gerencia_dados_ocor_pck.pls_atualiza_ie_glosa ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_proc_partic_p pls_proc_participante.nr_sequencia%type, ie_novo_valor_p pls_conta_proc.ie_glosa%type, ie_replica_proc_partic text, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

ie_tipo_item_w		varchar(1);

C01 CURSOR(	nr_seq_conta_proc_p		pls_conta_proc.nr_sequencia%type) FOR 
	SELECT	nr_sequencia 
	from	pls_proc_participante_v 
	where	nr_seq_conta_proc = nr_seq_conta_proc_p 
	and	ie_status	<> 'C';
BEGIN
 
ie_tipo_item_w	:= pls_util_cta_pck.pls_obter_tipo_item_atend(nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, nr_seq_proc_partic_p);
 
case ie_tipo_item_w 
	-- conta 
	when 'C' then 
		update 	pls_conta set 
			ie_glosa 	= ie_novo_valor_p, 
			nm_usuario	= nm_usuario_p, 
			dt_atualizacao	= clock_timestamp() 
		where	nr_sequencia 	= nr_seq_conta_p;
	-- procedimento 
	when 'P' then 
		update 	pls_conta_proc set 
			ie_glosa 	= ie_novo_valor_p, 
			nm_usuario	= nm_usuario_p, 
			dt_atualizacao	= clock_timestamp() 
		where	nr_sequencia 	= nr_seq_conta_proc_p;
		 
		-- se o procedimento for glosado ou foi passado de parâmetro que deve ser replicado o ie_glosa para os participantes 
		if (ie_novo_valor_p = 'S' or ie_replica_proc_partic = 'S') then 
			for r_C01_w in C01(nr_seq_conta_proc_p) loop 
				update 	pls_proc_participante set 
					ie_glosa 	= ie_novo_valor_p, 
					nm_usuario	= nm_usuario_p, 
					dt_atualizacao	= clock_timestamp() 
				where	nr_sequencia 	= r_C01_w.nr_sequencia;
			end loop;
		end if;		
	-- material 
	when 'M' then 
		update 	pls_conta_mat set 
			ie_glosa 	= ie_novo_valor_p, 
			nm_usuario	= nm_usuario_p, 
			dt_atualizacao	= clock_timestamp() 
		where	nr_sequencia 	= nr_seq_conta_mat_p;
	-- participante 
	when 'R' then 
		update 	pls_proc_participante set 
			ie_glosa 	= ie_novo_valor_p, 
			nm_usuario	= nm_usuario_p, 
			dt_atualizacao	= clock_timestamp() 
		where	nr_sequencia 	= nr_seq_proc_partic_p;
end case;
 
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_dados_ocor_pck.pls_atualiza_ie_glosa ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_proc_partic_p pls_proc_participante.nr_sequencia%type, ie_novo_valor_p pls_conta_proc.ie_glosa%type, ie_replica_proc_partic text, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;