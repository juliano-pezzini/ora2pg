-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE grava_dados_api_cnes_pck.inserir_profissional_cnes ( nr_seq_estabelecimento_p cnes_api_profissionais.nr_seq_estabelecimento%type, nm_profissional_p cnes_api_profissionais.nm_profissional%type, nr_cpf_p cnes_api_profissionais.nr_cpf%type, nr_cns_p cnes_api_profissionais.nr_cns%type, data_atualizacao_cns_p cnes_api_profissionais.dt_atualizacao_cnes%type, nm_usuario_p cnes_api_profissionais.nm_usuario%type, nr_seq_profissional_p INOUT cnes_api_profissionais.nr_sequencia%type) AS $body$
BEGIN

begin
insert	into	cnes_api_profissionais(	nr_sequencia, nr_seq_estabelecimento, dt_atualizacao,
		nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
		nm_profissional, nr_cpf, nr_cns,
		dt_atualizacao_cnes)
	values (nextval('cnes_api_profissionais_seq'), nr_seq_estabelecimento_p, clock_timestamp(),
		nm_usuario_p, clock_timestamp(), nm_usuario_p,
		nm_profissional_p, nr_cpf_p, nr_cns_p,
		data_atualizacao_cns_p )
	returning nr_sequencia into nr_seq_profissional_p;
exception
when others then
	CALL CALL grava_dados_api_cnes_pck.gravar_log(nr_seq_estabelecimento_p, wheb_mensagem_pck.get_texto(1204638,'NM_PROFISSIONAL='||nm_profissional_p) , nm_usuario_p);
end;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_dados_api_cnes_pck.inserir_profissional_cnes ( nr_seq_estabelecimento_p cnes_api_profissionais.nr_seq_estabelecimento%type, nm_profissional_p cnes_api_profissionais.nm_profissional%type, nr_cpf_p cnes_api_profissionais.nr_cpf%type, nr_cns_p cnes_api_profissionais.nr_cns%type, data_atualizacao_cns_p cnes_api_profissionais.dt_atualizacao_cnes%type, nm_usuario_p cnes_api_profissionais.nm_usuario%type, nr_seq_profissional_p INOUT cnes_api_profissionais.nr_sequencia%type) FROM PUBLIC;
