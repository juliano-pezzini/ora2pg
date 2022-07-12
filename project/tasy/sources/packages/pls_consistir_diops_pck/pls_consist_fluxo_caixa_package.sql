-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_consistir_diops_pck.pls_consist_fluxo_caixa ( nr_seq_periodo_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE

	
	vl_fluxo_w		diops_fin_fluxo_caixa.vl_fluxo%type;
	vl_saldo_final_w	diops_fin_mov_passivo.vl_saldo_final%type;
	
	
BEGIN
	
	delete	
	from 	diops_periodo_inconsist a
	where	a.nr_seq_periodo	= nr_seq_periodo_p
	and	a.nr_seq_inconsistencia	= 62;
	
	commit;
	
	select	coalesce(sum(a.vl_fluxo),0)
	into STRICT	vl_fluxo_w
	from	diops_fin_fluxo_caixa a
	where	a.nr_seq_periodo	= nr_seq_periodo_p;
	
	select	coalesce(sum(a.vl_saldo_final - a.vl_saldo_anterior),0) vl_saldo_final
	into STRICT	vl_saldo_final_w
	from 	diops_fin_mov_ativo	a
	where	a.nr_seq_periodo	= nr_seq_periodo_p
	and	a.ds_conta	in ('1211','1213');
	
	-- Requirement 07:  Inconsistent total of operating, financing and investment activities
	if (vl_fluxo_w <> vl_saldo_final_w) then
		PERFORM set_config('pls_consistir_diops_pck.nr_quadro_w', 19, false);
		CALL pls_consistir_diops_pck.pls_gravar_consistencia(nr_seq_periodo_p, cd_estabelecimento_p, 62);
	end if;
	
	PERFORM set_config('pls_consistir_diops_pck.nr_quadro_w', 0, false);
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_diops_pck.pls_consist_fluxo_caixa ( nr_seq_periodo_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
