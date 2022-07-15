-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evento_mhr ( cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, nr_atendimento_p bigint, nm_usuario_p text, ds_adicional_info_p text default null) AS $body$
DECLARE


  nr_seq_evento_w bigint;
  qt_idade_w      bigint;
  c04 CURSOR FOR
    SELECT a.nr_seq_evento
    from regra_envio_sms a
    where a.cd_estabelecimento = cd_estabelecimento_p
    and a.ie_evento_disp       = 'MHR'
    and qt_idade_w between coalesce(qt_idade_min,0) and coalesce(qt_idade_max,9999)
    and coalesce(a.ie_situacao,'A') = 'A';

BEGIN
  qt_idade_w := coalesce(obter_idade_pf(cd_pessoa_fisica_p,clock_timestamp(),'A'),0);
  open c04;
  loop
    fetch c04 into nr_seq_evento_w;
    EXIT WHEN NOT FOUND; /* apply on c04 */
    begin
      CALL gerar_evento_paciente_trigger(nr_seq_evento_w, nr_atendimento_p, cd_pessoa_fisica_p, null,nm_usuario_p, ds_adicional_info_p);
    end;
  end loop;
  close c04;
  commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evento_mhr ( cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, nr_atendimento_p bigint, nm_usuario_p text, ds_adicional_info_p text default null) FROM PUBLIC;

