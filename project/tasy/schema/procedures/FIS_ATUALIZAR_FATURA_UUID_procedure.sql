-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_atualizar_fatura_uuid ( nr_nota_fiscal_p text, cd_serie_nf_p text, vl_total_nota_p text, nr_nfe_imp_p text) AS $body$
BEGIN

if (nr_nota_fiscal_p IS NOT NULL AND nr_nota_fiscal_p::text <> '') then
	begin
	update 	nota_fiscal
		set nr_nfe_imp = nr_nfe_imp_p
	where 	nr_nota_fiscal = nr_nota_fiscal_p
	and 	cd_serie_nf = cd_serie_nf_p
	and 	subst_virgula_ponto_adic_zero(vl_total_nota) = vl_total_nota_p;
	commit;
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_atualizar_fatura_uuid ( nr_nota_fiscal_p text, cd_serie_nf_p text, vl_total_nota_p text, nr_nfe_imp_p text) FROM PUBLIC;

