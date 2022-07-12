-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_quantidade_glosas ( nr_sequencia_p bigint, nr_seq_requisicao_p bigint, nr_seq_guia_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:   Obter a quantidade de glosas dos procedimentos / materiais
----------------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ x ] Tasy (Delphi/Java) [ x ] Portal [  ] Relatórios [ ] Outros:
 ----------------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	IE_OPCAO_P
	P - Procedimento
	M - Medicamento
*/ds_retorno_w			bigint;
qt_glosas_w			bigint := 0;
qt_glosas_ocorrencia_w		bigint := 0;


BEGIN

if ((nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') and nr_seq_guia_p > 0) then
	if (ie_opcao_p	 = 'P') then
		select	count(*)
		into STRICT	qt_glosas_w
		from	pls_guia_glosa_ocorrencia_v
		where (nr_seq_guia	= nr_seq_guia_p or coalesce(nr_seq_guia::text, '') = '')
		and	((nr_seq_proc	= nr_sequencia_p and (nr_seq_proc IS NOT NULL AND nr_seq_proc::text <> '')) or (nr_sequencia_p = 0 and coalesce(nr_seq_proc::text, '') = ''));
	elsif (ie_opcao_p	= 'M') then
		select	count(*)
		into STRICT	qt_glosas_w
		from	pls_guia_glosa_ocorrencia_v
		where (nr_seq_guia	= nr_seq_guia_p or coalesce(nr_seq_guia::text, '') = '')
		and	((nr_seq_mat	= nr_sequencia_p and (nr_seq_mat IS NOT NULL AND nr_seq_mat::text <> '')) or (nr_sequencia_p = 0 and coalesce(nr_seq_mat::text, '') = ''));
	end if;
else
	if (ie_opcao_p	 = 'P') then
		select	count(*)
		into STRICT	qt_glosas_w
		from	pls_requisicao_glosa
		where   nr_seq_req_proc = nr_sequencia_p;

		select	count(*)
		into STRICT	qt_glosas_ocorrencia_w
		from	pls_ocorrencia_benef
		where   nr_seq_proc = nr_sequencia_p;

	elsif (ie_opcao_p	= 'M') then
		select	count(*)
		into STRICT	qt_glosas_w
		from	pls_requisicao_glosa
		where   nr_seq_req_mat = nr_sequencia_p;

		select	count(*)
		into STRICT	qt_glosas_ocorrencia_w
		from	pls_ocorrencia_benef
		where   nr_seq_mat = nr_sequencia_p;
	end if;
end if;
ds_retorno_w	:= coalesce(qt_glosas_w,0) + coalesce(qt_glosas_ocorrencia_w, 0);

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_quantidade_glosas ( nr_sequencia_p bigint, nr_seq_requisicao_p bigint, nr_seq_guia_p bigint, ie_opcao_p text) FROM PUBLIC;

