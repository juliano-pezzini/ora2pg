-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ish_patient_pck.get_addresses_create ( nr_seq_fila_p bigint, ie_tipo_p text) RETURNS SETOF T_ADDRESSES_CREATE AS $body$
DECLARE


nr_seq_documento_w		intpd_fila_transmissao.nr_seq_documento%type;
ie_conversao_w			intpd_eventos_sistema.ie_conversao%type;
nr_seq_sistema_w		intpd_eventos_sistema.nr_seq_sistema%type;
nr_seq_projeto_xml_w		intpd_eventos_sistema.nr_seq_projeto_xml%type;
nr_seq_regra_w			intpd_eventos_sistema.nr_seq_regra_conv%type;
nr_seq_tipo_compl_adic_w	compl_pessoa_fisica.nr_seq_tipo_compl_adic%type;
r_addresses_create_w		r_addresses_create;
nm_pais_w			pais.nm_pais%type;
reg_integracao_w		gerar_int_padrao.reg_integracao_conv;
ds_fone_adic_w			compl_pessoa_fisica.ds_fone_adic%type;
pessoa_fisica_empregador_w  pessoa_fisica_empregador%rowtype;
qt_reg_w    bigint;
nr_sequencia_w  compl_pessoa_fisica.nr_sequencia%type;

c01 CURSOR FOR
SELECT	ie_tipo_complemento,
	nr_sequencia,
	ds_fone_adic,
	nr_ramal,
	ds_fax,
	nr_ddd_fax,
	nr_seq_pais,
	sg_estado,
	cd_cep,
	ds_municipio,
	ds_bairro,
	ds_endereco,
	ds_compl_end nr_endereco,
	ds_complemento,
	ds_email,
	ds_fonetica,
    obter_comunity_code(cd_cep) nr_comunity_code
from	compl_pessoa_fisica
where	cd_pessoa_fisica = nr_seq_documento_w
and	coalesce(ie_tipo_complemento, '0') <> '2'; -- OS 1954141 - H950 - Change of patient address handling in IS-H integration

c01_w	c01%rowtype;


BEGIN
intpd_reg_integracao_inicio(nr_seq_fila_p, 'E', reg_integracao_w);

select	a.nr_seq_documento,
	coalesce(b.ie_conversao,'I'),
	b.nr_seq_sistema,
	b.nr_seq_projeto_xml,
	b.nr_seq_regra_conv
into STRICT	nr_seq_documento_w,
	ie_conversao_w,
	nr_seq_sistema_w,
	nr_seq_projeto_xml_w,
	nr_seq_regra_w
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia = nr_seq_fila_p;

if (ie_tipo_p = 'I') then
	begin
	open c01;
	loop
	fetch c01 into
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		r_addresses_create_w		:=	null;
		reg_integracao_w.nm_tabela 	:=	'COMPL_PESSOA_FISICA';
		reg_integracao_w.nm_elemento	:=	'IAddresses';

		intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQUENCIA','addrno', 'N', c01_w.nr_sequencia, 'N', r_addresses_create_w.addrno);
		intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_PAIS','country', 'N', c01_w.nr_seq_pais, 'S', r_addresses_create_w.country);
		r_addresses_create_w.countryiso	:=	null;

		begin
		select	substr(nm_pais,1,15)
		into STRICT	nm_pais_w
		from	pais
		where	nr_sequencia = c01_w.nr_seq_pais;
		exception
		when others then
			nm_pais_w	:=	null;
		end;

		intpd_processar_atrib_envio(reg_integracao_w, 'NM_PAIS','countrytext', 'N', nm_pais_w, 'N', r_addresses_create_w.countrytext);
		intpd_processar_atrib_envio(reg_integracao_w, 'SG_ESTADO','region', 'N', c01_w.sg_estado, 'S', r_addresses_create_w.region);
		intpd_processar_atrib_envio(reg_integracao_w, 'SG_ESTADO','regiontext', 'N', substr(obter_valor_dominio(50, c01_w.sg_estado), 1, 20), 'N', r_addresses_create_w.regiontext);
		--r_addresses_create_w.regiontext	:=	substr(obter_valor_dominio(50, c01_w.sg_estado), 1, 20);

		intpd_processar_atrib_envio(reg_integracao_w, 'CD_CEP','pcd', 'N', c01_w.cd_cep, 'N', r_addresses_create_w.pcd);
		intpd_processar_atrib_envio(reg_integracao_w, 'DS_MUNICIPIO','city', 'N', c01_w.ds_municipio, 'N', r_addresses_create_w.city);
	--	r_addresses_create_w.stdcity		:=

		intpd_processar_atrib_envio(reg_integracao_w, 'DS_BAIRRO','district', 'N', c01_w.ds_bairro, 'N', r_addresses_create_w.district);
		intpd_processar_atrib_envio(reg_integracao_w, 'DS_BAIRRO','stddistrict', 'N', c01_w.ds_bairro, 'N', r_addresses_create_w.stddistrict);
	--	r_addresses_create_w.strno		:=	substr(c01_w.ds_endereco, 1, 40);

		intpd_processar_atrib_envio(reg_integracao_w, 'DS_FONETICA','stdstreet', 'N', c01_w.ds_fonetica, 'N', r_addresses_create_w.stdstreet);
		intpd_processar_atrib_envio(reg_integracao_w, 'DS_COMPLEMENTO','strsup', 'N', c01_w.ds_complemento, 'N', r_addresses_create_w.strsup);		
		
	--	r_addresses_create_w.stdstrsup	:=

	--	r_addresses_create_w.geograrea	:=		

	--	r_addresses_create_w.geograreatex	:=

	--	r_addresses_create_w.poboxpcd	:= substr(c01_w.cd_cep, 1, 10);

	--	r_addresses_create_w.pobox		:=

	--	r_addresses_create_w.pobcountry	:= substr(c01_w.nr_seq_pais, 1, 3);

	--	r_addresses_create_w.pobcountryiso	:=

	--	r_addresses_create_w.pobcountrytxt	:= nm_pais_w;

	--	r_addresses_create_w.poboxcity	:= substr(c01_w.ds_municipio, 1, 40);

	--	r_addresses_create_w.stdpoboxcity	:=

	--	r_addresses_create_w.companypcd	:=

		intpd_processar_atrib_envio(reg_integracao_w, 'DS_FONE_ADIC','phoneno', 'N', c01_w.ds_fone_adic, 'N', r_addresses_create_w.phoneno);
		intpd_processar_atrib_envio(reg_integracao_w, 'NR_RAMAL','extension', 'N', c01_w.nr_ramal, 'N', r_addresses_create_w.extension);
	--	r_addresses_create_w.otherphones	:=

		intpd_processar_atrib_envio(reg_integracao_w, 'DS_FAX','faxno', 'N', c01_w.ds_fax, 'N', r_addresses_create_w.faxno);
		intpd_processar_atrib_envio(reg_integracao_w, 'NR_DDD_FAX','faxextension', 'N', c01_w.nr_ddd_fax, 'N', r_addresses_create_w.faxextension);
	--	r_addresses_create_w.telexno	:=


		/*
		ds_complemento_w :=	substr(
			replace(c03_w.building,';','.') || ';' ||
			replace(c03_w.floor,';','.') || ';' ||
			replace(c03_w.unit,';','.') || ';' ||
			replace(c03_w.houseno,';','.'),1,40);
		*/


		r_addresses_create_w.building	:=	null;
		r_addresses_create_w.floor	:=	null;
		r_addresses_create_w.unit	:=	null;
	--	r_addresses_create_w.addrstring	:=	substr(c01_w.ds_endereco, 1, 50);

		intpd_processar_atrib_envio(reg_integracao_w, 'DS_EMAIL','email', 'N', c01_w.ds_email, 'N', r_addresses_create_w.email);

		if (c01_w.ie_tipo_complemento = 1) then
			intpd_processar_atrib_envio(reg_integracao_w, 'DS_COMPL_END','houseno', 'N', c01_w.nr_endereco, 'N', r_addresses_create_w.houseno);
			intpd_processar_atrib_envio(reg_integracao_w, 'DS_ENDERECO','streetlong', 'N', c01_w.ds_endereco, 'N', r_addresses_create_w.streetlong);
		else
			intpd_processar_atrib_envio(reg_integracao_w, 'DS_ENDERECO','strno', 'N', c01_w.ds_endereco || ' ' || c01_w.nr_endereco, 'N', r_addresses_create_w.strno);
		end if;

	--	r_addresses_create_w.strsuppl1	:=

	--	r_addresses_create_w.coname	:=

		intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQUENCIA','seqno', 'N', c01_w.nr_sequencia, 'N', r_addresses_create_w.seqno);
       	intpd_processar_atrib_envio(reg_integracao_w, 'NR_COMUNITY_CODE','stdcomunitycode', 'N', c01_w.nr_comunity_code, 'N', r_addresses_create_w.stdcomunitycode);

		RETURN NEXT r_addresses_create_w;
		end;
	end loop;
	close c01;
	
	

	begin
	select  *
	into STRICT    pessoa_fisica_empregador_w
	from    pessoa_fisica_empregador
	where   nr_sequencia = (
			SELECT	max(nr_sequencia)
			from	pessoa_fisica_empregador
			where	cd_pessoa_fisica = nr_seq_documento_w
			and	coalesce(dt_fim_trabalho::text, '') = '');
			
	r_addresses_create_w	:=	null;
	reg_integracao_w.nm_tabela 	:=	'PESSOA_FISICA_EMPREGADOR';
	reg_integracao_w.nm_elemento	:=	'IAddresses';
	intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQUENCIA','addrno', 'N', 99, 'N', r_addresses_create_w.addrno);
	r_addresses_create_w.countryiso	:=	null;
	intpd_processar_atrib_envio(reg_integracao_w, 'DS_PAIS_EMPREG','countrytext', 'N', pessoa_fisica_empregador_w.ds_pais_empreg, 'N', r_addresses_create_w.countrytext);
	intpd_processar_atrib_envio(reg_integracao_w, 'CD_CEP_EMPREG','pcd', 'N', pessoa_fisica_empregador_w.cd_cep_empreg, 'N', r_addresses_create_w.pcd);
	intpd_processar_atrib_envio(reg_integracao_w, 'DS_MUNICIPIO_EMPREG','city', 'N', pessoa_fisica_empregador_w.ds_municipio_empreg, 'N', r_addresses_create_w.city);
	intpd_processar_atrib_envio(reg_integracao_w, 'NR_TELEFONE','phoneno', 'N', pessoa_fisica_empregador_w.nr_telefone, 'N', r_addresses_create_w.phoneno);
	intpd_processar_atrib_envio(reg_integracao_w, 'NR_ENDERECO_EMPREG','houseno', 'N', pessoa_fisica_empregador_w.nr_endereco_empreg, 'N', r_addresses_create_w.houseno);
	intpd_processar_atrib_envio(reg_integracao_w, 'DS_ENDERECO_EMPREG','streetlong', 'N', pessoa_fisica_empregador_w.ds_endereco_empreg, 'N', r_addresses_create_w.streetlong);
	RETURN NEXT r_addresses_create_w;
	exception
	when others then
		pessoa_fisica_empregador_w  := null;
	end;	
	end;

end if;

CALL intpd_gravar_log_fila(reg_integracao_w);
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ish_patient_pck.get_addresses_create ( nr_seq_fila_p bigint, ie_tipo_p text) FROM PUBLIC;