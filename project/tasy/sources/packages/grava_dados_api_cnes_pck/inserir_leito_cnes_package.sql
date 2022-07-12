-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE grava_dados_api_cnes_pck.inserir_leito_cnes ( nr_seq_estabelecimento_p cnes_api_leitos.nr_seq_estabelecimento%type, ie_leito_p cnes_api_leitos.ie_leito%type, quantidade_leito_p cnes_api_leitos.qt_leito%type, quantidade_leito_sus_p cnes_api_leitos.qt_leito_sus%type, data_atualizacao_p cnes_api_leitos.dt_atualizacao_leito%type, nm_usuario_p cnes_api_leitos.nm_usuario%type) AS $body$
BEGIN

begin
insert	into	cnes_api_leitos(	nr_sequencia, nr_seq_estabelecimento, dt_atualizacao,
		nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
		ie_leito, qt_leito, qt_leito_sus,
		dt_atualizacao_leito )
	values (nextval('cnes_api_leitos_seq'), nr_seq_estabelecimento_p, clock_timestamp(),
		nm_usuario_p, clock_timestamp(), nm_usuario_p,
		to_char(somente_numero(ie_leito_p)), quantidade_leito_p, quantidade_leito_sus_p,
		data_atualizacao_p );
exception
when others then
	CALL CALL grava_dados_api_cnes_pck.gravar_log(nr_seq_estabelecimento_p, wheb_mensagem_pck.get_texto(1204636,'DS_LEITO='||ie_leito_p) , nm_usuario_p);
end;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_dados_api_cnes_pck.inserir_leito_cnes ( nr_seq_estabelecimento_p cnes_api_leitos.nr_seq_estabelecimento%type, ie_leito_p cnes_api_leitos.ie_leito%type, quantidade_leito_p cnes_api_leitos.qt_leito%type, quantidade_leito_sus_p cnes_api_leitos.qt_leito_sus%type, data_atualizacao_p cnes_api_leitos.dt_atualizacao_leito%type, nm_usuario_p cnes_api_leitos.nm_usuario%type) FROM PUBLIC;
