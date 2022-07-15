-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_hora_acm_sn_pr_md ( nr_intervalo_p INOUT bigint, ds_prescricao_p text, ds_horarios_p INOUT text, ds_horarios2_p INOUT text, ds_horarios3_p INOUT text, ds_caracter_espaco_p text, ds_erro_p INOUT text ) AS $body$
BEGIN
    --INICIO MD 6
    --OBTER_HORARIOS_ACM_SN_PRESCR_MD
    if (nr_intervalo_p = 1) and (ds_prescricao_p in ('ACM', 'SN')) then
        begin
        ds_horarios_p := substr(ds_prescricao_p,1,254);
        ds_horarios2_p := substr(ds_prescricao_p,255,255);
        end;
    else
        begin
            ds_horarios_p := substr(ds_horarios3_p,1,254);
            ds_horarios2_p := substr(ds_horarios3_p,255,255);
        end;
    end if;
    ds_horarios_p  := replace(ds_horarios_p,' ',ds_caracter_espaco_p);
    ds_horarios2_p := replace(ds_horarios2_p,' ',ds_caracter_espaco_p);
    if (nr_intervalo_p < 0) then
        nr_intervalo_p	:= 0;
    end if;

    if (nr_intervalo_p = 0) or (coalesce(nr_intervalo_p::text, '') = '') then
        nr_intervalo_p := 1;
    end if;
exception when others then
    ds_erro_p := sqlerrm;
end;
--FIM MD 6
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_hora_acm_sn_pr_md ( nr_intervalo_p INOUT bigint, ds_prescricao_p text, ds_horarios_p INOUT text, ds_horarios2_p INOUT text, ds_horarios3_p INOUT text, ds_caracter_espaco_p text, ds_erro_p INOUT text ) FROM PUBLIC;

