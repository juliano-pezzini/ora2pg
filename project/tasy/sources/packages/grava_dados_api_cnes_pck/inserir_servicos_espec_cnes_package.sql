-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE grava_dados_api_cnes_pck.inserir_servicos_espec_cnes ( nr_seq_estabelecimento_p cnes_api_servicos_espec.nr_seq_estabelecimento%type, cd_servico_p cnes_api_servicos_espec.cd_servico%type, ds_servico_p cnes_api_servicos_espec.ds_servico%type, cd_classificacao_p cnes_api_servicos_espec.cd_classificacao%type, ds_classificacao_p cnes_api_servicos_espec.ds_classificacao%type, cd_caracteristica_p cnes_api_servicos_espec.cd_caracteristica%type, cd_cnes_p cnes_api_servicos_espec.cd_cnes%type, nm_usuario_p cnes_api_servicos_espec.nm_usuario%type) AS $body$
BEGIN

begin
insert	into	cnes_api_servicos_espec(	nr_sequencia, nr_seq_estabelecimento, dt_atualizacao,
		nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
		cd_servico, ds_servico, cd_classificacao,
		ds_classificacao, cd_caracteristica, cd_cnes )
	values (nextval('cnes_api_servicos_espec_seq'), nr_seq_estabelecimento_p, clock_timestamp(),
		nm_usuario_p, clock_timestamp(), nm_usuario_p,
		cd_servico_p, ds_servico_p, cd_classificacao_p,
		ds_classificacao_p, cd_caracteristica_p, cd_cnes_p );
exception
when others then
	CALL CALL grava_dados_api_cnes_pck.gravar_log(nr_seq_estabelecimento_p, wheb_mensagem_pck.get_texto(1204634,'DS_SERVICO='||ds_servico_p||';DS_CLASSIFICACAO='||ds_classificacao_p) , nm_usuario_p);
end;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_dados_api_cnes_pck.inserir_servicos_espec_cnes ( nr_seq_estabelecimento_p cnes_api_servicos_espec.nr_seq_estabelecimento%type, cd_servico_p cnes_api_servicos_espec.cd_servico%type, ds_servico_p cnes_api_servicos_espec.ds_servico%type, cd_classificacao_p cnes_api_servicos_espec.cd_classificacao%type, ds_classificacao_p cnes_api_servicos_espec.ds_classificacao%type, cd_caracteristica_p cnes_api_servicos_espec.cd_caracteristica%type, cd_cnes_p cnes_api_servicos_espec.cd_cnes%type, nm_usuario_p cnes_api_servicos_espec.nm_usuario%type) FROM PUBLIC;
