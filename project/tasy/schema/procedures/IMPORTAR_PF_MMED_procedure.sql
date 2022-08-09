-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE importar_pf_mmed (cd_pessoa_fisica_p text, /*  V10 */
 nm_pessoa_fisica_p text, /*  V60 */
 dt_nascimento_p timestamp, /*  Date */
 ie_sexo_p text, /*  V1 - 	F - Feminino
								M - Masculino
								I - Indeterminado */
 ie_estado_civil_p text, /*  V2 -	1 - Solteiro
								2 - Casado
								3 - Divorciado
								4 - Desquitado
								5 - Viúvo
								6 - Separado
								7 - Concubinado
								9 - Outros */
 nr_cpf_p text, /*  V11 */
 nr_identidade_p text, /*  V15 */
 nr_prontuario_p bigint, /*  N10 */
 qt_altura_cm_p bigint, /*  N4,1 */
 ds_fonetica_p text, /*  V60 */
 qt_peso_p bigint, /*  N6,3 */
 ds_observacao_p text, /*  V2000 */
 nm_pessoa_fisica_sem_acento_p text, /*  V60 */
 cd_municipio_ibge_p text, /*  V6 */
 ds_profissao_p text, /*  V255 */
 ds_endereco_p text, /*  V100 */
 cd_cep_p text, /*  V15 */
 ds_bairro_p text, /*  V40 */
 ds_municipio_p text, /*  V40 */
 sg_estado_p text, /*  V2 */
 nr_telefone_p text, /*  V15 */
 ds_email_p text, /*  V255 */
 cd_zona_procedencia_p text, /*  V3  - É uma FK de um cadastro do TASY. Na tabela PROCEDENCIA tem o campo CD_PROCEDENCIA_EXTERNO para conversão */
 nm_usuario_p text, /*  V15 */
 ds_retorno_p INOUT text, /*  V255 */
 id_multimed_p bigint) AS $body$
DECLARE


/*objeto chamada no integração da multimed, os novos parâmetros que forem adicionados devem ser definidos como default para não ocorrer problemas na integração*/

/* Havia conflito em 4 campos na correlação:
NM_PESSOA_PESQUISA          	NOMEFONETICO  - Desconsiderado
DS_FONETICA                 	NOMEFONETICO - Considerado
NR_IDENTIDADE          	RG DO PACIENTE - Desconsiderado
NR_CPF                 		CPF DO PACIENTE - Desconsiderado

*/
ie_erro_compl_pf_w	varchar(1)	:= 'N';
ie_erro_pf_w		varchar(1)	:= 'N';
qt_registro_w		bigint;
nr_sequencia_w		bigint;
cd_pessoa_fisica_w	varchar(10);
sql_errm_w		varchar(2000);
ds_retorno_w		varchar(255) := '';



BEGIN

CALL wheb_usuario_pck.SET_IE_EXECUTAR_TRIGGER('N');

if (nr_prontuario_p IS NOT NULL AND nr_prontuario_p::text <> '') then

	select	count(*)
	into STRICT	qt_registro_w
	from	pessoa_fisica
	where	nr_prontuario = nr_prontuario_p;

	if (qt_registro_w > 0) then

		ds_retorno_w := 'Já existe uma pessoa física cadastrada com o prontuário ' || nr_prontuario_p;

		ie_erro_pf_w	:= 'S';
	end if;
end if;

if (ie_erro_pf_w = 'N') then

	begin

	select	nextval('pessoa_fisica_seq')
	into STRICT	cd_pessoa_fisica_w
	;

	insert into pessoa_fisica(cd_pessoa_fisica,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		ie_tipo_pessoa,
		cd_sistema_ant,
		nm_pessoa_fisica,
		dt_nascimento,
		ie_sexo,
		ie_estado_civil,
		nr_cpf,
		nr_identidade,
		nr_prontuario,
		qt_altura_cm,
		ds_fonetica,
		qt_peso,
		ds_observacao,
		nm_pessoa_fisica_sem_acento,
		cd_municipio_ibge,
		ds_profissao)
	values (cd_pessoa_fisica_w,
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		1,
		cd_pessoa_fisica_p,
		nm_pessoa_fisica_p,
		dt_nascimento_p,
		ie_sexo_p,
		ie_estado_civil_p,
		nr_cpf_p,
		nr_identidade_p,
		nr_prontuario_p,
		qt_altura_cm_p,
		ds_fonetica_p,
		qt_peso_p,
		ds_observacao_p,
		nm_pessoa_fisica_sem_acento_p,
		cd_municipio_ibge_p,
		ds_profissao_p);
	exception
		when others then
		sql_errm_w	:= sqlerrm;
		ds_retorno_w := 'Erro ao inserir pessoa. '|| sql_errm_w;

		ie_erro_pf_w	:= 'S';

		insert into ISITEINTEG_TASY_MULTIMED(id_multimed,
		   cd_pessoa_fisica)
		values (id_multimed_p,
		 cd_pessoa_fisica_w);
	end;

	if (ie_erro_pf_w = 'N') then

		select	coalesce(max(nr_sequencia),0) + 1
		into STRICT	nr_sequencia_w
		from	compl_pessoa_fisica
		where	cd_pessoa_fisica	= cd_pessoa_fisica_w;

		insert into compl_pessoa_fisica(nr_sequencia,
			cd_pessoa_fisica,
			ie_tipo_complemento,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			nm_usuario,
			dt_atualizacao,
			ds_endereco,
			cd_cep,
			ds_bairro,
			ds_municipio,
			sg_estado,
			nr_telefone,
			ds_email,
			cd_zona_procedencia)
		values (nr_sequencia_w,
			cd_pessoa_fisica_w,
			1,
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			ds_endereco_p,
			cd_cep_p,
			ds_bairro_p,
			ds_municipio_p,
			sg_estado_p,
			nr_telefone_p,
			ds_email_p,
			cd_zona_procedencia_p);

	end if;

end if;
CALL wheb_usuario_pck.SET_IE_EXECUTAR_TRIGGER('S');

ds_retorno_p := ds_retorno_w;

--commit; removido commit a pedido da multimed pois utilizam dentro de transação
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importar_pf_mmed (cd_pessoa_fisica_p text,  nm_pessoa_fisica_p text,  dt_nascimento_p timestamp,  ie_sexo_p text,  ie_estado_civil_p text,  nr_cpf_p text,  nr_identidade_p text,  nr_prontuario_p bigint,  qt_altura_cm_p bigint,  ds_fonetica_p text,  qt_peso_p bigint,  ds_observacao_p text,  nm_pessoa_fisica_sem_acento_p text,  cd_municipio_ibge_p text,  ds_profissao_p text,  ds_endereco_p text,  cd_cep_p text,  ds_bairro_p text,  ds_municipio_p text,  sg_estado_p text,  nr_telefone_p text,  ds_email_p text,  cd_zona_procedencia_p text,  nm_usuario_p text,  ds_retorno_p INOUT text,  id_multimed_p bigint) FROM PUBLIC;
