-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION via_obter_cd_pf_aprovador ( nr_seq_viagem_p bigint, ie_opcao_p text ) RETURNS varchar AS $body$
DECLARE


	cd_pessoa_aprov_w 			pessoa_fisica.cd_pessoa_fisica%type;
	cd_aprov_sub_w 				pessoa_fisica.cd_pessoa_fisica%type;
	cd_pessoa_aprov_rel_desp_w 		pessoa_fisica.cd_pessoa_fisica%type;
	cd_pessoa_aprov_rel_desp_sub_w 		pessoa_fisica.cd_pessoa_fisica%type;

	cd_retorno_w 				pessoa_fisica.cd_pessoa_fisica%type;


BEGIN

	SELECT 	max(cd_pessoa_aprov),
		max(cd_aprov_sub),
		max(cd_pessoa_aprov_rel_desp),
		max(cd_pessoa_aprov_rel_desp_sub)
	INTO STRICT 	cd_pessoa_aprov_w,
		cd_aprov_sub_w,
		cd_pessoa_aprov_rel_desp_w,
		cd_pessoa_aprov_rel_desp_sub_w
	FROM 	fin_gv_pend_aprov
	WHERE 	nr_seq_viagem = nr_seq_viagem_p;
	
	if (ie_opcao_p = 'APV') then
		cd_retorno_w := cd_pessoa_aprov_w;
	elsif (ie_opcao_p = 'ASV') then
		cd_retorno_w := cd_aprov_sub_w;
	elsif (ie_opcao_p = 'APR') then
		cd_retorno_w := cd_pessoa_aprov_rel_desp_w;
	elsif (ie_opcao_p = 'ASR') then
		cd_retorno_w := cd_pessoa_aprov_rel_desp_sub_w;
	end if;
	
	return cd_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION via_obter_cd_pf_aprovador ( nr_seq_viagem_p bigint, ie_opcao_p text ) FROM PUBLIC;
