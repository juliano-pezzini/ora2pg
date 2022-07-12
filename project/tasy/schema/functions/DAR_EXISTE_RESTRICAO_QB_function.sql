-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION dar_existe_restricao_qb (tabela_p text, nr_seq_objeto_schematic_p text) RETURNS varchar AS $body$
DECLARE

    TYPE obj_schem_ids_t IS TABLE OF objeto_schematic.nr_sequencia%TYPE INDEX BY integer;
    obj_schem_ids   obj_schem_ids_t;

BEGIN
        select os.nr_sequencia as nr_sequencia
        BULK COLLECT INTO STRICT obj_schem_ids
        from objeto_schematic os
        inner join objeto_schematic_param osp on osp.nr_seq_obj_sch = os.nr_sequencia
        left join obj_schem_usuario osu on osu.nr_seq_obj_schem_param = osp.nr_sequencia and osu.nm_usuario = wheb_usuario_pck.get_nm_usuario
        left join obj_schem_perfil osp2 on osp2.nr_seq_obj_schem_param = osp.nr_sequencia and osp2.cd_perfil = wheb_usuario_pck.get_cd_perfil
        left join obj_schem_estab ose on ose.nr_seq_obj_schem_param = osp.nr_sequencia and ose.cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento
        where exists (SELECT 1
            from objeto_schematic a,
                 tabela_visao b
            where	a.nm_tabela = b.nm_tabela
            and	a.nr_seq_visao = b.nr_sequencia
            and	a.nr_seq_funcao_schematic = os.nr_seq_funcao_schematic
            and	a.ie_tipo_componente = 'WDBP'
            and (select schematic_obter_parent_nav(a.nr_sequencia) ) = os.nr_sequencia
            and a.nm_tabela = tabela_p)
        and coalesce(osu.vl_parametro, osp2.vl_parametro, ose.vl_parametro, osp.vl_parametro_padrao) = 'N';

    IF obj_schem_ids.count > 0 THEN 
        FOR idx IN obj_schem_ids.first .. obj_schem_ids.last
        LOOP
            IF (dar_caminhos_iguais(obj_schem_ids(idx), nr_seq_objeto_schematic_p) = 'S') THEN
                RETURN 'S';
            END IF;
        END LOOP;
    END IF;	
    RETURN 'N';
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION dar_existe_restricao_qb (tabela_p text, nr_seq_objeto_schematic_p text) FROM PUBLIC;

