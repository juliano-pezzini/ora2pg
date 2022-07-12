-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Consist_ncia para verifica__o dos valores liberados para pagamento de produ__o m_dica o valor liberado do item sempre dever_ ser igual ao liberado para pagamento



CREATE OR REPLACE PROCEDURE pls_cta_consistir_pck.atualiza_valores_item ( tb_conta_p dbms_sql.number_table) AS $body$
BEGIN

if (tb_conta_p.count > 0) then
	
	--Atualiza valor dos procedimentos

	--O campo vl_lib_original _ utilizado na fun__o OPS- Ajuste de valoriza__o 

	forall i in tb_conta_p.first..tb_conta_p.last
		update	pls_conta_proc
		set	vl_lib_original	= vl_liberado
		where	nr_seq_conta	= tb_conta_p(i);
	commit;
			
	--Atualiza valor dos materiais

	--O campo vl_lib_original _ utilizado na fun__o OPS- Ajuste de valoriza__o

	forall i in tb_conta_p.first..tb_conta_p.last
		update	pls_conta_mat
		set	vl_lib_original	= vl_liberado
		where	nr_seq_conta	= tb_conta_p(i);
		
	commit;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_consistir_pck.atualiza_valores_item ( tb_conta_p dbms_sql.number_table) FROM PUBLIC;
