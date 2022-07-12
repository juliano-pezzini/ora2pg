-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_is_routine_sol_order_type ( cd_protocolo_p protocolo_medic_material.cd_protocolo%type, nr_sequencia_p protocolo_medic_material.nr_sequencia%type, nr_seq_solucao_p protocolo_medic_material.nr_seq_solucao%type, nr_seq_order_unit_p material_order_type.nr_seq_order_type%type, cd_estabelecimento_p material_order_type.cd_estabelecimento%type ) RETURNS varchar AS $body$
DECLARE


is_material     varchar(1) := 'N';

cMaterialCode CURSOR FOR
        SELECT cd_material
        from PROTOCOLO_MEDIC_MATERIAL
        where cd_protocolo = cd_protocolo_p
        and nr_sequencia = nr_sequencia_p
        and nr_seq_solucao = nr_seq_solucao_p;

BEGIN


    for cCdMaterial_w in cMaterialCode
		loop
            is_material := 'N';
			 select  max('S')
                into STRICT    is_material
                from	cpoe_order_unit a,
                        material_order_type b
                where   a.nr_sequencia = nr_seq_order_unit_p
                and		a.NR_SEQ_CPOE_TIPO_PEDIDO = b.nr_seq_order_type
                and		b.cd_material = cCdMaterial_w.cd_material
                and     b.cd_estabelecimento = cd_estabelecimento_p
                and		b.IE_SITUACAO = 'A';


                if (is_material <> 'S') then
                    return is_material;
                end if;

		end loop;	

    return is_material;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_is_routine_sol_order_type ( cd_protocolo_p protocolo_medic_material.cd_protocolo%type, nr_sequencia_p protocolo_medic_material.nr_sequencia%type, nr_seq_solucao_p protocolo_medic_material.nr_seq_solucao%type, nr_seq_order_unit_p material_order_type.nr_seq_order_type%type, cd_estabelecimento_p material_order_type.cd_estabelecimento%type ) FROM PUBLIC;
