-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nicu_insert_breastmilk (nr_sequencia_p nicu_breast_milk.nr_sequencia%type, nr_seq_encounter_p nicu_breast_milk.nr_seq_encounter%type, qt_left_volume_p nicu_breast_milk.qt_left_volume%type, qt_right_volume_p nicu_breast_milk.qt_right_volume%type, nm_usuario_p nicu_breast_milk.nm_usuario%type, dt_production_date_p nicu_breast_milk.dt_production_date%type, mensagem_erro_o INOUT text) AS $body$
DECLARE

  e_exeption                 exception;
  nr_sequencia_breast_milk_w nicu_breast_milk.nr_sequencia%type;

BEGIN
  if (coalesce(nr_sequencia_p::text, '') = '') then
    --Busca novo Sequencial
    select nextval('nicu_breast_milk_seq')
      into STRICT nr_sequencia_breast_milk_w
;
  else
    nr_sequencia_breast_milk_w := nr_sequencia_p;
  end if;

  begin
    insert into nicu_breast_milk(nr_sequencia,
        nr_seq_encounter,
        dt_production_date,
        qt_left_volume,
        qt_right_volume,
        nm_usuario_nrec,
        dt_atualizacao_nrec,
        nm_usuario,
        dt_atualizacao)
    values (nr_sequencia_breast_milk_w,
        nr_seq_encounter_p,
        dt_production_date_p,
        qt_left_volume_p,
        qt_right_volume_p,
        nm_usuario_p,
        clock_timestamp(),
        nm_usuario_p,
        clock_timestamp());
  exception
    when unique_violation then
      begin
        update nicu_breast_milk
           set nr_seq_encounter = nr_seq_encounter_p,
               dt_production_date = dt_production_date_p,
               qt_left_volume = qt_left_volume_p,
               qt_right_volume = qt_right_volume_p,
               nm_usuario_nrec = nm_usuario_p,
               dt_atualizacao_nrec = clock_timestamp(),
               nm_usuario = nm_usuario_p,
               dt_atualizacao = clock_timestamp()
         where nr_sequencia = nr_sequencia_breast_milk_w;
      exception
        when others then
          mensagem_erro_o := expressao_pck.obter_desc_expressao(776218)||' error: '||sqlerrm;
          raise e_exeption;
      end;
  when others then
    mensagem_erro_o := expressao_pck.obter_desc_expressao(776218)||' error: '||sqlerrm;
    raise e_exeption;
  end;

  commit;
exception
  when e_exeption then
    rollback;
  when others then
    mensagem_erro_o := expressao_pck.obter_desc_expressao(776218)||' error: '||sqlerrm;
    rollback;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nicu_insert_breastmilk (nr_sequencia_p nicu_breast_milk.nr_sequencia%type, nr_seq_encounter_p nicu_breast_milk.nr_seq_encounter%type, qt_left_volume_p nicu_breast_milk.qt_left_volume%type, qt_right_volume_p nicu_breast_milk.qt_right_volume%type, nm_usuario_p nicu_breast_milk.nm_usuario%type, dt_production_date_p nicu_breast_milk.dt_production_date%type, mensagem_erro_o INOUT text) FROM PUBLIC;
