-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_proposta_mig_gerar_benef ( nr_seq_proposta_p bigint, nr_seq_beneficiario_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
cd_pessoa_fisica_w		varchar(10);
nr_seq_plano_w			bigint;
nr_seq_tabela_w			bigint;
nr_seq_pagador_w		bigint;
ie_preco_w			bigint;
ds_plano_w			varchar(255);
nr_seq_titular_w		bigint;
cd_pessoa_fisica_tit_w		varchar(10);
nr_seq_titular_proposta_w	bigint;
nr_seq_motivo_inclusao_w	bigint;
cd_estabelecimento_w		bigint;
qt_registros_w			bigint;
qt_benef_titular_w		bigint;
nr_contrato_existente_w		bigint;
nr_seq_titular_contrato_w	bigint;
nr_seq_plano_sca_w		bigint;
nr_seq_tabela_sca_w		bigint;
nr_seq_vendedor_canal_w		bigint;
nr_seq_vendedor_pf_w		bigint;
nr_seq_proposta_benef_w		bigint;
ds_erro_sca_w			varchar(4000);
nr_seq_parentesco_w		bigint;
ie_tipo_parentesco_w		varchar(3);
nr_seq_causa_rescisao_w		bigint;
nr_seq_benef_depend_w		bigint;
nr_seq_benef_prop_depen_w	bigint;
dt_inicio_proposta_w		timestamp;

C01 CURSOR FOR 
	SELECT	nr_seq_plano, 
		nr_seq_tabela, 
		nr_seq_vendedor_canal, 
		nr_seq_vendedor_pf 
	from	pls_sca_regra_contrato	b, 
		pls_contrato		a 
	where	b.nr_seq_contrato	= a.nr_sequencia 
	and	a.nr_contrato		= nr_contrato_existente_w 
	and	((b.nr_seq_plano_benef	= nr_seq_plano_w) or (coalesce(nr_seq_plano_benef::text, '') = '')) 
	and	dt_inicio_proposta_w between coalesce(dt_inicio_vigencia,dt_inicio_proposta_w) and fim_dia(coalesce(dt_fim_vigencia,dt_inicio_proposta_w));

C02 CURSOR FOR 
	SELECT	b.nr_seq_beneficiario, 
		b.nr_sequencia 
	from	pls_proposta_beneficiario	b 
	where	b.nr_seq_proposta	= nr_seq_proposta_p 
	and	b.cd_beneficiario	in (	SELECT	X.CD_PESSOA_FISICA 
							from	pls_segurado	x 
							where	x.nr_seq_titular	= nr_seq_beneficiario_p);


BEGIN 
 
select	cd_pessoa_fisica, 
	nr_seq_titular 
into STRICT	cd_pessoa_fisica_w, 
	nr_seq_titular_w 
from	pls_segurado 
where	nr_sequencia	= nr_seq_beneficiario_p;
 
select	cd_estabelecimento, 
	nr_seq_contrato, 
	dt_inicio_proposta 
into STRICT	cd_estabelecimento_w, 
	nr_contrato_existente_w, 
	dt_inicio_proposta_w 
from	pls_proposta_adesao 
where	nr_sequencia	= nr_seq_proposta_p;
 
begin 
nr_seq_causa_rescisao_w	:= coalesce(obter_valor_param_usuario(1232, 81, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_w), 'N');
exception 
when others then 
	nr_seq_causa_rescisao_w	:= null;
end;
 
--Buscar o titular do beneficiário da proposta 
if (nr_seq_titular_w IS NOT NULL AND nr_seq_titular_w::text <> '') then 
	select	max(cd_pessoa_fisica) 
	into STRICT	cd_pessoa_fisica_tit_w 
	from	pls_segurado 
	where	nr_sequencia	= nr_seq_titular_w;
 
	if (cd_pessoa_fisica_tit_w IS NOT NULL AND cd_pessoa_fisica_tit_w::text <> '') then 
		select	max(nr_sequencia) 
		into STRICT	nr_seq_titular_proposta_w 
		from	pls_proposta_beneficiario 
		where	nr_seq_proposta 	= nr_seq_proposta_p 
		and	cd_beneficiario 	= cd_pessoa_fisica_tit_w;
	end if;
end if;
 
/*aaschlote 01/10/2011 OS - 368210*/
 
if (coalesce(nr_seq_titular_proposta_w::text, '') = '') and (nr_contrato_existente_w IS NOT NULL AND nr_contrato_existente_w::text <> '') then 
 
	select	count(*) 
	into STRICT	qt_benef_titular_w 
	from	pls_segurado		b, 
		pls_contrato		a 
	where	b.nr_seq_contrato	= a.nr_sequencia 
	and	a.nr_contrato		= nr_contrato_existente_w 
	and 	(a.cd_pf_estipulante IS NOT NULL AND a.cd_pf_estipulante::text <> '') /* acstapassoli 23/12/2014 - validar somente para contratos PF - OS - 827423 */
 
	and	coalesce(b.nr_seq_titular::text, '') = '' 
	and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '');
 
	if (qt_benef_titular_w = 1) then 
		select	max(b.nr_sequencia) 
		into STRICT	nr_seq_titular_contrato_w 
		from	pls_segurado		b, 
			pls_contrato		a 
		where	b.nr_seq_contrato	= a.nr_sequencia 
		and	a.nr_contrato		= nr_contrato_existente_w		 
		and	coalesce(b.nr_seq_titular::text, '') = '' 
		and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '');
	end if;
end if;
 
/*aaschlote 27/02/2012 OS - 416505*/
 
if (nr_seq_titular_proposta_w IS NOT NULL AND nr_seq_titular_proposta_w::text <> '') or (nr_seq_titular_contrato_w IS NOT NULL AND nr_seq_titular_contrato_w::text <> '') then 
	select	max(nr_seq_parentesco) 
	into STRICT	nr_seq_parentesco_w 
	from	pls_segurado 
	where	nr_sequencia	= nr_seq_beneficiario_p;
 
	if (nr_seq_parentesco_w IS NOT NULL AND nr_seq_parentesco_w::text <> '') then 
		select	ie_tipo_parentesco 
		into STRICT	ie_tipo_parentesco_w 
		from	grau_parentesco 
		where	nr_sequencia	= nr_seq_parentesco_w;
	end if;
end if;
 
/*OS 295470 - Diego - Se haver somente um plano ou uma tabela ou pagador inseri-los com o beneficiario*/
 
 
--Se houver somente um pagador é inserido este com o benefi. Senão entra no excpetion. 
begin 
select	nr_sequencia 
into STRICT	nr_seq_pagador_w 
from	pls_proposta_pagador 
where	nr_seq_proposta = nr_seq_proposta_p;
exception 
when others then 
	nr_seq_pagador_w := null;
end;
 
--Se houver somente um plano é inserido este com o benefi. Senão entra no excpetion. 
begin 
select	a.nr_seq_plano, 
	b.ie_preco, 
	b.ds_plano 
into STRICT	nr_seq_plano_w, 
	ie_preco_w, 
	ds_plano_w 
from	pls_proposta_plano a, 
	pls_plano b 
where	a.nr_seq_plano = b.nr_sequencia 
and	a.nr_seq_proposta = nr_seq_proposta_p 
group by a.nr_seq_plano, 
	 b.ie_preco, 
	 b.ds_plano;
exception 
when others then 
	nr_seq_plano_w	:= null;
	ie_preco_w	:= null;
end;
 
--Realizado a verificação separadamente pois existindo somente um produto mas duas ou mais tabelas o produto ainda pode ser inserido 
if (coalesce(nr_seq_plano_w,0) <> 0) then 
	begin 
	select	nr_seq_tabela 
	into STRICT	nr_seq_tabela_w 
	from	pls_proposta_plano 
	where	nr_seq_proposta = nr_seq_proposta_p 
	group by nr_seq_tabela;
	exception 
	when others then 
		nr_seq_tabela_w	:= null;
	end;
end if;
 
select	coalesce(max(nr_seq_motivo_migracao), max(nr_seq_motivo_inclusao)) 
into STRICT	nr_seq_motivo_inclusao_w 
from	pls_parametros 
where	cd_estabelecimento	= cd_estabelecimento_w;
 
--Se o produto for preestabelecido e não houver tabela não é inserido 
if (coalesce(ie_preco_w,0) = 1) and (coalesce(nr_seq_tabela_w,0) = 0) then 
	CALL WHEB_MENSAGEM_PCK.exibir_mensagem_abort(176934,'DS_PLANO='||ds_plano_w);
end if;
 
select	count(*) 
into STRICT	qt_registros_w 
from	pls_proposta_beneficiario 
where	nr_seq_proposta	= nr_seq_proposta_p 
and	cd_beneficiario	= cd_pessoa_fisica_w;
 
if (qt_registros_w = 0) then 
 
	select	nextval('pls_proposta_beneficiario_seq') 
	into STRICT	nr_seq_proposta_benef_w 
	;
 
	 
	insert into pls_proposta_beneficiario(nr_sequencia, nr_seq_proposta, cd_beneficiario, 
		dt_atualizacao, nm_usuario, dt_atualizacao_nrec, 
		nm_usuario_nrec, nr_seq_beneficiario, ie_nascido_plano, 
		nr_seq_plano, nr_seq_tabela, nr_seq_pagador,nr_seq_titular,ie_taxa_inscricao, 
		nr_seq_motivo_inclusao,nr_seq_titular_contrato,nr_seq_parentesco, 
		ie_tipo_parentesco,nr_seq_causa_rescisao, ie_copiar_sca_plano) 
	values (	nr_seq_proposta_benef_w, nr_seq_proposta_p, cd_pessoa_fisica_w, 
		clock_timestamp(), nm_usuario_p, clock_timestamp(), 
		nm_usuario_p, nr_seq_beneficiario_p, 'N', 
		nr_seq_plano_w, nr_seq_tabela_w, nr_seq_pagador_w,nr_seq_titular_proposta_w,'S', 
		nr_seq_motivo_inclusao_w,nr_seq_titular_contrato_w,nr_seq_parentesco_w, 
		ie_tipo_parentesco_w,nr_seq_causa_rescisao_w, 'S');
 
	open C01;
	loop 
	fetch C01 into 
		nr_seq_plano_sca_w, 
		nr_seq_tabela_sca_w, 
		nr_seq_vendedor_canal_w, 
		nr_seq_vendedor_pf_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
 
		ds_erro_sca_w := pls_consistir_sca_proposta(nr_seq_proposta_benef_w, nr_seq_plano_sca_w, nr_seq_tabela_sca_w, cd_estabelecimento_w, ds_erro_sca_w, nm_usuario_p);
 
		if (coalesce(ds_erro_sca_w::text, '') = '') then 
			insert into pls_sca_vinculo(	nr_sequencia,dt_atualizacao, nm_usuario, dt_atualizacao_nrec,nm_usuario_nrec, 
					nr_seq_benef_proposta,nr_seq_plano,nr_seq_tabela,nr_seq_vendedor_canal,nr_seq_vendedor_pf) 
			values (	nextval('pls_sca_vinculo_seq'),clock_timestamp(), nm_usuario_p, clock_timestamp(),nm_usuario_p, 
					nr_seq_proposta_benef_w,nr_seq_plano_sca_w,nr_seq_tabela_sca_w,nr_seq_vendedor_canal_w,nr_seq_vendedor_pf_w);
		end if;
		end;
	end loop;
	close C01;
 
	/*aaschlote 30/11/2012 - OS - 523648 - Caso os dependentes já estão na proposta, então atualiza seu titular*/
 
	if (coalesce(nr_seq_titular_w::text, '') = '') then 
		open C02;
		loop 
		fetch C02 into 
			nr_seq_benef_depend_w, 
			nr_seq_benef_prop_depen_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin 
 
			select	max(nr_seq_parentesco) 
			into STRICT	nr_seq_parentesco_w 
			from	pls_segurado 
			where	nr_sequencia	= nr_seq_benef_depend_w;
 
			if (nr_seq_parentesco_w IS NOT NULL AND nr_seq_parentesco_w::text <> '') then 
				select	ie_tipo_parentesco 
				into STRICT	ie_tipo_parentesco_w 
				from	grau_parentesco 
				where	nr_sequencia	= nr_seq_parentesco_w;
			end if;
 
			update	pls_proposta_beneficiario 
			set	nr_seq_titular		= nr_seq_proposta_benef_w, 
				nr_seq_parentesco	= nr_seq_parentesco_w, 
				ie_tipo_parentesco	= ie_tipo_parentesco_w 
			where	nr_sequencia		= nr_seq_benef_prop_depen_w;
 
			end;
		end loop;
		close C02;
	end if;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_proposta_mig_gerar_benef ( nr_seq_proposta_p bigint, nr_seq_beneficiario_p bigint, nm_usuario_p text) FROM PUBLIC;
