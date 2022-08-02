-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_dados_milliman ( ie_tipo_pessoa_p text, nr_seq_conta_med_ted_p bigint, nm_usuario_p text, dt_ingresso_p timestamp) AS $body$
DECLARE

nr_matricula_benef_w		varchar(255);
nm_beneficiario_w		varchar(255);
ie_sexo_w			varchar(255);
dt_nascimento_w			timestamp;
nm_municipio_w			varchar(255);
nr_seq_titular_w		bigint;
cd_pessoa_fisica_w		varchar(255);
dt_ingresso_w			timestamp;
ie_tipo_garantia_w		varchar(255);
dt_saida_w			timestamp;
nm_lote_w			varchar(255);
ie_grau_dependencia_w		varchar(255);
cd_produto_ans_w		varchar(255);
nr_matricula_titular_w		varchar(255);
nr_cpf_w			varchar(255);
ds_razao_social_w		varchar(255);
nr_cnpj_w			varchar(255);
nr_matricula_pj_w		varchar(255);
cd_ramo_atividade_w		varchar(255);
ie_tipo_contratacao_w		varchar(255);
nr_cpf_titular_w		varchar(255);
dt_inicio_ref_w			pls_conta_medica_ted.dt_inicio_ref%type;
dt_fim_ref_w			pls_conta_medica_ted.dt_fim_ref%type;

--Cursor retorna os dados a serem inseridos na tabela pls_milliman
C01 CURSOR FOR
	SELECT	c.cd_usuario_plano 	nr_matricula_benef,
		a.nm_pessoa_fisica	nm_beneficiario,
		a.ie_sexo		ie_sexo,
		a.dt_nascimento		dt_nascimento,
		a.cd_pessoa_fisica	cd_pessoa_fisica,
		b.nr_seq_titular	nr_seq_titular,
		b.dt_contratacao	dt_ingresso,
		CASE WHEN e.ie_segmentacao='3' THEN  '1' WHEN e.ie_segmentacao='7' THEN  '2' WHEN e.ie_segmentacao='1' THEN  '3' WHEN e.ie_segmentacao='2' THEN  '4' WHEN e.ie_segmentacao='11' THEN  '5' WHEN e.ie_segmentacao='5' THEN  '6' WHEN e.ie_segmentacao='12' THEN  '7' WHEN e.ie_segmentacao='10' THEN  '8' WHEN e.ie_segmentacao='8' THEN  '9' WHEN e.ie_segmentacao='9' THEN  '10' WHEN e.ie_segmentacao='4' THEN  '11' WHEN e.ie_segmentacao='6' THEN  '12' END  ie_tipo_garantia,
		b.dt_rescisao		dt_saida,
		null			nm_lote,
		CASE WHEN coalesce(b.nr_seq_titular::text, '') = '' THEN  '1'  ELSE CASE WHEN b.nr_seq_parentesco=125 THEN '3'  ELSE '2' END  END 	ie_grau_dependencia,
		CASE WHEN e.ie_regulamentacao='R' THEN  e.cd_scpa  ELSE e.nr_protocolo_ans END 			cd_produto_ans,
		a.nr_cpf									nr_cpf,
		substr(d.nr_seq_cnae||' '||obter_desc_cnae(d.nr_seq_cnae),1,255)		cd_ramo_atividade,
		d.ds_razao_social								ds_razao_social,
		d.cd_cgc									nr_cnpj,
		h.cd_operadora_empresa								nr_matricula_pj,
		e.ie_tipo_contratacao								ie_tipo_contratacao
	from	pessoa_fisica		a,
		pls_segurado		b,
		pls_segurado_carteira	c,
		pls_contrato		h,
		pls_plano		e,
		pessoa_juridica		d
	where	a.cd_pessoa_fisica 	= b.cd_pessoa_fisica
	and	b.nr_sequencia 		= c.nr_seq_segurado
	and	h.nr_sequencia		= b.nr_seq_contrato
	and	b.nr_seq_plano		= e.nr_sequencia
	and	h.cd_cgc_estipulante	= d.cd_cgc
	and	b.ie_tipo_segurado	= 'B'
	and	e.ie_tipo_contratacao	in ('CE','CA')
	and	'PJ' = ie_tipo_pessoa_p
	and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
	and 	b.dt_contratacao <= dt_fim_ref_w
	and	((coalesce(b.dt_rescisao::text, '') = '') or (coalesce(b.dt_limite_utilizacao,b.dt_rescisao) >= dt_inicio_ref_w))
	
union all

	SELECT	c.cd_usuario_plano 	nr_matricula_benef,
		a.nm_pessoa_fisica	nm_beneficiario,
		a.ie_sexo		ie_sexo,
		a.dt_nascimento		dt_nascimento,
		a.cd_pessoa_fisica	cd_pessoa_fisica,
		b.nr_seq_titular	nr_seq_titular,
		b.dt_contratacao	dt_ingresso,
		CASE WHEN e.ie_segmentacao='3' THEN  '1' WHEN e.ie_segmentacao='7' THEN  '2' WHEN e.ie_segmentacao='1' THEN  '3' WHEN e.ie_segmentacao='2' THEN  '4' WHEN e.ie_segmentacao='11' THEN  '5' WHEN e.ie_segmentacao='5' THEN  '6' WHEN e.ie_segmentacao='12' THEN  '7' WHEN e.ie_segmentacao='10' THEN  '8' WHEN e.ie_segmentacao='8' THEN  '9' WHEN e.ie_segmentacao='9' THEN  '10' WHEN e.ie_segmentacao='4' THEN  '11' WHEN e.ie_segmentacao='6' THEN  '12' END  ie_tipo_garantia,
		b.dt_rescisao		dt_saida,
		null			nm_lote,
		CASE WHEN coalesce(b.nr_seq_titular::text, '') = '' THEN  '1'  ELSE CASE WHEN b.nr_seq_parentesco=125 THEN '3'  ELSE '2' END  END 	ie_grau_dependencia,
		CASE WHEN e.ie_regulamentacao='R' THEN  e.cd_scpa  ELSE e.nr_protocolo_ans END 			cd_produto_ans,
		a.nr_cpf									nr_cpf,
		null										cd_ramo_atividade,
		null										ds_razao_social,
		null										nr_cnpj,
		null										nr_matricula_pj,
		null										ie_tipo_contratacao
	from	pessoa_fisica		a,
		pls_segurado		b,
		pls_segurado_carteira	c,
		pls_contrato		h,
		pls_plano		e
	where	a.cd_pessoa_fisica 	= b.cd_pessoa_fisica
	and	b.nr_sequencia 		= c.nr_seq_segurado
	and	h.nr_sequencia		= b.nr_seq_contrato
	and	b.nr_seq_plano		= e.nr_sequencia
	and	b.ie_tipo_segurado	= 'B'
	and	e.ie_tipo_contratacao	= 'I'
	and	'PF' = ie_tipo_pessoa_p
	and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
	and 	b.dt_contratacao <= dt_fim_ref_w
	and	((coalesce(b.dt_rescisao::text, '') = '') or (coalesce(b.dt_limite_utilizacao,b.dt_rescisao) >= dt_inicio_ref_w));

BEGIN
--Limpa os registros contidos na tabela pls_milliman antes de gerar os novos registros para que não ocorra duplicidade de dados
delete	from pls_milliman
where	nr_seq_conta_med_ted	= nr_seq_conta_med_ted_p
and	nm_usuario		= nm_usuario_p;

select	dt_inicio_ref,
	dt_fim_ref
into STRICT	dt_inicio_ref_w,
	dt_fim_ref_w
from	pls_conta_medica_ted
where	nr_sequencia	= nr_seq_conta_med_ted_p;

open C01;
loop
fetch C01 into
	nr_matricula_benef_w,
	nm_beneficiario_w,
	ie_sexo_w,
	dt_nascimento_w,
	cd_pessoa_fisica_w,
	nr_seq_titular_w,
	dt_ingresso_w,
	ie_tipo_garantia_w,
	dt_saida_w,
	nm_lote_w,
	ie_grau_dependencia_w,
	cd_produto_ans_w,
	nr_cpf_w,
	cd_ramo_atividade_w,
	ds_razao_social_w,
	nr_cnpj_w,
	nr_matricula_pj_w,
	ie_tipo_contratacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	max(x.ds_municipio)
	into STRICT	nm_municipio_w
	from	compl_pessoa_fisica	x
	where	x.cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	x.ie_tipo_complemento	in (1,2)  LIMIT 1;

	if (nr_seq_titular_w IS NOT NULL AND nr_seq_titular_w::text <> '') then
		select	max(y.cd_usuario_plano)
		into STRICT	nr_matricula_titular_w
		from	pls_segurado_carteira	y,
			pls_segurado		x
		where	x.nr_sequencia 		= y.nr_seq_segurado
		and	x.nr_sequencia 		= nr_seq_titular_w;

		select	max(x.nr_cpf)
		into STRICT	nr_cpf_titular_w
		from	pessoa_fisica	x,
			pls_segurado	y
		where	x.cd_pessoa_fisica	= y.cd_pessoa_fisica
		and	y.nr_sequencia		= nr_seq_titular_w;
	else
		nr_matricula_titular_w	:= nr_matricula_benef_w;
		nr_cpf_titular_w	:= nr_cpf_w;
	end if;

	insert into pls_milliman(nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
		nr_seq_conta_med_ted,dt_nascimento,ie_sexo,nr_cpf,dt_ingresso,
		dt_saida,ie_grau_dependencia,ie_tipo_contrato,ie_tipo_garantia,nr_matricula_benef,
		nm_beneficiario,cd_produto_ans,nm_municipio,nr_matricula_titular,nm_lote,
		cd_ramo_atividade,ie_tipo_contratacao,nr_cpf_titular,nr_matricula_pj,nr_cnpj,
		ds_razao_social)
	values (nextval('pls_milliman_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
		nr_seq_conta_med_ted_p,dt_nascimento_w,ie_sexo_w,nr_cpf_w,dt_ingresso_w,
		dt_saida_w,ie_grau_dependencia_w,ie_tipo_pessoa_p,ie_tipo_garantia_w,nr_matricula_benef_w,
		nm_beneficiario_w,cd_produto_ans_w,nm_municipio_w,nr_matricula_titular_w,nm_lote_w,
		cd_ramo_atividade_w,ie_tipo_contratacao_w,nr_cpf_titular_w,nr_matricula_pj_w,nr_cnpj_w,
		ds_razao_social_w);
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_dados_milliman ( ie_tipo_pessoa_p text, nr_seq_conta_med_ted_p bigint, nm_usuario_p text, dt_ingresso_p timestamp) FROM PUBLIC;

