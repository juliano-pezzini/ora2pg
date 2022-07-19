-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE populate_quality_review (cd_funcao_p bigint, nm_usuario_p text) AS $body$
DECLARE


    nr_seq_dic_objeto_w bigint;WITH RECURSIVE cte AS (


    c01 CURSOR FOR
        SELECT 1 as level,coalesce(obter_desc_expressao(a.cd_exp_desc_obj, null), ds_objeto) ||
               CASE WHEN coalesce(ie_tipo_componente::text, '') = '' THEN  ''  ELSE ' (' || ie_tipo_componente || ')' END  ds_objeto,coalesce(ie_tipo_componente, CASE WHEN ie_tipo_objeto='T' THEN  'WTab'  ELSE null END ) ie_tipo_componente,nr_sequencia,ie_tipo_objeto,ARRAY[ row_number() OVER (ORDER BY  nr_seq_apres) ] as hierarchy
          from objeto_schematic a WHERE coalesce(a.nr_seq_obj_sup::text, '') = ''
                and a.nr_seq_funcao_schematic in (select x.nr_sequencia from funcao_schematic x where coalesce(x.ie_situacao_funcao, 'I') = 'A')
                and coalesce(ie_tipo_componente, 'XPTO') not in ('WDLG', 'WSCB')
  UNION ALL


    c01 CURSOR FOR
        SELECT (c.level+1),coalesce(obter_desc_expressao(a.cd_exp_desc_obj, null), ds_objeto) ||
               CASE WHEN coalesce(ie_tipo_componente::text, '') = '' THEN  ''  ELSE ' (' || ie_tipo_componente || ')' END  ds_objeto,coalesce(ie_tipo_componente, CASE WHEN ie_tipo_objeto='T' THEN  'WTab'  ELSE null END ) ie_tipo_componente,nr_sequencia,ie_tipo_objeto, array_append(c.hierarchy, row_number() OVER (ORDER BY  nr_seq_apres))  as hierarchy
          from objeto_schematic a JOIN cte c ON (c.prior nr_sequencia = a.nr_seq_obj_sup)

) SELECT * FROM cte WHERE nr_seq_funcao_schematic in (SELECT x.nr_sequencia from funcao_schematic x where coalesce(x.ie_situacao_funcao, 'I') = 'A')
           and cd_funcao = cd_funcao_p
           and coalesce(ie_tipo_componente, 'XPTO') not in ('WDLG', 'WSCB', 'WAE') ORDER BY hierarchy;
;

    c02 CURSOR FOR
        SELECT * from dic_objeto where nr_seq_obj_sup = nr_seq_dic_objeto_w;

    c03 CURSOR FOR
        SELECT coalesce(obter_desc_expressao(cd_exp_desc_obj, null), ds_objeto) ds_objeto,
               ie_tipo_componente,
               nr_sequencia
          from objeto_schematic
         where cd_funcao = cd_funcao_p
           and ie_tipo_componente = 'WAE';

    c01_w           c01%rowtype;
    c02_w           c02%rowtype;
    c03_w           c03%rowtype;
    level_w         bigint := 0;
    nr_seq_sup_w    bigint := 0;
    nr_order_w      bigint := 1;
    nr_sequencia_w  bigint := 0;
    nr_versao_w     bigint;
    ie_possui_wae_w varchar(1);


BEGIN

    if (coalesce(cd_funcao_p, 0) > 0) then
        select coalesce(max(nr_versao), 0) + 1 into STRICT nr_versao_w from qr_objeto_schematic where cd_funcao = cd_funcao_p;

        open c01;
        loop
            fetch c01
                into c01_w;
            EXIT WHEN NOT FOUND; /* apply on c01 */
            begin

                if (c01_w.ie_tipo_componente in ('WDBP', 'WPOPUP', 'WAV', 'WF', 'WCP', 'WCL', 'BD') or
                   c01_w.ie_tipo_objeto in ('DDM', 'T', 'IT', 'BC', 'TV', 'TDDM', 'BCDBP', 'SG', 'STEP', 'TG', 'VM', 'MN')) then
                    select max(nr_sequencia)
                      into STRICT nr_seq_sup_w
                      from qr_objeto_schematic
                     where nr_level < c01_w.level
                       and ((upper(ie_tipo_componente) not in ('WPOPUP', 'WAV', 'WF', 'WMENUITEM')) or (coalesce(ie_tipo_componente::text, '') = ''))
                       and cd_funcao = cd_funcao_p
                       and nr_versao = nr_versao_w;

                    $if $$tasy_local_dict=true $then
                    nr_sequencia_w := get_remote_sequence('seq:qr_objeto_schematic_seq');
                    $else
                    select nextval('qr_objeto_schematic_seq') into STRICT nr_sequencia_w;
                    $end

                    insert into qr_objeto_schematic(nr_sequencia,
                         dt_atualizacao,
                         nm_usuario,
                         dt_atualizacao_nrec,
                         nm_usuario_nrec,
                         nr_seq_obj_sch,
                         nr_level,
                         nr_order_by,
                         nr_seq_obj_sup,
                         nr_versao,
                         ds_objeto,
                         ie_tipo_componente,
                         cd_funcao)
                    values (nr_sequencia_w,
                         clock_timestamp(),
                         nm_usuario_p,
                         clock_timestamp(),
                         nm_usuario_p,
                         c01_w.nr_sequencia,
                         c01_w.level,
                         nr_order_w,
                         CASE WHEN nr_seq_sup_w=0 THEN  null  ELSE nr_seq_sup_w END ,
                         nr_versao_w,
                         c01_w.ds_objeto,
                         c01_w.ie_tipo_componente,
                         cd_funcao_p);

                    /*insert into cornetet (   
                        dd,
                        nr_seq_sch,
                        nr_seq_obj_sup,
                        nr_level,
                        nr_order,
                        nr_sequencia)
                    values(   c01_w.ds_objeto,
                            c01_w.nr_sequencia,
                            decode(nr_seq_sup_w,0,null,nr_seq_sup_w),
                            c01_w.level,
                            nr_order_w,
                            nr_sequencia_w);*/
                end if;

                if (c01_w.ie_tipo_componente = 'WPOPUP') then
                    select max(nr_seq_dic_objeto)
                      into STRICT nr_seq_dic_objeto_w
                      from objeto_schematic
                     where nr_sequencia = c01_w.nr_sequencia;

                    nr_seq_sup_w := nr_sequencia_w;

                    open c02;
                    loop
                        fetch c02
                            into c02_w;
                        EXIT WHEN NOT FOUND; /* apply on c02 */
                        begin

                            nr_order_w := nr_order_w + 1;

                            $if $$tasy_local_dict=true $then
                            nr_sequencia_w := get_remote_sequence('seq:qr_objeto_schematic_seq');
                            $else
                            select nextval('qr_objeto_schematic_seq') into STRICT nr_sequencia_w;
                            $end

                            insert into qr_objeto_schematic(nr_sequencia,
                                 dt_atualizacao,
                                 nm_usuario,
                                 dt_atualizacao_nrec,
                                 nm_usuario_nrec,
                                 nr_seq_obj_sch,
                                 nr_level,
                                 nr_order_by,
                                 nr_seq_obj_sup,
                                 nr_versao,
                                 ds_objeto,
                                 ie_tipo_componente,
                                 cd_funcao)
                            values (nr_sequencia_w,
                                 clock_timestamp(),
                                 nm_usuario_p,
                                 clock_timestamp(),
                                 nm_usuario_p,
                                 null,
                                 c01_w.level + 1,
                                 nr_order_w,
                                 CASE WHEN nr_seq_sup_w=0 THEN  null  ELSE nr_seq_sup_w END ,
                                 nr_versao_w,
                                 obter_desc_expressao(c02_w.cd_exp_texto),
                                 'WMENUITEM',
                                 cd_funcao_p);

                            /*insert into cornetet (    
                                dd,
                                nr_seq_sch,
                                nr_seq_obj_sup,
                                nr_level,
                                nr_order,
                                nr_sequencia)
                            values(   obter_desc_expressao(c02_w.CD_EXP_TEXTO),
                                    null,
                                    decode(nr_seq_sup_w,0,null,nr_seq_sup_w),
                                    c01_w.level+1,
                                    nr_order_w,
                                    nr_sequencia_w);*/
                        end;
                    end loop;
                    close c02;

                end if;

                nr_order_w := nr_order_w + 1;

            end;
        end loop;
        close c01;

        --Insere no das chamadas externas
        select CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END 
          into STRICT ie_possui_wae_w
          from objeto_schematic
         where cd_funcao = cd_funcao_p
           and ie_tipo_componente = 'WAE';

        if (ie_possui_wae_w = 'S') then
        
            $if $$tasy_local_dict=true $then
            nr_sequencia_w := get_remote_sequence('seq:qr_objeto_schematic_seq');
            $else
            select nextval('qr_objeto_schematic_seq') into STRICT nr_sequencia_w;
            $end

            insert into qr_objeto_schematic(nr_sequencia,
                 dt_atualizacao,
                 nm_usuario,
                 dt_atualizacao_nrec,
                 nm_usuario_nrec,
                 nr_seq_obj_sch,
                 nr_level,
                 nr_order_by,
                 nr_seq_obj_sup,
                 nr_versao,
                 ds_objeto,
                 ie_tipo_componente,
                 cd_funcao)
            values (nr_sequencia_w,
                 clock_timestamp(),
                 nm_usuario_p,
                 clock_timestamp(),
                 nm_usuario_p,
                 null,
                 1,
                 nr_order_w,
                 null,
                 nr_versao_w,
                 'WAEs',
                 'WAEGroup',
                 cd_funcao_p);

            nr_order_w := nr_order_w + 1;

            nr_seq_sup_w := nr_sequencia_w;

            open c03;
            loop
                fetch c03
                    into c03_w;
                EXIT WHEN NOT FOUND; /* apply on c03 */
                begin

                    $if $$tasy_local_dict=true $then
                    nr_sequencia_w := get_remote_sequence('seq:qr_objeto_schematic_seq');
                    $else
                    select nextval('qr_objeto_schematic_seq') into STRICT nr_sequencia_w;
                    $end

                    insert into qr_objeto_schematic(nr_sequencia,
                         dt_atualizacao,
                         nm_usuario,
                         dt_atualizacao_nrec,
                         nm_usuario_nrec,
                         nr_seq_obj_sch,
                         nr_level,
                         nr_order_by,
                         nr_seq_obj_sup,
                         nr_versao,
                         ds_objeto,
                         ie_tipo_componente,
                         cd_funcao)
                    values (nr_sequencia_w,
                         clock_timestamp(),
                         nm_usuario_p,
                         clock_timestamp(),
                         nm_usuario_p,
                         c03_w.nr_sequencia,
                         2,
                         nr_order_w,
                         nr_seq_sup_w,
                         nr_versao_w,
                         c03_w.ds_objeto,
                         c03_w.ie_tipo_componente,
                         cd_funcao_p);

                    nr_order_w := nr_order_w + 1;
                end;
            end loop;
            close c03;
        end if;

        -- Gera o checklist da funcao
        CALL generate_function_checklist(cd_funcao_p, nm_usuario_p, nr_versao_w);
    end if;

    commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE populate_quality_review (cd_funcao_p bigint, nm_usuario_p text) FROM PUBLIC;

