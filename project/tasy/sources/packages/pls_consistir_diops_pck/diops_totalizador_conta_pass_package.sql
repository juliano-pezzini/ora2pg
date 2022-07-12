-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_consistir_diops_pck.diops_totalizador_conta_pass ( nr_seq_periodo_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE


	cd_conta_contabil_w		conta_contabil.cd_conta_contabil%type;
	ds_conta_w			diops_fin_mov_passivo.ds_conta%type;
	vl_saldo_final_w		diops_fin_mov_passivo.vl_saldo_final%type;	
	vl_saldo_final_inferior_w	diops_fin_mov_passivo.vl_saldo_final%type;

	/* Retrieves all accounting accounts registered in the balance sheet, with the exception of the 9-digit accounts, since these do not have any child accounting accounts */

	c_contas CURSOR FOR
	SELECT	ds_conta,
		coalesce(vl_saldo_final, 0)
	from	diops_fin_mov_passivo 	a
	where	nr_seq_periodo 		= nr_seq_periodo_p
	and	length(ds_conta) 	< 9
	order by ds_conta;

	
BEGIN

	open c_contas;
	loop
	fetch c_contas into
	  	ds_conta_w,
		vl_saldo_final_w;
	EXIT WHEN NOT FOUND; /* apply on c_contas */
		begin
			/* Retrieves the sum of all the child accounting accounts for the accounting account passing through the cursor
			A child accounting account in this case is defined as having one more digit than the original account account, and having the same initial digits.
			Ex: 2.5.3.4.2 (SUPERIOR) and 2.5.3.4.2.1 (CHILD) */
			select	coalesce(sum(coalesce(vl_saldo_final, 0)), vl_saldo_final_w)
			into STRICT	vl_saldo_final_inferior_w
			from	diops_fin_mov_passivo a
			where	a.nr_seq_periodo = nr_seq_periodo_p
			and	length(a.ds_conta) > length(ds_conta_w)
			and	substr(a.ds_conta, 1, length(ds_conta_w)) = ds_conta_w
			and	not exists (	SELECT	1
						from	diops_fin_mov_passivo b
						where	nr_seq_periodo = nr_seq_periodo_p
						and	length(b.ds_conta) > length(a.ds_conta)
						and	substr(b.ds_conta, 1, length(a.ds_conta)) = a.ds_conta);

			if (vl_saldo_final_w <> vl_saldo_final_inferior_w) then

				/* If there is a difference in the accounting account balance in comparison with its child accounting accounts, gets the accounting account code to save the inconsistency*/

				select	max(b.cd_conta_contabil)
				into STRICT	cd_conta_contabil_w
				from	diops_fin_mov_passivo	a,
					w_diops_fin_mov_passivo	b
				where	a.ds_conta		= b.ds_conta
				and	a.nr_seq_periodo	= b.nr_seq_periodo
				and	b.nr_seq_periodo	= nr_seq_periodo_p
				and	a.ds_conta		= ds_conta_w;

				PERFORM set_config('pls_consistir_diops_pck.cd_conta_macro_w', cd_conta_contabil_w, false);
				CALL pls_consistir_diops_pck.pls_gravar_consistencia(nr_seq_periodo_p, cd_estabelecimento_p, 52);
			end if;
		end;
	end loop;
	close c_contas;

	commit;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_diops_pck.diops_totalizador_conta_pass ( nr_seq_periodo_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
