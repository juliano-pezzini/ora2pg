-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	-- DESCARREGA O VETOR
CREATE OR REPLACE PROCEDURE pls_repasse_sca_pck.inserir_vetor_sca ( ie_descarregar_vetor_p text) AS $body$
BEGIN
	
	if	((nr_indice_w >= pls_util_pck.qt_registro_transacao_w) or (ie_descarregar_vetor_p = 'S')) then
		if (tb_seq_sca_w.count > 0) then
			forall i in tb_seq_sca_w.first..tb_seq_sca_w.last
				insert	into	pls_repasse_sca_plano(	nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_repasse_fornecedor,
						nr_seq_sca)
					values (nextval('pls_repasse_sca_plano_seq'),
						clock_timestamp(),
						current_setting('pls_repasse_sca_pck.nm_usuario_w')::usuario.nm_usuario%type,
						clock_timestamp(),
						current_setting('pls_repasse_sca_pck.nm_usuario_w')::usuario.nm_usuario%type,
						tb_seq_prestador_w(i),
						tb_seq_sca_w(i));
			commit;
		end if;
		
		CALL pls_repasse_sca_pck.limpar_vetor_sca();
	else
		nr_indice_w	:= nr_indice_w + 1;
	end if;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_repasse_sca_pck.inserir_vetor_sca ( ie_descarregar_vetor_p text) FROM PUBLIC;