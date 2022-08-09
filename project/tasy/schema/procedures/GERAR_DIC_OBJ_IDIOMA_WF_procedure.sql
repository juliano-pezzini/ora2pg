-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_dic_obj_idioma_wf (cd_funcao_p bigint, nr_seq_idioma_p bigint, nm_usuario_p text) AS $body$
DECLARE


    nr_seq_objeto_filtro_w bigint;
    nr_seq_objeto_w        bigint;
    nm_atributo_w          varchar(50);
    ds_texto_w             varchar(4000);
    cd_funcao_w            integer;
    nr_seq_traducao_w      bigint;

    c01 CURSOR FOR
        SELECT a.nr_sequencia,
               'DS_TEXTO',
               a.ds_texto,
               a.cd_funcao
          from dic_objeto a
         where a.cd_funcao = cd_funcao_p
           and a.ie_tipo_objeto = 'WF'
           and not exists (SELECT 1
                  from dic_objeto_idioma x
                 where x.nr_seq_objeto = a.nr_sequencia
                   and x.nm_atributo = 'DS_TEXTO'
                   and x.nr_seq_idioma = nr_seq_idioma_p)
         order by a.nr_sequencia;

    c02 CURSOR FOR
        SELECT a.nr_seq_objeto,
               a.nr_sequencia,
               'DS_LABEL',
               a.ds_label,
               b.cd_funcao
          from dic_objeto        b,
               dic_objeto_filtro a
         where b.nr_sequencia = a.nr_seq_objeto
           and b.cd_funcao = cd_funcao_p
           and (a.ds_label IS NOT NULL AND a.ds_label::text <> '')
           and not exists (SELECT 1
                  from dic_objeto_filtro_idioma x
                 where x.nr_seq_objeto = a.nr_sequencia
                   and x.nm_atributo = 'DS_LABEL'
                   and x.nr_seq_idioma = nr_seq_idioma_p)
         order by b.nr_sequencia,
                  a.nr_sequencia;

    c03 CURSOR FOR
        SELECT a.nr_seq_objeto,
               a.nr_sequencia,
               'DS_OPCOES',
               a.ds_opcoes,
               b.cd_funcao
          from dic_objeto        b,
               dic_objeto_filtro a
         where b.nr_sequencia = a.nr_seq_objeto
           and b.cd_funcao = cd_funcao_p
           and (a.ds_opcoes IS NOT NULL AND a.ds_opcoes::text <> '')
           and a.ie_componente = 'WJRB'
           and not exists (SELECT 1
                  from dic_objeto_filtro_idioma x
                 where x.nr_seq_objeto = a.nr_sequencia
                   and x.nm_atributo = 'DS_OPCOES'
                   and x.nr_seq_idioma = nr_seq_idioma_p)
         order by b.nr_sequencia,
                  a.nr_sequencia;


BEGIN
    if (cd_funcao_p IS NOT NULL AND cd_funcao_p::text <> '') and (nr_seq_idioma_p IS NOT NULL AND nr_seq_idioma_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
        begin
            open c01;
            loop
                fetch c01
                    into nr_seq_objeto_w,
                         nm_atributo_w,
                         ds_texto_w,
                         cd_funcao_w;
                EXIT WHEN NOT FOUND; /* apply on c01 */
                begin
                    if (coalesce(trim(both ds_texto_w)::text, '') = '') then
                        ds_texto_w := ' ';
                    end if;

                    $if $$tasy_local_dict=true $then
                    nr_seq_traducao_w := get_remote_sequence('seq:dic_objeto_idioma_seq');
                    $else
                    select nextval('dic_objeto_idioma_seq') into STRICT nr_seq_traducao_w;
                    $end

                    insert into dic_objeto_idioma(nr_sequencia,
                         dt_atualizacao_nrec,
                         nm_usuario_nrec,
                         dt_atualizacao,
                         nm_usuario,
                         nr_seq_objeto,
                         nm_atributo,
                         ds_descricao,
                         cd_funcao,
                         nr_seq_idioma,
                         ds_traducao,
                         ie_necessita_revisao,
                         ie_tipo_objeto)
                    values (nr_seq_traducao_w,
                         clock_timestamp(),
                         nm_usuario_p,
                         clock_timestamp(),
                         nm_usuario_p,
                         nr_seq_objeto_w,
                         nm_atributo_w,
                         ds_texto_w,
                         cd_funcao_w,
                         nr_seq_idioma_p,
                         ' ',
                         'T',
                         'WF');
                end;
            end loop;
            close c01;

            open c02;
            loop
                fetch c02
                    into nr_seq_objeto_filtro_w,
                         nr_seq_objeto_w,
                         nm_atributo_w,
                         ds_texto_w,
                         cd_funcao_w;
                EXIT WHEN NOT FOUND; /* apply on c02 */
                begin
                    if ((trim(both ds_texto_w) IS NOT NULL AND (trim(both ds_texto_w))::text <> '')) then
                        begin
                            $if $$tasy_local_dict=true $then
                            nr_seq_traducao_w := get_remote_sequence('seq:dic_objeto_filtro_idioma_seq');
                            $else
                            select nextval('dic_objeto_filtro_idioma_seq') into STRICT nr_seq_traducao_w;
                            $end

                            insert into dic_objeto_filtro_idioma(nr_sequencia,
                                 dt_atualizacao_nrec,
                                 nm_usuario_nrec,
                                 dt_atualizacao,
                                 nm_usuario,
                                 nr_seq_objeto_filtro,
                                 nr_seq_objeto,
                                 nm_atributo,
                                 ds_descricao,
                                 cd_funcao,
                                 nr_seq_idioma,
                                 ds_traducao,
                                 ie_necessita_revisao)
                            values (nr_seq_traducao_w,
                                 clock_timestamp(),
                                 nm_usuario_p,
                                 clock_timestamp(),
                                 nm_usuario_p,
                                 nr_seq_objeto_filtro_w,
                                 nr_seq_objeto_w,
                                 nm_atributo_w,
                                 ds_texto_w,
                                 cd_funcao_w,
                                 nr_seq_idioma_p,
                                 ' ',
                                 'T');
                        end;
                    end if;
                end;
            end loop;
            close c02;

            open c03;
            loop
                fetch c03
                    into nr_seq_objeto_filtro_w,
                         nr_seq_objeto_w,
                         nm_atributo_w,
                         ds_texto_w,
                         cd_funcao_w;
                EXIT WHEN NOT FOUND; /* apply on c03 */
                begin
                    if ((trim(both ds_texto_w) IS NOT NULL AND (trim(both ds_texto_w))::text <> '')) then
                        begin

                            $if $$tasy_local_dict=true $then
                            nr_seq_traducao_w := get_remote_sequence('seq:dic_objeto_filtro_idioma_seq');
                            $else
                            select nextval('dic_objeto_filtro_idioma_seq') into STRICT nr_seq_traducao_w;
                            $end

                            insert into dic_objeto_filtro_idioma(nr_sequencia,
                                 dt_atualizacao_nrec,
                                 nm_usuario_nrec,
                                 dt_atualizacao,
                                 nm_usuario,
                                 nr_seq_objeto_filtro,
                                 nr_seq_objeto,
                                 nm_atributo,
                                 ds_descricao,
                                 cd_funcao,
                                 nr_seq_idioma,
                                 ds_traducao,
                                 ie_necessita_revisao)
                            values (nr_seq_traducao_w,
                                 clock_timestamp(),
                                 nm_usuario_p,
                                 clock_timestamp(),
                                 nm_usuario_p,
                                 nr_seq_objeto_filtro_w,
                                 nr_seq_objeto_w,
                                 nm_atributo_w,
                                 ds_texto_w,
                                 cd_funcao_w,
                                 nr_seq_idioma_p,
                                 ' ',
                                 'T');
                        end;
                    end if;
                end;
            end loop;
            close c03;
        end;
    end if;
    commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_dic_obj_idioma_wf (cd_funcao_p bigint, nr_seq_idioma_p bigint, nm_usuario_p text) FROM PUBLIC;
