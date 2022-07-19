-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE scheduler_report_log ( ds_arquivo_p text default null, ds_caminho_p text default null, ds_documento_p text default null, ds_profissional_p text default null, ds_sexo_p text default null, ds_situacao_p text default null, ds_tipo_documento_p text default null, dt_cadastro_p timestamp default null, dt_envio_p timestamp default null, dt_nascimento_p timestamp default null, dt_registro_p timestamp default null, nm_paciente_p text default null, nm_usuario_p text default null, nr_prontuario_p text default null, nr_seq_arquivo_p text default null, nr_sequencia_p bigint default null, ie_tipo_log text default 'I') AS $body$
DECLARE


  nr_sequencia_w   bigint;
  dt_envio_w       timestamp;

BEGIN

  if (ie_tipo_log = 'I' or coalesce(ie_tipo_log::text, '') = '' or ie_tipo_log = '') then

    select nextval('conting_scheduler_log_seq')
    into STRICT nr_sequencia_w
;

    insert into conting_scheduler_log(
        ds_arquivo,
        ds_caminho,
        ds_documento,
        ds_profissional,
        ds_sexo,
        ds_situacao,
        ds_tipo_documento,
        dt_atualizacao,
        dt_atualizacao_nrec,
        dt_cadastro,
        dt_envio,
        dt_nascimento,
        dt_registro,
        nm_paciente,
        nm_usuario,
        nm_usuario_nrec,
        nr_prontuario,
        nr_seq_arquivo,
        nr_sequencia
    ) values (
        ds_arquivo_p,
        ds_caminho_p,
        ds_documento_p,
        ds_profissional_p,
        ds_sexo_p,
        ds_situacao_p,
        ds_tipo_documento_p,
        clock_timestamp(),
        clock_timestamp(),
        dt_cadastro_p,
        dt_envio_p,
        dt_nascimento_p,
        dt_registro_p,
        nm_paciente_p,
        nm_usuario_p,
        nm_usuario_p,
        nr_prontuario_p,
        nr_seq_arquivo_p,
        nr_sequencia_w
    );

  elsif (ie_tipo_log = 'UE' and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '')) then

    if (coalesce(dt_envio_p::text, '') = '') then
      dt_envio_w := clock_timestamp();
    else
      dt_envio_w := dt_envio_p;
    end if;

    update conting_scheduler_log 
    set dt_envio = dt_envio_w
    where nr_sequencia = nr_sequencia_p;

  end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE scheduler_report_log ( ds_arquivo_p text default null, ds_caminho_p text default null, ds_documento_p text default null, ds_profissional_p text default null, ds_sexo_p text default null, ds_situacao_p text default null, ds_tipo_documento_p text default null, dt_cadastro_p timestamp default null, dt_envio_p timestamp default null, dt_nascimento_p timestamp default null, dt_registro_p timestamp default null, nm_paciente_p text default null, nm_usuario_p text default null, nr_prontuario_p text default null, nr_seq_arquivo_p text default null, nr_sequencia_p bigint default null, ie_tipo_log text default 'I') FROM PUBLIC;

