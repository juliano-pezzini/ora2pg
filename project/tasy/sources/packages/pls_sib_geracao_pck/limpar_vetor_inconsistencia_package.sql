-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--Vetor da movimentacao

--SEMPRE que incluida uma nova variavel, precisa tratar nas procedures LIMPAR_VETOR e INICIA_REGISTRO




CREATE OR REPLACE PROCEDURE pls_sib_geracao_pck.limpar_vetor_inconsistencia () AS $body$
BEGIN
PERFORM set_config('pls_sib_geracao_pck.indice_w', 0, false);
current_setting('pls_sib_geracao_pck.tb_nr_seq_movimento_w')::pls_util_cta_pck.t_number_table.delete;
current_setting('pls_sib_geracao_pck.tb_nr_seq_consistencia_w')::pls_util_cta_pck.t_number_table.delete;
current_setting('pls_sib_geracao_pck.tb_nr_seq_consistencia_conf_w')::pls_util_cta_pck.t_number_table.delete;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sib_geracao_pck.limpar_vetor_inconsistencia () FROM PUBLIC;
