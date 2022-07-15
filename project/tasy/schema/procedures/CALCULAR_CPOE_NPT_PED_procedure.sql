-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_cpoe_npt_ped ( nr_seq_npt_cpoe_p bigint, ie_tipo_npt_p text, nm_usuario_p text, ds_json_p INOUT text ) AS $body$
DECLARE


nr_seq_elemento_w		nut_elemento.nr_sequencia%type;
nr_seq_elemento_old_w	nut_elemento.nr_sequencia%type;
cd_unidade_medida_w		nut_elemento.cd_unidade_medida%type;
ie_prim_fase_w			nut_elemento.ie_prim_fase%type;
ie_seg_fase_w			nut_elemento.ie_seg_fase%type;
ie_terc_fase_w			nut_elemento.ie_terc_fase%type;
ie_quar_fase_w			nut_elemento.ie_quar_fase%type;
ie_unid_med_w			nut_elemento.ie_unid_med%type;
ie_tipo_elemento_w		nut_elemento.ie_tipo_elemento%type;
ie_glutamina_w			nut_elemento.ie_glutamina%type;
ie_somar_volume_w		nut_elemento.ie_somar_volume%type;

nr_seq_produto_w		nut_elem_material.nr_sequencia%type;
cd_material_w			nut_elem_material.cd_material%type;

nr_seq_npt_elem_w		cpoe_npt_elemento.nr_sequencia%type;
nr_seq_npt_prod_w		cpoe_npt_produto.nr_sequencia%type;

ds_json_elem_w          text;
ds_json_prod_w          text;
qt_count_elemento_w     bigint;
qt_count_produto_w      bigint;

C01 CURSOR FOR
SELECT	elem.nr_sequencia,
        elem.cd_unidade_medida,
        elem.ie_prim_fase,
        elem.ie_seg_fase,
        elem.ie_terc_fase,
        elem.ie_quar_fase,
        elem.ie_unid_med,
        elem.ie_tipo_elemento,
        elem.ie_glutamina,
        elem.ie_somar_volume,
        mat.nr_sequencia,
        mat.cd_material
FROM	nut_elemento elem,
        nut_elem_material mat
WHERE	elem.nr_sequencia = mat.nr_seq_elemento
AND	    elem.ie_situacao = 'A'
AND	    mat.ie_situacao = 'A'
AND	    mat.ie_padrao = 'S'
AND	    coalesce(mat.ie_tipo, 'NPT') = 'NPT'
AND	    ((ie_tipo_npt_p = 'N' AND elem.ie_gerar_ped = 'S')
        OR (ie_tipo_npt_p = 'I' AND elem.ie_npt_pediatrica = 'S'))
AND	    (elem.cd_unidade_medida IS NOT NULL AND elem.cd_unidade_medida::text <> '')
ORDER BY	elem.nr_seq_apresent,
            elem.ds_elemento;

c02 CURSOR FOR
SELECT  *
from    cpoe_npt_elemento
where   nr_seq_npt_cpoe = nr_seq_npt_cpoe_p;

c03 CURSOR FOR
SELECT  *
from    cpoe_npt_produto
where   nr_seq_npt_cpoe = nr_seq_npt_cpoe_p;

BEGIN
	nr_seq_elemento_old_w := null;
	ds_json_elem_w := null;
	ds_json_prod_w := null;

    select  count(0)
    into STRICT    qt_count_elemento_w
    from    cpoe_npt_elemento
    where   nr_seq_npt_cpoe = nr_seq_npt_cpoe_p;

    select  count(0)
    into STRICT    qt_count_produto_w
    from    cpoe_npt_produto
    where   nr_seq_npt_cpoe = nr_seq_npt_cpoe_p;

    if (qt_count_elemento_w > 0 and qt_count_produto_w > 0) then
         for c02_w in c02 loop 
            
            ds_json_elem_w := ds_json_elem_w || '{'
                || format_array_json('NR_SEQUENCIA', c02_w.nr_sequencia, 1)
                || format_array_json('DS_ELEMENTO', substr(obter_descricao_padrao('NUT_ELEMENTO','DS_ELEMENTO',c02_w.nr_seq_elemento),1,40), 1)
                || format_array_json('DS_PADRAO', substr(Obter_padrao_elem_nut_pac_ped(c02_w.nr_seq_elemento),1,40), 1)
                || format_array_json('DS_UNIDADE_MEDIDA', substr(obter_desc_unid_med(c02_w.cd_unidade_medida),1,40), 1)
                || format_array_json('NM_USUARIO', c02_w.nm_usuario, 1)
                || format_array_json('NR_SEQ_NPT_CPOE', nr_seq_npt_cpoe_p, 1)
                || format_array_json('CD_UNIDADE_MEDIDA', c02_w.cd_unidade_medida, 1)
                || format_array_json('NR_SEQ_ELEMENTO',c02_w.nr_seq_elemento, 1)                
                || format_array_json('IE_EDITADO',c02_w.ie_editado, 1)
                || format_array_json('IE_ITEM_VALIDO',c02_w.ie_item_valido, 1)
                || format_array_json('NR_SEQ_ELEM_MAT',c02_w.nr_seq_elem_mat, 1)
                || format_array_json_number('QT_DIARIA', c02_w.qt_diaria)
                || format_array_json_number('QT_KCAL', c02_w.qt_kcal)
                || format_array_json_number('PR_TOTAL', c02_w.pr_total)
                || format_array_json_number('PR_CONCENTRACAO', c02_w.pr_concentracao)
                || format_array_json_number('QT_ELEM_KG_DIA', c02_w.qt_elem_kg_dia)      
                || format_array_json_number('QT_VOLUME', c02_w.qt_volume)
                || format_array_json_number('QT_VOLUME_FINAL', c02_w.qt_volume_final)
                || format_array_json_number('QT_PROTOCOLO', c02_w.qt_protocolo)
                || format_array_json_number('QT_GRAMA_NITROGENIO', c02_w.qt_grama_nitrogenio)
                || format_array_json_number('QT_OSMOLARIDADE', c02_w.qt_osmolaridade)                
                || format_array_json('IE_PRIM_FASE', c02_w.ie_prim_fase, 1)
                || format_array_json('IE_SEG_FASE', c02_w.ie_seg_fase, 1)
                || format_array_json('IE_TERC_FASE', c02_w.ie_terc_fase, 1)
                || format_array_json('IE_QUAR_FASE', c02_w.ie_quar_fase, 1)
                || format_array_json('IE_UNID_MED', c02_w.ie_unid_med, 1)
                || format_array_json('IE_NPT', c02_w.ie_npt, 1) 
                || format_array_json('IE_PROD_ADICIONAL', c02_w.ie_prod_adicional, 1)              
                || format_array_json('IE_TIPO_ELEMENTO', c02_w.ie_tipo_elemento, 1)
                || format_array_json('IE_GLUTAMINA', c02_w.ie_glutamina, 1);

            ds_json_elem_w := substr(ds_json_elem_w, 1, length(ds_json_elem_w) -2) || '}, ';
         end loop;

         for c03_w in c03 loop
            ds_json_prod_w := ds_json_prod_w || '{'
                || format_array_json('NR_SEQUENCIA', c03_w.nr_sequencia, 1)
                || format_array_json('NM_USUARIO', c03_w.nm_usuario, 1)
                || format_array_json('NR_SEQ_ELEM_MAT', c03_w.nr_seq_elem_mat, 1)
                || format_array_json('NR_SEQ_ELEMENTO', c03_w.nr_seq_elemento, 1)
                || format_array_json('NR_SEQ_NPT_CPOE', c03_w.nr_seq_npt_cpoe, 1)      
                || format_array_json('CD_MATERIAL', c03_w.cd_material, 1)
                || format_array_json('CD_UNIDADE_MEDIDA', c03_w.cd_unidade_medida, 1)
                || format_array_json_number('QT_PROTOCOLO', c03_w.qt_protocolo)
                || format_array_json_number('QT_VOL_COR', c03_w.qt_vol_cor)
                || format_array_json_number('QT_VOLUME', c03_w.qt_volume)
                || format_array_json_number('QT_VOL_1_FASE', c03_w.qt_vol_1_fase)
                || format_array_json_number('QT_VOL_2_FASE', c03_w.qt_vol_2_fase)
                || format_array_json_number('QT_VOL_3_FASE', c03_w.qt_vol_3_fase)
                || format_array_json_number('QT_VOL_4_FASE', c03_w.qt_vol_4_fase)      
                || format_array_json_number('QT_DOSE', c03_w.qt_dose)            
                || format_array_json('IE_SOMAR_VOLUME', c03_w.ie_somar_volume, 1)                
                || format_array_json('IE_ITEM_VALIDO', c03_w.ie_item_valido , 1)
                || format_array_json('IE_MODIFICADO', c03_w.ie_modificado, 1)
                || format_array_json('IE_PROD_ADICIONAL', c03_w.ie_prod_adicional, 1)
                || format_array_json('IE_SUPERA_LIMITE_USO', c03_w.ie_supera_limite_uso, 1)                
                || format_array_json('DS_MATERIAL', substr(obter_desc_material(c03_w.cd_material),1,60), 1);

            ds_json_prod_w := substr(ds_json_prod_w, 1, length(ds_json_prod_w) -2) || '}, ';
         
         end loop;

    else
        OPEN c01;
        LOOP
        FETCH c01 INTO
            nr_seq_elemento_w,
            cd_unidade_medida_w,
            ie_prim_fase_w,
            ie_seg_fase_w,
            ie_terc_fase_w,
            ie_quar_fase_w,
            ie_unid_med_w,
            ie_tipo_elemento_w,
            ie_glutamina_w,
            ie_somar_volume_w,
            nr_seq_produto_w,
            cd_material_w;
        EXIT WHEN NOT FOUND; /* apply on c01 */

        SELECT	nextval('cpoe_npt_produto_seq')
        INTO STRICT	nr_seq_npt_prod_w
;

        -- an element can have more than 1 product
        if (coalesce(nr_seq_elemento_old_w::text, '') = '' OR nr_seq_elemento_old_w <> nr_seq_elemento_w) then
            SELECT	nextval('cpoe_npt_elemento_seq')
            INTO STRICT	nr_seq_npt_elem_w
;

            ds_json_elem_w := ds_json_elem_w || '{'
                || format_array_json('NR_SEQUENCIA', nr_seq_npt_elem_w, 1)
                || format_array_json('DS_ELEMENTO', substr(obter_descricao_padrao('NUT_ELEMENTO','DS_ELEMENTO',nr_seq_elemento_w),1,40), 1)
                || format_array_json('DS_PADRAO', substr(Obter_padrao_elem_nut_pac_ped(nr_seq_elemento_w),1,40), 1)
                || format_array_json('DS_UNIDADE_MEDIDA', substr(obter_desc_unid_med(cd_unidade_medida_w),1,40), 1)
                || format_array_json('NM_USUARIO', nm_usuario_p, 1)
                || format_array_json('NR_SEQ_NPT_CPOE', nr_seq_npt_cpoe_p, 1)
                || format_array_json('CD_UNIDADE_MEDIDA', cd_unidade_medida_w, 1)
                || format_array_json('NR_SEQ_ELEMENTO', nr_seq_elemento_w, 1)
                || format_array_json_number('QT_DIARIA', 0)
                || format_array_json_number('QT_KCAL', 0)
                || format_array_json_number('PR_TOTAL', 0)
                || format_array_json_number('QT_ELEM_KG_DIA', 0)      
                || format_array_json_number('QT_VOLUME_FINAL', 0)
                || format_array_json('IE_PRIM_FASE', ie_prim_fase_w, 1)
                || format_array_json('IE_SEG_FASE', ie_seg_fase_w, 1)
                || format_array_json('IE_TERC_FASE', ie_terc_fase_w, 1)
                || format_array_json('IE_QUAR_FASE', ie_quar_fase_w, 1)
                || format_array_json('IE_UNID_MED', ie_unid_med_w, 1)
                || format_array_json('IE_NPT', 'S', 1) 
                || format_array_json('IE_PROD_ADICIONAL', 'N', 1)              
                || format_array_json('IE_TIPO_ELEMENTO', ie_tipo_elemento_w, 1)
                || format_array_json('IE_GLUTAMINA', ie_glutamina_w, 1);
            ds_json_elem_w := substr(ds_json_elem_w, 1, length(ds_json_elem_w) -2) || '}, ';
        end if;
          
        ds_json_prod_w := ds_json_prod_w || '{'
            || format_array_json('NR_SEQUENCIA', nr_seq_npt_prod_w, 1)
            || format_array_json('NM_USUARIO', nm_usuario_p, 1)
            || format_array_json('NR_SEQ_ELEM_MAT', nr_seq_produto_w, 1)
            || format_array_json('NR_SEQ_ELEMENTO', nr_seq_npt_elem_w, 1)
            || format_array_json('NR_SEQ_NPT_CPOE', nr_seq_npt_cpoe_p, 1)      
            || format_array_json('CD_MATERIAL', cd_material_w, 1)      
            || format_array_json_number('QT_VOLUME', 0)
            || format_array_json_number('QT_VOL_1_FASE', 0)
            || format_array_json_number('QT_VOL_2_FASE', 0)
            || format_array_json_number('QT_VOL_3_FASE', 0)
            || format_array_json_number('QT_VOL_4_FASE', 0)      
            || format_array_json_number('QT_DOSE', 0)            
            || format_array_json('IE_SOMAR_VOLUME', ie_somar_volume_w, 1)      
            || format_array_json('DS_MATERIAL', substr(obter_desc_material(cd_material_w),1,60), 1)      
            || format_array_json('IE_TIPO_ELEMENTO', ie_tipo_elemento_w, 1);
        ds_json_prod_w := substr(ds_json_prod_w, 1, length(ds_json_prod_w) -2) || '}, ';
    
        nr_seq_elemento_old_w := nr_seq_elemento_w;

        END loop;
        CLOSE c01;

    end if;	
	
	ds_json_elem_w := '"CPOE_NPT_ELEMENTO": [' || substr(ds_json_elem_w, 1, length(ds_json_elem_w) -2) || ']';
	ds_json_prod_w := '"CPOE_NPT_PRODUTO": [' || substr(ds_json_prod_w, 1, length(ds_json_prod_w) -2) || ']';

	ds_json_p := '{'|| ds_json_elem_w || ', ' || ds_json_prod_w ||'}';

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_cpoe_npt_ped ( nr_seq_npt_cpoe_p bigint, ie_tipo_npt_p text, nm_usuario_p text, ds_json_p INOUT text ) FROM PUBLIC;

