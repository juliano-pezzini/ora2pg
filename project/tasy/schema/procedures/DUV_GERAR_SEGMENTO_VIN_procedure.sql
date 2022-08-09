-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duv_gerar_segmento_vin ( nr_seq_mensagem_p duv_mensagem.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_episodio_p episodio_paciente.nr_sequencia%type) AS $body$
DECLARE


nm_sobrenome_w		duv_vin.nm_sobrenome%type;
ds_nome_w		duv_vin.nm_primeiro_nome%type;
cd_pais_segurado_w	duv_vin.cd_pais_segurado%type;

c01 CURSOR FOR
SELECT	pf.nr_seq_person_name,
	pf.cd_nacionalidade,
	CASE WHEN PF.IE_SEXO='M' THEN 'M' WHEN PF.IE_SEXO='F' THEN 'W'  ELSE 'X' END  ie_genero,
	substr(cpf.cd_cep,1,6) cd_cep,
	substr(cpf.ds_municipio,1,30) ds_municipio,
	substr(cpf.ds_endereco,1,46) ds_endereco,
	substr(pa.CD_PAIS_DALE_UV,1,3) cd_pais_residencia,
	pf.dt_nascimento dt_nascimento,
	pf.nr_telefone_celular nr_telefone,
	acc.cd_usuario_convenio,
	'0' ie_empregado_seguradora
FROM conta_paciente cp, atendimento_paciente ap, atend_categoria_convenio acc, pessoa_fisica pf
LEFT OUTER JOIN compl_pessoa_fisica cpf ON (pf.cd_pessoa_fisica = cpf.cd_pessoa_fisica)
LEFT OUTER JOIN pais pa ON (cpf.nr_seq_pais = pa.nr_sequencia)
WHERE ap.nr_seq_episodio  	= nr_seq_episodio_p and ap.nr_atendimento   	= cp.nr_atendimento and ap.cd_pessoa_fisica 	= pf.cd_pessoa_fisica and acc.nr_seq_interno 	= obter_Atecaco_Atendimento(ap.nr_atendimento) and ap.nr_atendimento   	= acc.nr_atendimento   and cpf.ie_tipo_complemento	= '1';

c01_w c01%rowtype;


BEGIN

c01_w := null;
open c01;
fetch c01 into c01_w;
close c01;

begin
select	substr(ds_family_name,1,30),
	substr(ds_given_name,1,30)
into STRICT	nm_sobrenome_w,
	ds_nome_w
from	person_name
where	nr_sequencia = c01_w.nr_seq_person_name  LIMIT 1;
exception
when others then
	nm_sobrenome_w 	:= null;
	ds_nome_w	:= null;
end;

select	max(substr(coalesce(cd_externo,cd_nacionalidade),1,3))
into STRICT	cd_pais_segurado_w
from	nacionalidade
where	cd_nacionalidade	= c01_w.cd_nacionalidade;

insert into DUV_VIN(nr_sequencia
	,dt_atualizacao
	,nm_usuario
	,dt_atualizacao_nrec
	,nm_usuario_nrec
	,nr_seq_mensagem
	,nm_sobrenome
	,nm_primeiro_nome
	,cd_pais_segurado
	,ie_genero
	,cd_cep
	,ds_municipio
	,ds_endereco
	,cd_pais_residencia
	,dt_nascimento
	,nr_telefone
	,cd_usuario_convenio
	,ie_empregado_seguradora)
values (nextval('duv_vin_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_mensagem_p,
	nm_sobrenome_w,
	ds_nome_w,
	cd_pais_segurado_w,
	c01_w.IE_GENERO,
	c01_w.CD_CEP,
	c01_w.DS_MUNICIPIO,
	c01_w.DS_ENDERECO,
	c01_w.CD_PAIS_RESIDENCIA,
	c01_w.DT_NASCIMENTO,
	c01_w.NR_TELEFONE,
	c01_w.CD_USUARIO_CONVENIO,
	c01_w.IE_EMPREGADO_SEGURADORA);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duv_gerar_segmento_vin ( nr_seq_mensagem_p duv_mensagem.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_episodio_p episodio_paciente.nr_sequencia%type) FROM PUBLIC;
