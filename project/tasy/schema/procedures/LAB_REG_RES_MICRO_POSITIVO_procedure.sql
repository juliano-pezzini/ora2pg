-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_reg_res_micro_positivo ( nr_prescricao_p prescr_medica.nr_prescricao%type, nr_seq_prescr_p prescr_procedimento.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type DEFAULT NULL) AS $body$
DECLARE


nr_sequencia_w  result_laboratorio.nr_sequencia%type;
nr_atendimento_w prescr_medica.nr_atendimento%type;
nm_usuario_w usuario.nm_usuario%type;
nr_seq_prescr_depend_w prescr_procedimento.nr_sequencia%type;
ie_existe_conta_w   varchar(1) := 'N';


C01 CURSOR FOR
SELECT a.nr_sequencia nr_seq_prescr_depend
FROM prescr_procedimento a
WHERE a.nr_prescricao = nr_prescricao_p
order by a.nr_sequencia;

c01_w      C01%rowtype;


BEGIN

BEGIN

  select nr_sequencia
  INTO STRICT nr_sequencia_w
  from (  SELECT nr_sequencia
          FROM   result_laboratorio a
          WHERE  a.nr_prescricao = nr_prescricao_p
          AND    a.nr_seq_prescricao = nr_seq_prescr_p
          ORDER BY dt_atualizacao desc) alias0 LIMIT 1;

EXCEPTION
      WHEN no_data_found THEN
        CALL WHEB_MENSAGEM_PCK.EXIBIR_MENSAGEM_ABORT(1206289);
      WHEN too_many_rows THEN
        nr_sequencia_w:=0;
END;

BEGIN

SELECT nr_atendimento
INTO STRICT nr_atendimento_w
FROM prescr_medica a
WHERE a.nr_prescricao = nr_prescricao_p;

EXCEPTION
      WHEN no_data_found THEN
        CALL WHEB_MENSAGEM_PCK.EXIBIR_MENSAGEM_ABORT(1206289);
      WHEN too_many_rows THEN
         nr_atendimento_w:=0;
END;

nm_usuario_w := nm_usuario_p;

IF (coalesce(nm_usuario_w::text, '') = '') THEN
  nm_usuario_w := 'LabBco';
END IF;

if (nr_atendimento_w > 0 or nr_sequencia_w > 0) then
    INSERT INTO result_laboratorio_integ(
        nr_sequencia,
        nr_prescricao,
        nr_seq_prescricao,
        dt_atualizacao,
        nm_usuario,
        nr_seq_result_lab,
        ie_res_micro_positivo)
    VALUES (
        nextval('result_laboratorio_integ_seq'),
        nr_prescricao_p,
        nr_seq_prescr_p,
        clock_timestamp(),
        nm_usuario_p,
        nr_sequencia_w,
        'S'
    );

    CALL gerar_exame_lab_dependente(nr_prescricao_p, nr_seq_prescr_p, 11, nr_atendimento_w, nm_usuario_w, null, null, null);

    OPEN C01;
    LOOP
    FETCH C01 INTO
    c01_w;
    EXIT WHEN NOT FOUND; /* apply on C01 */
    BEGIN
    select 'S'
    into STRICT ie_existe_conta_w
    from procedimento_paciente
    where nr_prescricao = nr_prescricao_p
    and nr_sequencia_prescricao = c01_w.nr_seq_prescr_depend;

    EXCEPTION
         WHEN no_data_found THEN
             ie_existe_conta_w := 'N';
         WHEN too_many_rows THEN
             ie_existe_conta_w := 'S';

    END;

        if (ie_existe_conta_w = 'N') then
            CALL Gerar_Proc_Pac_Prescricao(nr_prescricao_p, c01_w.nr_seq_prescr_depend, 0, 0, nm_usuario_w, null, null,null);
            commit;
        end if;

    END LOOP;
    CLOSE C01;
end if;
COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_reg_res_micro_positivo ( nr_prescricao_p prescr_medica.nr_prescricao%type, nr_seq_prescr_p prescr_procedimento.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type DEFAULT NULL) FROM PUBLIC;

