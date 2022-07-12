-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_consistir_conferencia_pck.carregar_inconsistencias () AS $body$
DECLARE

i	integer;
C01 CURSOR FOR
	SELECT	cd_divergencia,
		nr_sequencia
	from	pls_sib_divergencia_conf
	where	ie_situacao = 'A';
BEGIN
i := 0;
current_setting('pls_consistir_conferencia_pck.tb_cd_divergencia_w')::pls_util_cta_pck.t_number_table.delete;
current_setting('pls_consistir_conferencia_pck.tb_nr_seq_diverg_regra_w')::pls_util_cta_pck.t_number_table.delete;
for r_c01_w in C01 loop
	begin
	current_setting('pls_consistir_conferencia_pck.tb_cd_divergencia_w')::pls_util_cta_pck.t_number_table(i) := r_c01_w.cd_divergencia;
	current_setting('pls_consistir_conferencia_pck.tb_nr_seq_diverg_regra_w')::pls_util_cta_pck.t_number_table(i) := r_c01_w.nr_sequencia;
	i := i+1;
	end;
end loop;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_conferencia_pck.carregar_inconsistencias () FROM PUBLIC;