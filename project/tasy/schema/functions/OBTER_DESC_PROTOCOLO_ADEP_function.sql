-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_protocolo_adep (nr_prescricao_p text) RETURNS varchar AS $body$
DECLARE


ds_protocolo_adep_w varchar(255);


BEGIN
    if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then

        select  max(substr(obter_desc_protocolo(CD_PROTOCOLO) || '/' || obter_desc_protocolo_medic(NR_SEQ_MEDICACAO,CD_PROTOCOLO),1,255))
        into STRICT     ds_protocolo_adep_w
        from    paciente_setor a,
                   paciente_atendimento b
        where   a.nr_seq_paciente = b.nr_seq_paciente
        and     b.nr_prescricao   = nr_prescricao_p;

    end if;

    return ds_protocolo_adep_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_protocolo_adep (nr_prescricao_p text) FROM PUBLIC;

