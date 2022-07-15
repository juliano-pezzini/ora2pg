-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_proc_orig_befpost_eup_js ( nr_atendimento_p bigint, dt_emissao_p timestamp, nr_aih_p bigint, cd_proc_original_p INOUT text, ds_proc_original_p INOUT text) AS $body$
DECLARE

cd_proc_original_w	varchar(240);
ds_proc_original_w	PROCEDIMENTO.DS_PROCEDIMENTO%type;
					

BEGIN 
 
cd_proc_original_w := substr(sus_obter_proc_orig_laudo(nr_aih_p,nr_aih_p,nr_atendimento_p,dt_emissao_p,1),1,240);
ds_proc_original_w := substr(sus_obter_proc_orig_laudo(nr_aih_p,nr_aih_p,nr_atendimento_p,dt_emissao_p,2),1,255);
 
cd_proc_original_p := cd_proc_original_w;
ds_proc_original_p := ds_proc_original_w;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_proc_orig_befpost_eup_js ( nr_atendimento_p bigint, dt_emissao_p timestamp, nr_aih_p bigint, cd_proc_original_p INOUT text, ds_proc_original_p INOUT text) FROM PUBLIC;

