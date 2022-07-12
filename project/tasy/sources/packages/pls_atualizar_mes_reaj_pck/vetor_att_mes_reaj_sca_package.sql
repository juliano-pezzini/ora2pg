-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_atualizar_mes_reaj_pck.vetor_att_mes_reaj_sca ( nm_usuario_p usuario.nm_usuario%type, ie_descarregar_vetor_p text) AS $body$
BEGIN

if	((current_setting('pls_atualizar_mes_reaj_pck.nr_indice_att_mes_sca_w')::integer >= pls_util_pck.qt_registro_transacao_w) or (ie_descarregar_vetor_p = 'S')) then
	if (current_setting('pls_atualizar_mes_reaj_pck.tb_nr_seq_sca_vinculo_w')::pls_util_cta_pck.t_number_table.count > 0) then
		forall i in current_setting('pls_atualizar_mes_reaj_pck.tb_nr_seq_sca_vinculo_w')::pls_util_cta_pck.t_number_table.first..tb_nr_seq_sca_vinculo_w.last
			update	pls_sca_vinculo
			set	nr_mes_reajuste	= current_setting('pls_atualizar_mes_reaj_pck.tb_nr_mes_reajuste_sca_w')::pls_util_cta_pck.t_number_table(i),
				nm_usuario	= nm_usuario_p
			where	nr_sequencia 	= current_setting('pls_atualizar_mes_reaj_pck.tb_nr_seq_sca_vinculo_w')::pls_util_cta_pck.t_number_table(i);
		commit;
	end if;

	CALL pls_atualizar_mes_reaj_pck.limpar_vetor_mes_reaj_sca();
else
	PERFORM set_config('pls_atualizar_mes_reaj_pck.nr_indice_att_mes_sca_w', current_setting('pls_atualizar_mes_reaj_pck.nr_indice_att_mes_sca_w')::integer + 1, false);
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_mes_reaj_pck.vetor_att_mes_reaj_sca ( nm_usuario_p usuario.nm_usuario%type, ie_descarregar_vetor_p text) FROM PUBLIC;
