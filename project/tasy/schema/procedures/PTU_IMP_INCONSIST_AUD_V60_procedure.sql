-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_imp_inconsist_aud_v60 ( nr_seq_aud_servico_p ptu_resp_auditoria_servico.nr_sequencia%type, cd_mensagem_p ptu_resp_auditoria_servico.cd_servico%type, ds_mensagem_p ptu_resp_auditoria_servico.ds_servico%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Realizar a importação das inconsistências geradas nos itens de 00404 - Resposta de Auditoria
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ x] Tasy (Delphi/Java) [  x] Portal [  ]  Relatórios [ x] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

insert	into ptu_resp_aud_inconsist(nr_sequencia, nr_seq_aud_servico, cd_mensagem,
	ds_mensagem, dt_atualizacao, nm_usuario,
	dt_atualizacao_nrec, nm_usuario_nrec )
values (nextval('ptu_resp_aud_inconsist_seq'), nr_seq_aud_servico_p, cd_mensagem_p,
	ds_mensagem_p, clock_timestamp(), nm_usuario_p,
	clock_timestamp(), nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_imp_inconsist_aud_v60 ( nr_seq_aud_servico_p ptu_resp_auditoria_servico.nr_sequencia%type, cd_mensagem_p ptu_resp_auditoria_servico.cd_servico%type, ds_mensagem_p ptu_resp_auditoria_servico.ds_servico%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

