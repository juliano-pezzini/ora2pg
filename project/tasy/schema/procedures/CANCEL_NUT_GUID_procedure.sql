-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancel_nut_guid ( nr_sequencia_p bigint ) AS $body$
DECLARE

    ie_gerar_soap_nut_guidance_w    varchar(1) := 'N';
    cd_evolucao_w                   bigint;
    cd_pessoa_fisica_w              bigint;
    nr_atendimento_w                bigint;

BEGIN
    ie_gerar_soap_nut_guidance_w := Obter_Param_Usuario(281, 1669, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, obter_estabelecimento_ativo, ie_gerar_soap_nut_guidance_w);
    select max(cd_evolucao)
    into STRICT cd_evolucao_w
    from nut_orientacao_list
    where nr_sequencia = nr_sequencia_p;
    if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
    update	nut_orientacao_list
    set		ie_status= 'S'
    where	nr_sequencia=nr_sequencia_p;
    end if;
	if (ie_gerar_soap_nut_guidance_w = 'S' and coalesce(cd_evolucao_w,0)>0) then
        delete from clinical_note_soap_data
        where cd_evolucao = cd_evolucao_w
        and ie_med_rec_type ='NUT_GUIDANCE'
        and ie_stage = 1
        and ie_soap_type = 'A'
        and nr_seq_med_item = nr_sequencia_p
        and ie_cpoe_item_type = 1;
        CALL clinical_notes_pck.soap_data_after_delete(cd_evolucao_w);
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancel_nut_guid ( nr_sequencia_p bigint ) FROM PUBLIC;

