-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_pf ( cd_pessoa_fisica_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* CASO FOR ALTERAR ALGUM CAMPO DO TIPO DATA E NECESSARIO QUE SE ALTERE TAMBEM A FUNCTION OBTER_DATAS_PF */
				
				
/* IE_OPCAO_P

DN	- Data de nascimento
EC	- Estado civil
CNS	- Cartao nacional do SUS
R	- Religiao
CP	- Cor da pele
GI	- Grau de instrucao
RG	- Identidade
TC	- Telefone celular
TCD	- Telefone celular com ddd
TCDDI	- Telefone celular com ddi - HTML5
TCI 	- Telefone celular com ddd e ddi
DO	- Data de obito
I	- Idade
TP	- Tipo prontuario
ATC	- Codigo Atividade SUS
INSS	- Inss (Rafael em 01/08/06 OS38439);
COPR	- Conselho e codigo de profissional (Rafael em 29/08/06 - Atender necessidades do checkup);
CON	- Conselho (Rafael em 29/08/06 - Atender necessidades do checkup);
CPR	- Codigo profissional (Rafael em 29/08/06 - Atender necessidades do checkup);
AL	- Altura em cm (Jacson em 27/09/2006 - Performance hemoterapia)
CPF	- Numero do CPF (Elemar em 08/11/2006)
CNES	- Codigo do CNES (Jacson em 18/01/2007 - Plano de Saude / TISS)
CSA	- Codigo sistema anterior (Rafael em 02/01/2007 OS49483)
SA	- Numero Same (Oraci em 27/03/2007 OS53293)
CBOS	- Codigo brasileiro de ocupacao de saude
M	- Medico (Oraci em 11/07/2007 OS62470)
O	- Orgao Emissor CI (Oraci em 11/07/2007 OS62470)
CN	- Certidao de Nascimento (Almir em 13/11/2007 OS74130)
PLS	- Numero do registro do Plano de Saude (responsavel)
DRG	- Data de emissao da carteira de identidade
VRG	- Data de validade da carteira de identidade
TS	- Sangue
RH	- Fator RH
RGES	- Registro Geral de Estrangeiro (Eduardo em 17/07/2008)
N       	- Nacionalidade (Adriano F. Stringari em 10/02/2009)
NC	- Codigo Nacionalidade
F	- Funcionario
RGE	- RG Estrangeiro
PA	- Numero do Passaporte
NRTRA	- Numero Transplante
QD	- Quantidade de dependentes
CR	- Cargo
CCR	- Codigo Cargo
PIS	- Numero do PIS (nr_pis_pasep)
SE	- Sexo
DCB	- Data chegada Brasil
TE	 - Titulo de eleitor
ZE	- Zona eleitoral
SEL	- Secao eleitoral
NCTPS	- Nr. CTPS
SCTPS	- Serie CTPS
UCTPS	- UF CTPS
ECTPS	- Data de emissao do CTPS
UFRG	- Unidade federativa de emissao do RG
DEC	- Data de emissao da certidao de casamento
DNAT	- Data da naturalizacao
NRPNAT	- Numero da portaria de naturalizacao
DES	- Descricao da escolaridade
CBOR	- CBO-R
FRE	- Frequenta escola
CBORD	- Descricao do CBO-R
SF	- Situacao conjugal/familiar
MRN	 - Matricula de nascimento (Geliard em 10/03/2010 OS198272)
CF	- Codigo familia
BAC	- Banco/Agencia/Conta
NP	- Numero do prontuario
KG	- Peso
KGN	- Peso Nascimento
NPE	- Numero do prontuario externo
ISS	- Numero ISS
CE	- Cartao/Carteira estrangeiro
CNP	- Cidade Natal
CNP	- Cidade Natal
UFP     - UF Natal
DAS	- Descricao Atividade SUS
CDF	- Codigo do funcionario
NDR	- Nome do responsavel
NSOC	- Nome social
IE	- Inscricao Estadual
DPRA	- Data do primeiro atendimento
DDDC	- DDD do telefone celular
UB	- Ultimo banco cadastrado para a pessoa
UA	- Ultima agencia cadastrada para a pessoa
UCC	- Ultima conta corrente cadastrada para a pessoa
UAD	- Ultima agencia cadastrada para a pessoa com o digito
UCCD	- Ultima conta corrente cadastrada para a pessoa com o digito
DUA	- Digito da ultima agencia cadastrada para a pessoa
DUCC	- Digito da ultima conta corrente cadastrada para a pessoa
RFC	- Codigo RFC (Mexico)
IFE	- Codiogo IFE (Mexico)
CURP	- Codigo CURP (Mexico)
OBS	- Observacao do paciente
NA 	- Nome abreviado
DP	- Dependente
MN	- Municipio IBGE de nascimento
CCP	- Codigo da cor da pele
CGI	- Codigo do grau de instrucao.
SABO	- Subgrupo ABO
COB	- Certidao de obito
PNG	- Person Name Given
PNL	- Person Name Last
PNM	- Person Name Middle
PNC	- Person Name Complete
PP - Perfil da gestao de acessos PEP vinculado ao paciente
*/
cd_pessoa_fisica_w		varchar(10);
nr_prontuario_w			bigint;
nr_pront_ext_w			varchar(100);
nr_reg_geral_estrangeiro_w		varchar(255);
nr_passaporte_w			varchar(255);
dt_nascimento_w			varchar(255);
ds_retorno_w			varchar(255);
ie_estado_civil_w			varchar(255);
nr_cartao_nac_sus_w		varchar(20);
nr_identidade_w			varchar(255);
nr_telefone_celular_w		pessoa_fisica.nr_telefone_celular%type;
nr_ddi_celular_w			pessoa_fisica.nr_ddi_celular%type;
nr_ddd_celular_w			pessoa_fisica.nr_ddd_celular%type;
dt_obito_w			varchar(255);
cd_atividade_sus_w		bigint;
nr_inss_w				varchar(255);
nr_seq_conselho_w			bigint;
ds_cod_prof_w			varchar(255);
qt_altura_cm_w			double precision;
nr_cpf_w				varchar(255);
cd_cnes_w			varchar(255);
cd_sistema_ant_w			varchar(255);
nr_seq_cbo_saude_w		bigint;
cd_cbo_saude_w			varchar(255);
cd_medico_w			varchar(255);
ds_orgao_emissor_ci_w		pessoa_fisica.ds_orgao_emissor_ci%type;
nr_cert_nasc_w			varchar(255);
nr_registro_pls_w			varchar(255);
ds_cargo_w			varchar(255);
cd_cargo_w			bigint;
dt_emissao_ci_w			timestamp;
dt_validade_ci_w			timestamp;
cd_religiao_w			bigint;
nr_seq_cor_pele_w			bigint;
ie_grau_instrucao_w		bigint;
ie_tipo_prontuario_w		bigint;
ie_tipo_sangue_w			varchar(255);
ie_fator_rh_w			varchar(255);
nr_reg_geral_estrang_w		varchar(255);
cd_nacionalidade_w		varchar(255);
ie_funcionario_w			varchar(255);
nr_transplante_w			varchar(255);
qt_dependente_w			bigint;
nr_pis_pasep_w			varchar(11);
ie_sexo_w			varchar(1);
dt_chegada_brasil_w		timestamp;
nr_titulo_eleitor_w			varchar(20);
nr_zona_w			varchar(5);
nr_secao_w			varchar(15);
nr_ctps_w			pessoa_fisica.nr_ctps%type;
uf_emissora_ctps_w		valor_dominio.vl_dominio%type;
nr_serie_ctps_w			pessoa_fisica.nr_serie_ctps%type;
dt_emissao_ctps_w			timestamp;
sg_emissora_ci_w		valor_dominio.vl_dominio%type;
dt_emissao_cert_casamento_w	timestamp;
dt_naturalizacao_pf_w		timestamp;
nr_portaria_nat_w			varchar(16);
ds_escolaridade_cns_w		varchar(255);
cd_cbo_sus_w			integer;
ie_frequenta_escola_w		varchar(1);
cd_cbo_red_w			integer;
ds_cbo_red_w			varchar(255);
ds_situacao_conj_cns_w		varchar(255);
nr_matricula_nasc_w		varchar(32);
cd_familia_w			bigint;
qt_peso_w			real;
nr_iss_w			varchar(20);
nr_cartao_estrangeiro_w		varchar(30);
ds_cidade_natal_w		varchar(50);
ds_cidade_natal_ibge_w		varchar(50);
ds_atividade_sus_w		varchar(255);
cd_funcionario_w		varchar(15);
nm_mae_w			varchar(255);
nm_social_w			varchar(200);
nr_inscricao_estadual_w		varchar(20);
ds_classif_concat_w  		varchar(255);
ds_classificacao_w		varchar(255);
dt_atendimento_w		timestamp;
nr_atendimento_w		bigint;
cd_banco_w			pessoa_fisica_conta.cd_banco%type;
nr_agencia_w			pessoa_fisica_conta.cd_agencia_bancaria%type;
nr_conta_w 			pessoa_fisica_conta.nr_conta%type;
nr_seq_pf_conta_w 		pessoa_fisica_conta.nr_sequencia%type;
ie_digito_agencia_w		pessoa_fisica_conta.ie_digito_agencia%type;
nr_digito_conta_w		pessoa_fisica_conta.nr_digito_conta%type;
cd_rfc_w			pessoa_fisica.cd_rfc%type;
cd_curp_w			pessoa_fisica.cd_curp%type;
cd_ife_w			pessoa_fisica.cd_ife%type;
ds_observacao_w			pessoa_fisica.ds_observacao%type;
nm_abreviado_w			pessoa_fisica.nm_abreviado%type;
ie_dependente_w		 	pessoa_fisica.ie_dependente%type;
cd_municipio_ibge_w	 	pessoa_fisica.cd_municipio_ibge%type;
ie_subtipo_sanguineo_w		pessoa_fisica.ie_subtipo_sanguineo%type;
nr_seq_person_name_w		pessoa_fisica.nr_seq_person_name%type;
ds_person_name_w		person_name.ds_given_name%type;
ds_type_name_w	 		varchar(50);

C01 CURSOR FOR
	SELECT	b.ds_classificacao
	from	PESSOA_CLASSIF a,
		classif_pessoa b
	where	a.nr_seq_classif = b.nr_sequencia
	and	clock_timestamp() between dt_inicio_vigencia and ESTABLISHMENT_TIMEZONE_UTILS.endOfDay(coalesce(dt_final_vigencia,clock_timestamp()))
	and	a.cd_pessoa_fisica = cd_pessoa_fisica_p
	group by b.ds_classificacao
	order by b.ds_classificacao;


BEGIN

if (coalesce(cd_pessoa_fisica_p,'0') <> '0') then
	begin

	begin
	if (ie_opcao_p	= 'DN') then
		select	to_char(max(dt_nascimento),'DD/MM/YYYY')
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'EC') then
		select	max(ie_estado_civil)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'CNS') then
		select	substr(max(nr_cartao_nac_sus),1,20)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'R') then
		select	OBTER_DESC_RELIGIAO(max(cd_religiao))
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'CP') then
		select	Obter_Desc_Cor_pele(max(nr_seq_cor_pele))
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'CCP') then
		select	nr_seq_cor_pele
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'RG') then
		select	max(nr_identidade)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'GI') then
		select	obter_valor_dominio(10,max(ie_grau_instrucao))
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'CGI') then
		select	max(ie_grau_instrucao)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'TC') then
		select	max(nr_telefone_celular)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;		
	elsif (ie_opcao_p	= 'TCDDI') then	
		select	max(nr_ddi_celular) || max(nr_telefone_celular)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;	
		
	elsif (ie_opcao_p	= 'TCD') then
		select	nr_telefone_celular,
				nr_ddi_celular,
				nr_ddd_celular
		into STRICT	nr_telefone_celular_w,
				nr_ddi_celular_w,
				nr_ddd_celular_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;	
		
		if (substr(somente_numero(nr_telefone_celular_w),1,2) = substr(somente_numero(nr_ddd_celular_w),1,2)) and (length(somente_numero(nr_telefone_celular_w)) > 9) then
			ds_retorno_w := nr_ddi_celular_w || nr_telefone_celular_w;
		else
			ds_retorno_w := nr_ddi_celular_w || nr_ddd_celular_w || nr_telefone_celular_w;
		end if;
	elsif (ie_opcao_p	= 'TCI')	 then	
		select	nr_telefone_celular,
				nr_ddi_celular,
				nr_ddd_celular
		into STRICT	nr_telefone_celular_w,
				nr_ddi_celular_w,
				nr_ddd_celular_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;	
		
		if (substr(somente_numero(nr_telefone_celular_w),1,2) = substr(somente_numero(nr_ddd_celular_w),1,2))then
			ds_retorno_w := nr_ddi_celular_w || nr_telefone_celular_w;
		else
			ds_retorno_w := nr_ddi_celular_w || nr_ddd_celular_w || nr_telefone_celular_w;
		end if;					
	elsif (ie_opcao_p	= 'DDDC') then
		select	max(nr_ddd_celular)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'DO') then
		select	to_char(max(dt_obito),'DD/MM/YYYY')
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'I') then
		/*ds_retorno_w	:= obter_idade(dt_nascimento_w,nvl(dt_obito_w,sysdate),'A'); -- Rafael em 6/5/8 OS95469 */

		select	obter_idade(to_date(to_char(dt_nascimento,'DD/MM/YYYY'),'dd/mm/yyyy'),coalesce(to_date(to_char(dt_obito,'DD/MM/YYYY'),'dd/mm/yyyy'),clock_timestamp()),'A')
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
		--ds_retorno_w	:= obter_idade(to_date(dt_nascimento_w,'dd/mm/yyyy'),nvl(to_date(dt_obito_w,'dd/mm/yyyy'),sysdate),'A');
	elsif (ie_opcao_p	= 'TP') then
		select	obter_valor_dominio(1528,max(ie_tipo_prontuario))
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'ATC') then
		select	substr(max(cd_atividade_sus),1,3)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'INSS') then
		select	substr(max(nr_inss),1,20)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'COPR') then
		select	obter_conselho_profissional(max(nr_seq_conselho),'S')||'  '||max(ds_codigo_prof)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
		--ds_retorno_w	:= obter_conselho_profissional(nr_seq_conselho_w,'S')||'  '||ds_cod_prof_w;
	elsif (ie_opcao_p	= 'CON') then
		select	obter_conselho_profissional(max(nr_seq_conselho),'S')
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'CPR') then
		select	substr(max(ds_codigo_prof),1,15)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'AL') then
		select	to_char(max(qt_altura_cm))
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'CPF') then
		select	max(nr_cpf)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p 	= 'CNES') then
		select	max(cd_cnes)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p 	= 'CSA') then
		select	max(cd_sistema_ant)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p 	= 'SA') then
		ds_retorno_w	:= obter_nr_same_paciente(cd_pessoa_fisica_p);
	elsif (ie_opcao_p 	= 'CBOS') then
		select	max(cd_cbo_sus)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	
		select	max(nr_seq_cbo_saude)
		into STRICT	nr_seq_cbo_saude_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	
		select	max(cd_cbo)
		into STRICT	cd_cbo_saude_w
		from	cbo_saude
		where	nr_sequencia	= nr_seq_cbo_saude_w;
		ds_retorno_w	:= cd_cbo_saude_w;
	elsif (ie_opcao_p	= 'M') then
		select	max(cd_medico)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'O') then
		select	max(ds_orgao_emissor_ci)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'CN') then
		select	max(nr_cert_nasc)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'ISS') then
		select	max(nr_iss)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'PLS') then
		select	max(nr_registro_pls)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'DRG') then
		select	to_char(max(dt_emissao_ci), 'dd/mm/yyyy')
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'VRG') then
		select	to_char(max(dt_validade_rg), 'dd/mm/yyyy')
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'TS') then
		select	max(ie_tipo_sangue)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'RH') then
		select	max(ie_fator_rh)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p = 'RGES') then
		select	max(nr_reg_geral_estrang)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p = 'N') then
		select	obter_desc_nacionalidade(max(cd_nacionalidade))
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p = 'NC') then
		select	max(cd_nacionalidade)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p = 'F') then
		select	max(ie_funcionario)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	 = 'PA') then
		select	max(nr_passaporte)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=	'RGE') then
		select	max(nr_reg_geral_estrang)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=  'NRTRA') then
		select	max(nr_transplante)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=  'CR') then
		select	substr(obter_desc_cargo(max(cd_cargo)),1,80)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=  'CCR') then
		select	max(cd_cargo)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=  'QD') then
		select	max(qt_dependente)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=  'PIS') then
		select	max(nr_pis_pasep)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=  'SE') then
		select	max(ie_sexo)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=  'DCB') then
		select	max(dt_chegada_brasil)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=  'DNAT') then
		select	max(dt_naturalizacao_pf)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=  'TE') then
		select	max(nr_titulo_eleitor)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=  'ZE') then
		select	max(nr_zona)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=  'SEL') then
		select	max(nr_secao)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=  'NCTPS') then
		select	max(nr_ctps)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=  'SCTPS') then
		select	max(nr_serie_ctps)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=  'UCTPS') then
		select	max(uf_emissora_ctps)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=  'ECTPS') then
		select	max(dt_emissao_ctps)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=  'UFRG') then
		select	max(sg_emissora_ci)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=  'DEC') then
		select	max(dt_emissao_cert_casamento)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=  'NRPNAT') then
		select	max(nr_portaria_nat)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=  'DES') then
		select	substr(obter_valor_dominio(3249,max(ie_escolaridade_cns)),1,200)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=  'NP') then
		select	max(nr_prontuario)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=  'NPE') then
		select	max(nr_pront_ext)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=  'CBOR') then
		select	max(cd_cbo_sus)
		into STRICT	cd_cbo_sus_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	
		select	max(cd_cbo)
		into STRICT	cd_cbo_red_w
		from	cbo_red
		where	cd_cbo	= cd_cbo_sus_w;

		ds_retorno_w	:= cd_cbo_red_w;
	elsif (ie_opcao_p	=  'FRE') then
		select	max(ie_frequenta_escola)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	=  'CBORD') then
		select	max(cd_cbo_sus)
		into STRICT	cd_cbo_sus_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	
		select	max(ds_cbo)
		into STRICT	ds_cbo_red_w
		from	cbo_red
		where	cd_cbo	= cd_cbo_sus_w;

		ds_retorno_w	:= ds_cbo_red_w;
	elsif (ie_opcao_p	=  'SF') then
		select	substr(obter_valor_dominio(3250,max(ie_situacao_conj_cns)),1,255)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p 	=  'MRN') then
		select	max(nr_matricula_nasc)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p 	=  'CF') then
		select	max(cd_familia)
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	elsif (ie_opcao_p	= 'BAC') then
		select	substr(max(obter_nome_banco(a.cd_banco) || ' - ' ||
			a.cd_agencia_bancaria || CASE WHEN coalesce(a.ie_digito_agencia::text, '') = '' THEN null  ELSE '/' END  || a.ie_digito_agencia || ' - ' ||
			a.nr_conta || CASE WHEN coalesce(a.nr_digito_conta::text, '') = '' THEN null  ELSE '/' END  || a.nr_digito_conta ||
			CASE WHEN a.ie_tipo_conta='CC' THEN OBTER_DESC_EXPRESSAO(729540) WHEN a.ie_tipo_conta='CP' THEN OBTER_DESC_EXPRESSAO(729558) WHEN a.ie_tipo_conta='')),1,255)			-- 729540: ' - Conta corrente'			729558: ' - Conta poupanca'		into STRICT	ds_retorno_w		from	pessoa_fisica_conta a		where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p		and	a.ie_situacao		= 'A';	elsif (ie_opcao_p	= 'KG') then		select	max(qt_peso)		into STRICT	ds_retorno_w		from	pessoa_fisica		where	cd_pessoa_fisica = cd_pessoa_fisica_p;	elsif (ie_opcao_p	= 'KGN') then		select	max(qt_peso_nasc)		into STRICT	ds_retorno_w		from	pessoa_fisica		where	cd_pessoa_fisica = cd_pessoa_fisica_p;	elsif (ie_opcao_p	= 'CE') then		select	max(nr_cartao_estrangeiro)		into STRICT	ds_retorno_w		from	pessoa_fisica		where	cd_pessoa_fisica = cd_pessoa_fisica_p;	elsif (ie_opcao_p	= 'DAS') then		select	substr(Sus_Obter_Desc_Cnaer(max(cd_atividade_sus)),1,255)		into STRICT	ds_retorno_w		from	pessoa_fisica		where	cd_pessoa_fisica = cd_pessoa_fisica_p;	elsif (ie_opcao_p	= 'CDF') then		select	max(cd_funcionario)		into STRICT	ds_retorno_w		from	pessoa_fisica		where	cd_pessoa_fisica = cd_pessoa_fisica_p;	elsif (ie_opcao_p  	= 'CNP')	then		if (coalesce(Obter_Valor_Param_Usuario(0,86,obter_perfil_ativo,Obter_Usuario_Ativo,obter_estabelecimento_ativo),'L') = 'L') then			select	substr(obter_desc_cep_loc(max(NR_CEP_CIDADE_NASC)),1,50)			into STRICT	ds_retorno_w			from	pessoa_fisica			where	cd_pessoa_fisica = cd_pessoa_fisica_p;		else			select	substr(OBTER_DESC_MUNICIPIO_IBGE(max(cd_municipio_ibge)),1,255)			into STRICT	ds_retorno_w			from	pessoa_fisica			where	cd_pessoa_fisica = cd_pessoa_fisica_p;		end if;        elsif (ie_opcao_p     = 'UFP') then                 select	substr(rhc_obter_uf_natal(max(NR_CEP_CIDADE_NASC)),1,2)			into STRICT	ds_retorno_w			from	pessoa_fisica			where	cd_pessoa_fisica = cd_pessoa_fisica_p;	elsif (ie_opcao_p	= 'NDR') then		select	substr(obter_nome_pf(max(cd_pessoa_mae)),1,240)		into STRICT	ds_retorno_w		from	pessoa_fisica		where	cd_pessoa_fisica = cd_pessoa_fisica_p;	elsif (ie_opcao_p	= 'NSOC') then		select	max(nm_social)		into STRICT	ds_retorno_w		from	pessoa_fisica		where	cd_pessoa_fisica = cd_pessoa_fisica_p;	elsif (ie_opcao_p	= 'IE') then		select	max(nr_inscricao_estadual)		into STRICT	ds_retorno_w		from	pessoa_fisica		where	cd_pessoa_fisica = cd_pessoa_fisica_p;	elsif (ie_opcao_p	= 'RFC') then		select	max(cd_rfc)		into STRICT	ds_retorno_w		from	pessoa_fisica		where	cd_pessoa_fisica = cd_pessoa_fisica_p;	elsif (ie_opcao_p	= 'IFE') then		select	max(cd_ife)		into STRICT	ds_retorno_w		from	pessoa_fisica		where	cd_pessoa_fisica = cd_pessoa_fisica_p;	elsif (ie_opcao_p	= 'CURP') then		select	max(cd_curp)		into STRICT	ds_retorno_w		from	pessoa_fisica		where	cd_pessoa_fisica = cd_pessoa_fisica_p;	elsif (ie_opcao_p = 'OBS') then		select	substr(max(ds_observacao),1,255)		into STRICT	ds_retorno_w		from	pessoa_fisica		where	cd_pessoa_fisica = cd_pessoa_fisica_p;	elsif (ie_opcao_p	= 'CLC') then		begin		ds_classif_concat_w := null;		open C01;		loop		fetch C01 into			ds_classificacao_w;		EXIT WHEN NOT FOUND; /* apply on C01 */			begin			ds_classif_concat_w := substr(ds_classif_concat_w || ', ' || ds_classificacao_w,1,4000);			end;		end loop;		close C01;		if (ds_classif_concat_w IS NOT NULL AND ds_classif_concat_w::text <> '') then			ds_classif_concat_w := substr(ds_classif_concat_w,3,4000);		end if;		ds_retorno_w := substr(ds_classif_concat_w,1,255);		end;	elsif (ie_opcao_p 	= 'DPRA') then		begin		select	min(nr_atendimento)		into STRICT	nr_atendimento_w		from	atendimento_paciente		where	cd_pessoa_fisica = cd_pessoa_fisica_p;		select  min(dt_entrada)		into STRICT 	dt_atendimento_w		from	atendimento_paciente		where	nr_atendimento = nr_atendimento_w;		ds_retorno_w := dt_atendimento_w;		end;	elsif (ie_opcao_p in ('UB','UA','UCC','UAD','UCCD','DUA','DUCC')) then		begin			select 	max(nr_sequencia)			into STRICT	nr_seq_pf_conta_w			from 	pessoa_fisica_conta			where 	cd_pessoa_fisica = cd_pessoa_fisica_p;			if (nr_seq_pf_conta_w IS NOT NULL AND nr_seq_pf_conta_w::text <> '') then			begin			select 	cd_banco THEN					cd_agencia_bancaria WHEN a.ie_tipo_conta=nr_conta THEN 					ie_digito_agencia WHEN a.ie_tipo_conta=nr_digito_conta			into STRICT	cd_banco_w THEN 					nr_agencia_w WHEN a.ie_tipo_conta=nr_conta_w THEN 					ie_digito_agencia_w WHEN a.ie_tipo_conta=nr_digito_conta_w			from 	pessoa_fisica_conta			where 	nr_sequencia = nr_seq_pf_conta_w;			end;			end if;			if (ie_opcao_p = 'UB') then			begin				ds_retorno_w := cd_banco_w;			end;			elsif (ie_opcao_p = 'UA') then			begin				ds_retorno_w := nr_agencia_w;			end;			elsif (ie_opcao_p = 'UCC') then			begin				ds_retorno_w := nr_conta_w;			end;			elsif (ie_opcao_p = 'UAD') then			begin				ds_retorno_w := nr_agencia_w||ie_digito_agencia_w;			end;			elsif (ie_opcao_p = 'UCCD') then			begin				ds_retorno_w := nr_conta_w||nr_digito_conta_w;			end;			elsif (ie_opcao_p = 'DUA') then			begin				ds_retorno_w := ie_digito_agencia_w;			end;			elsif (ie_opcao_p = 'DUCC') then			begin				ds_retorno_w := nr_digito_conta_w;			end;			end if;		end;	elsif (ie_opcao_p = 'NA') then		select	max(nm_abreviado)		into STRICT	ds_retorno_w		from	pessoa_fisica		where	cd_pessoa_fisica = cd_pessoa_fisica_p;	elsif (ie_opcao_p = 'DP') then		select	max(ie_dependente)		into STRICT	ds_retorno_w		from	pessoa_fisica		where	cd_pessoa_fisica = cd_pessoa_fisica_p;	elsif (ie_opcao_p = 'MN') then		select	max(cd_municipio_ibge)		into STRICT	ds_retorno_w		from	pessoa_fisica		where	cd_pessoa_fisica = cd_pessoa_fisica_p;	elsif (ie_opcao_p = 'SABO') then		select	 max(ie_subtipo_sanguineo)		into STRICT	ie_subtipo_sanguineo_w		from	pessoa_fisica		where	cd_pessoa_fisica = cd_pessoa_fisica_p;			select	max(ds_subtipo)		into STRICT	ds_retorno_w		from	subtipo_sanguineo		where	nr_sequencia = ie_subtipo_sanguineo_w;	elsif (ie_opcao_p = 'COB') then		select	max(nr_certidao_obito)		into STRICT	ds_retorno_w		from	pessoa_fisica		where	cd_pessoa_fisica = cd_pessoa_fisica_p;   elsif (ie_opcao_p = 'PP') then      select	max(b.ds_perfil)		into STRICT	   ds_retorno_w		from	   pessoa_fisica a THEN               PEP_PERFIL_PACIENTE b		where	   a.nr_seq_perfil            = b.nr_sequencia      and      coalesce(b.ie_situacao,'A')     = 'A'      and      a.cd_pessoa_fisica         = cd_pessoa_fisica_p;	elsif (ie_opcao_p 	= 'CBO') then			select	max(nr_seq_cbo_saude)		into STRICT	ds_retorno_w		from	pessoa_fisica		where	cd_pessoa_fisica = cd_pessoa_fisica_p;	elsif (ie_opcao_p in ('PNG','PNM','PNC','PNL')) then			begin						select	max(nr_seq_person_name)		into STRICT	nr_seq_person_name_w		from	pessoa_fisica		where	cd_pessoa_fisica	= cd_pessoa_fisica_p;				if (ie_opcao_p = 'PNG') then						ds_type_name_w	:= 'givenName';						elsif (ie_opcao_p = 'PNM') then						ds_type_name_w	:= 'middleName';				elsif (ie_opcao_p = 'PNC') then			ds_type_name_w	:= 'full';				elsif (ie_opcao_p = 'PNL') then					ds_type_name_w	:='familyName';					end if;							if (pkg_name_utils.get_name_feature_enabled() = 'N') and (nr_seq_person_name_w IS NOT NULL AND nr_seq_person_name_w::text <> '') then								select	max(pkg_name_utils.get_person_name(a.nr_seq_person_name, obter_estabelecimento_ativo, ds_type_name_w, 'main'))				into STRICT	ds_retorno_w				from   pessoa_fisica a				where  a.cd_pessoa_fisica = cd_pessoa_fisica_p  LIMIT 1;						else						if (ie_opcao_p = 'PNG') then								select	substr(Obter_Parte_Nome_pf(nm_pessoa_fisica,'nome'),1,60)					into STRICT	ds_retorno_w					from 	table(search_names_dev(null, cd_pessoa_fisica_p, null, ds_type_name_w, 'main', obter_estabelecimento_ativo));				elsif (ie_opcao_p = 'PNM') then								select	substr(Obter_Parte_Nome_pf(nm_pessoa_fisica,'restonome'),1,60)					into STRICT	ds_retorno_w					from 	table(search_names_dev(null, cd_pessoa_fisica_p, null, ds_type_name_w, 'main', obter_estabelecimento_ativo));				elsif (ie_opcao_p = 'PNC') then					select	substr(nm_pessoa_fisica,1,60)					into STRICT	ds_retorno_w					from 	table(search_names_dev(null, cd_pessoa_fisica_p, null, ds_type_name_w, 'main', obter_estabelecimento_ativo));				elsif (ie_opcao_p = 'PNL') then							select	substr(Obter_Parte_Nome_pf(nm_pessoa_fisica,'sobrenome'),1,60)					into STRICT	ds_retorno_w					from 	table(search_names_dev(null, cd_pessoa_fisica_p, null, ds_type_name_w, 'main', obter_estabelecimento_ativo));				else					select	substr(nm_pessoa_fisica,1,60)					into STRICT	ds_retorno_w					from 	table(search_names_dev(null, cd_pessoa_fisica_p, null, ds_type_name_w, 'main', obter_estabelecimento_ativo));				end if;				end if;		end;	end if;	end;	end;end if;return ds_retorno_w;end; END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_pf ( cd_pessoa_fisica_p text, ie_opcao_p text) FROM PUBLIC;
