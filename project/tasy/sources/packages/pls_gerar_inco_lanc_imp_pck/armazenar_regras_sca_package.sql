-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerar_inco_lanc_imp_pck.armazenar_regras_sca () AS $body$
DECLARE


	nr_seq_plano_w				pls_regra_sca_lanc_imp_inc.nr_seq_plano%type;

	c01 CURSOR FOR
		SELECT	nr_seq_plano
		from	pls_regra_sca_lanc_imp_inc;

	
BEGIN

	open c01;
	loop
	fetch c01 into
		nr_seq_plano_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		current_setting('pls_gerar_inco_lanc_imp_pck.sca_lanc_imp_inc_rec_vetor_w')::sca_lanc_imp_inc_rec_v(current_setting('pls_gerar_inco_lanc_imp_pck.sca_lanc_imp_inc_rec_vetor_w')::sca_lanc_imp_inc_rec_v.count+1).nr_seq_plano	:= nr_seq_plano_w;
		end;
	end loop;
	close c01;

	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_inco_lanc_imp_pck.armazenar_regras_sca () FROM PUBLIC;