-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_cadastro_legenda (nr_seq_leg_origem_p bigint, nm_usuario_p text) AS $body$
DECLARE


    qt_leg_existe_w     bigint;
    nr_seq_legenda_w    bigint;
    nr_seq_padrao_cor_w bigint;
    ds_padrao_w         tasy_padrao_cor.ds_padrao%type;
    ds_cor_fundo_w      tasy_padrao_cor.ds_cor_fundo%type;
    ds_cor_fonte_w      tasy_padrao_cor.ds_cor_fonte%type;
    ds_cor_selecao_w    tasy_padrao_cor.ds_cor_selecao%type;
    nr_seq_apres_w      tasy_padrao_cor.nr_seq_apres%type;
    ds_item_w           tasy_padrao_cor.ds_item%type;
    ds_hint_w           tasy_padrao_cor.ds_hint%type;
    cd_exp_item_w       tasy_padrao_cor.cd_exp_item%type;
    ie_java_w           tasy_padrao_cor.ie_java%type;
    nr_seq_cor_html_w   tasy_padrao_cor.nr_seq_cor_html%type;
    ds_cor_html_w       tasy_padrao_cor.ds_cor_html%type;

    c01 CURSOR FOR
        SELECT ds_padrao,
               ds_cor_fundo,
               ds_cor_fonte,
               ds_cor_selecao,
               nr_seq_apres,
               ds_item,
               ds_hint,
               cd_exp_item,
               ie_java,
               nr_seq_cor_html,
               ds_cor_html
          from tasy_padrao_cor
         where nr_seq_legenda = nr_seq_leg_origem_p;


BEGIN

    select count(*) into STRICT qt_leg_existe_w from tasy_legenda where nr_sequencia = coalesce(nr_seq_leg_origem_p, 0);

    if (qt_leg_existe_w > 0) then
        begin

            $if $$tasy_local_dict=true $then
            nr_seq_legenda_w := get_remote_sequence('seq:tasy_legenda_seq');
            $else
            select nextval('tasy_legenda_seq') into STRICT nr_seq_legenda_w;
            $end

            insert into tasy_legenda(nr_sequencia,
                 dt_atualizacao,
                 nm_usuario,
                 ds_legenda,
                 dt_atualizacao_nrec,
                 nm_usuario_nrec,
                 cd_funcao,
                 cd_exp_legenda,
                 ie_visao_wcpanel,
                 nr_seq_visao,
                 nr_seq_objeto)
                SELECT nr_seq_legenda_w,
                       clock_timestamp(),
                       nm_usuario_p,
                       ds_legenda,
                       clock_timestamp(),
                       nm_usuario_p,
                       cd_funcao,
                       cd_exp_legenda,
                       ie_visao_wcpanel,
                       nr_seq_visao,
                       nr_seq_objeto
                  from tasy_legenda
                 where nr_sequencia = nr_seq_leg_origem_p;

            open c01;
            loop
                fetch c01
                    into ds_padrao_w,
                         ds_cor_fundo_w,
                         ds_cor_fonte_w,
                         ds_cor_selecao_w,
                         nr_seq_apres_w,
                         ds_item_w,
                         ds_hint_w,
                         cd_exp_item_w,
                         ie_java_w,
                         nr_seq_cor_html_w,
                         ds_cor_html_w;
                EXIT WHEN NOT FOUND; /* apply on c01 */
                begin

                    $if $$tasy_local_dict=true $then
                    nr_seq_padrao_cor_w := get_remote_sequence('seq:tasy_padrao_cor_seq');
                    $else
                    select nextval('tasy_padrao_cor_seq') into STRICT nr_seq_padrao_cor_w;
                    $end

                    insert into tasy_padrao_cor(nr_sequencia,
                         dt_atualizacao,
                         nm_usuario,
                         ds_padrao,
                         ds_cor_fundo,
                         ds_cor_fonte,
                         ds_cor_selecao,
                         nr_seq_apres,
                         ds_item,
                         nr_seq_legenda,
                         dt_atualizacao_nrec,
                         nm_usuario_nrec,
                         ds_hint,
                         cd_exp_item,
                         ie_java,
                         ds_cor_html,
                         nr_seq_cor_html)
                    values (nr_seq_padrao_cor_w,
                         clock_timestamp(),
                         nm_usuario_p,
                         ds_padrao_w,
                         ds_cor_fundo_w,
                         ds_cor_fonte_w,
                         ds_cor_selecao_w,
                         nr_seq_apres_w,
                         ds_item_w,
                         nr_seq_legenda_w,
                         clock_timestamp(),
                         nm_usuario_p,
                         ds_hint_w,
                         cd_exp_item_w,
                         ie_java_w,
                         ds_cor_html_w,
                         nr_seq_cor_html_w);

                end;
            end loop;
            close c01;

            commit;

        end;
    end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_cadastro_legenda (nr_seq_leg_origem_p bigint, nm_usuario_p text) FROM PUBLIC;

