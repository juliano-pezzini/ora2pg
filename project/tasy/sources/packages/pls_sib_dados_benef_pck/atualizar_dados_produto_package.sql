-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_sib_dados_benef_pck.atualizar_dados_produto ( nr_seq_plano_p pls_plano.nr_sequencia%type) AS $body$
BEGIN
if (nr_seq_plano_p IS NOT NULL AND nr_seq_plano_p::text <> '') then
	select	nr_sequencia,
		CASE WHEN a.ie_regulamentacao='P' THEN a.nr_protocolo_ans  ELSE null END ,
		CASE WHEN a.ie_regulamentacao='P' THEN  null  ELSE CASE WHEN current_setting('pls_sib_dados_benef_pck.ie_scpa_contrato_w')::pls_parametros.ie_scpa_contrato%type='S' THEN coalesce(current_setting('pls_sib_dados_benef_pck.cd_scpa_contrato')::varchar(30),a.cd_scpa)  ELSE a.cd_scpa END  END ,
		CASE WHEN a.ie_regulamentacao='R' THEN 1  ELSE 0 END  current_setting('pls_sib_dados_benef_pck.ie_itens_excluidos_cobertura')::smallint
	into STRICT	current_setting('pls_sib_dados_benef_pck.nr_seq_plano')::bigint,
		current_setting('pls_sib_dados_benef_pck.nr_plano_ans')::varchar(20),
		current_setting('pls_sib_dados_benef_pck.nr_plano_operadora')::varchar(20),
		current_setting('pls_sib_dados_benef_pck.ie_itens_excluidos_cobertura')::smallint
	from	pls_plano a
	where	a.nr_sequencia	= nr_seq_plano_p;
end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sib_dados_benef_pck.atualizar_dados_produto ( nr_seq_plano_p pls_plano.nr_sequencia%type) FROM PUBLIC;