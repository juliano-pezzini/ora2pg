-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nicu_insert_skin_skin (nr_sequencia_p nicu_skin_skin.nr_sequencia%type, nr_seq_encounter_p nicu_skin_skin.nr_seq_encounter%type, dt_session_date_p nicu_skin_skin.dt_session_date%type, qt_duration_p nicu_skin_skin.qt_duration%type, nm_usuario_p nicu_skin_skin.nm_usuario%type, mensagem_erro_p INOUT text) AS $body$
DECLARE


  nr_sequencia_skin_skin_w nicu_skin_skin.nr_sequencia%type;
  exeption_w               exception;
  exit_w                   exception;

BEGIN
  if (qt_duration_p < 1) then
    raise exit_w;
  end if;

  if (coalesce(nr_sequencia_p::text, '') = '') then
    --Busca novo sequencial
    select nextval('nicu_skin_skin_seq')
      into STRICT nr_sequencia_skin_skin_w
;
  else
    nr_sequencia_skin_skin_w := nr_sequencia_p;
  end if;

  begin
    insert into nicu_skin_skin(nr_sequencia,
        nr_seq_encounter,
        dt_session_date,
        qt_duration,
        dt_atualizacao,
        nm_usuario,
        dt_atualizacao_nrec,
        nm_usuario_nrec)
    values (nr_sequencia_skin_skin_w,
        nr_seq_encounter_p,
        dt_session_date_p,
        qt_duration_p,
        clock_timestamp(),
        nm_usuario_p,
        clock_timestamp(),
        nm_usuario_p);
  exception
    when unique_violation then
      begin
        update nicu_skin_skin
           set nr_seq_encounter = nr_seq_encounter_p,
               dt_session_date = coalesce(dt_session_date_p, dt_session_date),
               qt_duration = qt_duration_p,
               dt_atualizacao = clock_timestamp(),
               nm_usuario = nm_usuario_p,
               dt_atualizacao_nrec = clock_timestamp(),
               nm_usuario_nrec = nm_usuario_p
         where nr_sequencia = nr_sequencia_skin_skin_w;
      exception
        when others then
          mensagem_erro_p := expressao_pck.obter_desc_expressao(776218)||' Error: '|| sqlerrm;
          raise exeption_w;
      end;
    when others then
      mensagem_erro_p := expressao_pck.obter_desc_expressao(776218)||' Error: '|| sqlerrm;
      raise exeption_w;
  end;

  commit;
exception
  when exit_w then
    null;
  when exeption_w then
    rollback;
  when others then
    mensagem_erro_p := expressao_pck.obter_desc_expressao(776218)||' Error: '|| sqlerrm;
    rollback;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nicu_insert_skin_skin (nr_sequencia_p nicu_skin_skin.nr_sequencia%type, nr_seq_encounter_p nicu_skin_skin.nr_seq_encounter%type, dt_session_date_p nicu_skin_skin.dt_session_date%type, qt_duration_p nicu_skin_skin.qt_duration%type, nm_usuario_p nicu_skin_skin.nm_usuario%type, mensagem_erro_p INOUT text) FROM PUBLIC;

