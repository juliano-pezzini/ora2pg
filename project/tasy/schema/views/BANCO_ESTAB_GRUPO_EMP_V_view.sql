-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW banco_estab_grupo_emp_v (cd, ds, cd_estabelecimento, cd_empresa) AS SELECT  a.nr_sequencia cd,
        a.ds_conta ds,
        a.cd_estabelecimento,
        a.cd_empresa
FROM    banco_estabelecimento_v a
WHERE a.cd_empresa IN (SELECT cd_empresa cd
                      FROM grupo_emp_estrutura b
                       WHERE dt_inicio_vigencia  <=  TRUNC(LOCALTIMESTAMP)
                       AND (dt_fim_vigencia    >=  TRUNC(LOCALTIMESTAMP) OR dt_fim_vigencia  IS  NULL)
                       AND b.nr_seq_grupo =
                             holding_pck.get_acesso_grupo_emp(851,
                                                              wheb_usuario_pck.get_cd_perfil,
                                                              wheb_usuario_pck.get_nm_usuario,
                                                              NULL,
                                                              'GEM',
                                                              obter_empresa_estab(wheb_usuario_pck.get_cd_estabelecimento)))
AND (
  a.cd_estabelecimento IS NULL OR
  a.cd_estabelecimento IN (SELECT e.cd_estabelecimento cd
                            FROM grupo_emp_estrutura b, estabelecimento e
                             WHERE e.cd_empresa = b.cd_empresa
                             AND    dt_inicio_vigencia  <=  TRUNC(LOCALTIMESTAMP)
                             AND (dt_fim_vigencia    >=  TRUNC(LOCALTIMESTAMP) OR dt_fim_vigencia  IS  NULL)
                             AND b.nr_seq_grupo =
                                 holding_pck.get_acesso_grupo_emp(851,
                                                                  wheb_usuario_pck.get_cd_perfil,
                                                                  wheb_usuario_pck.get_nm_usuario,
                                                                  NULL,
                                                                  'GEM',
                                                                  obter_empresa_estab(wheb_usuario_pck.get_cd_estabelecimento))) OR
  obter_estab_financeiro(a.cd_estabelecimento) IN (SELECT e.cd_estabelecimento cd
                            FROM grupo_emp_estrutura b, estabelecimento e
                             WHERE e.cd_empresa = b.cd_empresa
                             AND    dt_inicio_vigencia  <=  TRUNC(LOCALTIMESTAMP)
                             AND (dt_fim_vigencia    >=  TRUNC(LOCALTIMESTAMP) OR dt_fim_vigencia  IS  NULL)
                             AND b.nr_seq_grupo =
                                 holding_pck.get_acesso_grupo_emp(851,
                                                                  wheb_usuario_pck.get_cd_perfil,
                                                                  wheb_usuario_pck.get_nm_usuario,
                                                                  NULL,
                                                                  'GEM',
                                                                  obter_empresa_estab(wheb_usuario_pck.get_cd_estabelecimento)))
)
AND a.ie_situacao   =  'A';
