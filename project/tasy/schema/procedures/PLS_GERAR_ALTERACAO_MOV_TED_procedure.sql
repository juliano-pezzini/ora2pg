-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE reg_alteracao_ted AS (nm_tabela varchar(50), nm_atributo varchar(50));


CREATE OR REPLACE PROCEDURE pls_gerar_alteracao_mov_ted ( nr_seq_lote_mov_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


dt_referencia_inicial_w		timestamp;
dt_referencia_final_w		timestamp;
dt_contratacao_w		timestamp;
dt_nascimento_w			timestamp;
dt_admissao_w			timestamp;
dt_exclusao_w			timestamp;
dt_nascimento_mae_w		timestamp;

cd_cargo_w			bigint;
nr_seq_segurado_w		bigint;
nr_seq_titular_w		bigint;
nr_seq_vendedor_canal_w		bigint;
cd_operadora_empresa_w		bigint;
nr_seq_parentesco_w		bigint;
nr_seq_segurado_preco_w		bigint;
nr_seq_contrato_w		bigint;
nr_sequencial_familiar_w	bigint;
nr_seq_regra_ted_w		bigint;
nr_vetor_w			bigint;
qt_registros_w			bigint;
i				bigint;
qt_endereco_residencial_w	bigint;
qt_endereco_comercial_w		bigint;
vl_preco_beneficiario_w		double precision;
cd_declaracao_nasc_vivo_w	pessoa_fisica.cd_declaracao_nasc_vivo%type;
nr_seq_empresa_w		bigint;
nr_seq_pagador_empresa_w	bigint;

ie_situacao_benef_w		varchar(1);
ie_incide_lote_w		varchar(10);
cd_pessoa_fisica_w		varchar(10);
uf_w				compl_pessoa_fisica.sg_estado%type;
ie_estado_civil_w		varchar(10);
cd_matricula_familia_w		varchar(10);
ie_mes_cobranca_reajuste_w	varchar(10);
ie_possui_alteracao_w		varchar(10);
ie_erro_w			varchar(10);
nr_cpf_w			varchar(11);
nr_pis_pasep_w			varchar(11);
nr_identidade_w			varchar(15);
ds_complemento_w		varchar(15);
cep_w				varchar(15);
nr_telefone_w			varchar(15);
cd_cod_anterior_w		varchar(30);
cd_cod_anterior_titular_w	varchar(30);
cd_plano_w			varchar(20);
cd_usuario_plano_w		varchar(30);
ds_logradouro_w			varchar(50);
ds_bairro_w			varchar(50);
cd_municipio_w			varchar(50);
ds_municipio_w			varchar(50);
nm_tabela_w			varchar(50);
nm_atributo_w			varchar(50);
nm_mae_segurado_w		varchar(255);
ds_email_w			varchar(255);
nm_segurado_w			varchar(255);
ie_sexo_w			varchar(255);
ds_plano_w			varchar(255);
nr_seq_titular_ww		pls_segurado.nr_seq_titular%type;
ie_titularidade_w		pls_lote_mov_benef.ie_titularidade%type;
ie_regulamentacao_w		pls_plano.ie_regulamentacao%type;
ie_segmentacao_w		pls_plano.ie_segmentacao%type;
nr_seq_pagador_w		bigint;
nr_endereco_w			compl_pessoa_fisica.nr_endereco%type;
nr_seq_plano_w			pls_plano.nr_sequencia%type;
ie_tipo_segurado_w		pls_segurado.ie_tipo_segurado%type;
ie_pcmso_w			pls_segurado.ie_pcmso%type;
nr_seq_contrato_ww		pls_segurado.nr_seq_contrato%type;
nr_seq_grupo_contratual_w	pls_grupo_contrato.nr_sequencia%type;
cd_pf_estipulante_w		pls_contrato.cd_pf_estipulante%type;
type vetor is table of reg_alteracao_ted index by integer;
vetor_w				vetor;

c01 CURSOR FOR
	SELECT 	a.nr_sequencia,
		a.cd_pessoa_fisica,
		a.nr_seq_titular,
		a.nr_seq_pagador,
		a.ie_tipo_segurado,
		a.ie_pcmso,
		a.nr_seq_contrato,
		b.cd_pf_estipulante
	from   	pls_segurado a,
		pls_contrato b
	where  	a.nr_seq_contrato = b.nr_sequencia
	and 	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	trunc(a.dt_contratacao,'month') <> dt_referencia_inicial_w
	and	((trunc(a.dt_contratacao,'month') <> trunc(a.dt_rescisao,'month') and (a.dt_rescisao IS NOT NULL AND a.dt_rescisao::text <> '')) or coalesce(a.dt_rescisao::text, '') = '')
	and (trunc(a.dt_rescisao,'dd') >= trunc(dt_referencia_inicial_w,'dd') or (coalesce(a.dt_rescisao::text, '') = ''))
	and	((b.nr_sequencia		= nr_seq_contrato_w) or (coalesce(nr_seq_contrato_w::text, '') = ''))
	and	((a.nr_seq_vendedor_canal	= nr_seq_vendedor_canal_w) or (coalesce(nr_seq_vendedor_canal_w::text, '') = ''))
	and	((a.cd_operadora_empresa	= cd_operadora_empresa_w) or (coalesce(cd_operadora_empresa_w::text, '') = ''))
	and	exists (	SELECT	1
				from	tasy_log_alteracao		x
				where	x.nm_tabela			= 'PESSOA_FISICA'
				and	x.ds_chave_simples		= a.cd_pessoa_fisica
				and	trunc(x.dt_atualizacao,'dd') between dt_referencia_inicial_w and dt_referencia_final_w
				
union

				select	1
				from	COMPL_PESSOA_FISICA_HIST	x
				where	x.cd_pessoa_fisica		= a.cd_pessoa_fisica
				and	x.IE_TIPO_COMPLEMENTO		in (1,2)
				and	trunc(x.DT_ATUALIZACAO_NREC,'dd') between dt_referencia_inicial_w and dt_referencia_final_w)
	and	((ie_situacao_benef_w	= 'T') or (ie_situacao_benef_w	= 'A' and (coalesce(a.dt_rescisao::text, '') = '' or a.dt_rescisao > clock_timestamp())) or (ie_situacao_benef_w	= 'I' and a.dt_rescisao < clock_timestamp()))
	order by CASE WHEN coalesce(nr_seq_titular::text, '') = '' THEN -1  ELSE 1 END;

C02 CURSOR FOR
	SELECT	nm_tabela,
		nm_atributo
	from	pls_ted_regra_alt_benef
	where	nr_seq_regra_ted	= nr_seq_regra_ted_w;


BEGIN

select	trunc(dt_periodo_inicial,'dd'),
	trunc(dt_periodo_final,'dd'),
	nr_seq_contrato,
	nr_seq_vendedor_canal,
	cd_operadora_empresa,
	nr_seq_regra_ted,
	coalesce(ie_situacao_benef,'T'),
	coalesce(ie_titularidade,'A'),
	nr_seq_empresa
into STRICT	dt_referencia_inicial_w,
	dt_referencia_final_w,
	nr_seq_contrato_w,
	nr_seq_vendedor_canal_w,
	cd_operadora_empresa_w,
	nr_seq_regra_ted_w,
	ie_situacao_benef_w,
	ie_titularidade_w,
	nr_seq_empresa_w
from	pls_lote_mov_benef
where	nr_sequencia	= nr_seq_lote_mov_p;

select	count(1)
into STRICT	qt_registros_w
from	pls_ted_regra_mov_incid
where	nr_seq_regra_ted	= nr_seq_regra_ted_w  LIMIT 1;


select	coalesce(ie_mes_cobranca_reaj,'P')
into STRICT	ie_mes_cobranca_reajuste_w
from	pls_parametros
where	cd_estabelecimento	= cd_estabelecimento_p;

open C02;
loop
fetch C02 into
	nm_tabela_w,
	nm_atributo_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin

	nr_vetor_w	:= vetor_w.count+1;
	vetor_w[nr_vetor_w].nm_tabela	:= nm_tabela_w;
	vetor_w[nr_vetor_w].nm_atributo	:= nm_atributo_w;

	end;
end loop;
close C02;

if (vetor_w.count > 0) then
	open c01;
	loop
	fetch c01 into
		nr_seq_segurado_w,
		cd_pessoa_fisica_w,
		nr_seq_titular_ww,
		nr_seq_pagador_w,
		ie_tipo_segurado_w,
		ie_pcmso_w,
		nr_seq_contrato_ww,
		cd_pf_estipulante_w;

	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		/*Restrição pela titularidade, verificar o campo nr_seq_titular quando houver restrição de titularidade na geraçãdo de mov do TED
		drquadros O.S - 647711 */
		if (ie_titularidade_w = 'A')		or
			((ie_titularidade_w = 'T') 		and (coalesce(nr_seq_titular_ww::text, '') = ''))	or
			(ie_titularidade_w = 'D' AND nr_seq_titular_ww IS NOT NULL AND nr_seq_titular_ww::text <> '')	then

			if (nr_seq_empresa_w IS NOT NULL AND nr_seq_empresa_w::text <> '') then
				select	max(a.nr_seq_empresa)
				into STRICT	nr_seq_pagador_empresa_w
				from	pls_contrato_pagador_fin	a
				where	a.nr_seq_pagador	= nr_seq_pagador_w
				and	a.dt_inicio_vigencia	= (	SELECT	max(x.dt_inicio_vigencia)
									from	pls_contrato_pagador_fin	x
									where	x.nr_seq_pagador	= a.nr_seq_pagador);

				if (coalesce(nr_seq_pagador_empresa_w,0)	<> nr_seq_empresa_w) then
					goto final;
				end if;
			end if;

			i			:= 0;
			ie_possui_alteracao_w	:= 'N';
			ie_erro_w		:= 'N';

			for i in 1..vetor_w.count loop
				if (vetor_w[i].nm_tabela	= 'PESSOA_FISICA') then
					select	count(1)
					into STRICT	qt_registros_w
					from	tasy_log_alteracao b,
						tasy_log_alt_campo a
					where	a.nr_seq_log_alteracao	= b.nr_sequencia
					and	b.nm_tabela		= 'PESSOA_FISICA'
					AND	a.nm_atributo		= vetor_w[i].nm_atributo
					and	trunc(b.dt_atualizacao,'dd') between dt_referencia_inicial_w and dt_referencia_final_w
					and	b.ds_chave_simples		= cd_pessoa_fisica_w;

					if (qt_registros_w	> 0) then
						ie_possui_alteracao_w	:= 'S';
						exit;
					end if;
				elsif (vetor_w[i].nm_tabela	= 'COMPL_PESSOA_FISICA') then
					select	count(1)
					into STRICT	qt_registros_w
					from	tasy_log_alteracao b,
						tasy_log_alt_campo a
					where	a.nr_seq_log_alteracao	= b.nr_sequencia
					and	b.nm_tabela		= 'COMPL_PESSOA_FISICA'
					AND	a.nm_atributo		= vetor_w[i].nm_atributo
					and	trunc(b.dt_atualizacao,'dd') between dt_referencia_inicial_w and dt_referencia_final_w
					and	b.ds_chave_composta like '%CD_PESSOA_FISICA=' || cd_pessoa_fisica_w;

					if (qt_registros_w	> 0) then
						ie_possui_alteracao_w	:= 'S';
						exit;
					end if;
				END IF;
			end loop;
			if (ie_possui_alteracao_w	= 'S') then
				cd_cod_anterior_titular_w	:= '';

				begin
				select	b.nm_pessoa_fisica,
					b.dt_nascimento,
					b.ie_sexo,
					b.nr_identidade,
					a.nr_seq_titular,
					b.ie_estado_civil,
					b.nr_cpf,
					a.cd_cod_anterior,
					a.dt_contratacao,
					a.nr_seq_parentesco,
					c.nr_sequencia,
					a.cd_matricula_familia,
					b.cd_cargo,
					b.nr_pis_pasep,
					b.cd_declaracao_nasc_vivo,
					c.ds_plano,
					d.cd_usuario_plano,
					a.dt_rescisao,
					c.ie_regulamentacao,
					c.ie_segmentacao
				into STRICT	nm_segurado_w,
					dt_nascimento_w,
					ie_sexo_w,
					nr_identidade_w,
					nr_seq_titular_w,
					ie_estado_civil_w,
					nr_cpf_w,
					cd_cod_anterior_w,
					dt_contratacao_w,
					nr_seq_parentesco_w,
					nr_seq_plano_w,
					cd_matricula_familia_w,
					cd_cargo_w,
					nr_pis_pasep_w,
					cd_declaracao_nasc_vivo_w,
					ds_plano_w,
					cd_usuario_plano_w,
					dt_exclusao_w,
					ie_regulamentacao_w,
					ie_segmentacao_w
				from   	pessoa_fisica		b,
					pls_segurado 		a,
					pls_segurado_carteira	d,
					pls_plano		c
				where  	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
				and	d.nr_seq_segurado	= a.nr_sequencia
				and	a.nr_seq_plano		= c.nr_sequencia
				and	a.nr_sequencia		= nr_seq_segurado_w;
				exception
				when others then
					ie_erro_w	:= 'S';
				end;

				if (ie_erro_w = 'S') then
					goto final;
				end if;

				select	max(dt_admissao)
				into STRICT	dt_admissao_w
				from	pls_segurado_compl
				where	nr_seq_segurado		= nr_seq_segurado_w;

				if (nr_seq_titular_w IS NOT NULL AND nr_seq_titular_w::text <> '') then
					select	cd_cod_anterior
					into STRICT	cd_cod_anterior_titular_w
					from	pls_segurado
					where	nr_sequencia	= nr_seq_titular_w;

					select	max(nr_sequencial_familia)
					into STRICT	nr_sequencial_familiar_w
					from	pls_movimentacao_benef
					where	nr_seq_lote	= nr_seq_lote_mov_p
					and	nr_seq_segurado	= nr_seq_titular_w;

					if (coalesce(nr_sequencial_familiar_w::text, '') = '') then
						select	max(nr_sequencial_familia)
						into STRICT	nr_sequencial_familiar_w
						from	pls_movimentacao_benef
						where	nr_seq_lote	= nr_seq_lote_mov_p
						and	nr_seq_titular	= nr_seq_titular_w;

						if (coalesce(nr_sequencial_familiar_w::text, '') = '') then
							select	max(nr_sequencial_familia)
							into STRICT	nr_sequencial_familiar_w
							from	pls_movimentacao_benef
							where	nr_seq_lote	= nr_seq_lote_mov_p;

							if (coalesce(nr_sequencial_familiar_w::text, '') = '') then
								nr_sequencial_familiar_w	:= 0;
							end if;

							nr_sequencial_familiar_w	:= nr_sequencial_familiar_w +1;
						end if;
					end if;
				else
					select	max(nr_sequencial_familia)
					into STRICT	nr_sequencial_familiar_w
					from	pls_movimentacao_benef
					where	nr_seq_lote	= nr_seq_lote_mov_p;

					if (coalesce(nr_sequencial_familiar_w::text, '') = '') then
						nr_sequencial_familiar_w	:= 0;
					end if;

					nr_sequencial_familiar_w	:= nr_sequencial_familiar_w +1;
				end if;

				select	count(*)
				into STRICT	qt_endereco_residencial_w
				from	compl_pessoa_fisica
				where	cd_pessoa_fisica	= cd_pessoa_fisica_w
				and	ie_tipo_complemento	= 1
				and	(cd_cep IS NOT NULL AND cd_cep::text <> '')
				and	(ds_endereco IS NOT NULL AND ds_endereco::text <> '')
				and	(sg_estado IS NOT NULL AND sg_estado::text <> '');

				if (qt_endereco_residencial_w > 0) then
					begin
					select	substr(b.ds_endereco,1,30),
						substr(b.ds_complemento,1,15),
						substr(b.ds_bairro,1,20),
						substr(b.cd_municipio_ibge,1,10),
						substr(b.sg_estado,1,5),
						lpad(b.cd_cep,8,'0'),
						b.ds_email,
						coalesce(b.nr_endereco, b.ds_compl_end) nr_endereco
					into STRICT	ds_logradouro_w,
						ds_complemento_w,
						ds_bairro_w,
						cd_municipio_w,
						uf_w,
						cep_w,
						ds_email_w,
						nr_endereco_w
					from	pessoa_fisica a,
						compl_pessoa_fisica b
					where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
					and	a.cd_pessoa_fisica	= cd_pessoa_fisica_w
					and	b.ie_tipo_complemento	= 1  LIMIT 1;
					exception
					when others then
						ds_logradouro_w		:= '';
						ds_complemento_w	:= '';
						ds_bairro_w		:= '';
						cd_municipio_w		:= '';
						uf_w			:= '';
						cep_w			:= '00000000';
					end;
				else
					select	count(*)
					into STRICT	qt_endereco_comercial_w
					from	compl_pessoa_fisica
					where	cd_pessoa_fisica	= cd_pessoa_fisica_w
					and	ie_tipo_complemento	= 2;

					if (qt_endereco_comercial_w > 0) then
						begin
						select	substr(b.ds_endereco,1,30),
							substr(b.ds_complemento,1,15),
							substr(b.ds_bairro,1,20),
							substr(b.cd_municipio_ibge,1,10),
							substr(b.sg_estado,1,5),
							lpad(b.cd_cep,8,'0'),
							b.ds_email,
							coalesce(b.nr_endereco, b.ds_compl_end) nr_endereco
						into STRICT	ds_logradouro_w,
							ds_complemento_w,
							ds_bairro_w,
							cd_municipio_w,
							uf_w,
							cep_w,
							ds_email_w,
							nr_endereco_w
						from	pessoa_fisica a,
							compl_pessoa_fisica b
						where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
						and	a.cd_pessoa_fisica	= cd_pessoa_fisica_w
						and	b.ie_tipo_complemento	= 2  LIMIT 1;
						exception
						when others then
							ds_logradouro_w		:= '';
							ds_complemento_w	:= '';
							ds_bairro_w		:= '';
							cd_municipio_w		:= '';
							uf_w			:= '';
							cep_w			:= '00000000';
						end;
					end if;
				end if;

				select	pls_dados_grupo_relac_contr(nr_seq_contrato_ww,'S')
				into STRICT	nr_seq_grupo_contratual_w
				;

				ie_incide_lote_w	:= 'S';

				if (qt_registros_w > 0) then
					ie_incide_lote_w := pls_obter_incind_mov_benef_ted(nr_seq_regra_ted_w, cd_municipio_w, ie_regulamentacao_w, ie_segmentacao_w, nr_seq_plano_w, nr_seq_contrato_w, ie_tipo_segurado_w, ie_pcmso_w, nr_seq_grupo_contratual_w, cd_pf_estipulante_w, ie_incide_lote_w);
					if (ie_incide_lote_w = 'N') then
						goto final;
					end if;
				end if;

				cep_w	:= replace(cep_w,'-','');
				cep_w	:= replace(cep_w,'.','');

				begin
				ds_municipio_w	:= substr(obter_desc_municipio_ibge(cd_municipio_w),1,50);
				exception
				when others then
					ds_municipio_w	:= '';
				end;

				select	max(a.nr_sequencia)
				into STRICT	nr_seq_segurado_preco_w
				from	pls_segurado_preco	a,
					pls_segurado		b
				where	a.nr_seq_segurado	= b.nr_sequencia
				and	b.nr_sequencia		= nr_seq_segurado_w
				and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
				and	coalesce(a.ie_situacao,'A')	= 'A'
				and	(((dt_referencia_inicial_w >= trunc(a.dt_reajuste, 'month')) and ((a.cd_motivo_reajuste	<> 'E') or (ie_mes_cobranca_reajuste_w = 'M')))
					or	(((a.cd_motivo_reajuste	= 'E') and (dt_referencia_inicial_w >= trunc(add_months(a.dt_reajuste,1), 'month'))) and (ie_mes_cobranca_reajuste_w = 'P')));

				if (nr_seq_segurado_preco_w IS NOT NULL AND nr_seq_segurado_preco_w::text <> '') then
					select	coalesce(vl_preco_atual,0) - coalesce(vl_desconto,0)
					into STRICT	vl_preco_beneficiario_w
					from	pls_segurado_preco
					where	nr_sequencia	= nr_seq_segurado_preco_w;
				end if;

				select	max(a.nm_pessoa_fisica),
					max(a.dt_nascimento)
				into STRICT	nm_mae_segurado_w,
					dt_nascimento_mae_w
				from	pessoa_fisica a,
					compl_pessoa_fisica b
				where	b.cd_pessoa_fisica_ref	= a.cd_pessoa_fisica
				and	b.ie_tipo_complemento	= 5
				and	b.cd_pessoa_fisica	= cd_pessoa_fisica_w;

				if (coalesce(nm_mae_segurado_w::text, '') = '') then
					select	max(a.nm_contato)
					into STRICT	nm_mae_segurado_w
					from	compl_pessoa_fisica a
					where	a.cd_pessoa_fisica	= cd_pessoa_fisica_w
					and	a.ie_tipo_complemento	= 5;
				end if;

				/* Alterado para obter o telefone sem parentêses no DDD
				nr_telefone_w	:= substr(obter_telefone_pf(cd_pessoa_fisica_w,4),1,15);  */
				select	lpad(max(a.nr_ddd_telefone),4,' ') || rpad(substr(elimina_caracteres_especiais(max(a.nr_telefone)),1,11),11,' ')
				into STRICT	nr_telefone_w
				from	compl_pessoa_fisica a
				where	a.cd_pessoa_fisica = cd_pessoa_fisica_w
				and	a.ie_tipo_complemento = 1;

				insert into pls_movimentacao_benef(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
						nr_seq_lote,nr_seq_segurado,ie_tipo_movimentacao,ds_endereco,cd_cep,
						ds_complemento,ds_bairro,ds_municipio,sg_estado,nr_telefone,
						dt_nascimento,ie_sexo,ie_estado_civil,nr_cpf,nr_identidade,
						nr_seq_titular,nm_beneficiario,cd_cod_anterior,dt_contratacao,cd_cod_anterior_titular,
						nr_seq_parentesco,vl_preco_segurado,nm_mae,cd_plano,cd_matricula_familia,
						nr_sequencial_familia,dt_nascimento_mae,ds_email,cd_cargo,nr_pis_pasep,
						cd_declaracao_nasc_vivo,dt_admissao,cd_usuario_plano,ds_plano,dt_rescisao,
						nr_endereco)
				values (	nextval('pls_movimentacao_benef_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
						nr_seq_lote_mov_p,nr_seq_segurado_w,'A',ds_logradouro_w,cep_w,
						ds_complemento_w,ds_bairro_w,ds_municipio_w,uf_w,nr_telefone_w,
						dt_nascimento_w,ie_sexo_w,ie_estado_civil_w,nr_cpf_w,nr_identidade_w,
						nr_seq_titular_w,nm_segurado_w,cd_cod_anterior_w,dt_contratacao_w,cd_cod_anterior_titular_w,
						nr_seq_parentesco_w,vl_preco_beneficiario_w,nm_mae_segurado_w,nr_seq_plano_w,cd_matricula_familia_w,
						nr_sequencial_familiar_w,dt_nascimento_mae_w,ds_email_w,cd_cargo_w,nr_pis_pasep_w,
						cd_declaracao_nasc_vivo_w,dt_admissao_w,cd_usuario_plano_w,ds_plano_w,dt_exclusao_w,
						nr_endereco_w);
			end if;
			<<final>>
			nr_seq_segurado_w	:= nr_seq_segurado_w;
		end if;
		end;
	end loop;
	close c01;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_alteracao_mov_ted ( nr_seq_lote_mov_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

