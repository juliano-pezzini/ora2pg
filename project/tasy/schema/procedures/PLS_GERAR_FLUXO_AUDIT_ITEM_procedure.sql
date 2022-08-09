-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_fluxo_audit_item ( nr_seq_analise_p bigint, nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nr_seq_proc_partic_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar o fluxo de auditoria para os itens da conta
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ X ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_pre_analise_w		varchar(255);
ie_despesa_w			varchar(10)	:= 'N';
ie_tipo_despesa_proc_w		varchar(10)	:= null;
ie_tipo_despesa_mat_w		varchar(10)	:= null;
ie_intercambio_w		varchar(10) := 'N';
ie_conta_medica_w		varchar(10) := 'N';
ie_tipo_conta_w			varchar(10);
ie_origem_conta_w		varchar(1);
nr_seq_ocor_benef_w		bigint;
nr_seq_ocorrencia_w		bigint;
nr_seq_grupo_w			bigint;
qt_registro_w			bigint;
qt_analise_item_w		bigint;
qt_grupo_analise_w		bigint;
cd_estabelecimento_w		smallint;
nr_seq_conta_w			bigint;
qt_oco_despesa_w		bigint;
nr_seq_ocorr_grupo_w		bigint;
nr_seq_conta_proc_w		bigint;
nr_seq_conta_mat_w		bigint;
nr_seq_fatura_w			bigint;
ie_tipo_conta_item_w		varchar(10);
ie_origem_analise_w		pls_analise_conta.ie_origem_analise%type;
nr_seq_glosa_w			pls_ocorrencia_benef.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		b.nr_sequencia,
		b.nr_seq_ocorrencia,
		a.ie_origem_conta,
		coalesce(b.ie_pre_analise, 'N'),
		b.nr_seq_conta_proc,
		b.nr_seq_conta_mat,
		a.ie_tipo_conta,
		b.nr_seq_glosa
	from	pls_ocorrencia c,
		pls_ocorrencia_benef	b,
		pls_conta		a
	where	a.nr_sequencia		= b.nr_seq_conta
	and	b.nr_seq_ocorrencia	= c.nr_sequencia
	and	a.nr_seq_analise	= nr_seq_analise_p
	and (a.nr_sequencia		= nr_seq_conta_p or coalesce(nr_seq_conta_p::text, '') = '')
	and (b.nr_seq_conta_proc	= nr_seq_conta_proc_p or coalesce(nr_seq_conta_proc_p::text, '') = '')
	and (b.nr_seq_conta_mat	= nr_seq_conta_mat_p or coalesce(nr_seq_conta_mat_p::text, '') = '')
	and (b.nr_seq_proc_partic	= nr_seq_proc_partic_p or coalesce(nr_seq_proc_partic_p::text, '') = '')
	and	coalesce(b.nr_seq_conta_pos_estab::text, '') = ''
	and (coalesce(b.ie_lib_manual::text, '') = '' or b.ie_lib_manual = 'N') /* Nao deve gerar fluxo para as ocorrencias inseridas pelo usuario */
	and	((b.ie_situacao 	= 'A') or (coalesce(c.ie_auditoria_conta,'N')	= 'N'));
--tratei para que somente seja gerado o fluxo de auditoria para ocorrencias ativas, uma vez que nao faz sentido gerarmos para uma ocorrencia que ja esta inativa
C02 CURSOR FOR
	SELECT	b.nr_seq_grupo
	from	pls_analise_grupo_item b,
		pls_analise_conta_item a
	where	a.nr_sequencia		= b.nr_seq_item_analise
	and	a.nr_seq_analise	= nr_seq_analise_p
	and	a.nr_seq_ocorrencia	= nr_seq_ocorrencia_w
	group by
		a.nr_seq_ocorrencia,
		b.nr_seq_grupo;

C03 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_grupo
	from	pls_ocorrencia_grupo	a
	where	a.nr_seq_ocorrencia	= nr_seq_ocorrencia_w
	and (a.ie_conta_medica	= 'S'or coalesce(a.ie_conta_medica::text, '') = '')
	and	a.ie_situacao		= 'A'
	and	((a.ie_intercambio = 'S') or (a.ie_intercambio = ie_intercambio_w))
	and (a.ie_origem_conta = ie_origem_conta_w or coalesce(a.ie_origem_conta::text, '') = '')
	and	((coalesce(a.ie_tipo_analise::text, '') = '') or (a.ie_tipo_analise = 'A') or (a.ie_tipo_analise = 'C' and ie_origem_analise_w in ('1','3','4','5','6')) or (a.ie_tipo_analise	= 'P' and ie_origem_analise_w in ('2','7')))
	
union

	SELECT	null,
		a.nr_seq_grupo_pre_analise
	from	pls_parametros	a
	where	a.cd_estabelecimento	= cd_estabelecimento_w
	and	ie_pre_analise_w	= 'S'
	and	ie_tipo_conta_item_w		= 'I'
	and	(a.nr_seq_grupo_pre_analise IS NOT NULL AND a.nr_seq_grupo_pre_analise::text <> '');


BEGIN
/* Verificar primeiro se tem os registros na tabela antiga */

select	count(1)
into STRICT	qt_analise_item_w
from	pls_analise_conta_item a
where	a.nr_seq_analise	= nr_seq_analise_p  LIMIT 1;

select	max(a.cd_estabelecimento)
into STRICT	cd_estabelecimento_w
from	pls_analise_conta	a
where	a.nr_sequencia	= nr_seq_analise_p;

begin
select	ie_tipo_conta
into STRICT	ie_tipo_conta_w
from	pls_conta
where	nr_sequencia	= nr_seq_conta_p;
exception
when others then
	ie_tipo_conta_w	:= 'O';
end;

if (ie_tipo_conta_w = 'I') then
	ie_conta_medica_w	:= 'N';
else
	ie_conta_medica_w	:= 'S';
end if;

select	max(CASE WHEN a.ie_origem_analise=3 THEN 'I'  ELSE 'N' END ),
	max(ie_origem_analise)
into STRICT	ie_intercambio_w,
	ie_origem_analise_w
from	pls_analise_conta	a
where	a.nr_sequencia	= nr_seq_analise_p;

open C01;
loop
fetch C01 into
	nr_seq_conta_w,
	nr_seq_ocor_benef_w,
	nr_seq_ocorrencia_w,
	ie_origem_conta_w,
	ie_pre_analise_w,
	nr_seq_conta_proc_w,
	nr_seq_conta_mat_w,
	ie_tipo_conta_item_w,
	nr_seq_glosa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	/* Se tiver, copiar para nova */

	
	open C03;
	loop
	fetch C03 into
		nr_seq_ocorr_grupo_w,
		nr_seq_grupo_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		ie_despesa_w	:= 'N';
		ie_tipo_despesa_proc_w	:= null;
		ie_tipo_despesa_mat_w	:= null;
		/* Verificar regra por tipo de despesa */

		select	count(1)
		into STRICT	qt_oco_despesa_w
		from	pls_oc_grupo_tipo_desp
		where	nr_seq_ocorrencia_grupo = nr_seq_ocorr_grupo_w  LIMIT 1;
		
		if (qt_oco_despesa_w = 0) then
			ie_despesa_w	:= 'S';
		end if;
		
		if (ie_despesa_w = 'N') then
			if (nr_seq_conta_proc_w IS NOT NULL AND nr_seq_conta_proc_w::text <> '') then
				select	a.ie_tipo_despesa
				into STRICT	ie_tipo_despesa_proc_w
				from	pls_conta_proc a
				where	a.nr_sequencia	= nr_seq_conta_proc_w;
			elsif (nr_seq_conta_mat_w IS NOT NULL AND nr_seq_conta_mat_w::text <> '') then
				select	a.ie_tipo_despesa
				into STRICT	ie_tipo_despesa_mat_w
				from	pls_conta_mat a
				where	a.nr_sequencia	= nr_seq_conta_mat_w;
			end if;
		
			if (ie_tipo_despesa_proc_w IS NOT NULL AND ie_tipo_despesa_proc_w::text <> '') then
				select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
				into STRICT	ie_despesa_w
				from	pls_oc_grupo_tipo_desp a
				where	a.nr_seq_ocorrencia_grupo = nr_seq_ocorr_grupo_w
				and	a.ie_tipo_despesa_proc = ie_tipo_despesa_proc_w;
			elsif (ie_tipo_despesa_mat_w IS NOT NULL AND ie_tipo_despesa_mat_w::text <> '') then
				select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
				into STRICT	ie_despesa_w
				from	pls_oc_grupo_tipo_desp a
				where	a.nr_seq_ocorrencia_grupo = nr_seq_ocorr_grupo_w
				and	a.ie_tipo_despesa_mat = ie_tipo_despesa_mat_w;
			else
				ie_despesa_w	:= 'S';
			end if;
		end if;
		
		if (ie_despesa_w = 'S') then
			select	count(1)
			into STRICT	qt_registro_w
			from	pls_analise_glo_ocor_grupo a
			where	a.nr_seq_ocor_benef	= nr_seq_ocor_benef_w
			and	a.nr_seq_grupo		= nr_seq_grupo_w  LIMIT 1;
			
			if (qt_registro_w = 0) then
								
				insert into pls_analise_glo_ocor_grupo(nr_sequencia,
					nm_usuario,
					dt_atualizacao,
					nm_usuario_nrec,
					dt_atualizacao_nrec,
					nr_seq_analise,
					nr_seq_ocor_benef,
					nr_seq_grupo,
					ie_status,
					nr_seq_conta_glosa) --aaschlote 07/10/2015  - Coloquei esse campo, pois depois na rotina pls_analise_cta_pck.pls_gerencia_glo_ocor_grupo, ele compara essa informacao tambem para inserir na tabela
				values (nextval('pls_analise_glo_ocor_grupo_seq'),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nr_seq_analise_p,
					nr_seq_ocor_benef_w,
					nr_seq_grupo_w,
					'P',
					nr_seq_glosa_w);
					
				if (coalesce(nr_seq_ocorr_grupo_w::text, '') = '') and (ie_pre_analise_w = 'S') then
					update	pls_analise_conta
					set	ie_status_pre_analise	= 'S'
					where	nr_sequencia		= nr_seq_analise_p;
				end if;
				null;
			end if;
		end if;
		end;
	end loop;
	close C03;
	end;
end loop;
close C01;

/* commit */

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_fluxo_audit_item ( nr_seq_analise_p bigint, nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nr_seq_proc_partic_p bigint, nm_usuario_p text) FROM PUBLIC;
