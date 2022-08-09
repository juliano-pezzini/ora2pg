-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_saldo_diario ( vl_saldo_inicial_p bigint, vl_cheque_pre_inicial_p bigint, vl_cartao_cr_inicial_p bigint, vl_cheque_vista_inicial_p bigint, vl_especie_inicial_p bigint, vl_saldo_sem_desp_cartao_p bigint, nr_sequencia_p bigint, ie_posteriores_p text) AS $body$
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') 	then
	begin
	update 	caixa_saldo_diario
	set 	vl_saldo_inicial       		= vl_saldo_inicial_p,
		vl_cheque_pre_inicial     	= vl_cheque_pre_inicial_p,
		vl_cartao_cr_inicial       	= vl_cartao_cr_inicial_p,
		vl_cheque_vista_inicial    	= vl_cheque_vista_inicial_p,
		vl_especie_inicial         	= vl_especie_inicial_p,
		vl_saldo_sem_desp_cartao   	= vl_saldo_sem_desp_cartao_p
        	where   nr_sequencia      		= nr_sequencia_p;

	CALL recalcular_caixa_saldo_diario(nr_sequencia_p, ie_posteriores_p);

	commit;
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_saldo_diario ( vl_saldo_inicial_p bigint, vl_cheque_pre_inicial_p bigint, vl_cartao_cr_inicial_p bigint, vl_cheque_vista_inicial_p bigint, vl_especie_inicial_p bigint, vl_saldo_sem_desp_cartao_p bigint, nr_sequencia_p bigint, ie_posteriores_p text) FROM PUBLIC;
