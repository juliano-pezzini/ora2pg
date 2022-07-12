-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_simulacao_preco_insert ON pls_simulacao_preco CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_simulacao_preco_insert() RETURNS trigger AS $BODY$
declare

nr_sequencia_w		bigint;
vl_ddd_w		varchar(3);
vl_ddi_w		varchar(3);

BEGIN

nr_sequencia_w	:= nr_sequencia_w;

/* Conforme solicitado pelo Adriano não é para gerar uma solicitação de lead sempre quando for apenas feita uma simulação de preço
if	(upper(:new.nm_usuario) = 'OPS - PORTAL') then

	Obter_Param_Usuario(1237,1,obter_perfil_ativo,:new.nm_usuario,:new.cd_estabelecimento,vl_ddd_w);

	Obter_Param_Usuario(1237,2,obter_perfil_ativo,:new.nm_usuario,:new.cd_estabelecimento,vl_ddi_w);

	select	pls_solicitacao_comercial_seq.nextval
	into	nr_sequencia_w
	from	dual;

	insert into pls_solicitacao_comercial(
		nr_sequencia, cd_estabelecimento, ie_status,
		nm_pessoa_fisica, dt_nascimento, nr_telefone,
		dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
		nm_usuario_nrec, ds_email, nr_seq_simul_preco,
		dt_solicitacao, ie_origem_solicitacao, ie_tipo_contratacao,
		nr_cpf, cd_cgc, nr_ddi,
		nr_ddd, cd_nacionalidade, sg_uf_municipio,
		cd_municipio_ibge)
	values	(nr_sequencia_w, :new.cd_estabelecimento, 'PE',
		:new.nm_pessoa, :new.dt_nascimento, :new.nr_telefone,
		sysdate, :new.nm_usuario, sysdate,
		:new.nm_usuario, :new.ds_email, :new.nr_sequencia,
		nvl(:new.dt_simulacao,sysdate), 'W', null,
		null, null, :new.nr_ddi,
		:new.nr_ddd, '10', :new.sg_estado,
		:new.cd_municipio_ibge);
end if;

*/
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_simulacao_preco_insert() FROM PUBLIC;

CREATE TRIGGER pls_simulacao_preco_insert
	AFTER INSERT ON pls_simulacao_preco FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_simulacao_preco_insert();

