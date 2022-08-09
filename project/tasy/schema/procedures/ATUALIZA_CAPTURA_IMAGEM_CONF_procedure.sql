-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_captura_imagem_conf ( nm_usuario_p text, cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint, cd_equipamento_p bigint, nm_computador_p text, ie_dispositivo_p bigint, ie_resolucao_p bigint, ie_extensao_p bigint ) AS $body$
BEGIN

  update captura_imagem_conf
  set ie_dispositivo = ie_dispositivo_p, ie_resolucao = ie_resolucao_p, ie_extensao = ie_extensao_p
  where cd_estabelecimento   = cd_estabelecimento_p
  and cd_setor_atendimento   = cd_setor_atendimento_p
  and coalesce(cd_equipamento,-1)   = coalesce(cd_equipamento_p,-1)
  and nr_seq_computador    = (SELECT nr_sequencia from computador where nm_computador = nm_computador_p and cd_estabelecimento = cd_estabelecimento_p and ie_situacao = 'A');

  commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_captura_imagem_conf ( nm_usuario_p text, cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint, cd_equipamento_p bigint, nm_computador_p text, ie_dispositivo_p bigint, ie_resolucao_p bigint, ie_extensao_p bigint ) FROM PUBLIC;
