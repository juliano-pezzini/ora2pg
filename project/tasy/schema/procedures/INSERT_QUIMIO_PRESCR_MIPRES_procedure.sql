-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_quimio_prescr_mipres ( nr_seq_paciente_p paciente_setor.nr_seq_paciente%TYPE, nr_atendimento_p prescr_mipres.nr_atendimento%TYPE, cd_funcao_p prescr_mipres.cd_funcao%TYPE, nr_seq_prescr_mipres_p prescr_mipres.nr_sequencia%TYPE default null, nr_presc_mipres_p prescr_mipres.nr_presc_mipres%TYPE default null, dt_validity_p prescr_mipres.dt_validity_mipres%TYPE default null) AS $body$
DECLARE


ie_eps_w                    convenio_plano.ie_eps%TYPE;
ie_tipo_item_presc_w        prescr_mipres.ie_tipo_item_presc%TYPE;
nr_seq_prescr_mipres_w      prescr_mipres.nr_sequencia%TYPE;

TYPE prescr_mipres_t            IS TABLE OF prescr_mipres%rowtype               INDEX BY integer;
TYPE paciente_protocolo_medic_t IS TABLE OF paciente_protocolo_medic%rowtype    INDEX BY integer;
TYPE paciente_protocolo_soluc_t IS TABLE OF paciente_protocolo_soluc%rowtype    INDEX BY integer;
TYPE paciente_protocolo_proc_t  IS TABLE OF paciente_protocolo_proc%rowtype     INDEX BY integer;

prescr_mipres_row               prescr_mipres_t;
paciente_protocolo_medic_row    paciente_protocolo_medic_t;
paciente_protocolo_soluc_row    paciente_protocolo_soluc_t;
paciente_protocolo_proc_row     paciente_protocolo_proc_t;

prescr_mipres_count                integer := 0;

c_chemotherapy CURSOR FOR
    SELECT  ps.cd_pessoa_fisica,
            ppm.nr_seq_interno nr_seq_tabela,
            'M' ie_tipo_item_prescr
    from    paciente_protocolo_medic ppm,
            paciente_setor ps,
            material m
    where   ppm.cd_material = m.cd_material
    and     ppm.nr_seq_paciente = nr_seq_paciente_p
    and     ppm.nr_seq_paciente = ps.nr_seq_paciente
    and     coalesce(ppm.nr_seq_prescr_mipres::text, '') = ''
    and     coalesce(ppm.nr_seq_solucao::text, '') = ''
    and     m.ie_nopbs = 'S'

union

    SELECT  ps.cd_pessoa_fisica,
            pps.nr_seq_solucao nr_seq_tabela,
            'SOL' ie_tipo_item_prescr
    from    paciente_protocolo_soluc pps,
            paciente_protocolo_medic ppm,
            paciente_setor ps,
            material m
    where   pps.nr_seq_paciente = nr_seq_paciente_p
    and     pps.nr_seq_paciente = ppm.nr_seq_paciente
    and     pps.nr_seq_paciente = ps.nr_seq_paciente
    and     ppm.nr_seq_solucao = pps.nr_seq_solucao
    and     ppm.cd_material = m.cd_material
    and     coalesce(pps.nr_seq_prescr_mipres::text, '') = ''
    and     coalesce(ppm.nr_seq_prescr_mipres::text, '') = ''
    and     m.ie_nopbs = 'S'
    
union

    select  ps.cd_pessoa_fisica,
            ppp.nr_seq_procedimento nr_seq_tabela,
            'P' ie_tipo_item_prescr
    from    paciente_protocolo_proc ppp,
            paciente_setor ps,
            proc_interno pi,
            procedimento p
    where   ppp.nr_seq_paciente = nr_seq_paciente_p
    and     ppp.nr_seq_paciente = ps.nr_seq_paciente
    and     ppp.nr_seq_proc_interno = pi.nr_sequencia
    and     pi.cd_procedimento = p.cd_procedimento
    and     pi.ie_origem_proced = p.ie_origem_proced
    and     coalesce(ppp.nr_seq_prescr_mipres::text, '') = ''
    and     p.ie_nopbs = 'S';
BEGIN

    SELECT coalesce(max(a.ie_eps),'N')
    INTO STRICT   ie_eps_w
    FROM   convenio_plano a
    WHERE  a.cd_plano = obter_plano_convenio_atend(nr_atendimento_p,'C')
    AND    a.cd_convenio = obter_convenio_atendimento(nr_atendimento_p);

    IF (ie_eps_w = 'S' AND coalesce(nr_seq_prescr_mipres_p::text, '') = '') THEN

        FOR l_chemotherapy IN c_chemotherapy LOOP

            nr_seq_prescr_mipres_w := obter_nextval_sequence('PRESCR_MIPRES');
            prescr_mipres_count                                         := prescr_mipres_count + 1;
            prescr_mipres_row[prescr_mipres_count].nr_sequencia         := nr_seq_prescr_mipres_w;
            prescr_mipres_row[prescr_mipres_count].dt_atualizacao       := clock_timestamp();
            prescr_mipres_row[prescr_mipres_count].dt_atualizacao_nrec  := clock_timestamp();
            prescr_mipres_row[prescr_mipres_count].nm_usuario           := wheb_usuario_pck.get_nm_usuario;
            prescr_mipres_row[prescr_mipres_count].nm_usuario_nrec      := wheb_usuario_pck.get_nm_usuario;
            prescr_mipres_row[prescr_mipres_count].ie_status            := '1';
            prescr_mipres_row[prescr_mipres_count].nr_atendimento       := nr_atendimento_p;
            prescr_mipres_row[prescr_mipres_count].cd_pessoa_fisica     := l_chemotherapy.cd_pessoa_fisica;
            prescr_mipres_row[prescr_mipres_count].cd_funcao            := cd_funcao_p;
            prescr_mipres_row[prescr_mipres_count].ie_pendency_origin   := 'ONC';
            prescr_mipres_row[prescr_mipres_count].ie_tipo_item_presc   := l_chemotherapy.ie_tipo_item_prescr;

            IF (l_chemotherapy.ie_tipo_item_prescr = 'M') THEN
                
                paciente_protocolo_medic_row[prescr_mipres_count].nr_seq_prescr_mipres := nr_seq_prescr_mipres_w;
                paciente_protocolo_medic_row[prescr_mipres_count].nr_seq_interno := l_chemotherapy.nr_seq_tabela;

            ELSIF (l_chemotherapy.ie_tipo_item_prescr = 'SOL') then

                paciente_protocolo_soluc_row[prescr_mipres_count].nr_seq_prescr_mipres := nr_seq_prescr_mipres_w;
                paciente_protocolo_soluc_row[prescr_mipres_count].nr_seq_solucao := l_chemotherapy.nr_seq_tabela;

                paciente_protocolo_medic_row[prescr_mipres_count].nr_seq_prescr_mipres := nr_seq_prescr_mipres_w;
                paciente_protocolo_medic_row[prescr_mipres_count].nr_seq_solucao := l_chemotherapy.nr_seq_tabela;

            ELSIF (l_chemotherapy.ie_tipo_item_prescr = 'P') then

                paciente_protocolo_proc_row[prescr_mipres_count].nr_seq_prescr_mipres := nr_seq_prescr_mipres_w;
                paciente_protocolo_proc_row[prescr_mipres_count].nr_seq_procedimento := l_chemotherapy.nr_seq_tabela;

                paciente_protocolo_medic_row[prescr_mipres_count].nr_seq_prescr_mipres := nr_seq_prescr_mipres_w;
                paciente_protocolo_medic_row[prescr_mipres_count].nr_seq_procedimento := l_chemotherapy.nr_seq_tabela;

            END IF;
        END LOOP;

        $if dbms_db_version.version >= 11 $then

          IF (prescr_mipres_row.FIRST IS NOT NULL AND prescr_mipres_row.FIRST::text <> '') THEN  
              FORALL i IN prescr_mipres_row.FIRST .. prescr_mipres_row.LAST  
                  INSERT INTO prescr_mipres VALUES prescr_mipres_row(i);

              FOR i IN prescr_mipres_row.FIRST..prescr_mipres_row.LAST LOOP
                  CALL SET_TASK_LIST_MIPRES('I', nr_atendimento_p, NULL, prescr_mipres_row[i].nr_sequencia, wheb_usuario_pck.get_nm_usuario);
              END LOOP;

          END IF;
          
          IF (paciente_protocolo_medic_row.FIRST IS NOT NULL AND paciente_protocolo_medic_row.FIRST::text <> '') THEN  
              FORALL i IN paciente_protocolo_medic_row.FIRST .. paciente_protocolo_medic_row.LAST  
                  UPDATE  paciente_protocolo_medic 
                  SET     nr_seq_prescr_mipres = paciente_protocolo_medic_row[i].nr_seq_prescr_mipres
                  WHERE   ((paciente_protocolo_medic_row[i](.nr_seq_interno IS NOT NULL AND .nr_seq_interno::text <> '') and nr_seq_interno = paciente_protocolo_medic_row[i].nr_seq_interno) OR (paciente_protocolo_medic_row[i](.nr_seq_solucao IS NOT NULL AND .nr_seq_solucao::text <> '') and nr_seq_solucao = paciente_protocolo_medic_row[i].nr_seq_solucao))
                  AND     nr_seq_paciente = nr_seq_paciente_p;
          END IF;
          
          IF (paciente_protocolo_soluc_row.FIRST IS NOT NULL AND paciente_protocolo_soluc_row.FIRST::text <> '') THEN  
              FORALL i IN paciente_protocolo_soluc_row.FIRST .. paciente_protocolo_soluc_row.LAST  
                  UPDATE  paciente_protocolo_soluc
                  SET     nr_seq_prescr_mipres = paciente_protocolo_soluc_row[i].nr_seq_prescr_mipres
                  WHERE   nr_seq_solucao = paciente_protocolo_soluc_row[i].nr_seq_solucao
                  AND     nr_seq_paciente = nr_seq_paciente_p;
          END IF;
          
          IF (paciente_protocolo_proc_row.FIRST IS NOT NULL AND paciente_protocolo_proc_row.FIRST::text <> '') THEN  
              FORALL i IN paciente_protocolo_proc_row.FIRST .. paciente_protocolo_proc_row.LAST  
                  UPDATE  paciente_protocolo_proc
                  SET     nr_seq_prescr_mipres = paciente_protocolo_proc_row[i].nr_seq_prescr_mipres
                  WHERE   nr_seq_procedimento = paciente_protocolo_proc_row[i].nr_seq_procedimento
                  AND     nr_seq_paciente = nr_seq_paciente_p;
          END IF;
    
        $end
    ELSIF (nr_seq_prescr_mipres_p IS NOT NULL AND nr_seq_prescr_mipres_p::text <> '') then
    
        UPDATE  prescr_mipres
        SET     nr_presc_mipres = nr_presc_mipres_p,
                dt_validity_mipres = dt_validity_p
        WHERE   nr_sequencia = nr_seq_prescr_mipres_p;
        
    END IF;
    COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_quimio_prescr_mipres ( nr_seq_paciente_p paciente_setor.nr_seq_paciente%TYPE, nr_atendimento_p prescr_mipres.nr_atendimento%TYPE, cd_funcao_p prescr_mipres.cd_funcao%TYPE, nr_seq_prescr_mipres_p prescr_mipres.nr_sequencia%TYPE default null, nr_presc_mipres_p prescr_mipres.nr_presc_mipres%TYPE default null, dt_validity_p prescr_mipres.dt_validity_mipres%TYPE default null) FROM PUBLIC;

