-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_crud_schematics (nr_seq_obj_origem_p bigint, nr_seq_obj_dest_p bigint, nr_seq_crud_p bigint, ie_todas_p text, nm_usuario_p text) AS $body$
DECLARE


    nr_seq_novo_crud_w bigint;
    ie_opcao_crud_w    varchar(2);
    ds_opcao_crud_w    varchar(255);
    ie_insert_w        varchar(2);
    ie_update_w        varchar(2);
    ie_delete_w        varchar(2);
    ie_duplicar_w      varchar(2);
    nr_seq_crud_cond_w bigint;
    nr_seq_condicao_w  bigint;
    nm_condicao_w      varchar(100);
    cd_exp_msg_regra_w bigint;
    nr_seq_cond_nova_w bigint;

    c01 CURSOR FOR
        SELECT nr_sequencia,
               ie_opcao_crud,
               ds_opcao_crud,
               ie_insert,
               ie_update,
               ie_delete,
               ie_duplicar,
               nextval('opcoes_crud_seq')
          from opcoes_crud
         where nr_seq_objeto_schematic = nr_seq_obj_origem_p;

    c02 CURSOR FOR
        SELECT nr_sequencia,
               nm_condicao,
               cd_exp_msg_regra,
               nextval('regra_condicao_seq')
          from regra_condicao
         where nr_seq_opcao_crud = nr_seq_crud_cond_w;


BEGIN
    if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (nr_seq_obj_origem_p IS NOT NULL AND nr_seq_obj_origem_p::text <> '') and (nr_seq_obj_dest_p IS NOT NULL AND nr_seq_obj_dest_p::text <> '') then
        begin

            if (ie_todas_p = 'S') then
                begin
                    open c01;
                    loop
                        fetch c01
                            into nr_seq_crud_cond_w,
                                 ie_opcao_crud_w,
                                 ds_opcao_crud_w,
                                 ie_insert_w,
                                 ie_update_w,
                                 ie_delete_w,
                                 ie_duplicar_w,
                                 nr_seq_novo_crud_w;
                        EXIT WHEN NOT FOUND; /* apply on c01 */
                        begin

                            insert into opcoes_crud(nr_sequencia,
                                 dt_atualizacao,
                                 nm_usuario,
                                 dt_atualizacao_nrec,
                                 nm_usuario_nrec,
                                 ie_opcao_crud,
                                 nr_seq_objeto_schematic,
                                 ds_opcao_crud,
                                 ie_insert,
                                 ie_update,
                                 ie_delete,
                                 ie_duplicar)
                            values (nr_seq_novo_crud_w,
                                 clock_timestamp(),
                                 nm_usuario_p,
                                 clock_timestamp(),
                                 nm_usuario_p,
                                 ie_opcao_crud_w,
                                 nr_seq_obj_dest_p,
                                 ds_opcao_crud_w,
                                 ie_insert_w,
                                 ie_update_w,
                                 ie_delete_w,
                                 ie_duplicar_w);

                            commit;

                            open c02;
                            loop
                                fetch c02
                                    into nr_seq_condicao_w,
                                         nm_condicao_w,
                                         cd_exp_msg_regra_w,
                                         nr_seq_cond_nova_w;
                                EXIT WHEN NOT FOUND; /* apply on c02 */
                                begin

                                    insert into regra_condicao(nr_sequencia,
                                         dt_atualizacao,
                                         nm_condicao,
                                         dt_atualizacao_nrec,
                                         nm_usuario,
                                         nm_usuario_nrec,
                                         nr_seq_objeto_schematic,
                                         nr_seq_opcao_crud,
                                         cd_exp_msg_regra)
                                    values (nr_seq_cond_nova_w,
                                         clock_timestamp(),
                                         nm_condicao_w,
                                         clock_timestamp(),
                                         nm_usuario_p,
                                         nm_usuario_p,
                                         nr_seq_obj_dest_p,
                                         nr_seq_novo_crud_w,
                                         cd_exp_msg_regra_w);

                                    commit;

                                    insert into regra_condicao_item(nr_sequencia,
                                         dt_atualizacao,
                                         dt_atualizacao_nrec,
                                         ie_condicao,
                                         ie_opcao_comparacao,
                                         ie_valor,
                                         nm_atributo,
                                         nm_atributo_base,
                                         nm_usuario,
                                         nm_usuario_nrec,
                                         vl_parametro,
                                         cd_funcao,
                                         nr_seq_param,
                                         nr_seq_regra,
                                         ie_grid_detalhe,
                                         ie_edit,
                                         ie_insert,
                                         ie_browser,
                                         ie_qtdade_registro_selec,
                                         nr_seq_objeto_schematic,
                                         nm_variavel_sistema)
                                        SELECT nextval('regra_condicao_item_seq'),
                                               clock_timestamp(),
                                               clock_timestamp(),
                                               ie_condicao,
                                               ie_opcao_comparacao,
                                               ie_valor,
                                               nm_atributo,
                                               nm_atributo_base,
                                               nm_usuario_p,
                                               nm_usuario_p,
                                               vl_parametro,
                                               cd_funcao,
                                               nr_seq_param,
                                               nr_seq_cond_nova_w,
                                               ie_grid_detalhe,
                                               ie_edit,
                                               ie_insert,
                                               ie_browser,
                                               ie_qtdade_registro_selec,
                                               nr_seq_objeto_schematic,
                                               nm_variavel_sistema
                                          from regra_condicao_item
                                         where nr_seq_regra = nr_seq_condicao_w;
                                end;
                            end loop;
                            close c02;
                        end;
                    end loop;
                    close c01;
                end;
            elsif (nr_seq_crud_p IS NOT NULL AND nr_seq_crud_p::text <> '') then
                begin

                    select nextval('opcoes_crud_seq'),
                           ie_opcao_crud,
                           ds_opcao_crud,
                           ie_insert,
                           ie_update,
                           ie_delete,
                           ie_duplicar
                      into STRICT nr_seq_novo_crud_w,
                           ie_opcao_crud_w,
                           ds_opcao_crud_w,
                           ie_insert_w,
                           ie_update_w,
                           ie_delete_w,
                           ie_duplicar_w
                      from opcoes_crud
                     where nr_sequencia = nr_seq_crud_p;

                    insert into opcoes_crud(nr_sequencia,
                         dt_atualizacao,
                         nm_usuario,
                         dt_atualizacao_nrec,
                         nm_usuario_nrec,
                         ie_opcao_crud,
                         nr_seq_objeto_schematic,
                         ds_opcao_crud,
                         ie_insert,
                         ie_update,
                         ie_delete,
                         ie_duplicar)
                    values (nr_seq_novo_crud_w,
                         clock_timestamp(),
                         nm_usuario_p,
                         clock_timestamp(),
                         nm_usuario_p,
                         ie_opcao_crud_w,
                         nr_seq_obj_dest_p,
                         ds_opcao_crud_w,
                         ie_insert_w,
                         ie_update_w,
                         ie_delete_w,
                         ie_duplicar_w);

                    commit;

                    nr_seq_crud_cond_w := nr_seq_crud_p;
                    open c02;
                    loop
                        fetch c02
                            into nr_seq_condicao_w,
                                 nm_condicao_w,
                                 cd_exp_msg_regra_w,
                                 nr_seq_cond_nova_w;
                        EXIT WHEN NOT FOUND; /* apply on c02 */
                        begin

                            insert into regra_condicao(nr_sequencia,
                                 dt_atualizacao,
                                 nm_condicao,
                                 dt_atualizacao_nrec,
                                 nm_usuario,
                                 nm_usuario_nrec,
                                 nr_seq_objeto_schematic,
                                 nr_seq_opcao_crud,
                                 cd_exp_msg_regra)
                            values (nr_seq_cond_nova_w,
                                 clock_timestamp(),
                                 nm_condicao_w,
                                 clock_timestamp(),
                                 nm_usuario_p,
                                 nm_usuario_p,
                                 nr_seq_obj_dest_p,
                                 nr_seq_novo_crud_w,
                                 cd_exp_msg_regra_w);

                            commit;

                            insert into regra_condicao_item(nr_sequencia,
                                 dt_atualizacao,
                                 dt_atualizacao_nrec,
                                 ie_condicao,
                                 ie_opcao_comparacao,
                                 ie_valor,
                                 nm_atributo,
                                 nm_atributo_base,
                                 nm_usuario,
                                 nm_usuario_nrec,
                                 vl_parametro,
                                 cd_funcao,
                                 nr_seq_param,
                                 nr_seq_regra,
                                 ie_grid_detalhe,
                                 ie_edit,
                                 ie_insert,
                                 ie_browser,
                                 ie_qtdade_registro_selec,
                                 nr_seq_objeto_schematic,
                                 nm_variavel_sistema)
                                SELECT nextval('regra_condicao_item_seq'),
                                       clock_timestamp(),
                                       clock_timestamp(),
                                       ie_condicao,
                                       ie_opcao_comparacao,
                                       ie_valor,
                                       nm_atributo,
                                       nm_atributo_base,
                                       nm_usuario_p,
                                       nm_usuario_p,
                                       vl_parametro,
                                       cd_funcao,
                                       nr_seq_param,
                                       nr_seq_cond_nova_w,
                                       ie_grid_detalhe,
                                       ie_edit,
                                       ie_insert,
                                       ie_browser,
                                       ie_qtdade_registro_selec,
                                       nr_seq_objeto_schematic,
                                       nm_variavel_sistema
                                  from regra_condicao_item
                                 where nr_seq_regra = nr_seq_condicao_w;
                        end;
                    end loop;
                    close c02;
                end;
            end if;
        end;
    end if;

    commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_crud_schematics (nr_seq_obj_origem_p bigint, nr_seq_obj_dest_p bigint, nr_seq_crud_p bigint, ie_todas_p text, nm_usuario_p text) FROM PUBLIC;

