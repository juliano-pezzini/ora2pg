-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION wheb_inconsistencia.habilitar_integridade (integridade_referencial_p INTEGRIDADE_REFERENCIAL, tasy_config_inconsistencia_p TASY_CONFIG_INCONSISTENCIA) RETURNS boolean AS $body$
DECLARE

    count_w bigint;
    sql_w   varchar(4000);

BEGIN    
    IF wheb_inconsistencia.is_ajusta_automaticamente(integridade_referencial_p) THEN
      count_w := wheb_inconsistencia.do_count_incrows(integridade_referencial_p);

      -- TEM REGISTRO INCONSISTENTE
      IF count_w > 0 THEN
        SAVEPOINT SavePoint_W;
        BEGIN
          -- Acao 1
          IF NOT wheb_inconsistencia.do_action(integridade_referencial_p, tasy_config_inconsistencia_p.ie_acao_prioridade1) THEN
            -- Acao 2
            IF NOT wheb_inconsistencia.do_action(integridade_referencial_p, tasy_config_inconsistencia_p.ie_acao_prioridade2) THEN
              -- Acao 3
              IF NOT wheb_inconsistencia.do_action(integridade_referencial_p, tasy_config_inconsistencia_p.ie_acao_prioridade3) THEN
                -- Acao 4
                IF NOT wheb_inconsistencia.do_action(integridade_referencial_p, tasy_config_inconsistencia_p.ie_acao_prioridade4) THEN
                  RETURN FALSE;
                END IF;
              END IF;
            END IF;
          END IF;

          COMMIT WRITE IMMEDIATE NOWAIT;
        EXCEPTION
          WHEN OTHERS THEN
            ROLLBACK TO SavePoint_W;
            CALL WHEB_MENSAGEM_PCK.EXIBIR_MENSAGEM_ABORT(sqlerrm(SQLSTATE));
        END;
      END IF;
    END IF;

    -- SE ZEROU OS REGISTROS INCONSISTENTES, HABILITA A CONSTRAINT
    IF wheb_inconsistencia.do_count_incrows(integridade_referencial_p) <= 0 THEN
      sql_w := WHEB_DB.GETSQL_ENABLE_CONSTRAINT(integridade_referencial_p);

      CALL WHEB_INCONSISTENCIA_LOG.LOG_COMMAND(sql_w || ';');

      IF current_setting('wheb_inconsistencia.canchangedatabase')::boolean THEN
        EXECUTE sql_w;
        RETURN TRUE;
      END IF;
    END IF;

    RETURN FALSE;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION wheb_inconsistencia.habilitar_integridade (integridade_referencial_p INTEGRIDADE_REFERENCIAL, tasy_config_inconsistencia_p TASY_CONFIG_INCONSISTENCIA) FROM PUBLIC;
