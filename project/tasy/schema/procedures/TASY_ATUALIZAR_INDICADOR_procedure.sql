-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_atualizar_indicador () AS $body$
DECLARE

    nr_sequencia_w       bigint;
    nr_seq_nova_w        bigint;
    nr_seq_wheb_w        bigint;
    nr_seq_old_w         bigint;
    nr_seq_sub_w         bigint;
    nr_seq_sub_ww        bigint;
    nr_seq_superior_w    bigint;
    qt_registro_w        bigint;
    ds_ind_gestao_w      varchar(2000);
    ds_ind_atrib_w       varchar(2000);
    ds_ind_relat_w       varchar(2000);
    ds_indicador_w       varchar(50);
    ds_ind_doc_w         varchar(2000);
    ds_subindicador_w    varchar(2000);
    ds_subind_atrib_w    varchar(2000);
    ds_comando_w         varchar(2000);
    ds_insert_w          varchar(2000);
    ds_parametros_w      varchar(2000);
    qt_processada_w      integer;
    c010                 integer;
    c020                 integer;
    c030                 integer;
    retorno_w            integer;
    ds_documento_longo_w text;
    ie_tipo_w            varchar(3);
    cd_pais_w            varchar(5);
    nr_seq_indicador     bigint;
    nr_seq_regra_w       bigint;
    nr_dimensao_new_w    bigint;
    nr_informacao_new_w  bigint;
    nr_dimensao_old_w    bigint;
    nr_informacao_old_w  bigint;
    nr_seq_atrib_new_w   bigint;
    ds_dimensao_w        varchar(255);
    ds_informacao_w      varchar(100);

    ds_comando_c010_w varchar(2000) := ' SELECT 	nr_sequencia ' || ' from 		tasy_versao.indicador_gestao a ' ||
                                        ' where		a.nr_seq_wheb is not null ' ||
                                        ' and		((a.dt_atualizacao >= obter_data_geracao_versao) or' ||
                                        ' 		(exists (select 1 from tasy_versao.indicador_gestao_atrib x where a.nr_sequencia = x.nr_seq_ind_gestao and x.dt_atualizacao >= obter_data_geracao_versao)) or' ||
                                        ' 		(exists (select 1 from tasy_versao.subindicador_gestao x where a.nr_sequencia = x.nr_seq_indicador and x.dt_atualizacao >= obter_data_geracao_versao)) or' ||
                                        ' 		(exists (select 1 from tasy_versao.indicador_gestao_relat x where a.nr_sequencia = x.nr_seq_indicador and x.dt_atualizacao >= obter_data_geracao_versao)) or' ||
                                        ' 		(exists (select 1 from tasy_versao.subindicador_gestao_atrib x, tasy_versao.subindicador_gestao y where a.nr_sequencia = y.nr_seq_indicador and x.nr_seq_subindicador = y.nr_sequencia and x.dt_atualizacao >= obter_data_geracao_versao)) or' ||
                                        ' 		(exists (select 1 from tasy_versao.indicador_gestao_doc x where a.nr_sequencia = x.nr_seq_indicador and x.dt_atualizacao >= obter_data_geracao_versao)))';

    ds_comando_c020_w varchar(2000) := ' SELECT 	nr_sequencia, ' || '		nr_seq_superior ' ||
                                        ' from 		tasy_versao.subindicador_gestao ' ||
                                        ' where		nr_seq_indicador = :nr_sequencia ' ||
                                        ' order by	nvl(nr_seq_superior,0),nr_sequencia';

    c01 CURSOR FOR
        SELECT b.nr_sequencia,
               b.ds_dimensao,
               b.ds_informacao,
               c.nr_sequencia
          from indicador_gestao       a,
               indicador_gestao_atrib b,
               regra_indicador_visual c
         where a.nr_sequencia = nr_seq_old_w
           and a.nr_sequencia = b.nr_seq_ind_gestao
           and a.nr_seq_wheb = c.nr_seq_indicador
           and ((b.nr_sequencia = c.nr_informacao and (b.ds_informacao IS NOT NULL AND b.ds_informacao::text <> '')) or (b.nr_sequencia = c.nr_dimensao and (b.ds_dimensao IS NOT NULL AND b.ds_dimensao::text <> '')));

    c_dashboard CURSOR FOR
        SELECT a.nr_sequencia
          from indicador_gestao a
         where a.ie_converter_dashboard = 'S'
           and a.ie_situacao = 'A'
           and (a.nr_seq_wheb IS NOT NULL AND a.nr_seq_wheb::text <> '')
           and not exists (SELECT 1 from ind_base y where y.nr_seq_ind_gestao = a.nr_sequencia);

BEGIN

    CALL exec_sql_dinamico('Disable' || ' constraint',
                      'Alter table SUBINDICADOR_GESTAO_ATRIB disable' || ' constraint SUBINAT_DICEXPR_FK');
    CALL exec_sql_dinamico('Disable' || ' constraint',
                      'Alter table INDICADOR_GESTAO_ATRIB disable' || ' constraint INDGEAT_DICEXPR_FK4');
    CALL exec_sql_dinamico('Disable' || ' constraint',
                      'Alter table INDICADOR_GESTAO_ATRIB disable' || ' constraint INDGEAT_DICEXPR_FK2');

    select obter_atributo_tabela('INDICADOR_GESTAO'),
           obter_atributo_tabela('INDICADOR_GESTAO_ATRIB'),
           obter_atributo_tabela('SUBINDICADOR_GESTAO'),
           obter_atributo_tabela('SUBINDICADOR_GESTAO_ATRIB'),
           obter_atributo_tabela('INDICADOR_GESTAO_RELAT'),
           obter_atributo_tabela('INDICADOR_GESTAO_DOC')
      into STRICT ds_ind_gestao_w,
           ds_ind_atrib_w,
           ds_subindicador_w,
           ds_subind_atrib_w,
           ds_ind_relat_w,
           ds_ind_doc_w
;
    qt_processada_w := 0;
    CALL gravar_processo_longo(obter_desc_expressao(316772, 'Atualizando indicadores'), 'TASY_ATUALIZAR_INDICADOR', 0);

    c010 := dbms_sql.open_cursor;
    dbms_sql.parse(c010, ds_comando_c010_w, dbms_sql.native);
    dbms_sql.define_column(c010, 1, nr_sequencia_w);
    retorno_w := dbms_sql.execute(c010);

    while(dbms_sql.fetch_rows(c010) > 0) loop

        begin
        
            dbms_sql.column_value(c010, 1, nr_sequencia_w);
            select nextval('indicador_gestao_seq') into STRICT nr_seq_nova_w;
            select max(nr_sequencia) into STRICT nr_seq_old_w from indicador_gestao where nr_seq_wheb = nr_sequencia_w;
            /*   Inserir a tabela indicador de gestao */

            ds_insert_w  := replace(ds_ind_gestao_w, 'NR_SEQUENCIA', ':NR_SEQUENCIA');
            ds_insert_w  := replace(ds_insert_w, 'NR_SEQ_WHEB', ':NR_SEQ_WHEB');
            ds_comando_w := 'insert into indicador_gestao (' || ds_ind_gestao_w || ') select ' || ds_insert_w ||
                            ' from tasy_versao.indicador_gestao ' || 'where nr_sequencia = :NR_SEQUENCIA_2';
            CALL gravar_processo_longo(ds_comando_w, 'TASY_ATUALIZAR_INDICADOR', null);
            ds_parametros_w := 'NR_SEQUENCIA=' || nr_seq_nova_w || ';' || 'NR_SEQ_WHEB=' || nr_sequencia_w || ';' ||
                               'NR_SEQUENCIA_2=' || nr_sequencia_w || ';';
            CALL exec_sql_dinamico_bv('Insert indicador: ' || nr_sequencia_w, ds_comando_w, ds_parametros_w);
            /*   Inserir a tabela indicador_gestao_atrib */

            ds_insert_w  := replace(ds_ind_atrib_w, 'NR_SEQUENCIA', 'INDICADOR_GESTAO_ATRIB_SEQ.Nextval');
            ds_insert_w  := replace(ds_insert_w, 'NR_SEQ_IND_GESTAO', ':NR_SEQ_IND_GESTAO');
            ds_comando_w := 'insert into indicador_gestao_atrib (' || ds_ind_atrib_w || ') select ' || ds_insert_w ||
                            ' from tasy_versao.indicador_gestao_atrib ' || 'where nr_seq_ind_gestao = :NR_SEQ_IND_GESTAO_2';
            CALL gravar_processo_longo(ds_comando_w, 'TASY_ATUALIZAR_INDICADOR', null);
            ds_parametros_w := 'NR_SEQ_IND_GESTAO=' || nr_seq_nova_w || ';' || 'NR_SEQ_IND_GESTAO_2=' || nr_sequencia_w || ';';
            CALL exec_sql_dinamico_bv('Insert ind_gestao_atrib: ' || nr_sequencia_w, ds_comando_w, ds_parametros_w);
            /*     Deletar da tabela de relatorios */


            /*   Inserir a tabela indicador_gestao_relat */

            delete FROM indicador_gestao_relat where nr_seq_indicador = nr_seq_old_w;

            ds_insert_w     := replace(ds_ind_relat_w, 'NR_SEQUENCIA', 'INDICADOR_GESTAO_RELAT_SEQ.Nextval');
            ds_insert_w     := replace(ds_insert_w, 'NR_SEQ_INDICADOR', ':NR_SEQ_INDICADOR');
            ds_comando_w    := 'insert into indicador_gestao_relat (' || ds_ind_relat_w || ') select ' || ds_insert_w ||
                               ' from tasy_versao.indicador_gestao_relat ' || 'where nr_seq_indicador = :NR_SEQ_INDICADOR_2';
            ds_parametros_w := 'NR_SEQ_INDICADOR=' || nr_seq_nova_w || ';' || 'NR_SEQ_INDICADOR_2=' || nr_sequencia_w || ';';
            CALL gravar_processo_longo(ds_comando_w, 'TASY_ATUALIZAR_INDICADOR', null);
            CALL exec_sql_dinamico_bv('Insert ind_gestao_relat: ' || nr_sequencia_w, ds_comando_w, ds_parametros_w);
            /*   Inserir a tabela indicador_gestao_doc */

            ds_ind_doc_w    := replace(ds_ind_doc_w, 'DS_DOCUMENTO_LONGO,', '');
            ds_insert_w     := replace(ds_ind_doc_w, 'NR_SEQUENCIA', 'INDICADOR_GESTAO_DOC_SEQ.Nextval');
            ds_insert_w     := replace(ds_insert_w, 'NR_SEQ_INDICADOR', ':NR_SEQ_INDICADOR');
            ds_comando_w    := 'insert into indicador_gestao_doc (' || ds_ind_doc_w || ') select ' || ds_insert_w ||
                               ' from tasy_versao.indicador_gestao_doc ' || 'where nr_seq_indicador = :NR_SEQ_INDICADOR_2';
            ds_parametros_w := 'NR_SEQ_INDICADOR=' || nr_seq_nova_w || ';' || 'NR_SEQ_INDICADOR_2=' || nr_sequencia_w || ';';
            CALL gravar_processo_longo(ds_comando_w, 'TASY_ATUALIZAR_INDICADOR', null);
            CALL exec_sql_dinamico_bv('Insert ind_gestao_doc: ' || nr_sequencia_w, ds_comando_w, ds_parametros_w);

            ds_comando_w := 'select ie_tipo, nvl(cd_pais,1) cd_pais from tasy_versao.INDICADOR_GESTAO_DOC where nr_seq_indicador = ' ||
                            nr_sequencia_w;
            c030         := dbms_sql.open_cursor;
            dbms_sql.parse(c030, ds_comando_w, dbms_sql.native);

            dbms_sql.define_column(c030, 1, ie_tipo_w, 3);
            dbms_sql.define_column(c030, 2, cd_pais_w, 5);
            retorno_w := dbms_sql.execute(c030);
            while(dbms_sql.fetch_rows(c030) > 0) loop
                dbms_sql.column_value(c030, 1, ie_tipo_w);
                dbms_sql.column_value(c030, 2, cd_pais_w);

                CALL copia_campo_long_de_para('tasy_versao.INDICADOR_GESTAO_DOC',
                                         'DS_DOCUMENTO_LONGO',
                                         'where nr_seq_indicador=:nr_seq_indicador and ie_tipo=:ie_tipo and nvl(cd_pais,1) = :cd_pais',
                                         'nr_seq_indicador=' || nr_sequencia_w || ';ie_tipo=' || ie_tipo_w || ';cd_pais=' ||
                                         cd_pais_w,
                                         'INDICADOR_GESTAO_DOC',
                                         'DS_DOCUMENTO_LONGO',
                                         'where nr_seq_indicador=:nr_seq_indicador and ie_tipo=:ie_tipo and nvl(cd_pais,1) = :cd_pais',
                                         'nr_seq_indicador=' || nr_seq_nova_w || ';ie_tipo=' || ie_tipo_w || ';cd_pais=' ||
                                         cd_pais_w);

            /*COPIA_CAMPO_LONG_DE_PARA(  'W_INDICADOR_GESTAO_DOC',
                                        'DS_DOCUMENTO_LONGO',
                                        'where nr_seq_indicador=:nr_seq_indicador and ie_tipo=:ie_tipo ',
                                        'nr_seq_indicador='|| nr_sequencia_w || ';ie_tipo=' || ie_tipo_w,
                                        'INDICADOR_GESTAO_DOC',
                                        'DS_DOCUMENTO_LONGO',
                                        'where nr_seq_indicador=:nr_seq_nova_w and ie_tipo=:ie_tipo ',
                                        'nr_seq_indicador='|| nr_seq_nova_w || ';ie_tipo=' || ie_tipo_w);
                        
                        teste := dbms_lob.getlength(ds_documento_longo_w);
                        
                        update  INDICADOR_GESTAO_DOC
                        set   ds_documento_longo = ds_documento_longo_w
                        where nr_seq_indicador = nr_seq_nova_w
                        and   ie_tipo = ie_tipo_w;*/
            end loop;

            dbms_sql.close_cursor(c030);
            /*   Inserir a tabela SUBindicador_gestao */

            c020 := dbms_sql.open_cursor;
            dbms_sql.parse(c020, ds_comando_c020_w, dbms_sql.native);
            dbms_sql.define_column(c020, 1, nr_seq_sub_w);
            dbms_sql.define_column(c020, 2, nr_seq_superior_w);
            dbms_sql.bind_variable(c020, 'NR_SEQUENCIA', nr_sequencia_w);
            retorno_w := dbms_sql.execute(c020);
            while(dbms_sql.fetch_rows(c020) > 0) loop
                dbms_sql.column_value(c020, 1, nr_seq_sub_w);
                dbms_sql.column_value(c020, 2, nr_seq_superior_w);
                select nextval('subindicador_gestao_seq') into STRICT nr_seq_sub_ww;
                select max(nr_sequencia)
                  into STRICT nr_seq_superior_w
                  from subindicador_gestao
                 where nr_seq_wheb = nr_seq_superior_w
                   and (nr_seq_superior_w IS NOT NULL AND nr_seq_superior_w::text <> '');
                ds_insert_w := replace(ds_subindicador_w, 'NR_SEQUENCIA', ':NR_SEQUENCIA');
                ds_insert_w := replace(ds_insert_w, 'NR_SEQ_INDICADOR', ':NR_SEQ_INDICADOR');
                ds_insert_w := replace(ds_insert_w, 'NR_SEQ_WHEB', ':NR_SEQ_WHEB');
                if (coalesce(nr_seq_superior_w::text, '') = '') then
                    nr_seq_superior_w := '';
                end if;
                ds_insert_w  := replace(ds_insert_w, 'NR_SEQ_SUPERIOR', ':NR_SEQ_SUPERIOR');
                ds_comando_w := 'insert into subindicador_gestao (' || ds_subindicador_w || ') select ' || ds_insert_w ||
                                ' from tasy_versao.subindicador_gestao ' || 'where nr_sequencia = :NR_SEQUENCIA_2';
                CALL gravar_processo_longo(ds_comando_w, 'TASY_ATUALIZAR_INDICADOR', null);
                ds_parametros_w := 'NR_SEQUENCIA=' || nr_seq_sub_ww || ';' || 'NR_SEQ_INDICADOR=' || nr_seq_nova_w || ';' ||
                                   'NR_SEQ_WHEB=' || nr_seq_sub_w || ';' || 'NR_SEQUENCIA_2=' || nr_seq_sub_w || ';' ||
                                   'NR_SEQ_SUPERIOR=' || nr_seq_superior_w || ';';
                CALL exec_sql_dinamico_bv('Insert subindicador: ' || nr_sequencia_w, ds_comando_w, ds_parametros_w);
                /* Inserir a tabela SUBindicador_gestao_atrib */

                ds_insert_w  := replace(ds_subind_atrib_w, 'NR_SEQUENCIA', 'subindicador_gestao_atrib_seq.nextval');
                ds_insert_w  := replace(ds_insert_w, 'NR_SEQ_SUBINDICADOR', ':NR_SEQ_SUBINDICADOR');
                ds_comando_w := 'insert into subindicador_gestao_atrib (' || ds_subind_atrib_w || ') select ' || ds_insert_w ||
                                ' from tasy_versao.subindicador_gestao_atrib ' ||
                                'where nr_seq_subindicador = :NR_SEQ_SUBINDICADOR_2';
                CALL gravar_processo_longo(ds_comando_w, 'TASY_ATUALIZAR_INDICADOR', null);
                ds_parametros_w := 'NR_SEQ_SUBINDICADOR=' || nr_seq_sub_ww || ';' || 'NR_SEQ_SUBINDICADOR_2=' || nr_seq_sub_w || ';';
                CALL exec_sql_dinamico_bv('Insert subindicador_atrib: ' || nr_sequencia_w, ds_comando_w, ds_parametros_w);
            end loop;
            /*CLOSE C020;*/

            dbms_sql.close_cursor(c020);
            update ind_gestao_doc_cliente
               set nr_seq_indicador = nr_seq_nova_w
             where nr_seq_indicador = nr_seq_old_w
               and (nr_seq_old_w IS NOT NULL AND nr_seq_old_w::text <> '');
            update indicador_gestao_usuario
               set nr_seq_indicador = nr_seq_nova_w
             where nr_seq_indicador = nr_seq_old_w
               and (nr_seq_old_w IS NOT NULL AND nr_seq_old_w::text <> '');
            update eis_analise_tatico
               set nr_seq_indicador = nr_seq_nova_w
             where nr_seq_indicador = nr_seq_old_w
               and (nr_seq_old_w IS NOT NULL AND nr_seq_old_w::text <> '');
            update indicador_gestao_perfil
               set nr_seq_indicador = nr_seq_nova_w
             where nr_seq_indicador = nr_seq_old_w
               and (nr_seq_old_w IS NOT NULL AND nr_seq_old_w::text <> '');
            update eis_padrao_indicador
               set nr_seq_indicador = nr_seq_nova_w
             where nr_seq_indicador = nr_seq_old_w
               and (nr_seq_old_w IS NOT NULL AND nr_seq_old_w::text <> '');
            update qua_nao_conformidade
               set nr_seq_indicador = nr_seq_nova_w
             where nr_seq_indicador = nr_seq_old_w
               and (nr_seq_old_w IS NOT NULL AND nr_seq_old_w::text <> '');
            update indic_gestao_qual
               set nr_seq_indicador = nr_seq_nova_w
             where nr_seq_indicador = nr_seq_old_w
               and (nr_seq_old_w IS NOT NULL AND nr_seq_old_w::text <> '');
            update indicador_gestao_relat
               set nr_seq_indicador = nr_seq_nova_w
             where nr_seq_indicador = nr_seq_old_w
               and (nr_seq_old_w IS NOT NULL AND nr_seq_old_w::text <> '');
            update bsc_ind_gestao
               set nr_sq_ind_gestao = nr_seq_nova_w
             where nr_sq_ind_gestao = nr_seq_old_w
               and (nr_seq_old_w IS NOT NULL AND nr_seq_old_w::text <> '');
            update regra_painel_controle
               set nr_seq_indicador = nr_seq_nova_w
             where nr_seq_indicador = nr_seq_old_w
               and (nr_seq_old_w IS NOT NULL AND nr_seq_old_w::text <> '');

            -- OS 656258 PROBLEMA COM A TRIGGER MAN_ORDEM_SERVICO_ATUAL
            begin
                update man_ordem_servico
                   set nr_seq_indicador = nr_seq_nova_w
                 where nr_seq_indicador = nr_seq_old_w
                   and (nr_seq_old_w IS NOT NULL AND nr_seq_old_w::text <> '');
            exception
                when others then
                    null;
            end;
            update qua_nao_conformidade
               set nr_seq_indicador = nr_seq_nova_w
             where nr_seq_indicador = nr_seq_old_w
               and (nr_seq_old_w IS NOT NULL AND nr_seq_old_w::text <> '');
            update indicador_regra_dimensao
               set nr_seq_indicador = nr_seq_nova_w
             where nr_seq_indicador = nr_seq_old_w
               and (nr_seq_old_w IS NOT NULL AND nr_seq_old_w::text <> '');
            begin
                update tabela_atrib_regra
                   set vl_default = nr_seq_nova_w
                 where vl_default = nr_seq_old_w
                   and nm_tabela = 'QUA_NAO_CONFORMIDADE'
                   and nm_atributo = 'NR_SEQ_INDICADOR';
            exception
                when others then
                    null;
            end;
            update indicador_grupo
               set nr_seq_indicador = nr_seq_nova_w
             where nr_seq_indicador = nr_seq_old_w
               and (nr_seq_old_w IS NOT NULL AND nr_seq_old_w::text <> '');
            update eis_usuario_regra_grid
               set nr_seq_indicador = nr_seq_nova_w
             where nr_seq_indicador = nr_seq_old_w
               and (nr_seq_old_w IS NOT NULL AND nr_seq_old_w::text <> '');
            update indicador_gestao
               set nr_seq_indic_corresp = nr_seq_nova_w
             where nr_seq_indic_corresp = nr_seq_old_w
               and (nr_seq_old_w IS NOT NULL AND nr_seq_old_w::text <> '');

            open c01; /* Vincular os antigos paineis aos novos indicadores */
            loop
                fetch c01
                    into nr_seq_atrib_new_w,
                         ds_dimensao_w,
                         ds_informacao_w,
                         nr_seq_regra_w;
                EXIT WHEN NOT FOUND; /* apply on c01 */
                begin
                    update indicador_gestao_atrib
                       set nr_seq_ind_gestao = nr_seq_nova_w
                     where nr_sequencia = nr_seq_atrib_new_w;

                    if (ds_dimensao_w IS NOT NULL AND ds_dimensao_w::text <> '') then
                        update regra_indicador_visual
                           set nr_dimensao      = nr_seq_atrib_new_w,
                               nr_seq_indicador = nr_seq_nova_w
                         where nr_sequencia = nr_seq_regra_w;
                    elsif (ds_informacao_w IS NOT NULL AND ds_informacao_w::text <> '') then
                        update regra_indicador_visual
                           set nr_informacao    = nr_seq_atrib_new_w,
                               nr_seq_indicador = nr_seq_nova_w
                         where nr_sequencia = nr_seq_regra_w;
                    end if;
                end;
            end loop;
            close c01;

            select max(ds_indicador) into STRICT ds_indicador_w from indicador_gestao where nr_sequencia = nr_seq_old_w;

            delete from indicador_gestao where nr_sequencia = nr_seq_old_w;

            qt_processada_w := qt_processada_w + 1;
            CALL gravar_processo_longo('', 'TASY_ATUALIZAR_INDICADOR', qt_processada_w);

        exception
            when others then
                CALL gravar_log_atualizacao_erro(null,
                                            obter_desc_expressao(622689, 'Erro ao gerar Indicador') || ': ' || nr_sequencia_w,
                                            '',
                                            'Tasy');
        end;

    end loop;
    dbms_sql.close_cursor(c010);

    for vet in c_dashboard loop
        begin
            CALL exec_sql_dinamico_bv('CONVERT_KPI:' || vet.nr_sequencia,
                                 'declare nr_seq_ind_w number(10); begin convert_kpi(:nm_usuario, :nr_seq_indicador, nr_seq_ind_w); end;',
                                 'nm_usuario=' || chr(39) || 'Tasy' || chr(39) || ';' || 'nr_seq_indicador=' ||
                                 vet.nr_sequencia || ';');
        exception
            when others then
                CALL gravar_log_atualizacao_erro(null,
                                            obter_desc_expressao(622689, 'Erro ao converter indicador') || ': ' ||
                                            vet.nr_sequencia,
                                            '',
                                            'Tasy');
        end;
    end loop;

    CALL exec_sql_dinamico('Enable' || ' constraint',
                      'Alter table SUBINDICADOR_GESTAO_ATRIB enable' || ' constraint SUBINAT_DICEXPR_FK');
    CALL exec_sql_dinamico('Enable' || ' constraint',
                      'Alter table INDICADOR_GESTAO_ATRIB enable' || ' constraint INDGEAT_DICEXPR_FK4');
    CALL exec_sql_dinamico('Enable' || ' constraint',
                      'Alter table INDICADOR_GESTAO_ATRIB enable' || ' constraint INDGEAT_DICEXPR_FK2');

    commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_atualizar_indicador () FROM PUBLIC;

