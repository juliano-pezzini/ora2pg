-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pkg_stress_ulcer.buscar_vent_stress_ulcer ( setor bigint, estabelecimento bigint, trimestre bigint, flagIntern bigint ) RETURNS SETOF TABLE_ANALIT_TYPE AS $body$
DECLARE


C_VENT CURSOR FOR
         SELECT 'Number of At-Risk Patients' LABEL,
                 coalesce(PR, 0) PR,
                 coalesce(SEG, 0) SEG,
                 coalesce(TER, 0) TER,
                 coalesce(QUA, 0) QUA,
                 coalesce(ALLEICU, 0) ALLEICU
            FROM (
                  SELECT (
                          SELECT COUNT(DISTINCT CD_PESSOA_FISICA)
                            FROM W_STRESS_ULCER su
                           WHERE ((estabelecimento != 0 AND CD_ESTABELECIMENTO = estabelecimento) OR estabelecimento = 0)
                             AND ((setor != 0 AND CD_SETOR_ATENDIMENTO = setor) OR setor = 0)
                             AND su.ie_tipo = 1
                             AND su.nr_trimestre = CASE
                                                       WHEN trimestre = 4
                                                       THEN 1 
                                                       WHEN trimestre < 4
                                                       THEN trimestre + 1
                                                   END
                             AND (
                                  (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                  OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                  OR
                                  flagIntern = 3
                                 )
                       ) pr,
                       (
                        SELECT COUNT(DISTINCT CD_PESSOA_FISICA)
                          FROM W_STRESS_ULCER su
                         WHERE ((estabelecimento != 0 AND CD_ESTABELECIMENTO = estabelecimento) OR estabelecimento = 0)
                           AND ((setor != 0 AND CD_SETOR_ATENDIMENTO = setor) OR setor = 0)
                           AND su.ie_tipo = 1
                           AND su.nr_trimestre = CASE 
                                                     WHEN trimestre > 2
                                                     THEN trimestre - 2
                                                     ELSE trimestre + 2
                                                 END
                           AND (
                                (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                OR
                                flagIntern = 3
                               )
                       ) seg,
                       (
                        SELECT COUNT(DISTINCT CD_PESSOA_FISICA)
                          FROM W_STRESS_ULCER su
                         WHERE ((estabelecimento != 0 AND CD_ESTABELECIMENTO = estabelecimento) OR estabelecimento = 0)
                           AND ((setor != 0 AND CD_SETOR_ATENDIMENTO = setor) OR setor = 0)
                           AND su.ie_tipo = 1
                           AND su.nr_trimestre = CASE 
                                                     WHEN trimestre > 1
                                                     THEN trimestre - 1
                                                     ELSE 4
                                                 END
                           AND (
                                (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                OR
                                flagIntern = 3
                               )
                       ) ter,
                       (
                        SELECT COUNT(DISTINCT CD_PESSOA_FISICA)
                          FROM W_STRESS_ULCER su
                         WHERE ((estabelecimento != 0 AND CD_ESTABELECIMENTO = estabelecimento) OR estabelecimento = 0)
                           AND ((setor != 0 AND CD_SETOR_ATENDIMENTO = setor) OR setor = 0)
                           AND su.ie_tipo = 1
                           AND su.nr_trimestre = trimestre
                           AND (
                                (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                OR
                                flagIntern = 3
                               )
                       ) qua,
                       (
                        SELECT COUNT(DISTINCT CD_PESSOA_FISICA)
                          FROM W_STRESS_ULCER su
                         WHERE su.ie_tipo = 1
                           AND su.nr_trimestre = trimestre
                           AND (
                                (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                OR
                                flagIntern = 3
                               )
                       ) alleicu
                    
                ) a
           
UNION ALL

          SELECT 'Number of At-Risk Patients Treated' LABEL,
                 coalesce(PR, 0) PR,
                 coalesce(SEG, 0) SEG,
                 coalesce(TER, 0) TER,
                 coalesce(QUA, 0) QUA,
                 coalesce(ALLEICU, 0) ALLEICU
            FROM (
                  SELECT (
                          SELECT COUNT(DISTINCT CD_PESSOA_FISICA)
                            FROM W_STRESS_ULCER su
                           WHERE ((estabelecimento != 0 AND CD_ESTABELECIMENTO = estabelecimento) OR estabelecimento = 0)
                             AND ((setor != 0 AND CD_SETOR_ATENDIMENTO = setor) OR setor = 0)
                             AND su.ie_tipo = 1
                             AND (su.ds_medicamento IS NOT NULL AND su.ds_medicamento::text <> '')
                             AND su.nr_trimestre = CASE 
                                                       WHEN trimestre = 4
                                                       THEN 1 
                                                       WHEN trimestre < 4
                                                       THEN trimestre + 1
                                                   END
                             AND (
                                  (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                  OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                  OR
                                  flagIntern = 3
                                 )
                       ) pr,
                       (
                        SELECT COUNT(DISTINCT CD_PESSOA_FISICA)
                          FROM W_STRESS_ULCER su
                         WHERE ((estabelecimento != 0 AND CD_ESTABELECIMENTO = estabelecimento) OR estabelecimento = 0)
                           AND ((setor != 0 AND CD_SETOR_ATENDIMENTO = setor) OR setor = 0)
                           AND su.ie_tipo = 1
                           AND (su.ds_medicamento IS NOT NULL AND su.ds_medicamento::text <> '')
                           AND su.nr_trimestre = CASE 
                                                     WHEN trimestre > 2
                                                     THEN trimestre - 2
                                                     ELSE trimestre + 2
                                                 END
                           AND (
                                (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                OR
                                flagIntern = 3
                               )
                       ) seg,
                       (
                        SELECT COUNT(DISTINCT CD_PESSOA_FISICA)
                          FROM W_STRESS_ULCER su
                         WHERE ((estabelecimento != 0 AND CD_ESTABELECIMENTO = estabelecimento) OR estabelecimento = 0)
                           AND ((setor != 0 AND CD_SETOR_ATENDIMENTO = setor) OR setor = 0)
                           AND su.ie_tipo = 1
                           AND (su.ds_medicamento IS NOT NULL AND su.ds_medicamento::text <> '')
                           AND su.nr_trimestre = CASE 
                                                     WHEN trimestre > 1
                                                     THEN trimestre - 1
                                                     ELSE 4
                                                 END
                           AND (
                                (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                OR
                                flagIntern = 3
                               )
                       ) ter,
                       (
                        SELECT COUNT(DISTINCT CD_PESSOA_FISICA)
                          FROM W_STRESS_ULCER su
                         WHERE ((estabelecimento != 0 AND CD_ESTABELECIMENTO = estabelecimento) OR estabelecimento = 0)
                           AND ((setor != 0 AND CD_SETOR_ATENDIMENTO = setor) OR setor = 0)
                           AND su.ie_tipo = 1
                           AND su.nr_trimestre = trimestre
                           AND (su.ds_medicamento IS NOT NULL AND su.ds_medicamento::text <> '')
                           AND (
                                (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                OR
                                flagIntern = 3
                               )
                       ) qua,
                       (
                        SELECT COUNT(DISTINCT CD_PESSOA_FISICA)
                          FROM W_STRESS_ULCER su
                         WHERE su.ie_tipo = 1
                           AND su.nr_trimestre = trimestre
                           AND (su.ds_medicamento IS NOT NULL AND su.ds_medicamento::text <> '')
                           AND (
                                (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                OR
                                flagIntern = 3
                               )
                       ) alleicu
                    
                ) a
           
UNION ALL

          SELECT 'At-Risk Patients Treated (%)' LABEL,
                 coalesce(PR, 0) PR,
                 coalesce(SEG, 0) SEG,
                 coalesce(TER, 0) TER,
                 coalesce(QUA, 0) QUA,
                 coalesce(ALLEICU, 0) ALLEICU
            FROM (
                  SELECT ROUND (
                          (
                           (
                            SELECT COUNT(DISTINCT CD_PESSOA_FISICA)
                              FROM W_STRESS_ULCER su
                             WHERE ((estabelecimento != 0 AND CD_ESTABELECIMENTO = estabelecimento) OR estabelecimento = 0)
                               AND ((setor != 0 AND CD_SETOR_ATENDIMENTO = setor) OR setor = 0)
                               AND su.ie_tipo = 1
                               AND (su.ds_medicamento IS NOT NULL AND su.ds_medicamento::text <> '')
                               AND su.nr_trimestre = CASE 
                                                         WHEN trimestre = 4
                                                         THEN 1 
                                                         WHEN trimestre < 4
                                                         THEN trimestre + 1
                                                     END
                               AND (
                                    (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                    OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                    OR
                                    flagIntern = 3
                                   )
                         ) / (
                            SELECT COUNT(DISTINCT CD_PESSOA_FISICA)
                              FROM W_STRESS_ULCER su
                             WHERE ((estabelecimento != 0 AND CD_ESTABELECIMENTO = estabelecimento) OR estabelecimento = 0)
                               AND ((setor != 0 AND CD_SETOR_ATENDIMENTO = setor) OR setor = 0)
                               AND su.ie_tipo = 1
                               AND su.nr_trimestre = CASE 
                                                         WHEN trimestre = 4
                                                         THEN 1 
                                                         WHEN trimestre < 4
                                                         THEN trimestre + 1
                                                     END
                               AND (
                                    (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                    OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                    OR
                                    flagIntern = 3
                                   )
                         )
                        ) * 100
                       , 2) pr,
                       ROUND (
                          (
                           (
                            SELECT COUNT(DISTINCT CD_PESSOA_FISICA)
                              FROM W_STRESS_ULCER su
                             WHERE ((estabelecimento != 0 AND CD_ESTABELECIMENTO = estabelecimento) OR estabelecimento = 0)
                               AND ((setor != 0 AND CD_SETOR_ATENDIMENTO = setor) OR setor = 0)
                               AND su.ie_tipo = 1
                               AND (su.ds_medicamento IS NOT NULL AND su.ds_medicamento::text <> '')
                               AND su.nr_trimestre = CASE 
                                                         WHEN trimestre > 2
                                                         THEN trimestre - 2
                                                         ELSE trimestre + 2
                                                     END
                               AND (
                                    (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                    OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                    OR
                                    flagIntern = 3
                                   )
                         ) / (
                            SELECT COUNT(DISTINCT CD_PESSOA_FISICA)
                              FROM W_STRESS_ULCER su
                             WHERE ((estabelecimento != 0 AND CD_ESTABELECIMENTO = estabelecimento) OR estabelecimento = 0)
                               AND ((setor != 0 AND CD_SETOR_ATENDIMENTO = setor) OR setor = 0)
                               AND su.ie_tipo = 1
                               AND su.nr_trimestre = CASE 
                                                         WHEN trimestre > 2
                                                         THEN trimestre - 2
                                                         ELSE trimestre + 2
                                                     END
                               AND (
                                    (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                    OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                    OR
                                    flagIntern = 3
                                   )
                         )
                        ) * 100
                       , 2) seg,
                       ROUND (
                          (
                           (
                            SELECT COUNT(DISTINCT CD_PESSOA_FISICA)
                              FROM W_STRESS_ULCER su
                             WHERE ((estabelecimento != 0 AND CD_ESTABELECIMENTO = estabelecimento) OR estabelecimento = 0)
                               AND ((setor != 0 AND CD_SETOR_ATENDIMENTO = setor) OR setor = 0)
                               AND su.ie_tipo = 1
                               AND (su.ds_medicamento IS NOT NULL AND su.ds_medicamento::text <> '')
                               AND su.nr_trimestre = CASE 
                                                         WHEN trimestre > 1
                                                         THEN trimestre - 1
                                                         ELSE 4
                                                     END
                               AND (
                                    (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                    OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                    OR
                                    flagIntern = 3
                                   )
                         ) / (
                            SELECT COUNT(DISTINCT CD_PESSOA_FISICA)
                              FROM W_STRESS_ULCER su
                             WHERE ((estabelecimento != 0 AND CD_ESTABELECIMENTO = estabelecimento) OR estabelecimento = 0)
                               AND ((setor != 0 AND CD_SETOR_ATENDIMENTO = setor) OR setor = 0)
                               AND su.ie_tipo = 1
                               AND su.nr_trimestre = CASE 
                                                         WHEN trimestre > 1
                                                         THEN trimestre - 1
                                                         ELSE 4
                                                     END
                               AND (
                                    (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                    OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                    OR
                                    flagIntern = 3
                                   )
                         )
                        ) * 100
                       , 2) ter,
                       ROUND (
                          (
                           (
                            SELECT COUNT(DISTINCT CD_PESSOA_FISICA)
                              FROM W_STRESS_ULCER su
                             WHERE ((estabelecimento != 0 AND CD_ESTABELECIMENTO = estabelecimento) OR estabelecimento = 0)
                               AND ((setor != 0 AND CD_SETOR_ATENDIMENTO = setor) OR setor = 0)
                               AND su.ie_tipo = 1
                               AND (su.ds_medicamento IS NOT NULL AND su.ds_medicamento::text <> '')
                               AND su.nr_trimestre = trimestre
                               AND (
                                    (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                    OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                    OR
                                    flagIntern = 3
                                   )
                         ) / (
                            SELECT COUNT(DISTINCT CD_PESSOA_FISICA)
                              FROM W_STRESS_ULCER su
                             WHERE ((estabelecimento != 0 AND CD_ESTABELECIMENTO = estabelecimento) OR estabelecimento = 0)
                               AND ((setor != 0 AND CD_SETOR_ATENDIMENTO = setor) OR setor = 0)
                               AND su.ie_tipo = 1
                               AND su.nr_trimestre = trimestre
                               AND (
                                    (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                    OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                    OR
                                    flagIntern = 3
                                   )
                         )
                        ) * 100
                       , 2) qua,
                       ROUND (
                          (
                           (
                            SELECT COUNT(DISTINCT CD_PESSOA_FISICA)
                              FROM W_STRESS_ULCER su
                             WHERE su.ie_tipo = 1
                               AND (su.ds_medicamento IS NOT NULL AND su.ds_medicamento::text <> '')
                               AND su.nr_trimestre = trimestre
                               AND (
                                    (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                    OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                    OR
                                    flagIntern = 3
                                   )
                         ) / (
                            SELECT COUNT(DISTINCT CD_PESSOA_FISICA)
                              FROM W_STRESS_ULCER su
                             WHERE su.ie_tipo = 1
                               AND su.nr_trimestre = trimestre
                               AND (
                                    (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                    OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                    OR
                                    flagIntern = 3
                                   )
                         )
                        ) * 100
                       , 2) alleicu
                    
                ) a;


TYPE T_VENT IS TABLE OF C_VENT%ROWTYPE;
R_VENT T_VENT;

BEGIN
  OPEN C_VENT;
  LOOP
    FETCH C_VENT BULK COLLECT INTO R_VENT LIMIT 1000;

      BEGIN
        FOR i IN R_VENT.FIRST..R_VENT.LAST LOOP
          RETURN NEXT R_VENT(i);
        END LOOP;
      EXCEPTION WHEN OTHERS THEN
        NULL;
      END;

    EXIT WHEN NOT FOUND; /* apply on C_VENT */

  END LOOP;
  CLOSE C_VENT;

  RETURN;
END;
  --
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pkg_stress_ulcer.buscar_vent_stress_ulcer ( setor bigint, estabelecimento bigint, trimestre bigint, flagIntern bigint ) FROM PUBLIC;