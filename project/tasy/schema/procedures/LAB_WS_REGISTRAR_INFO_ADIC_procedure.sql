-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_ws_registrar_info_adic (nr_prescricao_p bigint, nr_seq_prescr_p bigint, nm_usuario_p text, dt_registro_p text, dt_liberacao_p text, ds_informacao_p text, ie_achado_critico_p text, cd_pessoa_fisica_p text, ds_erro_p INOUT text) AS $body$
DECLARE

  nr_sequencia_w bigint;
  ds_erro_w			varchar(4000);


BEGIN
  if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_prescr_p IS NOT NULL AND nr_seq_prescr_p::text <> '') and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
      select nextval('prescr_proced_inf_adic_seq')
        into STRICT   nr_sequencia_w
;

      ds_erro_p := 'OK';

      insert into PRESCR_PROCED_INF_ADIC(
        nr_sequencia,
        nr_prescricao,
        nr_seq_prescricao,
        nm_usuario,
        dt_registro,
        dt_liberacao,
        ds_informacao,
        ie_achado_critico,
        cd_pessoa_fisica,
        dt_atualizacao,
        ie_situacao)
      values (
        nr_sequencia_w,
        nr_prescricao_p,
        nr_seq_prescr_p,
        nm_usuario_p,
        dt_registro_p,
        dt_liberacao_p,
        ds_informacao_p,
        ie_achado_critico_p,
        cd_pessoa_fisica_p,
        clock_timestamp(),
        'A');
  ELSE
          ds_erro_p := wheb_mensagem_pck.get_texto(1036114, 'DS_ERRO='||sqlerrm(SQLSTATE));
end if;
exception

            when others then
            ds_erro_p := wheb_mensagem_pck.get_texto(1036073, 'DS_ERRO='||sqlerrm(SQLSTATE));

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_ws_registrar_info_adic (nr_prescricao_p bigint, nr_seq_prescr_p bigint, nm_usuario_p text, dt_registro_p text, dt_liberacao_p text, ds_informacao_p text, ie_achado_critico_p text, cd_pessoa_fisica_p text, ds_erro_p INOUT text) FROM PUBLIC;
