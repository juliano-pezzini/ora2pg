-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_crm_e_uf_formatados (CD_MEDICO_P medico.cd_pessoa_fisica%type) RETURNS MEDICO.NM_GUERRA%TYPE AS $body$
DECLARE


campos_formatados_w		medico.nm_guerra%TYPE;
separacao_campos_w constant medico.uf_crm%TYPE := ' CRM/';
nr_crm_w medico.nr_crm%TYPE;
uf_crm_w medico.uf_crm%TYPE;


BEGIN
    SELECT
        max(m.nr_crm),
        max(m.uf_crm)
    INTO STRICT
        nr_crm_w,
        uf_crm_w
    FROM medico m
    WHERE m.cd_pessoa_fisica = cd_medico_p;

    IF coalesce(nr_crm_w::text, '') = '' THEN
        campos_formatados_w := nr_crm_w;
    ELSE
        campos_formatados_w := nr_crm_w || separacao_campos_w || uf_crm_w;
    END IF;

    RETURN campos_formatados_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_crm_e_uf_formatados (CD_MEDICO_P medico.cd_pessoa_fisica%type) FROM PUBLIC;

