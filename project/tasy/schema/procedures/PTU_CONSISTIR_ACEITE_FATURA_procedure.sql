-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_consistir_aceite_fatura ( nr_seq_fatura_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Consistir o aceite da fatura PTU, irá verificar se há ocorrências pendentes de pré-análise ou 
contas sem beneficiário 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ X] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
dt_mes_competencia_w		ptu_fatura.dt_mes_competencia%type;
ds_retorno_w			varchar(255)	:= null;
qt_grupos_analise_w		bigint;
cd_ocorrencia_w			varchar(30);
ds_ocorrencia_w			varchar(255);
qt_contas_sem_benef_w		bigint;
nr_seq_grupo_pre_analise_w	bigint;
nr_seq_ocor_benef_w		bigint;
nr_seq_conta_w			bigint;
nr_seq_ocorrencia_w		bigint;
qt_1001_w			bigint;
qt_1001_glosa_w			bigint;

c01 CURSOR FOR 
	SELECT	b.nr_sequencia, 
		b.nr_seq_ocorrencia, 
		c.nr_sequencia 
	from	pls_analise_glo_ocor_grupo	a, 
		pls_ocorrencia_benef		b, 
		pls_conta c 
	where	c.nr_sequencia		= b.nr_seq_conta 
	and	b.nr_sequencia		= a.nr_seq_ocor_benef 
	and	a.nr_seq_grupo		= nr_seq_grupo_pre_analise_w 
	and	b.ie_pre_analise	= 'S' 
	and	(c.nr_seq_segurado IS NOT NULL AND c.nr_seq_segurado::text <> '') 
	and	a.ie_status = 'P' 
	and	c.nr_seq_fatura	= nr_seq_fatura_p;


BEGIN 
if (nr_seq_fatura_p IS NOT NULL AND nr_seq_fatura_p::text <> '') then 
	select	max(dt_mes_competencia) 
	into STRICT	dt_mes_competencia_w 
	from	ptu_fatura 
	where	nr_sequencia	= nr_seq_fatura_p;
	 
	if (obter_se_lote_contabil_gerado(33,dt_mes_competencia_w) = 'S') then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(682676);
	end if;
 
	begin 
	select	a.nr_seq_grupo_pre_analise 
	into STRICT	nr_seq_grupo_pre_analise_w 
	from	pls_parametros a 
	where	a.cd_estabelecimento	= cd_estabelecimento_p;
	exception 
		when others then 
		nr_seq_grupo_pre_analise_w	:= null;
	end;
 
	/* Verificar se tem ocorrências de pré-análise ainda pendentes */
 
	open c01;
	loop 
	fetch c01 into 
		nr_seq_ocor_benef_w, 
		nr_seq_ocorrencia_w, 
		nr_seq_conta_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
		select	count(1) 
		into STRICT	qt_grupos_analise_w 
		from	pls_analise_glo_ocor_grupo x 
		where	x.nr_seq_ocor_benef = nr_seq_ocor_benef_w 
		and	x.nr_seq_grupo <> nr_seq_grupo_pre_analise_w;
		 
		if (qt_grupos_analise_w = 0) then 
			ds_retorno_w	:= 'Existem ocorrências de pré-análise ainda pendentes.' || chr(13) || chr(10) || 
					'As mesmas devem ser analisadas na pasta "Produção Médica - Resumo das ocorrências". ' || chr(13) || chr(10) || 
					'Para deixar as mesmas pendentes, estas ocorrências devem ter um grupo de análise definido no fluxo.';
		end if;
		end;
	end loop;
	close c01;
	 
	/* Verificar se ainda há contas sem beneficiário não glosadas */
 
	select	count(1) 
	into STRICT	qt_contas_sem_benef_w 
	from	pls_conta a 
	where	a.nr_seq_fatura	= nr_seq_fatura_p 
	and (coalesce(a.ie_glosa::text, '') = '' or a.ie_glosa = 'N') 
	and	coalesce(a.nr_seq_segurado::text, '') = '';
	 
	select	count(1) 
	into STRICT	qt_1001_w 
	from	pls_conta_glosa		b, 
		tiss_motivo_glosa	c, 
		pls_conta		a 
	where	c.nr_sequencia		= b.nr_seq_motivo_glosa 
	and	a.nr_sequencia		= b.nr_seq_conta 
	and	c.cd_motivo_tiss	= '1001' 
	and	a.nr_seq_fatura		= nr_seq_fatura_p;
	 
	select	count(1) 
	into STRICT	qt_1001_glosa_w 
	from	pls_conta_glosa		b, 
		tiss_motivo_glosa	c, 
		pls_conta		a 
	where	c.nr_sequencia		= b.nr_seq_motivo_glosa 
	and	a.nr_sequencia		= b.nr_seq_conta 
	and	c.cd_motivo_tiss	= '1001' 
	and	a.nr_seq_fatura		= nr_seq_fatura_p 
	and	a.ie_glosa		= 'S';
	 
	if (qt_contas_sem_benef_w > 0) and (qt_1001_glosa_w < qt_1001_w) then 
		ds_retorno_w	:= 'Existem contas sem beneficiário identificado.' || chr(13) || chr(10) || 
				'Devem ser identificados os beneficiários nas mesmas ou devem ser glosadas (Pasta Produção Médica)';
	end if;
end if;
 
ds_retorno_p	:= ds_retorno_w;
 
/* consistência - sem commit */
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_consistir_aceite_fatura ( nr_seq_fatura_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) FROM PUBLIC;
