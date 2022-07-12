-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE grava_dados_api_cnes_pck.inserir_vinculo_prof_cnes ( nr_seq_profissional_p cnes_api_prof_vinculo.nr_seq_profissional%type, nr_vinculo_p cnes_api_prof_vinculo.nr_vinculo%type, cd_modalidade_vinculo_p cnes_api_prof_vinculo.cd_modalidade_vinculo%type, ds_modalidade_vinculo_p cnes_api_prof_vinculo.ds_modalidade_vinculo%type, cd_tipo_vinculo_p cnes_api_prof_vinculo.cd_tipo_vinculo%type, ds_tipo_vinculo_p cnes_api_prof_vinculo.ds_tipo_vinculo%type, cd_subtipo_vinculo_p cnes_api_prof_vinculo.cd_subtipo_vinculo%type, ds_subtipo_vinculo_p cnes_api_prof_vinculo.ds_subtipo_vinculo%type, nm_usuario_p cnes_api_prof_vinculo.nm_usuario%type) AS $body$
DECLARE

nr_seq_estabelecimento_w	cnes_api_profissionais.nr_seq_estabelecimento%type;
nm_profissional_w		cnes_api_profissionais.nm_profissional%type;

BEGIN

begin
insert	into	cnes_api_prof_vinculo(	nr_sequencia, nr_seq_profissional, dt_atualizacao,
		nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
		nr_vinculo, cd_modalidade_vinculo, ds_modalidade_vinculo,
		cd_tipo_vinculo, ds_tipo_vinculo, cd_subtipo_vinculo,
		ds_subtipo_vinculo )
	values (nextval('cnes_api_prof_vinculo_seq'), nr_seq_profissional_p, clock_timestamp(),
		nm_usuario_p, clock_timestamp(), nm_usuario_p,
		nr_vinculo_p, cd_modalidade_vinculo_p, ds_modalidade_vinculo_p,
		cd_tipo_vinculo_p, ds_tipo_vinculo_p, cd_subtipo_vinculo_p,
		ds_subtipo_vinculo_p );
exception
when others then
	select	nr_seq_estabelecimento,
		nm_profissional
	into STRICT	nr_seq_estabelecimento_w,
		nm_profissional_w
	from	cnes_api_profissionais
	where	nr_sequencia	= nr_seq_profissional_p;
	
	CALL CALL grava_dados_api_cnes_pck.gravar_log(nr_seq_estabelecimento_w, wheb_mensagem_pck.get_texto(1204640,'NR_VINCULO='||nr_vinculo_p||';NM_PROFISSIONAL='||nm_profissional_w) , nm_usuario_p);
end;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_dados_api_cnes_pck.inserir_vinculo_prof_cnes ( nr_seq_profissional_p cnes_api_prof_vinculo.nr_seq_profissional%type, nr_vinculo_p cnes_api_prof_vinculo.nr_vinculo%type, cd_modalidade_vinculo_p cnes_api_prof_vinculo.cd_modalidade_vinculo%type, ds_modalidade_vinculo_p cnes_api_prof_vinculo.ds_modalidade_vinculo%type, cd_tipo_vinculo_p cnes_api_prof_vinculo.cd_tipo_vinculo%type, ds_tipo_vinculo_p cnes_api_prof_vinculo.ds_tipo_vinculo%type, cd_subtipo_vinculo_p cnes_api_prof_vinculo.cd_subtipo_vinculo%type, ds_subtipo_vinculo_p cnes_api_prof_vinculo.ds_subtipo_vinculo%type, nm_usuario_p cnes_api_prof_vinculo.nm_usuario%type) FROM PUBLIC;