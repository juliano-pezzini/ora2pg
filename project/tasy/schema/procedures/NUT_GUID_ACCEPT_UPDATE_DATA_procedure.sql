-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nut_guid_accept_update_data ( nr_sequencias_p text, ie_guidance_fee_p text, cd_doenca_cid_p text, ie_cont_orient_p text, ie_bulk_accept_p text default 'S') AS $body$
DECLARE

query_w varchar(1000);
C01 CURSOR FOR
SELECT nr_sequencia from
nut_orientacao_list
where obter_se_contido(nr_sequencia,nr_sequencias_p) ='S';
ie_gerar_soap_nut_guidance_w    varchar(1) := 'N';
cd_evolucao_w                   bigint;
cd_pessoa_fisica_w              bigint;
nr_atendimento_w                bigint;
BEGIN
ie_gerar_soap_nut_guidance_w := Obter_Param_Usuario(281, 1669, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, obter_estabelecimento_ativo, ie_gerar_soap_nut_guidance_w);
    if (nr_sequencias_p IS NOT NULL AND nr_sequencias_p::text <> '') then

        query_w := 'update nut_orientacao_list
                    set  ie_status = ''A'',
                    ie_guidance_fee = '''|| ie_guidance_fee_p || '''';

        if (ie_bulk_accept_p = 'N') then
                query_w := query_w || ', cd_doenca_cid = '''|| cd_doenca_cid_p|| '''';
                query_w := query_w || ', ie_cont_orient = '''|| ie_cont_orient_p|| '''';
        end if;

        query_w := query_w || ' where nr_sequencia in ('|| nr_sequencias_p ||')';

        EXECUTE query_w;
        commit;
    end if;
    for r_c01 in c01 loop
    begin
        if (coalesce(r_c01.nr_sequencia,0)>0 and ie_gerar_soap_nut_guidance_w = 'S' ) then
            select nr_atendimento,
            cd_pessoa_fisica
            into STRICT nr_atendimento_w,
            cd_pessoa_fisica_w
            from nut_orientacao_list
            where nr_sequencia = r_c01.nr_sequencia;
            cd_evolucao_w := clinical_notes_pck.gerar_soap(nr_atendimento_w, r_c01.nr_sequencia, 'NUT_GUIDANCE', '1', 'A', 1, cd_evolucao_w, null, cd_pessoa_fisica_w);
            update nut_orientacao_list
            set cd_evolucao = cd_evolucao_w
            where nr_sequencia = r_c01.nr_sequencia;
        end if;
    end;
    end loop;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nut_guid_accept_update_data ( nr_sequencias_p text, ie_guidance_fee_p text, cd_doenca_cid_p text, ie_cont_orient_p text, ie_bulk_accept_p text default 'S') FROM PUBLIC;
