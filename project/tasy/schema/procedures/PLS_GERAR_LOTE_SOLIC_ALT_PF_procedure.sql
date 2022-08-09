-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_lote_solic_alt_pf ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Gerar os dados no lote com as solicitação de alteração
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [X ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_chave_composta_w		varchar(500);
ds_chave_simples_w      	varchar(255);
nm_usuario_filtro_w		varchar(15);
cd_pessoa_fisica_w		varchar(10);
ie_beneficiario_solic_w		varchar(10);
ie_pagador_solic_w		varchar(10);
ie_estipulante_solic_w		varchar(10);
ie_prestador_solic_w		varchar(10);
ie_cooperado_solic_w		varchar(10);
ie_pessoa_benef_w		varchar(10);
ie_pessoa_pag_w			varchar(10);
ie_pessoa_estip_w		varchar(10);
ie_pessoa_pres_w		varchar(10);
ie_pessoa_coop_w		varchar(10);
ie_incluir_lote_w		varchar(10);
ie_pessoa_tipo_benef_w		varchar(10);
ie_tipo_segurado_w		varchar(3);
cd_funcao_solic_w		bigint;
cd_estab_solic_w		bigint;
nr_seq_solic_alt_w		bigint;
qt_registros_w			bigint;
nr_seq_inclusao_benef_w		bigint;
nr_seq_proposta_w		bigint;
dt_periodo_inicial_w		timestamp;
dt_periodo_final_w		timestamp;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_inclusao_benef
	from	(SELECT	a.nr_sequencia,
			trunc(a.dt_atualizacao_nrec,'dd') dt_alteracao,
			nr_seq_inclusao_benef
		from	tasy_solic_alteracao	a
		where	a.ie_status		= 'A'
		and	((cd_funcao		= cd_funcao_solic_w) or (coalesce(cd_funcao_solic_w::text, '') = ''))
		and	((cd_estabelecimento	= cd_estab_solic_w) or (coalesce(cd_estab_solic_w::text, '') = ''))
		and	((nm_usuario		= nm_usuario_filtro_w) or (coalesce(nm_usuario_filtro_w::text, '') = ''))
		and	exists (select	1
				from	tasy_solic_alt_campo	x
				where	a.nr_sequencia = x.nr_seq_solicitacao
				and	x.nm_tabela in ('PESSOA_FISICA', 'COMPL_PESSOA_FISICA'))) alias15
	where	dt_alteracao between coalesce(dt_periodo_inicial_w, dt_alteracao) and coalesce(dt_periodo_final_w, dt_alteracao);


BEGIN
select	trunc(dt_periodo_inicial, 'dd'),
	trunc(dt_periodo_final, 'dd'),
	cd_funcao_solic,
	cd_estab_solic,
	ie_beneficiario_solic,
	ie_pagador_solic,
	ie_estipulante_solic,
	ie_prestador_solic,
	ie_cooperado_solic,
	nm_usuario_filtro,
	ie_tipo_segurado
into STRICT	dt_periodo_inicial_w,
	dt_periodo_final_w,
	cd_funcao_solic_w,
	cd_estab_solic_w,
	ie_beneficiario_solic_w,
	ie_pagador_solic_w,
	ie_estipulante_solic_w,
	ie_prestador_solic_w,
	ie_cooperado_solic_w,
	nm_usuario_filtro_w,
	ie_tipo_segurado_w
from	pls_lote_pessoa_inconsist
where	nr_sequencia	= nr_seq_lote_p;

open C01;
loop
fetch C01 into
	nr_seq_solic_alt_w,
	nr_seq_inclusao_benef_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	max(ds_chave_simples),
		max(ds_chave_composta)
	into STRICT	ds_chave_simples_w,
		ds_chave_composta_w
	from	tasy_solic_alt_campo
	where	nr_seq_solicitacao	= nr_seq_solic_alt_w
	and	nm_tabela in ('PESSOA_FISICA', 'COMPL_PESSOA_FISICA');

	if (ds_chave_simples_w IS NOT NULL AND ds_chave_simples_w::text <> '') then
		cd_pessoa_fisica_w	:= ds_chave_simples_w;
	elsif (ds_chave_composta_w IS NOT NULL AND ds_chave_composta_w::text <> '') then
		cd_pessoa_fisica_w	:= substr(ds_chave_composta_w, 18, position('#' in ds_chave_composta_w) - 18);
	end if;

	select	count(1)
	into STRICT	qt_registros_w
	from	pessoa_fisica
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w  LIMIT 1;

	if (qt_registros_w = 0) then
		goto final;
	end if;

	ie_incluir_lote_w	:= 'N';
	ie_pessoa_benef_w	:= 'N';
	ie_pessoa_pag_w		:= 'N';
	ie_pessoa_estip_w	:= 'N';
	ie_pessoa_pres_w	:= 'N';
	ie_pessoa_coop_w	:= 'N';
	ie_pessoa_tipo_benef_w	:= 'S';

	if (ie_beneficiario_solic_w <> 'A') then
		select	count(1)
		into STRICT	qt_registros_w
		from	pls_segurado
		where	cd_pessoa_fisica	= cd_pessoa_fisica_w  LIMIT 1;

		if (qt_registros_w > 0) and (ie_beneficiario_solic_w = 'S') then
			ie_pessoa_benef_w	:= 'S';
		elsif (qt_registros_w = 0) and (ie_beneficiario_solic_w = 'N') then
			ie_pessoa_benef_w	:= 'S';
		end if;
	end if;

	if (ie_pagador_solic_w <> 'A') then
		select	count(1)
		into STRICT	qt_registros_w
		from	pls_contrato_pagador
		where	cd_pessoa_fisica	= cd_pessoa_fisica_w  LIMIT 1;

		if (qt_registros_w > 0) and (ie_pagador_solic_w = 'S') then
			ie_pessoa_pag_w	:= 'S';
		elsif (qt_registros_w = 0) and (ie_pagador_solic_w = 'N') then
			ie_pessoa_pag_w	:= 'S';
		end if;
	end if;

	if (ie_estipulante_solic_w <> 'A') then
		select	count(1)
		into STRICT	qt_registros_w
		from	pls_contrato
		where	cd_pf_estipulante	= cd_pessoa_fisica_w  LIMIT 1;

		if (qt_registros_w > 0) and (ie_estipulante_solic_w = 'S') then
			ie_pessoa_estip_w	:= 'S';
		elsif (qt_registros_w = 0) and (ie_estipulante_solic_w = 'N') then
			ie_pessoa_estip_w	:= 'S';
		end if;
	end if;

	if (ie_prestador_solic_w <> 'A') then
		select	count(1)
		into STRICT	qt_registros_w
		from	pls_prestador
		where	cd_pessoa_fisica	= cd_pessoa_fisica_w  LIMIT 1;

		if (qt_registros_w > 0) and (ie_prestador_solic_w = 'S') then
			ie_pessoa_pres_w	:= 'S';
		elsif (qt_registros_w = 0) and (ie_prestador_solic_w = 'N') then
			ie_pessoa_pres_w	:= 'S';
		end if;
	end if;

	if (ie_cooperado_solic_w <> 'A') then
		select	count(1)
		into STRICT	qt_registros_w
		from	pls_cooperado
		where	cd_pessoa_fisica	= cd_pessoa_fisica_w  LIMIT 1;

		if (qt_registros_w > 0) and (ie_cooperado_solic_w = 'S') then
			ie_pessoa_coop_w	:= 'S';
		elsif (qt_registros_w = 0) and (ie_cooperado_solic_w = 'N') then
			ie_pessoa_coop_w	:= 'S';
		end if;
	end if;

	if (ie_tipo_segurado_w IS NOT NULL AND ie_tipo_segurado_w::text <> '') then
		select	count(1)
		into STRICT	qt_registros_w
		from	pls_segurado	a
		where	a.cd_pessoa_fisica	= cd_pessoa_fisica_w
		and	a.ie_tipo_segurado	= ie_tipo_segurado_w
		and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and	((coalesce(a.dt_rescisao::text, '') = '') or
			((a.dt_rescisao IS NOT NULL AND a.dt_rescisao::text <> '') and (coalesce(a.dt_limite_utilizacao,a.dt_rescisao) >= clock_timestamp())));

		if (qt_registros_w = 0) then

			select	count(1)
			into STRICT	qt_registros_w
			from	pls_segurado  a,
				pls_contrato_pagador   b
			where	a.nr_seq_pagador = b.nr_sequencia
			and 	b.cd_pessoa_fisica  = cd_pessoa_fisica_w
			and 	a.ie_tipo_segurado  = ie_tipo_segurado_w
			and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
			and 	((coalesce(a.dt_rescisao::text, '') = '') or
				((a.dt_rescisao IS NOT NULL AND a.dt_rescisao::text <> '') and (coalesce(a.dt_limite_utilizacao,a.dt_rescisao) >= clock_timestamp())))    LIMIT 1;
		end if;

		if (qt_registros_w = 0) then
			ie_pessoa_tipo_benef_w	:= 'N';
		end if;
	end if;

	if (ie_pessoa_benef_w = 'S') or (ie_pessoa_pag_w = 'S') or (ie_pessoa_estip_w = 'S') or (ie_pessoa_pres_w = 'S') or (ie_pessoa_coop_w = 'S') then
		ie_incluir_lote_w	:= 'S';
	end if;

	if (ie_incluir_lote_w = 'N') and (ie_prestador_solic_w = 'A') and (ie_cooperado_solic_w = 'A') and (ie_estipulante_solic_w = 'A') and (ie_pagador_solic_w = 'A') and (ie_beneficiario_solic_w = 'A') and (ie_pessoa_tipo_benef_w = 'S') then
		ie_incluir_lote_w	:= 'S';
	end if;

	if (nr_seq_inclusao_benef_w IS NOT NULL AND nr_seq_inclusao_benef_w::text <> '') then
		select	max(a.nr_seq_proposta)
		into STRICT	nr_seq_proposta_w
		from	pls_inclusao_beneficiario	a
		where	a.nr_sequencia	= nr_seq_inclusao_benef_w;
	end if;

	if (ie_incluir_lote_w  = 'S') then
		insert into pls_revisao_solic_alt_pf(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_lote,
			nr_seq_solic_alt,
			cd_pessoa_fisica,
			nr_seq_proposta)
		values (nextval('pls_revisao_solic_alt_pf_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_lote_p,
			nr_seq_solic_alt_w,
			cd_pessoa_fisica_w,
			nr_seq_proposta_w);
	end if;

	<<final>>
	cd_pessoa_fisica_w	:= cd_pessoa_fisica_w;
	end;
end loop;
close C01;

select	count(1)
into STRICT	qt_registros_w
from	pls_revisao_solic_alt_pf
where	nr_seq_lote	= nr_seq_lote_p  LIMIT 1;

if (qt_registros_w	> 0) then
	update	pls_lote_pessoa_inconsist
	set	dt_geracao_lote	= clock_timestamp()
	where	nr_sequencia	= nr_seq_lote_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_lote_solic_alt_pf ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
