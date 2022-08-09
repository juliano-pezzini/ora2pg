-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_opc_cpoe_gerar_presc_md ( ds_item_p INOUT text, ie_opcao_prescr_p INOUT text, nr_seq_reg_item_p INOUT bigint, ie_opcao_prescr_pp INOUT text ) AS $body$
BEGIN

    ds_item_p := substr(ie_opcao_prescr_pp, 1, position(';' in ie_opcao_prescr_pp) - 1);

    ie_opcao_prescr_p := substr(ds_item_p, 1, position(',' in ds_item_p) - 1);

    nr_seq_reg_item_p := (substr(ds_item_p, position(',' in ds_item_p) + 1, length(ds_item_p)))::numeric;

    ie_opcao_prescr_pp := substr(ie_opcao_prescr_pp, position(';' in ie_opcao_prescr_pp) + 1, length(ie_opcao_prescr_pp));

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_opc_cpoe_gerar_presc_md ( ds_item_p INOUT text, ie_opcao_prescr_p INOUT text, nr_seq_reg_item_p INOUT bigint, ie_opcao_prescr_pp INOUT text ) FROM PUBLIC;
