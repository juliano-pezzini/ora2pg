-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tax_get_wsi_server_address ( profile_code_p funcao_param_perfil.cd_perfil%type, username_p funcao_param_Usuario.nm_usuario_param%type, establishment_code_p funcao_param_estab.cd_estabelecimento%type, response_p INOUT text) AS $body$
DECLARE

  feature_code_w      constant smallint := 9041;
  parameter_code_w    constant smallint := 5;
  integration_code_w  constant smallint := 1225;
  response_w          varchar(255);

BEGIN
  begin
    select  CASE WHEN coalesce(s.ip_conexao::text, '') = '' THEN  'localhost'  ELSE s.ip_conexao END  ||
            CASE WHEN coalesce(s.nr_porta::text, '') = '' THEN  ''  ELSE ':' || s.nr_porta END
    into STRICT    response_w
    from    cliente_integracao i, 
            servidor_integracao s 
    where   i.nr_seq_serv_origem = s.nr_sequencia
    and     i.ie_situacao = 'A'
    and     i.nr_seq_inf_integracao = integration_code_w;
  exception when others then
    response_w := null;
  end;

  if (coalesce(response_w::text, '') = '') then
    response_w := obter_param_funcao_usu(feature_code_w, parameter_code_w, profile_code_p, username_p, establishment_code_p, 1);
  end if;

  response_p := response_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tax_get_wsi_server_address ( profile_code_p funcao_param_perfil.cd_perfil%type, username_p funcao_param_Usuario.nm_usuario_param%type, establishment_code_p funcao_param_estab.cd_estabelecimento%type, response_p INOUT text) FROM PUBLIC;
