-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ehr_duplicar_elemento (nr_seq_elemento_p bigint, ie_base_wheb_p text, nm_usuario_p text, ie_copia_resultado_p text, ie_copia_doenca_p text, ie_copia_espec_p text, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


    nr_sequencia_w     bigint;
    nr_sequencia_rem_w bigint;
  r RECORD;

BEGIN

    $if $$tasy_local_dict=true $then
    nr_sequencia_w := get_remote_sequence('seq:ehr_elemento_seq');
    $else
    select nextval('ehr_elemento_seq') into STRICT nr_sequencia_w;
    $end

    insert into ehr_elemento(nr_sequencia,
         dt_atualizacao,
         nm_usuario,
         dt_atualizacao_nrec,
         nm_usuario_nrec,
         nr_seq_tipo_dado,
         ie_tipo,
         nm_elemento,
         cd_snomed,
         nm_arquetipo,
         ds_elemento,
         ie_componente,
         qt_tam_tela,
         qt_tam_grid,
         ds_label_tela,
         ds_label_grid,
         qt_altura,
         ds_mascara,
         vl_minimo,
         vl_maximo,
         ds_elemento_ehr,
         nr_seq_apres,
         qt_max_dec,
         ds_unid_medida,
         ds_sql,
         nr_seq_grupo,
         ds_palavra_chave,
         nr_seq_cefalocaudal,
         nr_seq_subgrupo,
         ie_cliente_cadastra,
         ie_origem)
        SELECT nr_sequencia_w,
               clock_timestamp(),
               nm_usuario_p,
               clock_timestamp(),
               nm_usuario_p,
               nr_seq_tipo_dado,
               ie_tipo,
               nm_elemento || '(' || obter_desc_expressao(303214) || ')',
               cd_snomed,
               nm_arquetipo,
               ' ',
               ie_componente,
               qt_tam_tela,
               qt_tam_grid,
               ' ',
               ' ',
               qt_altura,
               ds_mascara,
               vl_minimo,
               vl_maximo,
               ds_elemento_ehr,
               nr_seq_apres + 10,
               qt_max_dec,
               ds_unid_medida,
               ds_sql,
               nr_seq_grupo,
               ds_palavra_chave,
               nr_seq_cefalocaudal,
               nr_seq_subgrupo,
               ie_cliente_cadastra,
               CASE WHEN coalesce(ie_base_wheb_p, 'S')='S' THEN  'W'  ELSE 'C' END
          from ehr_elemento
         where nr_sequencia = nr_seq_elemento_p;

    commit;

    if (coalesce(ie_copia_resultado_p, 'S') = 'S') then
        for r in (SELECT nr_seq_apres,
                         cd_resultado,
                         ds_resultado,
                         vl_resultado
                    from ehr_elemento_result
                   where nr_seq_elemento = nr_seq_elemento_p) loop

            $if $$tasy_local_dict=true $then
            nr_sequencia_rem_w := get_remote_sequence('seq:ehr_elemento_result_seq');
            $else
            select nextval('ehr_elemento_result_seq') into STRICT nr_sequencia_rem_w;
            $end

            insert into ehr_elemento_result(nr_sequencia,
                 nr_seq_elemento,
                 dt_atualizacao,
                 nm_usuario,
                 dt_atualizacao_nrec,
                 nm_usuario_nrec,
                 nr_seq_apres,
                 cd_resultado,
                 ds_resultado,
                 vl_resultado)
            values (nr_sequencia_rem_w, --ehr_elemento_result_seq.nextval,
                 nr_sequencia_w,
                 clock_timestamp(),
                 nm_usuario_p,
                 clock_timestamp(),
                 nm_usuario_p,
                 r.nr_seq_apres,
                 r.cd_resultado,
                 r.ds_resultado,
                 r.vl_resultado);
        end loop;
    end if;

    if (coalesce(ie_copia_espec_p, 'S') = 'S') then

        for r in (SELECT nr_seq_especialidade from ehr_elemento_especialidade where nr_seq_elemento = nr_seq_elemento_p) loop
        
            $if $$tasy_local_dict=true $then
            nr_sequencia_rem_w := get_remote_sequence('seq:ehr_elemento_especialidade_seq');
            $else
            select nextval('ehr_elemento_especialidade_seq') into STRICT nr_sequencia_rem_w;
            $end

            insert into ehr_elemento_especialidade(nr_sequencia,
                 nr_seq_elemento,
                 dt_atualizacao,
                 nm_usuario,
                 dt_atualizacao_nrec,
                 nm_usuario_nrec,
                 nr_seq_especialidade)
            values (nr_sequencia_rem_w, --ehr_elemento_especialidade_seq.nextval,
                 nr_sequencia_w,
                 clock_timestamp(),
                 nm_usuario_p,
                 clock_timestamp(),
                 nm_usuario_p,
                 r.nr_seq_especialidade);
        end loop;
    end if;

    if (coalesce(ie_copia_doenca_p, 'S') = 'S') then

        for r in (SELECT nr_seq_doenca
                    from ehr_elemento_doenca
                   where nr_seq_elemento = nr_seq_elemento_p) loop
        
            $if $$tasy_local_dict=true $then
            nr_sequencia_rem_w := get_remote_sequence('seq:ehr_elemento_doenca_seq');
            $else
            select nextval('ehr_elemento_doenca_seq') into STRICT nr_sequencia_rem_w;
            $end

            insert into ehr_elemento_doenca(nr_sequencia,
                 nr_seq_elemento,
                 dt_atualizacao,
                 nm_usuario,
                 dt_atualizacao_nrec,
                 nm_usuario_nrec,
                 nr_seq_doenca)
            values (nr_sequencia_rem_w, --ehr_elemento_doenca_seq.nextval, 
                 nr_sequencia_w,
                 clock_timestamp(),
                 nm_usuario_p,
                 clock_timestamp(),
                 nm_usuario_p,
                 r.nr_seq_doenca);
        end loop;

    end if;

    nr_sequencia_p := nr_sequencia_w;
    commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ehr_duplicar_elemento (nr_seq_elemento_p bigint, ie_base_wheb_p text, nm_usuario_p text, ie_copia_resultado_p text, ie_copia_doenca_p text, ie_copia_espec_p text, nr_sequencia_p INOUT bigint) FROM PUBLIC;

