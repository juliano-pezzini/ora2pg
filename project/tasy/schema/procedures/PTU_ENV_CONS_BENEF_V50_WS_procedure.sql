-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_env_cons_benef_v50_ws ( cd_unimed_benef_p ptu_consulta_beneficiario.cd_unimed_beneficiario%type, cd_usuario_plano_p text, nm_beneficiario_p ptu_consulta_beneficiario.nm_beneficiario%type, sobrenome_benef_p ptu_consulta_beneficiario.sobrenome_beneficiario%type, dt_nascimento_p ptu_consulta_beneficiario.dt_nascimento%type, nr_versao_ptu_p ptu_consulta_beneficiario.nr_versao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_cons_benef_p INOUT ptu_consulta_beneficiario.nr_sequencia%type ) AS $body$
BEGIN

nr_seq_cons_benef_p := ptu_envio_scs_ws_pck.ptu_envio_cons_dados_benef(cd_unimed_benef_p, cd_usuario_plano_p, nm_beneficiario_p, sobrenome_benef_p, dt_nascimento_p, nr_versao_ptu_p, cd_estabelecimento_p, nm_usuario_p, nr_seq_cons_benef_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_env_cons_benef_v50_ws ( cd_unimed_benef_p ptu_consulta_beneficiario.cd_unimed_beneficiario%type, cd_usuario_plano_p text, nm_beneficiario_p ptu_consulta_beneficiario.nm_beneficiario%type, sobrenome_benef_p ptu_consulta_beneficiario.sobrenome_beneficiario%type, dt_nascimento_p ptu_consulta_beneficiario.dt_nascimento%type, nr_versao_ptu_p ptu_consulta_beneficiario.nr_versao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_cons_benef_p INOUT ptu_consulta_beneficiario.nr_sequencia%type ) FROM PUBLIC;
