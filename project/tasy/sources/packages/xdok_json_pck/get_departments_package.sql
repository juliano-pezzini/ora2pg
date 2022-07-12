-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION xdok_json_pck.get_departments ( nr_seq_episodio_p bigint) RETURNS PHILIPS_JSON_LIST AS $body$
DECLARE


json_care_sector_w          philips_json;
json_care_sector_list_w     philips_json_list;
hospitalid_w                pessoa_juridica.ds_nome_abrev%type;
newborn_w                   varchar(1);
costcenterfunctioncode_w    setor_atendimento.cd_cnes%type;
costcenterfunctioncode_ww   setor_atendimento.cd_cnes%type;
cont_w                      smallint;
record_id_w                 varchar(3);
pessoa_fisica_w             pessoa_fisica%rowtype;

X02 CURSOR FOR
SELECT  c.nr_episodio numberadmission,
        to_char(b.dt_entrada, 'yyyymmdd') recorddata,
        to_char(dt_entrada_unidade, 'yyyymmdd') costcentercontactdate, 
        to_char(dt_entrada_unidade, 'hhmi') costcentercontacttime, 
        to_char(dt_saida_unidade, 'yyyymmdd') costcenterretirementdate, 
        to_char(dt_saida_unidade, 'hhmi') costcenterretirementtime,
        obter_faixa_etaria_pac(b.cd_pessoa_fisica, 'C') agegroup,
        b.dt_entrada,
        b.cd_setor_usuario_atend,
        b.cd_estabelecimento,
        b.cd_pessoa_fisica,
        a.cd_setor_atendimento
from    atend_paciente_unidade a,
        atendimento_paciente b,
        episodio_paciente c
where   a.nr_atendimento = b.nr_atendimento
and     c.nr_sequencia = b.nr_seq_episodio
and     c.nr_sequencia = nr_seq_episodio_p
order by    a.dt_entrada_unidade;

BEGIN
json_care_sector_list_w := philips_json_list();
cont_w := 1;

for r_x02 in X02 loop
    begin

    begin
    select  xdok_json_pck.get_sistema_externo(obter_cgc_estabelecimento(r_x02.cd_estabelecimento), r_x02.cd_estabelecimento)
    into STRICT    hospitalid_w
;
    exception
    when others then
        hospitalid_w := null;
    end;

    begin
    select  max(cd_cnes)
    into STRICT    costcenterfunctioncode_w
    from    setor_atendimento
    where   cd_setor_atendimento = r_x02.cd_setor_atendimento;
    exception
    when others then
        costcenterfunctioncode_w := null;
    end;

    if  coalesce(costcenterfunctioncode_ww::text, '') = '' then
        costcenterfunctioncode_ww := costcenterfunctioncode_w;
    elsif   costcenterfunctioncode_ww <> costcenterfunctioncode_w then
        begin
        cont_w := cont_w + 1;
        costcenterfunctioncode_ww := costcenterfunctioncode_w;
        end;
    end if;

    select  lpad(to_char(cont_w), 3, '0')
    into STRICT    record_id_w
;

    begin
    select  *
    into STRICT    pessoa_fisica_w
    from    pessoa_fisica
    where   cd_pessoa_fisica = r_x02.cd_pessoa_fisica;
    exception
    when others then
        pessoa_fisica_w := null;
    end;

    begin
    select  case when(Obter_Idade(pessoa_fisica_w.dt_nascimento, r_x02.dt_entrada, 'DIA') < 28) then 'J' else 'N' end
    into STRICT    newborn_w
;
    exception
    when others then
        newborn_w := null;
    end;

    json_care_sector_w := philips_json();
    json_care_sector_w := xdok_json_pck.add_json_value(json_care_sector_w, 'hospitalID', hospitalid_w);
    /*    xdok_json_pck.add_json_value(json_care_sector_w, 'numberAdmission', r_x02.numberAdmission); */

    json_care_sector_w := xdok_json_pck.add_json_value(json_care_sector_w, 'numberAdmission', '');
    json_care_sector_w := xdok_json_pck.add_json_value(json_care_sector_w, 'recordID', '');
    json_care_sector_w := xdok_json_pck.add_json_value(json_care_sector_w, 'recordDate', r_x02.recordData);
    json_care_sector_w := xdok_json_pck.add_json_value(json_care_sector_w, 'costCenterSpeciality', record_id_w);
    json_care_sector_w := xdok_json_pck.add_json_value(json_care_sector_w, 'costCenterFunctionCode', costcenterfunctioncode_w);
    json_care_sector_w := xdok_json_pck.add_json_value(json_care_sector_w, 'costCenterContactDate', r_x02.costCenterContactDate);
    json_care_sector_w := xdok_json_pck.add_json_value(json_care_sector_w, 'costCenterContactTime', r_x02.costCenterContactTime);
    json_care_sector_w := xdok_json_pck.add_json_value(json_care_sector_w, 'physicalPresence', '');
    /* Campos  CcostCenterDeparture** sao obrigatorios apenas para UTI, que nao sera tratado nesse momento 
    xdok_json_pck.add_json_value(json_care_sector_w, 'costCenterDepartureDate', r_x02.costcenterretirementdate); 
    xdok_json_pck.add_json_value(json_care_sector_w, 'costCenterDepartureTime',  r_x02.costcenterretirementtime);  */
    json_care_sector_w := xdok_json_pck.add_json_value(json_care_sector_w, 'costCenterDepartureDate', '');
    json_care_sector_w := xdok_json_pck.add_json_value(json_care_sector_w, 'costCenterDepartureTime', '');
    json_care_sector_w := xdok_json_pck.add_json_value(json_care_sector_w, 'costCenterDepartureType', '');
    json_care_sector_w := xdok_json_pck.add_json_value(json_care_sector_w, 'costCenterBusinessFunction', '');
    json_care_sector_w := xdok_json_pck.add_json_value(json_care_sector_w, 'costCenterNursingFunction', '');
    json_care_sector_w := xdok_json_pck.add_json_value(json_care_sector_w, 'newborn', newborn_w);
    json_care_sector_w := xdok_json_pck.add_json_value(json_care_sector_w, 'ageGroup', r_x02.ageGroup);
    json_care_sector_w := xdok_json_pck.add_json_value(json_care_sector_w, 'recordingNumber', '');
    json_care_sector_list_w.append(json_care_sector_w.to_json_value());
    end;
end loop;

return json_care_sector_list_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION xdok_json_pck.get_departments ( nr_seq_episodio_p bigint) FROM PUBLIC;
