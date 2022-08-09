-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_xml_elem_atrib (nr_seq_proj_origem_p bigint, nr_seq_proj_destino_p bigint, nr_seq_elem_origem_p bigint, nr_seq_elem_destino_p bigint, nr_seq_elem_novo_p INOUT bigint, ie_atrib_elem_p text, nm_usuario_p text) AS $body$
DECLARE


    /*
    
    Edgar 10/05/2006
    CUIDADO AO ALTERAR ESTA PROCEDURE POIS A MESMA e RECURSIVA
    
    
    */
    nr_seq_elem_destino_w bigint;
    nr_seq_elem_origem_w  bigint;
    nr_sequencia_w        bigint;
    nr_seq_atrib_elem_w   bigint;
    nr_seq_elem_novo_w    bigint;
    nr_sequencia_rem_w    bigint;

    c01 CURSOR FOR
        SELECT a.nr_sequencia
          from xml_elemento a
         where ((a.nr_sequencia = nr_seq_elem_origem_p) or (coalesce(nr_seq_elem_origem_p::text, '') = '' and not exists (SELECT 1 from xml_atributo x where x.nr_seq_atrib_elem = a.nr_sequencia)))
           and nr_seq_projeto = nr_seq_proj_origem_p;

    c02 CURSOR FOR
        SELECT b.nr_sequencia,
               b.nr_seq_atrib_elem
          from xml_atributo b,
               xml_elemento a
         where b.nr_seq_elemento = nr_seq_elem_origem_p
           and a.nr_sequencia = b.nr_seq_elemento;

  r RECORD;

BEGIN

    if (ie_atrib_elem_p = 'E') then

        open c01;
        loop
            fetch c01
                into nr_seq_elem_origem_w;
            EXIT WHEN NOT FOUND; /* apply on c01 */

            $if $$tasy_local_dict=true $then
            nr_seq_elem_destino_w := get_remote_sequence('seq:xml_elemento_seq');
            $else
            select nextval('xml_elemento_seq') into STRICT nr_seq_elem_destino_w;
            $end

            insert into xml_elemento(nr_sequencia,
                 nr_seq_apresentacao,
                 nr_seq_projeto,
                 nm_elemento,
                 ds_elemento,
                 ds_cabecalho,
                 ds_sql,
                 ds_grupo,
                 nm_usuario,
                 dt_atualizacao,
                 ie_criar_nulo,
                 nm_usuario_nrec,
                 dt_atualizacao_nrec,
                 ie_tipo_elemento,
                 ie_criar_elemento)
                SELECT nr_seq_elem_destino_w,
                       nr_seq_apresentacao,
                       nr_seq_proj_destino_p,
                       nm_elemento,
                       ds_elemento,
                       ds_cabecalho,
                       ds_sql,
                       ds_grupo,
                       nm_usuario_p,
                       clock_timestamp(),
                       ie_criar_nulo,
                       nm_usuario_p,
                       clock_timestamp(),
                       ie_tipo_elemento,
                       ie_criar_elemento
                  from xml_elemento
                 where nr_sequencia = nr_seq_elem_origem_w;

            -- duplicar atributos do elemento
            nr_seq_elem_novo_w := duplicar_xml_elem_atrib(nr_seq_proj_origem_p, nr_seq_proj_destino_p, nr_seq_elem_origem_w, nr_seq_elem_destino_w, nr_seq_elem_novo_w, 'A', nm_usuario_p);

            nr_seq_elem_novo_p := nr_seq_elem_destino_w;

        end loop;
        close c01;

    elsif (ie_atrib_elem_p = 'A') then
    
        open c02;
        loop
            fetch c02
                into nr_sequencia_w,
                     nr_seq_atrib_elem_w;
            EXIT WHEN NOT FOUND; /* apply on c02 */

            nr_seq_elem_novo_w := null;

            if (nr_seq_atrib_elem_w IS NOT NULL AND nr_seq_atrib_elem_w::text <> '') then
            
                -- duplicar elemento do atributo
                nr_seq_elem_novo_w := duplicar_xml_elem_atrib(nr_seq_proj_origem_p, nr_seq_proj_destino_p, nr_seq_atrib_elem_w, null, nr_seq_elem_novo_w, 'E', nm_usuario_p);

            end if;

            for r in (SELECT nr_seq_apresentacao,
                             nm_atributo,
                             ie_criar_nulo,
                             ie_obrigatorio,
                             ie_tipo_atributo,
                             ds_mascara,
                             nm_atributo_xml
                        from xml_atributo
                       where nr_sequencia = nr_sequencia_w) loop
            
                $if $$tasy_local_dict=true $then
                nr_sequencia_rem_w := get_remote_sequence('seq:xml_atributo_seq');
                $else
                select nextval('xml_atributo_seq') into STRICT nr_sequencia_rem_w;
                $end

                insert into xml_atributo(nr_sequencia,
                     nr_seq_elemento,
                     nr_seq_apresentacao,
                     nm_atributo,
                     ie_criar_nulo,
                     ie_obrigatorio,
                     ie_tipo_atributo,
                     ds_mascara,
                     nm_usuario_nrec,
                     dt_atualizacao_nrec,
                     nm_usuario,
                     dt_atualizacao,
                     nr_seq_atrib_elem,
                     nm_atributo_xml)
                values (nr_sequencia_rem_w, --xml_atributo_seq.nextval,
                     nr_seq_elem_destino_p,
                     r.nr_seq_apresentacao,
                     r.nm_atributo,
                     r.ie_criar_nulo,
                     r.ie_obrigatorio,
                     r.ie_tipo_atributo,
                     r.ds_mascara,
                     nm_usuario_p,
                     clock_timestamp(),
                     nm_usuario_p,
                     clock_timestamp(),
                     nr_seq_elem_novo_w,
                     r.nm_atributo_xml);
            end loop;

        end loop;
        close c02;

    end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_xml_elem_atrib (nr_seq_proj_origem_p bigint, nr_seq_proj_destino_p bigint, nr_seq_elem_origem_p bigint, nr_seq_elem_destino_p bigint, nr_seq_elem_novo_p INOUT bigint, ie_atrib_elem_p text, nm_usuario_p text) FROM PUBLIC;
