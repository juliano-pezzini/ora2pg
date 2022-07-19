-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_diagnostico_imp_guia_web ( nr_seq_guia_p bigint, cd_doenca_imp_p text, ie_indicacao_acidente_imp_p text, ie_classificacao_p text, nm_usuario_p text) AS $body$
BEGIN

insert	into	pls_diagnostico(nr_sequencia, dt_atualizacao, nm_usuario,
				nr_seq_guia, cd_doenca_imp, ie_indicacao_acidente_imp,
				dt_atualizacao_nrec, nm_usuario_nrec, ie_classificacao_imp)
			values (nextval('pls_diagnostico_seq'), clock_timestamp(), nm_usuario_p,
				nr_seq_guia_p, cd_doenca_imp_p, ie_indicacao_acidente_imp_p,
				clock_timestamp(), nm_usuario_p, ie_classificacao_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_diagnostico_imp_guia_web ( nr_seq_guia_p bigint, cd_doenca_imp_p text, ie_indicacao_acidente_imp_p text, ie_classificacao_p text, nm_usuario_p text) FROM PUBLIC;

