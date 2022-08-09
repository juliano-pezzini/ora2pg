-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cips_gravar_sit_espec_profic ( ie_tipo_conselho_p text, /*conselhoProfissional - tipo*/
 nr_conselho_p text, /*conselhoProfissional - numero*/
 uf_conselho_p text, /*conselhoProfissional - uf*/
 cd_corportativo_p text, /*codCorportativoUnidade*/
 cd_especialidade_corp_p text, /*codCorportativoEspecialidade*/
 ie_status_profic_unid_espec_p text) AS $body$
 /*statusProfissionalUnidadeEspecialidade*/
DECLARE

										 
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
nr_seq_conselho_w		CONSELHO_PROFISSIONAL.nr_sequencia%type;
cd_medico_w				pessoa_fisica.cd_pessoa_fisica%type;

cd_especialidade_w		ESPECIALIDADE_MEDICA.cd_especialidade%type;
ie_exists_w				varchar(1);


BEGIN 
 
select	max(a.cd_estabelecimento) 
into STRICT	cd_estabelecimento_w 
from	med_integracao a 
where	a.cd_externo = cd_corportativo_p 
and		a.ie_cips_ativo = 'S';
 
 
if (cd_estabelecimento_w IS NOT NULL AND cd_estabelecimento_w::text <> '') then 
 
	select	max(a.nr_sequencia) 
	into STRICT	nr_seq_conselho_w 
	from	CONSELHO_PROFISSIONAL a 
	where	SG_CONSELHO = IE_TIPO_CONSELHO_P 
	and		a.ie_situacao = 'A';
 
	select	max(a.cd_pessoa_fisica) 
	into STRICT	cd_medico_w 
	from	medico a, 
			pessoa_fisica b 
	where	a.cd_pessoa_fisica = b.cd_pessoa_fisica 
	and		b.cd_estabelecimento = cd_estabelecimento_w 
	and		b.nr_seq_conselho = nr_seq_conselho_w 
	and		a.nr_crm = nr_conselho_p 
	and		a.uf_crm = uf_conselho_p 
	and		a.ie_integrado = 'S';
	 
	select	max(a.cd_especialidade) 
	into STRICT	cd_especialidade_w 
	from	ESPECIALIDADE_MEDICA a 
	where	a.CD_ESPECIALIDADE_EXTERNO = cd_especialidade_corp_p;
	 
	select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END  
	into STRICT	ie_exists_w 
	from	MEDICO_ESPECIALIDADE a 
	where	a.cd_pessoa_fisica = cd_medico_w 
	and		a.cd_especialidade = cd_especialidade_w;
	 
	if (ie_exists_w = 'S') then 
 
		update	MEDICO_ESPECIALIDADE 
		set		IE_ATIVO_CIPS = CASE WHEN ie_status_profic_unid_espec_p=1 THEN 'S'  ELSE 'N' END  
		where	cd_pessoa_fisica = cd_medico_w 
		and		cd_especialidade = cd_especialidade_w;
	 
	else 
 
	 
		insert into MEDICO_ESPECIALIDADE(	CD_PESSOA_FISICA, 
											CD_ESPECIALIDADE, 
											DT_ATUALIZACAO, 
											NM_USUARIO, 
											NR_SEQ_PRIORIDADE, 
											IE_ATIVO_CIPS) 
							values (	cd_medico_w, 
											cd_especialidade_w, 
											clock_timestamp(), 
											'Integracao CIPS', 
											1, 
											CASE WHEN ie_status_profic_unid_espec_p=1 THEN 'S'  ELSE 'N' END );
		 
	end if;
	 
 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cips_gravar_sit_espec_profic ( ie_tipo_conselho_p text,  nr_conselho_p text,  uf_conselho_p text,  cd_corportativo_p text,  cd_especialidade_corp_p text,  ie_status_profic_unid_espec_p text) FROM PUBLIC;
