-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pkg_stress_ulcer.buscar_meds_stress_ulcer ( setor bigint, estabelecimento bigint, trimestre bigint, flagIntern bigint ) RETURNS SETOF TABLE_ANALIT_TYPE AS $body$
DECLARE


C_MEDS CURSOR FOR
         SELECT ds_classe_material label,
       pr,
       seg,
       ter,
       qua,
       alleicu
  FROM (
        SELECT cm.ds_classe_material,
               coalesce(pr.qtd, 0) pr,
               coalesce(seg.qtd, 0) seg,
               coalesce(ter.qtd, 0) ter,
               coalesce(qua.qtd, 0) qua,
               coalesce(alleicu.qtd, 0) alleicu
          FROM classe_material cm
          LEFT JOIN (
               SELECT cd_classe_material,
                      COUNT(DISTINCT cd_pessoa_fisica) qtd
                 FROM w_stress_ulcer
                WHERE nr_trimestre = CASE
                                         WHEN trimestre = 4
                                         THEN 1 
                                         WHEN trimestre < 4
                                         THEN trimestre + 1
                                     END
                  AND cd_setor_atendimento = setor
                  AND cd_estabelecimento = estabelecimento
                  AND (
                       (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                       OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                       OR
                       flagIntern = 3
                      )
                GROUP BY cd_classe_material
             ) pr
            ON pr.cd_classe_material = cm.cd_classe_material
          LEFT JOIN (
               SELECT cd_classe_material,
                      COUNT(DISTINCT cd_pessoa_fisica) qtd
                 FROM w_stress_ulcer
                WHERE nr_trimestre = CASE 
                                         WHEN trimestre > 2
                                         THEN trimestre - 2
                                         ELSE trimestre + 2
                                     END
                  AND cd_setor_atendimento = setor
                  AND cd_estabelecimento = estabelecimento
                  AND (
                       (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                       OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                       OR
                       flagIntern = 3
                      )
                GROUP BY cd_classe_material
             ) seg
            ON seg.cd_classe_material = cm.cd_classe_material
          LEFT JOIN (
               SELECT cd_classe_material,
                      COUNT(DISTINCT cd_pessoa_fisica) qtd
                 FROM w_stress_ulcer
                WHERE nr_trimestre = CASE 
                                         WHEN trimestre > 1
                                         THEN trimestre - 1
                                         ELSE trimestre + 4
                                     END
                  AND cd_setor_atendimento = setor
                  AND cd_estabelecimento = estabelecimento
                  AND (
                       (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                       OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                       OR
                       flagIntern = 3
                      )
                GROUP BY cd_classe_material
             ) ter
            ON ter.cd_classe_material = cm.cd_classe_material
          LEFT JOIN (
               SELECT cd_classe_material,
                      COUNT(DISTINCT cd_pessoa_fisica) qtd
                 FROM w_stress_ulcer
                WHERE nr_trimestre = trimestre
                  AND cd_setor_atendimento = setor
                  AND cd_estabelecimento = estabelecimento
                  AND (
                       (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                       OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                       OR
                       flagIntern = 3
                      )
                GROUP BY cd_classe_material
             ) qua
            ON qua.cd_classe_material = cm.cd_classe_material
          LEFT JOIN (
               SELECT cd_classe_material,
                      COUNT(DISTINCT cd_pessoa_fisica) qtd
                 FROM w_stress_ulcer
                WHERE nr_trimestre = trimestre
                  AND (
                       (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                       OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                       OR
                       flagIntern = 3
                      )
                GROUP BY cd_classe_material
             ) alleicu
            ON alleicu.cd_classe_material = cm.cd_classe_material
         WHERE cm.ie_classe_material_rel IN (23, 24, 25, 26)
         ORDER BY ds_classe_material
     ) a
 
UNION ALL

SELECT 'Combined Therapy',
       coalesce(pr, 0) pr,
       coalesce(seg, 0) seg,
       coalesce(ter, 0) ter,
       coalesce(qua, 0) qua,
       coalesce(alleicu, 0) alleicu
  FROM (
        SELECT (
                SELECT COUNT(DISTINCT cd_pessoa_fisica) qtd
                  FROM (
                        SELECT cd_pessoa_fisica,
                               COUNT(DISTINCT ds_medicamento) qtd
                          FROM w_stress_ulcer
                         WHERE nr_trimestre = CASE 
                                                  WHEN trimestre = 4
                                                  THEN 1 
                                                  WHEN trimestre < 4
                                                  THEN trimestre + 1
                                              END
                           AND cd_setor_atendimento = setor
                           AND cd_estabelecimento = estabelecimento
                           AND (ds_medicamento IS NOT NULL AND ds_medicamento::text <> '')
                           AND (
                                (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                OR
                                flagIntern = 3
                               )
                         GROUP BY cd_pessoa_fisica
                     ) a
                 WHERE qtd > 1
               ) pr,
               (
                SELECT COUNT(DISTINCT cd_pessoa_fisica) qtd
                  FROM (
                        SELECT cd_pessoa_fisica,
                               COUNT(DISTINCT ds_medicamento) qtd
                          FROM w_stress_ulcer
                         WHERE nr_trimestre = CASE 
                                                  WHEN trimestre > 2
                                                  THEN trimestre - 2
                                                  ELSE trimestre + 2
                                              END
                           AND cd_setor_atendimento = setor
                           AND cd_estabelecimento = estabelecimento
                           AND (ds_medicamento IS NOT NULL AND ds_medicamento::text <> '')
                           AND (
                                (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                OR
                                flagIntern = 3
                               )
                         GROUP BY cd_pessoa_fisica
                     ) a
                 WHERE qtd > 1
               ) seg,
               (
                SELECT COUNT(DISTINCT cd_pessoa_fisica) qtd
                  FROM (
                        SELECT cd_pessoa_fisica,
                               COUNT(DISTINCT ds_medicamento) qtd
                          FROM w_stress_ulcer
                         WHERE nr_trimestre = CASE 
                                                  WHEN trimestre > 1
                                                  THEN trimestre - 1
                                                  ELSE 4
                                              END
                           AND cd_setor_atendimento = setor
                           AND cd_estabelecimento = estabelecimento
                           AND (ds_medicamento IS NOT NULL AND ds_medicamento::text <> '')
                           AND (
                                (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                OR
                                flagIntern = 3
                               )
                         GROUP BY cd_pessoa_fisica
                     ) a
                 WHERE qtd > 1
               ) ter,
               (
                SELECT COUNT(DISTINCT cd_pessoa_fisica) qtd
                  FROM (
                        SELECT cd_pessoa_fisica,
                               COUNT(DISTINCT ds_medicamento) qtd
                          FROM w_stress_ulcer
                         WHERE nr_trimestre = trimestre
                           AND cd_setor_atendimento = setor
                           AND cd_estabelecimento = estabelecimento
                           AND (ds_medicamento IS NOT NULL AND ds_medicamento::text <> '')
                           AND (
                                (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                OR
                                flagIntern = 3
                               )
                         GROUP BY cd_pessoa_fisica
                     ) a
                 WHERE qtd > 1
               ) qua,
               (
                SELECT COUNT(DISTINCT cd_pessoa_fisica) qtd
                  FROM (
                        SELECT cd_pessoa_fisica,
                               COUNT(DISTINCT ds_medicamento) qtd
                          FROM w_stress_ulcer
                         WHERE nr_trimestre = trimestre
                           AND (ds_medicamento IS NOT NULL AND ds_medicamento::text <> '')
                           AND (
                                (flagIntern = 1 AND coalesce(DT_SAIDA_HOSP::text, '') = '')
                                OR (flagIntern = 2 AND (DT_SAIDA_HOSP IS NOT NULL AND DT_SAIDA_HOSP::text <> ''))
                                OR
                                flagIntern = 3
                               )
                         GROUP BY cd_pessoa_fisica
                     ) a
                 WHERE qtd > 1
               ) alleicu
          
     ) a;


TYPE T_MEDS IS TABLE OF C_MEDS%ROWTYPE;
R_MEDS T_MEDS;

BEGIN
  OPEN C_MEDS;
  LOOP
    FETCH C_MEDS BULK COLLECT INTO R_MEDS LIMIT 1000;

      BEGIN
        FOR i IN R_MEDS.FIRST..R_MEDS.LAST LOOP
          RETURN NEXT R_MEDS(i);
        END LOOP;
      EXCEPTION WHEN OTHERS THEN
        NULL;
      END;

    EXIT WHEN NOT FOUND; /* apply on C_MEDS */

  END LOOP;
  CLOSE C_MEDS;

  RETURN;
END;
  --
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pkg_stress_ulcer.buscar_meds_stress_ulcer ( setor bigint, estabelecimento bigint, trimestre bigint, flagIntern bigint ) FROM PUBLIC;