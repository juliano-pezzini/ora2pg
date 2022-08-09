-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_nom_rc_paciente (nr_seq_cabecalho_p bigint, nm_usuario_p text) AS $body$
DECLARE

								

nr_atendimento_w			atendimento_paciente.nr_atendimento%type;
nr_seq_episodio_w			episodio_paciente.nr_sequencia%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;

ds_oid_primario_w		varchar(60);	-- id_14						
nr_ident_primario_w 	varchar(30);	-- id_15
nm_ident_primario_w		varchar(100);	-- id_16
cd_curp_w				varchar(30);	-- id_17
ds_oid_adicional_w  	varchar(60); 	-- id_18
nr_ident_adicional_w	varchar(30);	-- id_19
nm_ident_adicional_w	varchar(100);	-- id_20
cd_nacionalidade_w		varchar(30);	-- id_21
qt_idade_w				smallint;		-- id_22
ds_domicilio_w			varchar(2000);	-- id_23
cd_tipo_vialidade_w		varchar(10);	-- id_24		
nm_vialidade_w			varchar(255); 	-- id_25
nr_domicilio_ext_w		varchar(255);	-- id_26
nr_domicilio_ext_alfa_w	varchar(255);	-- id_27
nr_domicilio_int_w		varchar(255);	-- id_28
nr_domicilio_int_alfa_w	varchar(30);	-- id_29
cd_tipo_assentamento_w	varchar(10);	-- id_30
nm_assentamento_w		varchar(255);	-- id_31
cd_localidade_w			varchar(10);	-- id_32
cd_municipio_w			varchar(10);	-- id_33
cd_entidade_fed_w		varchar(10);	-- id_34
cd_postal_w				varchar(10);	-- id_35
cd_pais_w				varchar(10);	-- id_36
nr_telefone_w			varchar(30);	-- id_37
ds_email_w				varchar(255);	-- id_38
nm_primeiro_nome_w		varchar(255);	-- id_39	
nm_sobrenome_1_pai_w	varchar(255);	-- id_40	
nm_sobrenome_2_mae_w	varchar(255);	-- id_41
ie_sexo_w				varchar(3);	-- id_42
ds_sexo_w				varchar(255);	-- id_43
dt_nascimento_w			timestamp;			-- id_44
ie_estado_civil_w		varchar(3);	-- id_45
ds_estado_civil_w		varchar(255);	-- id_46
cd_religiao_w			varchar(10);	-- id_47
ds_religiao_w			varchar(255);  -- id_48
cd_lingua_indigena_w	varchar(10);	-- id_49
ds_lingua_indigena_w	varchar(255);	-- id_50
cd_entidade_nasc_w		varchar(10);	-- id_51
nr_seq_pessoa_endereco_w	pessoa_endereco.nr_sequencia%type;
nr_seq_catalogo_w		end_catalogo.nr_sequencia%type;


BEGIN

delete FROM nom_rc_pessoa_fisica where nr_seq_cabecalho = nr_seq_cabecalho_p and ie_tipo = 'PAC';

select	a.nr_atendimento,
		a.nr_seq_episodio,
		a.cd_estabelecimento
into STRICT	nr_atendimento_w,
		nr_seq_episodio_w,
		cd_estabelecimento_w
from	nom_rc_cabecalho a
where	a.nr_sequencia	= nr_seq_cabecalho_p;

if	((coalesce(nr_atendimento_w::text, '') = '') and (nr_seq_episodio_w IS NOT NULL AND nr_seq_episodio_w::text <> '')) then
	select	min(nr_atendimento)
	into STRICT	nr_atendimento_w
	from	atendimento_paciente a
	where	a.nr_seq_episodio = nr_seq_episodio_w;
end if;

if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then


	ds_oid_primario_w 		:= get_oid_details(3,'OID_NUMBER','NOM',cd_estabelecimento_w);
	nm_ident_primario_w 	:= get_oid_details(3,'OID_SHORTNAME','NOM',cd_estabelecimento_w);
	ds_oid_adicional_w		:= get_oid_details(4,'OID_NUMBER','NOM',cd_estabelecimento_w);
	nm_ident_adicional_w 	:= get_oid_details(4,'OID_SHORTNAME','NOM',cd_estabelecimento_w);

	select	a.cd_pessoa_fisica cd_pessoa_fisica, /*id_15*/
			y.ds_given_name nm_primeiro_nome, /*id_39*/
			y.ds_family_name nm_sobrenome_pai, /*id_40*/
			coalesce(y.ds_component_name_1, 'SIN INFORMACION') nm_sobrenome_mae, /*id_41*/
			b.dt_nascimento dt_nascimento, /*id_44*/
			obter_idade(b.dt_nascimento, clock_timestamp(), 'A') qt_idade, /*id_22*/
			CASE WHEN b.ie_sexo='M' THEN  'M' WHEN b.ie_sexo='F' THEN  'F' WHEN b.ie_sexo='I' THEN 'U'  ELSE 'UNK' END  ie_sexo, /*id_42*/
			coalesce(obter_valor_dominio(4,b.ie_sexo),obter_desc_expressao(325590,null)) ds_sexo, /*id_43*/
			nac.cd_nacionalidade cd_nacionalidade, /*id_21*/
			CASE WHEN b.ie_estado_civil='13' THEN  'D' WHEN b.ie_estado_civil='11' THEN  'M' WHEN b.ie_estado_civil='12' THEN  'S' WHEN b.ie_estado_civil='14' THEN  'W' WHEN b.ie_estado_civil='15' THEN  'T' WHEN b.ie_estado_civil='16' THEN  'L'  ELSE 'UNK' END
								ie_estado_civil, /*id_45*/
			obter_valor_dominio(9140,b.ie_estado_civil) ds_estado_civil, /*id_46*/
			b.cd_curp cd_curp, /*id_17*/
			coalesce(obter_telefone_pf_html5(b.cd_pessoa_fisica,14),obter_telefone_pf_html5(b.cd_pessoa_fisica,13)) nr_telefone, /* id_37*/
			obter_compl_pf(b.cd_pessoa_fisica,1,'M') ds_email, /*id_38*/
			CASE WHEN coalesce(b.SG_ESTADO_NASC, '')='IN' THEN  nac.ie_tipo_pais_nom WHEN coalesce(b.SG_ESTADO_NASC, '')='' THEN  nac.ie_tipo_pais_nom  ELSE (select max(cd_endereco_catalogo) 				  from end_endereco x				  where x.nr_seq_catalogo = obter_catalogo_nom(cd_estabelecimento_w)				  and x.ie_informacao = 'ESTADO_PROVINCI'				  and (x.sg_estado_tasy = b.sg_estado_nasc or b.sg_estado_nasc = x.cd_endereco_catalogo)				  ) END  cd_estado_nasc, /*id_34*/
			obter_dados_cat_lingua_indig(b.nr_seq_lingua_indigena,'CD_LINGUA_INDIGENA_MF') cd_lingua_indigena, /*id_49*/
			obter_dados_cat_lingua_indig(b.nr_seq_lingua_indigena,'DS_LINGUA_INDIGENA') ds_lingua_indigena, /*id_50*/
			(select x.cd_externo from religiao x where x.cd_religiao = b.cd_religiao) cd_religiao, /*id_47*/
			obter_desc_religiao(b.cd_religiao) ds_religiao, /*id_48*/
			b.nr_prontuario nr_prontuario /*id_19*/
	into STRICT
		nr_ident_primario_w,
		nm_primeiro_nome_w,
		nm_sobrenome_1_pai_w,
		nm_sobrenome_2_mae_w,
		dt_nascimento_w,
		qt_idade_w,
		ie_sexo_w,
		ds_sexo_w,
		cd_nacionalidade_w,
		ie_estado_civil_w,
		ds_estado_civil_w,
		cd_curp_w,
		nr_telefone_w,
		ds_email_w,
		cd_entidade_nasc_w,
		cd_lingua_indigena_w,
		ds_lingua_indigena_w,
		cd_religiao_w,
		ds_religiao_w,
		nr_ident_adicional_w
	FROM atendimento_paciente a, pessoa_fisica b
LEFT OUTER JOIN person_name y ON (b.nr_seq_person_name = y.nr_sequencia AND 'main' = y.ds_type)
LEFT OUTER JOIN nacionalidade nac ON (b.cd_nacionalidade = nac.cd_nacionalidade)
WHERE a.cd_pessoa_fisica = b.cd_pessoa_fisica    and a.nr_atendimento	= nr_atendimento_w;

	begin
	select nr_seq_pessoa_endereco,	
		    get_complete_address_desc(a.nr_seq_pessoa_endereco,null,null,null,null,'Y') ds_endereco_completo, /*id_23*/
			get_info_end_endereco(a.nr_seq_pessoa_endereco,'TIPO_LOGRAD','C') cd_tipo_vialidade, /*id_24*/
			get_info_end_endereco(a.nr_seq_pessoa_endereco,'RUA_VIALIDADE','D') ds_rua_vialidade, /*id_25*/
			get_info_end_endereco(a.nr_seq_pessoa_endereco,'NUMERO','D') nr_numero_externo, /*id_26*/
			get_info_end_endereco(a.nr_seq_pessoa_endereco,'COMPLEMENTO','D') nr_numero_interno, /*id_29*/
			get_info_end_endereco(a.nr_seq_pessoa_endereco,'TIPO_BAIRRO','C') cd_tipo_asentamento, /*id_30*/
			get_info_end_endereco(a.nr_seq_pessoa_endereco,'BAIRRO_VILA','D') nm_assentamento, /*id_31*/
			get_info_end_endereco(a.nr_seq_pessoa_endereco,'LOCALIDADE_AREA','C') cd_localidade, /*id_32*/
			get_info_end_endereco(a.nr_seq_pessoa_endereco,'MUNICIPIO','C') cd_municipio, /*id_33*/
			get_info_end_endereco(a.nr_seq_pessoa_endereco,'ESTADO_PROVINCI','C') cd_entidade, /*id_34*/
			get_info_end_endereco(a.nr_seq_pessoa_endereco,'CODIGO_POSTAL','D') cd_postal, /*id_35*/
			get_info_end_endereco(a.nr_seq_pessoa_endereco,'PAIS','C') cd_pais, /*id_36*/
			get_info_end_endereco(a.nr_seq_pessoa_endereco,'NUM_EXT_ALFA','D') nr_domicilio_ext_alfa,
			get_info_end_endereco(a.nr_seq_pessoa_endereco,'NUMERO_INT','D') nr_domicilio_int
	into STRICT
			nr_seq_pessoa_endereco_w,
			ds_domicilio_w,
			cd_tipo_vialidade_w,
			nm_vialidade_w,
			nr_domicilio_ext_w,
			nr_domicilio_int_alfa_w,
			cd_tipo_assentamento_w,
			nm_assentamento_w,
			cd_localidade_w,
			cd_municipio_w,
			cd_entidade_fed_w,
			cd_postal_w,
			cd_pais_w,
			nr_domicilio_ext_alfa_w,
			nr_domicilio_int_w
	from	compl_pessoa_fisica a
	where	a.cd_pessoa_fisica	= nr_ident_primario_w
	and		a.ie_tipo_complemento	= 1;
	exception
	when others then
		null;
	end;

	select	max(b.nr_seq_catalogo)
	into STRICT	nr_seq_catalogo_w
	from	end_endereco b,
			pessoa_endereco_item a
	where	b.nr_sequencia = a.nr_seq_end_endereco
	and		a.nr_seq_pessoa_endereco = nr_seq_pessoa_endereco_w;

	insert into nom_rc_pessoa_fisica(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_cabecalho,
			ie_tipo,
			ds_oid_primario,
			nr_ident_primario,
			nm_ident_primario,
			cd_curp,
			ds_oid_adicional,
			nr_ident_adicional,
			nm_ident_adicional,
			cd_nacionalidade,
			qt_idade,
			ds_domicilio,
			cd_tipo_vialidade,
			nm_vialidade,
			nr_domicilio_ext,
			nr_domicilio_int_alfa,
			cd_tipo_assentamento,
			nm_assentamento,
			cd_localidade,
			cd_municipio,
			cd_entidade_fed,
			cd_postal,
			cd_pais,
			nr_telefone,
			ds_email,
			nm_primeiro_nome,
			nm_sobrenome_1_pai,
			nm_sobrenome_2_mae,
			ie_sexo,
			ds_sexo,
			dt_nascimento,
			ie_estado_civil,
			ds_estado_civil,
			cd_religiao,
			ds_religiao,
			cd_lingua_indigena,
			ds_lingua_indigena,
			cd_entidade_nasc,
			nr_seq_catalogo,
			nr_domicilio_ext_alfa,
			nr_domicilio_int
			) values (
			nextval('nom_rc_pessoa_fisica_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_cabecalho_p,
			'PAC',
			ds_oid_primario_w,		
			nr_ident_primario_w, 	
			nm_ident_primario_w,		
			cd_curp_w,				
			ds_oid_adicional_w,  	
			nr_ident_adicional_w,	
			nm_ident_adicional_w,	
			cd_nacionalidade_w,		
			qt_idade_w,				
			ds_domicilio_w,			
			cd_tipo_vialidade_w,		
			nm_vialidade_w,			
			nr_domicilio_ext_w,		
			nr_domicilio_int_alfa_w,	
			cd_tipo_assentamento_w,	
			nm_assentamento_w,		
			cd_localidade_w,			
			cd_municipio_w,			
			cd_entidade_fed_w,		
			cd_postal_w,				
			cd_pais_w,				
			nr_telefone_w,			
			ds_email_w,				
			nm_primeiro_nome_w,		
			nm_sobrenome_1_pai_w,	
			nm_sobrenome_2_mae_w,	
			ie_sexo_w,				
			ds_sexo_w,				
			dt_nascimento_w,			
			ie_estado_civil_w,		
			ds_estado_civil_w,		
			cd_religiao_w,			
			ds_religiao_w,			
			cd_lingua_indigena_w,	
			ds_lingua_indigena_w,	
			cd_entidade_nasc_w,
			nr_seq_catalogo_w,
			nr_domicilio_ext_alfa_w,
			nr_domicilio_int_w
	);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_nom_rc_paciente (nr_seq_cabecalho_p bigint, nm_usuario_p text) FROM PUBLIC;
