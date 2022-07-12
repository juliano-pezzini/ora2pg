-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE dpc_pkg.imp_malignant_tumor ( cd_icd_p text, ds_description_p text, nm_usuario_p text ) AS $body$
BEGIN

insert into ICD_MALIGNANT_TUMOR_JPN(
	NR_SEQUENCIA,                  
	DT_ATUALIZACAO,                 
	NM_USUARIO,          
    CD_ICD,
    DS_DESCRIPTION,
	IE_SITUACAO)
	values (
    nextval('icd_malignant_tumor_jpn_seq'),
	clock_timestamp(),                  
	nm_usuario_p, 
	cd_icd_p,
	ds_description_p,
	'A');
end;



$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dpc_pkg.imp_malignant_tumor ( cd_icd_p text, ds_description_p text, nm_usuario_p text ) FROM PUBLIC;
