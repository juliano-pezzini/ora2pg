-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ptu_obter_qt_oco_pre_analises ( nr_seq_fatura_p bigint) RETURNS bigint AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Rotina que ira obter quantas ocorrências de pré- análise de um arquivo faltam ser liberadas. 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ X ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
		 
 
qt_retorno_w				bigint	:= 0;
qt_ocorrencias_w			bigint	:= 0;
nr_seq_analise_w			bigint;
nr_seq_lote_w				bigint;
nr_seq_grupo_pre_analise_w		bigint;
qt_pend_analise_w			bigint;
qt_outro_grupo_w			bigint;
cd_estabelecimento_w			smallint;

C01 CURSOR FOR 
	SELECT	b.nr_seq_analise 
	from	pls_protocolo_conta	a, 
		pls_conta		b 
	where	a.nr_seq_lote_conta	= nr_seq_lote_w 
	and	b.nr_seq_protocolo	= a.nr_sequencia 
	group by 
		b.nr_seq_analise 
	order by 
		1;


BEGIN 
select	max(b.nr_seq_lote_conta), 
	max(a.cd_estabelecimento) 
into STRICT	nr_seq_lote_w, 
	cd_estabelecimento_w 
from	ptu_fatura		a, 
	pls_protocolo_conta	b 
where	a.nr_sequencia		= nr_seq_fatura_p 
and	a.nr_seq_protocolo	= b.nr_sequencia;
 
select	max(a.nr_seq_grupo_pre_analise) 
into STRICT	nr_seq_grupo_pre_analise_w 
from	pls_parametros	a 
where	a.cd_estabelecimento	= cd_estabelecimento_w;
 
open C01;
loop 
fetch C01 into 
	nr_seq_analise_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	/* Pega as ocorrências para o grupo de pré-analise que estejam pendentes ainda */
 
	select	count(1) 
	into STRICT	qt_pend_analise_w 
	from	pls_ocorrencia			c, 
		pls_ocorrencia_benef		b, 
		pls_analise_glo_ocor_grupo	a 
	where	c.nr_sequencia		= b.nr_seq_ocorrencia 
	and	b.nr_sequencia		= a.nr_seq_ocor_benef 
	and	a.nr_seq_analise	= nr_seq_analise_w 
	and	a.nr_seq_grupo		= nr_seq_grupo_pre_analise_w 
	and	c.ie_pre_analise	= 'S' 
	and	a.ie_status = 'P';
	 
	/* Pegar as ocorrências de pré-analise que estejam pendentes para outro grupo */
 
	select	count(1) 
	into STRICT	qt_outro_grupo_w 
	from	pls_ocorrencia			c, 
		pls_ocorrencia_benef		b, 
		pls_analise_glo_ocor_grupo	a 
	where	c.nr_sequencia		= b.nr_seq_ocorrencia 
	and	b.nr_sequencia		= a.nr_seq_ocor_benef 
	and	a.nr_seq_analise	= nr_seq_analise_w 
	and	a.nr_seq_grupo		<> nr_seq_grupo_pre_analise_w 
	and	c.ie_pre_analise	= 'S' 
	and	a.ie_status = 'P'  LIMIT 1;
	 
	if (qt_pend_analise_w > 0) and (qt_outro_grupo_w = 0) then 
		qt_retorno_w	:= qt_retorno_w + qt_pend_analise_w;
	end if;
	end;
end loop;
close C01;
 
return	qt_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ptu_obter_qt_oco_pre_analises ( nr_seq_fatura_p bigint) FROM PUBLIC;
