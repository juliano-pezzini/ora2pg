-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ageint_cons_quimio_vinc.gerar_hora_quimio (dt_agenda_p timestamp, nr_seq_prof_p bigint, nr_seq_ageint_p bigint) AS $body$
DECLARE


qt_registros_w integer;
qt_minutos_duracao_w varchar(255);

cd_pessoa_fisica_w agenda_integrada.cd_pessoa_fisica%type;
nr_seq_ageint_item_w agenda_integrada_item.nr_sequencia%type;

nm_usuario_w varchar(255);
cd_estabelecimento_w integer;


BEGIN

  select max(b.nr_sequencia),
        max(a.cd_pessoa_fisica)
  into STRICT nr_seq_ageint_item_w,
    cd_pessoa_fisica_w
  from agenda_integrada a,
    agenda_integrada_item b
  where b.ie_tipo_agendamento = 'Q'
  and b.nr_seq_agenda_int = a.nr_sequencia
  and a.nr_sequencia = nr_seq_ageint_p;

  select count(1)
  into STRICT qt_registros_w
  from w_agenda_quimio
  where nr_seq_ageint_item = nr_seq_ageint_item_w
  and trunc(dt_horario) = trunc(dt_agenda_p);

  if qt_registros_w = 0 then
    nm_usuario_w := obter_usuario_ativo;
    cd_estabelecimento_w := obter_estabelecimento_ativo;

    Obter_Param_Usuario(865,3,obter_perfil_ativo,nm_usuario_w,cd_estabelecimento_w,qt_minutos_duracao_w);

    CALL Qt_Gerar_Hor_Itens_Ageint(cd_pessoa_fisica_w, dt_agenda_p, nr_seq_ageint_p, qt_minutos_duracao_w, nm_usuario_w, cd_estabelecimento_w, nr_seq_prof_p,
                              null, null, null);
  end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_cons_quimio_vinc.gerar_hora_quimio (dt_agenda_p timestamp, nr_seq_prof_p bigint, nr_seq_ageint_p bigint) FROM PUBLIC;