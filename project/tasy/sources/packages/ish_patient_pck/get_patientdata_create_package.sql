-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ish_patient_pck.get_patientdata_create ( nr_seq_fila_p bigint) RETURNS SETOF T_PATIENTDATA_CREATE AS $body$
DECLARE


nr_seq_documento_w		intpd_fila_transmissao.nr_seq_documento%type;
ie_conversao_w			intpd_eventos_sistema.ie_conversao%type;
nr_seq_sistema_w		intpd_eventos_sistema.nr_seq_sistema%type;
nr_seq_projeto_xml_w		intpd_eventos_sistema.nr_seq_projeto_xml%type;
nr_seq_regra_w			intpd_eventos_sistema.nr_seq_regra_conv%type;
ie_tipo_atend_w			atendimento_paciente.ie_tipo_atendimento%type;
ie_tipo_atend_ret_w		atendimento_paciente.ie_tipo_atendimento%type;


cd_pessoa_fisica_w		varchar(10);
r_patientdata_create_w		r_patientdata_create;
reg_integracao_w		gerar_int_padrao.reg_integracao_conv;
nm_localidade_nasc_w		cep_localidade.nm_localidade%type;

nr_seq_idioma_w			bigint;
nm_paroquia_w			varchar(80);
nr_seq_tipo_compl_adic_w	bigint;
dt_inicio_trabalho_w		pessoa_fisica_empregador.dt_inicio_trabalho%type;
ds_profissao_w			profissao.ds_profissao%type;
pessoa_fisica_empregador_w	pessoa_fisica_empregador%rowtype;
employerid_w			varchar(80);
ie_classif_w			varchar(15);
famphys_medic_w			bigint;
famrefphys_medic_w		bigint;
qtd_case_incompleto		bigint;

c01 CURSOR FOR
SELECT	a.cd_pessoa_fisica,
	a.dt_nascimento,
	a.ie_sexo,
	a.ds_apelido,
	a.nr_seq_forma_trat,
	a.ie_estado_civil,
	a.cd_religiao,
	a.cd_nacionalidade,
	a.ie_doador,
	a.dt_obito,
	a.cd_cid_direta,
	a.nr_seq_cor_pele,
	a.cd_rfc,
	a.dt_atualizacao_nrec,
	a.nm_usuario_nrec,
	a.nr_seq_person_name,
	a.nr_seq_nome_solteiro,
	a.nr_cep_cidade_nasc,
	coalesce(a.nr_prontuario, d.nr_prontuario) nr_prontuario,
	b.ds_family_name,
	b.ds_given_name,
	b.ds_component_name_1,
	b.ds_component_name_3,
	c.ds_forma_tratamento
FROM pessoa_fisica a
LEFT OUTER JOIN person_name b ON (a.nr_seq_person_name = b.nr_sequencia)
LEFT OUTER JOIN pf_forma_tratamento c ON (a.nr_seq_forma_trat = c.nr_sequencia)
LEFT OUTER JOIN pessoa_fisica_pront_estab d ON (a.cd_estabelecimento = d.cd_estabelecimento))
, (a
LEFT OUTER JOIN pessoa_fisica_pront_estab d ON ((a.cd_pessoa_fisica = d.cd_pessoa_fisica)
WHERE a.cd_pessoa_fisica = nr_seq_documento_w;

c01_w	c01%rowtype;

c02 CURSOR FOR
SELECT	a.nr_seq_classif
from	pessoa_classif a
where	a.cd_pessoa_fisica = c01_w.cd_pessoa_fisica
and	coalesce(a.dt_final_vigencia::text, '') = ''
and	a.dt_inicio_vigencia < clock_timestamp();

c02_w	c02%rowtype;

c03 CURSOR FOR
SELECT	a.nr_sequencia,
	a.cd_pessoa_fisica,
	a.ie_tipo_complemento,
	a.nr_seq_tipo_compl_adic,
	a.nm_contato,
	a.nr_telefone,
	a.nr_ramal,
	a.ds_fax,
	a.nr_ddd_fax,
	a.nr_seq_pais,
	a.sg_estado,
	a.cd_cep,
	a.ds_municipio,
	a.ds_bairro,
	a.ds_endereco,
	a.ds_compl_end,
	a.ds_complemento,
	a.ds_email,
	a.nm_usuario,
	a.ds_fonetica,
	a.nr_seq_parentesco,
	a.cd_pessoa_fisica_ref
from	compl_pessoa_fisica a
where	a.cd_pessoa_fisica = c01_w.cd_pessoa_fisica
and	coalesce(ie_tipo_complemento, '0') <> '2' -- OS 1954141 - H950 - Change of patient address handling in IS-H integration
order by a.nr_sequencia;

c03_w	c03%rowtype;

c04 CURSOR FOR
SELECT	a.qt_peso,
	a.qt_altura_cm,
	b.cd_medico,
	b.nr_seq_tipo_medico
FROM pessoa_fisica a
LEFT OUTER JOIN pf_medico_externo b ON (a.cd_pessoa_fisica = b.cd_pessoa_fisica)
WHERE a.cd_pessoa_fisica = c01_w.cd_pessoa_fisica and (coalesce(b.dt_fim_vigencia::text, '') = '' or (trunc(b.dt_fim_vigencia) > trunc(clock_timestamp()))) order by b.dt_atualizacao desc;


c04_w	c04%rowtype;


BEGIN
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

intpd_reg_integracao_inicio(nr_seq_fila_p, 'E', reg_integracao_w);
reg_integracao_w.nm_elemento			:= 'PatientData';

open c01;
loop
fetch c01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	reg_integracao_w.nm_tabela	:= 'PERSON_NAME';
	intpd_processar_atrib_envio(reg_integracao_w, 'DS_FAMILY_NAME','lastnamepat', 'N', c01_w.ds_family_name, 'N', r_patientdata_create_w.lastnamepat);
	intpd_processar_atrib_envio(reg_integracao_w, 'DS_GIVEN_NAME','frstnamepat', 'N', c01_w.ds_given_name, 'N', r_patientdata_create_w.frstnamepat);
	intpd_processar_atrib_envio(reg_integracao_w, 'DS_COMPONENT_NAME_1','prefix', 'N', c01_w.ds_component_name_1, 'N', r_patientdata_create_w.prefix);
	intpd_processar_atrib_envio(reg_integracao_w, 'DS_COMPONENT_NAME_3','affix', 'N', c01_w.ds_component_name_3, 'N', r_patientdata_create_w.affix);

	reg_integracao_w.nm_tabela 	:= 'PESSOA_FISICA';
	--r_patientdata_create_w.birthname 	:= 	substr(c01_w.nr_seq_nome_solteiro,1,30);

	intpd_processar_atrib_envio(reg_integracao_w, 'NR_PRONTUARIO','extpatid', 'N', c01_w.nr_prontuario, 'N', r_patientdata_create_w.extpatid);
	intpd_processar_atrib_envio(reg_integracao_w, 'DT_NASCIMENTO','dob', 'N', to_char(c01_w.dt_nascimento,'yyyy-mm-dd'), 'N', r_patientdata_create_w.dob);
	intpd_processar_atrib_envio(reg_integracao_w, 'CD_NACIONALIDADE','nationality', 'N', c01_w.cd_nacionalidade, 'S', r_patientdata_create_w.nationality);

	begin
	select	nm_localidade
	into STRICT	nm_localidade_nasc_w
	from	cep_localidade_v
	where	cd_cep	=	c01_w.nr_cep_cidade_nasc;
	exception
	when others then
		nm_localidade_nasc_w	:=	null;
	end;

	intpd_processar_atrib_envio(reg_integracao_w, 'NR_CEP_CIDADE_NASC', 'birthplace', 'N', nm_localidade_nasc_w, 'N', r_patientdata_create_w.birthplace);
	--r_patientdata_create_w.birthplace	:= 	substr(c01_w.nr_cep_cidade_nasc,1,25);

--	r_patientdata_create_w.birthctryiso		varchar2(2),


	intpd_processar_atrib_envio(reg_integracao_w, 'IE_SEXO','sexext', 'N', c01_w.ie_sexo, 'S', r_patientdata_create_w.sexext);
	intpd_processar_atrib_envio(reg_integracao_w, 'DS_APELIDO','pseudo', 'N', c01_w.ds_apelido, 'N', r_patientdata_create_w.pseudo);
--	r_patientdata_create_w.formaddrsstxt		varchar2(5),

	intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_FORMA_TRAT','title', 'N', c01_w.ds_forma_tratamento, 'N', r_patientdata_create_w.title);
	intpd_processar_atrib_envio(reg_integracao_w, 'IE_ESTADO_CIVIL','marstattext', 'N', c01_w.ie_estado_civil, 'S', r_patientdata_create_w.marstattext);
	--r_patientdata_create_w.marstattext := substr(obter_valor_dominio(5, c01_w.ie_estado_civil),1,6);

	intpd_processar_atrib_envio(reg_integracao_w, 'CD_RELIGIAO','reldenomstxt', 'N', c01_w.cd_religiao, 'S', r_patientdata_create_w.reldenomstxt);

	if (c01_w.ie_doador = 'S') then
		intpd_processar_atrib_envio(reg_integracao_w, 'IE_DOADOR','organdonor', 'N', 'X', 'N', r_patientdata_create_w.organdonor);
	else
		r_patientdata_create_w.organdonor	:= null;
		--intpd_processar_atrib_envio(reg_integracao_w, 'IE_DOADOR','organdonor', 'N', null, 'N', r_patientdata_create_w.organdonor);

	end if;

	begin
	select	nr_seq_idioma
	into STRICT	nr_seq_idioma_w
	from	pessoa_fisica_idioma
	where	cd_pessoa_fisica = c01_w.cd_pessoa_fisica
	and	ie_fluencia = 'A'  LIMIT 1;
	exception
	when others then
		r_patientdata_create_w.patlangu	:=	null;
	end;
	reg_integracao_w.nm_tabela 	:= 'PESSOA_FISICA_IDIOMA';
	intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_IDIOMA','patlangu', 'N', nr_seq_idioma_w, 'S', r_patientdata_create_w.patlangu);

--	r_patientdata_create_w.patlanguiso		:=	c01_w.cd_pessoa_fisica;





	open c02;
	loop
	fetch c02 into
		c02_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		reg_integracao_w.nm_tabela 	:= 'PESSOA_CLASSIF';

		ie_classif_w	:=	substr(intpd_conv('CLASSIF_PESSOA', 'NR_SEQUENCIA', c02_w.nr_seq_classif, nr_seq_regra_w, ie_conversao_w, 'E'), 1, 15);

		if (ie_classif_w = 'VIP') then
			intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_CLASSIF', 'vip', 'N', 'X', 'N', r_patientdata_create_w.vip);
		elsif (ie_classif_w = 'PUBLISTBLOCK') then
			intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_CLASSIF', 'publistblock', 'N', 'X', 'N', r_patientdata_create_w.publistblock);
		elsif (ie_classif_w = 'RELIGLIST') then
			intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_CLASSIF', 'religlist', 'N', 'X', 'N', r_patientdata_create_w.religlist);
		end if;
		end;
	end loop;
	close c02;

	reg_integracao_w.nm_tabela 	:= 'PESSOA_FISICA';
	r_patientdata_create_w.expired	:= '';
	intpd_processar_atrib_envio(reg_integracao_w, 'DT_OBITO','dtodeathfrom', 'N', to_char(c01_w.dt_obito,'yyyy-mm-dd'), 'N', r_patientdata_create_w.dtodeathfrom);
	intpd_processar_atrib_envio(reg_integracao_w, 'DT_OBITO','tmodeathfrom', 'N', to_char(c01_w.dt_obito,'hh24:mi:ss'), 'N', r_patientdata_create_w.tmodeathfrom);
	intpd_processar_atrib_envio(reg_integracao_w, 'DT_OBITO','dtodeathto', 'N', to_char(c01_w.dt_obito,'yyyy-mm-dd'), 'N', r_patientdata_create_w.dtodeathto);
	intpd_processar_atrib_envio(reg_integracao_w, 'DT_OBITO','tmodeathto', 'N', to_char(c01_w.dt_obito,'hh24:mi:ss'), 'N', r_patientdata_create_w.tmodeathto);
	intpd_processar_atrib_envio(reg_integracao_w, 'CD_CID_DIRETA','cofdeath', 'N', c01_w.cd_cid_direta, 'S', r_patientdata_create_w.cofdeath);

	begin
	select	ie_tipo_atendimento
	into STRICT	ie_tipo_atend_w
	from	atendimento_paciente
	where	cd_pessoa_fisica = c01_w.cd_pessoa_fisica
	and	(ie_tipo_atendimento IS NOT NULL AND ie_tipo_atendimento::text <> '')  LIMIT 1;
	exception
	when others then
		ie_tipo_atend_w := null;
	end;

	reg_integracao_w.nm_tabela 	:= 'ATENDIMENTO_PACIENTE';
	intpd_processar_atrib_envio(reg_integracao_w, 'IE_TIPO_ATENDIMENTO','emergadm', 'N', ie_tipo_atend_w, 'N', ie_tipo_atend_ret_w);

	if (ie_tipo_atend_w = 3) then
		intpd_processar_atrib_envio(reg_integracao_w, 'IE_TIPO_ATENDIMENTO','emergadm', 'N', 'X', 'N', r_patientdata_create_w.emergadm);
	else
		intpd_processar_atrib_envio(reg_integracao_w, 'IE_TIPO_ATENDIMENTO','emergadm', 'N', null, 'N', r_patientdata_create_w.emergadm);
	end if;

	begin
		select	count(*)
		into STRICT	qtd_case_incompleto
		from	atendimento_paciente
		where	atendimento_paciente.cd_pessoa_fisica = c01_w.cd_pessoa_fisica
		and		atendimento_paciente.ie_inform_incompletas = 'S';
	exception when no_data_found then
		qtd_case_incompleto := 0;
	end;

	if (qtd_case_incompleto > 0) then
		r_patientdata_create_w.quickadm := 'X';
	else
		r_patientdata_create_w.quickadm := '';
	end if;

--	r_patientdata_create_w.nonresident		varchar2(1),

--	r_patientdata_create_w.inactive		varchar2(1),


	begin
	select	substr(nm_paroquia,1,80)
	into STRICT	nm_paroquia_w
	from	pessoa_fisica_paroquia
	where	cd_pessoa_fisica = c01_w.cd_pessoa_fisica
	and (nm_paroquia IS NOT NULL AND nm_paroquia::text <> '')  LIMIT 1;
	exception
	when others then
		r_patientdata_create_w.parish := null;
	end;
	reg_integracao_w.nm_tabela 	:= 'PESSOA_FISICA_PAROQUIA';
	intpd_processar_atrib_envio(reg_integracao_w, 'NM_PAROQUIA','parish', 'N', nm_paroquia_w, 'N', r_patientdata_create_w.parish);
	reg_integracao_w.nm_tabela 	:= 'PESSOA_FISICA';
	intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_COR_PELE','race', 'N', c01_w.nr_seq_cor_pele, 'S', r_patientdata_create_w.race);
	intpd_processar_atrib_envio(reg_integracao_w, 'CD_RFC','ssn', 'N', c01_w.cd_rfc, 'N', r_patientdata_create_w.ssn);
--	r_patientdata_create_w.doctype		varchar2(2),

--	r_patientdata_create_w.docno		varchar2(15),


	reg_integracao_w.nm_tabela 	:= 'PESSOA_FISICA_EMPREGADOR';
	
	begin
	select  *
	into STRICT    pessoa_fisica_empregador_w
	from    pessoa_fisica_empregador
	where   nr_sequencia = (
			SELECT	max(nr_sequencia)
			from	pessoa_fisica_empregador
			where	cd_pessoa_fisica = c01_w.cd_pessoa_fisica
			and	coalesce(dt_fim_trabalho::text, '') = '');	
	exception
	when others then
		pessoa_fisica_empregador_w	:=	null;
	end;

	if (length(pessoa_fisica_empregador_w.ds_empresa_texto) > 0) then
		intpd_processar_atrib_envio(reg_integracao_w, 'CD_CGC', 'empname', 'N', substr(obter_nome_pf_pj(null, pessoa_fisica_empregador_w.cd_cgc),1,30), 'N', r_patientdata_create_w.empname);		
	elsif (length(pessoa_fisica_empregador_w.cd_cgc) > 0) then
		intpd_processar_atrib_envio(reg_integracao_w, 'CD_CGC','employerid', 'N', pessoa_fisica_empregador_w.cd_cgc, 'N', employerid_w);
		r_patientdata_create_w.employerid	:=	lpad(somente_numero(employerid_w),10, 0);
		intpd_processar_atrib_envio(reg_integracao_w, 'CD_CGC', 'empname', 'N', substr(obter_nome_pf_pj(null, pessoa_fisica_empregador_w.cd_cgc),1,30), 'N', r_patientdata_create_w.empname);
	end if;
	
	intpd_processar_atrib_envio(reg_integracao_w, 'DT_INICIO_TRABALHO','employedsince', 'N', pessoa_fisica_empregador_w.dt_inicio_trabalho, 'N', dt_inicio_trabalho_w);
	r_patientdata_create_w.employedsince	:= to_char(dt_inicio_trabalho_w,'yyyy-mm-dd');
	
	if (pessoa_fisica_empregador_w.cd_profissao IS NOT NULL AND pessoa_fisica_empregador_w.cd_profissao::text <> '') then
		begin
		select	substr(ds_profissao,1, 25)
		into STRICT	ds_profissao_w
		from	profissao
		where	cd_profissao = pessoa_fisica_empregador_w.cd_profissao;
		
		intpd_processar_atrib_envio(reg_integracao_w, 'DS_PROFISSAO','occupation', 'N', ds_profissao_w, 'N', r_patientdata_create_w.occupation);
		exception
		when others then
			r_patientdata_create_w.occupation	:=	null;
		end;
	else
		intpd_processar_atrib_envio(reg_integracao_w, 'DS_PROFISSAO','occupation', 'N', pessoa_fisica_empregador_w.ds_profissao, 'N', r_patientdata_create_w.occupation);
	end if;	
	
	open c03;
	loop
	fetch c03 into
		c03_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		begin
		reg_integracao_w.nm_tabela 	:= 'COMPL_PESSOA_FISICA';
		/*residencial*/


		if (c03_w.ie_tipo_complemento = '1') then
			begin
			intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQUENCIA','pataddrno', 'N', c03_w.nr_sequencia, 'N', r_patientdata_create_w.pataddrno);
			end;
		elsif (coalesce(somente_numero(r_patientdata_create_w.contactp1addrno),0) = 0) then
			begin

			intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQUENCIA','contactp1addrno', 'N', c03_w.nr_sequencia, 'N', r_patientdata_create_w.contactp1addrno);

			if (position(' ' in c03_w.nm_contato) > 0)	then
				intpd_processar_atrib_envio(reg_integracao_w, 'NM_CONTATO','contactp1fname', 'N', substr(substr(c03_w.nm_contato,1,position(' ' in c03_w.nm_contato)-1),1,30), 'N', r_patientdata_create_w.contactp1fname);
				intpd_processar_atrib_envio(reg_integracao_w, 'NM_CONTATO','contactp1lname', 'N', substr(substr(c03_w.nm_contato,position(' ' in c03_w.nm_contato)+1,255),1,30), 'N', r_patientdata_create_w.contactp1lname);
			else
				intpd_processar_atrib_envio(reg_integracao_w, 'NM_CONTATO','contactp1fname', 'N', c03_w.nm_contato, 'N', r_patientdata_create_w.contactp1fname);
			end if;

			if (c03_w.ie_tipo_complemento = 9) then
				intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_TIPO_COMPL_ADIC','contactp1relsh', 'N', c03_w.nr_seq_tipo_compl_adic, 'S', r_patientdata_create_w.contactp1relsh);
			else
				intpd_processar_atrib_envio(reg_integracao_w, 'IE_TIPO_COMPLEMENTO','contactp1relsh', 'N', c03_w.ie_tipo_complemento, 'S', r_patientdata_create_w.contactp1relsh);
			end if;

			intpd_processar_atrib_envio(reg_integracao_w, 'CD_PESSOA_FISICA_REF','contactp1extid', 'N', c03_w.cd_pessoa_fisica_ref, 'ISH', r_patientdata_create_w.contactp1extid);
			end;
		elsif (coalesce(somente_numero(r_patientdata_create_w.contactp2addrno),0) = 0) then
			begin
			intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQUENCIA','contactp2addrno', 'N', c03_w.nr_sequencia, 'N', r_patientdata_create_w.contactp2addrno);

			if (position(' ' in c03_w.nm_contato) > 0)	then
				intpd_processar_atrib_envio(reg_integracao_w, 'NM_CONTATO','contactp2fname', 'N', substr(substr(c03_w.nm_contato,1,position(' ' in c03_w.nm_contato)-1),1,30), 'N', r_patientdata_create_w.contactp2fname);
				intpd_processar_atrib_envio(reg_integracao_w, 'NM_CONTATO','contactp2lname', 'N', substr(substr(c03_w.nm_contato,position(' ' in c03_w.nm_contato)+1,255),1,30), 'N', r_patientdata_create_w.contactp2lname);
			else
				intpd_processar_atrib_envio(reg_integracao_w, 'NM_CONTATO','contactp2fname', 'N', c03_w.nm_contato, 'N', r_patientdata_create_w.contactp2fname);
			end if;

			if (c03_w.ie_tipo_complemento = 9) then
				intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_TIPO_COMPL_ADIC','contactp2relsh', 'N', c03_w.nr_seq_tipo_compl_adic, 'S', r_patientdata_create_w.contactp2relsh);
			else
				intpd_processar_atrib_envio(reg_integracao_w, 'IE_TIPO_COMPLEMENTO','contactp2relsh', 'N', c03_w.ie_tipo_complemento, 'S', r_patientdata_create_w.contactp2relsh);
			end if;

			intpd_processar_atrib_envio(reg_integracao_w, 'CD_PESSOA_FISICA_REF','contactp2extid', 'N', c03_w.cd_pessoa_fisica_ref, 'ISH', r_patientdata_create_w.contactp2extid);
			end;
		end if;
		end;
	end loop;
	close c03;

	begin
	select  99
	into STRICT    r_patientdata_create_w.empaddrno
	from    pessoa_fisica_empregador
	where   cd_pessoa_fisica = c01_w.cd_pessoa_fisica  LIMIT 1;	
	exception
	when others then
		r_patientdata_create_w.empaddrno	:=	null;
	end;
	
	open c04;
	loop
	fetch c04 into
		c04_w;
	EXIT WHEN NOT FOUND; /* apply on c04 */
		begin
		reg_integracao_w.nm_tabela	:= 'PF_MEDICO_EXTERNO';

		famphys_medic_w := somente_numero(intpd_conv('TIPO_MEDICO_EXTERNO', 'NR_SEQUENCIA', 'FAMPHYS', nr_seq_regra_w, ie_conversao_w, 'I'));
		famrefphys_medic_w := somente_numero(intpd_conv('TIPO_MEDICO_EXTERNO', 'NR_SEQUENCIA', 'FAMREFPHYS', nr_seq_regra_w, ie_conversao_w, 'I'));

		if (c04_w.nr_seq_tipo_medico = famphys_medic_w) or (c04_w.nr_seq_tipo_medico = famrefphys_medic_w) then
			intpd_processar_atrib_envio(reg_integracao_w, 'CD_MEDICO', 'famphys', 'N', c04_w.cd_medico, 'ISHMED', r_patientdata_create_w.famphys);
			exit;
		end if;
		end;
	end loop;
	close c04;
	
	intpd_processar_atributo(reg_integracao_w,'NM_USUARIO_NREC', wheb_usuario_pck.get_nm_usuario, 'N', current_setting('ish_patient_pck.usernameish')::varchar(15));
--	r_patientdata_create_w.refphys		:=	null;


--	r_patientdata_create_w.refphys2		:= substr(cd_medico_refer_w,1,20);

--	r_patientdata_create_w.user1			varchar2(20),

--	r_patientdata_create_w.user2			varchar2(20),

--	r_patientdata_create_w.user3			varchar2(10),

--	r_patientdata_create_w.user4			varchar2(10),

--	r_patientdata_create_w.user5			varchar2(50),

--	r_patientdata_create_w.user6			varchar2(1),

	r_patientdata_create_w.creationdate		:=	to_char(c01_w.dt_atualizacao_nrec,'yyyy-mm-dd');
	r_patientdata_create_w.creationuser		:=	current_setting('ish_patient_pck.usernameish')::varchar(15);
--	r_patientdata_create_w.istatbirthpl		varchar2(6),

--	r_patientdata_create_w.taxnumber		varchar2(20),

--	r_patientdata_create_w.taxnumberindic		varchar2(1),

--	r_patientdata_create_w.stpcode		varchar2(16),

--	r_patientdata_create_w.stpcodeexpiry		varchar2(10),

--	r_patientdata_create_w.consentpersdata	varchar2(1),

--	r_patientdata_create_w.birthrank		varchar2(1),

--	r_patientdata_create_w.flagextorderer		varchar2(1),

--	r_patientdata_create_w.dthloc		varchar2(2),

--	r_patientdata_create_w.postdisphys		varchar2(10),

--	r_patientdata_create_w.postdisphysoutp		varchar2(10),

--	r_patientdata_create_w.lastnamepatlong	varchar2(70),

--	r_patientdata_create_w.frstnamepatlong		varchar2(70),

--	r_patientdata_create_w.birthnamelong		varchar2(70),

--	r_patientdata_create_w.titleaca2		varchar2(4),

--	r_patientdata_create_w.sexspecialization	varchar2(1),


	RETURN NEXT r_patientdata_create_w;
	end;
end loop;
close c01;
CALL intpd_gravar_log_fila(reg_integracao_w);
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ish_patient_pck.get_patientdata_create ( nr_seq_fila_p bigint) FROM PUBLIC;