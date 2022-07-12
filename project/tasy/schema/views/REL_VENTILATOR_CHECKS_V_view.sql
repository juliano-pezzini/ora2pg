-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW rel_ventilator_checks_v (nr_sequencia, nr_atendimento, nm_usuario, dt_atualizacao, dt_liberacao, descritivo, valor) AS select a.nr_sequencia,
               a.nr_atendimento,
               coalesce(a.nm_usuario_nrec, a.nm_usuario) nm_usuario,
               coalesce(a.dt_atualizacao_nrec, a.dt_atualizacao) dt_atualizacao,
               a.dt_liberacao,
               'Tidal Volume (Actual)' Descritivo,
               a.qt_vmin valor
          FROM atendimento_monit_resp a
         where coalesce(a.qt_vmin, 0) > 0

union

        select a.nr_sequencia,
               a.nr_atendimento,
               coalesce(a.nm_usuario_nrec, a.nm_usuario) nm_usuario,
               coalesce(a.dt_atualizacao_nrec, a.dt_atualizacao) dt_atualizacao,
               a.dt_liberacao,
               'Tidal Volume (Set)',
               a.qt_vc_prog valor
          from atendimento_monit_resp a
         where coalesce(a.qt_vc_prog, 0) > 0
        
union

        select a.nr_sequencia,
               a.nr_atendimento,
               coalesce(a.nm_usuario_nrec, a.nm_usuario) nm_usuario,
               coalesce(a.dt_atualizacao_nrec, a.dt_atualizacao) dt_atualizacao,
               a.dt_liberacao,
               'Tidal Volume (Spontaneous)',
               a.qt_vci valor
          from atendimento_monit_resp a
         where coalesce(a.qt_vci, 0) > 0
        
union

        select a.nr_sequencia,
               a.nr_atendimento,
               coalesce(a.nm_usuario_nrec, a.nm_usuario) nm_usuario,
               coalesce(a.dt_atualizacao_nrec, a.dt_atualizacao) dt_atualizacao,
               a.dt_liberacao,
               'Mean Airway Pressure',
               a.qt_pva valor
          from atendimento_monit_resp a
         where coalesce(a.qt_pva, 0) > 0
        
union

        select a.nr_sequencia,
               a.nr_atendimento,
               coalesce(a.nm_usuario_nrec, a.nm_usuario) nm_usuario,
               coalesce(a.dt_atualizacao_nrec, a.dt_atualizacao) dt_atualizacao,
               a.dt_liberacao,
               'Minute Volume',
               a.qt_vmin_parcial valor
          from atendimento_monit_resp a
         where coalesce(a.qt_vmin_parcial, 0) > 0
        
union

        select a.nr_sequencia,
               a.nr_atendimento,
               coalesce(a.nm_usuario_nrec, a.nm_usuario) nm_usuario,
               coalesce(a.dt_atualizacao_nrec, a.dt_atualizacao) dt_atualizacao,
               a.dt_liberacao,
               'Peak Inspiratory Pressure',
               a.qt_pip valor
          from atendimento_monit_resp a
         where coalesce(a.qt_pip, 0) > 0
        
union

        select a.nr_sequencia,
               a.nr_atendimento,
               coalesce(a.nm_usuario_nrec, a.nm_usuario) nm_usuario,
               coalesce(a.dt_atualizacao_nrec, a.dt_atualizacao) dt_atualizacao,
               a.dt_liberacao,
               'Plateau Airway Pressure',
               a.qt_pplato valor
          from atendimento_monit_resp a
         where coalesce(a.qt_pplato, 0) > 0
        
union

        select a.nr_sequencia,
               a.nr_atendimento,
               coalesce(a.nm_usuario_nrec, a.nm_usuario) nm_usuario,
               coalesce(a.dt_atualizacao_nrec, a.dt_atualizacao) dt_atualizacao,
               a.dt_liberacao,
               'Jet Peak Inspiratory Pressure',
               a.qt_pip valor
          from atendimento_monit_resp a
         where coalesce(a.qt_pip, 0) > 0
        
union

        select a.nr_sequencia,
               a.nr_atendimento,
               coalesce(a.nm_usuario_nrec, a.nm_usuario) nm_usuario,
               coalesce(a.dt_atualizacao_nrec, a.dt_atualizacao) dt_atualizacao,
               a.dt_liberacao,
               'Peak Airway Pressure',
               a.qt_pc valor
          from atendimento_monit_resp a
         where coalesce(a.qt_pc, 0) > 0;

