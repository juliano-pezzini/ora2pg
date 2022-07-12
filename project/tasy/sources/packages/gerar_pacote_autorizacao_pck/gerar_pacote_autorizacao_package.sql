-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE gerar_pacote_autorizacao_pck.gerar_pacote_autorizacao ( nr_sequencia_autor_p bigint, nm_usuario_p text) AS $body$
BEGIN

PERFORM set_config('gerar_pacote_autorizacao_pck.nr_sequencia_autor_w', nr_sequencia_autor_p, false);
PERFORM set_config('gerar_pacote_autorizacao_pck.nm_usuario_w', nm_usuario_p, false);
PERFORM set_config('gerar_pacote_autorizacao_pck.ds_pacotes_nao_gerados_w', '', false);

select	cd_convenio,
	cd_estabelecimento,
	dt_autorizacao
into STRICT	current_setting('gerar_pacote_autorizacao_pck.cd_convenio_w')::autorizacao_convenio.cd_convenio%type,
	current_setting('gerar_pacote_autorizacao_pck.cd_estabelecimento_w')::autorizacao_convenio.cd_estabelecimento%type,
	current_setting('gerar_pacote_autorizacao_pck.dt_autorizacao_w')::timestamp
from	autorizacao_convenio
where	nr_sequencia	= nr_sequencia_autor_p;

--1) Consiste se permite gerar os pacotes.
CALL gerar_pacote_autorizacao_pck.consiste_se_gera_pacote();
--2) Primeiro precisa excluir os pacotes já gerados para a autorização.
CALL CALL gerar_pacote_autorizacao_pck.desfazer_pacote();
--3) Inicia a geração dos pacotes.
CALL gerar_pacote_autorizacao_pck.gerar_lista_pacotes();
--5) Crio os pacotes de autorização
--gerar_pacote_autorizacao_pck.criar_pacotes_autorizacao(); 	 ** É chamado dentro da gerar_pacote_autorizacao_pck.gerar_lista_pacotes();
--6) Valida os pacotes de acordo com o cadastro do pacote.
CALL gerar_pacote_autorizacao_pck.validar_pacotes();
--7) Atualiza os procedimentos e materiais da autorização, (vinculando com pacote e inserindo novos itens)
CALL gerar_pacote_autorizacao_pck.atualizar_itens_autorizacao();

--Limpa os vetores.
current_setting('gerar_pacote_autorizacao_pck.lista_pacotes_w')::lista_pacotes_vt.delete;
current_setting('gerar_pacote_autorizacao_pck.proc_pacote_w')::proc_pacote_vt.delete;
current_setting('gerar_pacote_autorizacao_pck.mat_pacote_w')::mat_pacote_vt.delete;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_pacote_autorizacao_pck.gerar_pacote_autorizacao ( nr_sequencia_autor_p bigint, nm_usuario_p text) FROM PUBLIC;