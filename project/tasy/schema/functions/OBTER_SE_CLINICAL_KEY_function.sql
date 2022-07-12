-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_clinical_key (nr_atendimento_p bigint, cd_doenca_p text default ' ') RETURNS varchar AS $body$
DECLARE

 
ds_url_w       varchar(4000);
cd_pessoa_fisica_w 	 varchar(10) := '';
cid_doenca_w		 varchar(10) := '';
ie_lib_diag_medico_w varchar(1);
ds_desc_cid_w		 varchar(255) := '';


BEGIN 
ds_url_w := obter_link_acesso_externo(obter_estabelecimento_ativo, 'CK');
if (ds_url_w <> ' ') then 
	if (nr_atendimento_p > 0) then			 
		cd_pessoa_fisica_w := obter_pessoa_atendimento(nr_atendimento_p,'C');
		 
		if (cd_doenca_p = ' ') then 
			select	coalesce(max(ie_lib_diag_medico),'N') 
			into STRICT	ie_lib_diag_medico_w 
			from 	parametro_medico 
			where 	cd_estabelecimento = obter_estabelecimento_ativo;
			 
			select 	coalesce(max(cd_doenca),'') 
			into STRICT	cid_doenca_w 
			from 	diagnostico_doenca a 
			where 	nr_atendimento = nr_atendimento_p 
			and 	((ie_lib_diag_medico_w = 'S' 
			and 	dt_liberacao = (SELECT max(dt_liberacao) from diagnostico_doenca b where a.nr_atendimento = b.nr_atendimento and coalesce(dt_inativacao::text, '') = '')) 
			or 		(ie_lib_diag_medico_w = 'N' 
			and 	dt_diagnostico = (select max(dt_diagnostico) from diagnostico_doenca b where a.nr_atendimento = b.nr_atendimento and coalesce(dt_inativacao::text, '') = ''))) 
			order by dt_liberacao desc;
		else 
			cid_doenca_w := cd_doenca_p;
		end if;
		 
		ds_desc_cid_w := trim(both REGEXP_REPLACE(substr(obter_desc_cid(cid_doenca_w),1,200),'( ){2,}',' '));
		ds_desc_cid_w := replace(ds_desc_cid_w, ' ','+');
		ds_desc_cid_w := trim(both replace(ds_desc_cid_w, cid_doenca_w, ''));
			 
	end if;
 
	ds_url_w := replace(ds_url_w,'@TIPO_IDADE','a');
	ds_url_w := replace(ds_url_w,'@IDADE',Obter_Idade_PF(cd_pessoa_fisica_w,clock_timestamp(),'A'));
	ds_url_w := replace(ds_url_w,'@ID_USUARIO','25813');
	ds_url_w := replace(ds_url_w,'@CID_DEFINITIVO', ds_desc_cid_w);
	ds_url_w := replace(ds_url_w,'@CID',cid_doenca_w);
	ds_url_w := replace(ds_url_w,'@SEXO',obter_sexo_pf(cd_pessoa_fisica_w,'C'));
			 
	return replace(ds_url_w,' ','');
end if;
 
return 'N';
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_clinical_key (nr_atendimento_p bigint, cd_doenca_p text default ' ') FROM PUBLIC;

