-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW w_benef_validation_v (nr_sequencia, cd_webid, cd_benef_id, cd_diagnostico, cd_service, cd_professional_provider, cd_provider, cd_emergency, cd_specialty, cd_refer, cd_contract, cd_identification, cd_member, cd_family_id, ie_send_type) AS select  NR_SEQUENCIA,
        CD_WEBID,
        CD_BENEF_ID,
        CD_DIAGNOSTICO,
        CD_SERVICE,
        CD_PROFESSIONAL_PROVIDER,
        CD_PROVIDER,
        CD_EMERGENCY,
        CD_SPECIALTY,
        CD_REFER,
        CD_CONTRACT,
        CD_IDENTIFICATION,
        CD_MEMBER,
        CD_FAMILY_ID,
        IE_SEND_TYPE
FROM  W_AUT_SERV_TRANSACTION;

