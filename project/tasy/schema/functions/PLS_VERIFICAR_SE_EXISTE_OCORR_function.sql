-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_verificar_se_existe_ocorr ( nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_execucao_p bigint, nr_seq_proc_p bigint, nr_seq_mat_p bigint, nr_seq_ocorrencia_p bigint) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Verificar se já existe a ocorrência gerada nos itens/cabeçalho nas guias,
requisições e execuções.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção: Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w		varchar(1);
qt_ocorrencia_w		bigint;


BEGIN

if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then
	if (nr_seq_proc_p IS NOT NULL AND nr_seq_proc_p::text <> '') then
		select	count(1)
		into STRICT    qt_ocorrencia_w
		from	pls_ocorrencia_benef
		where	nr_seq_guia_plano 	= nr_seq_guia_p
		and	nr_seq_proc		= nr_seq_proc_p
		and	nr_seq_ocorrencia	= nr_seq_ocorrencia_p;

	elsif (nr_seq_mat_p IS NOT NULL AND nr_seq_mat_p::text <> '') then
		select	count(1)
		into STRICT    qt_ocorrencia_w
		from	pls_ocorrencia_benef
		where	nr_seq_guia_plano 	= nr_seq_guia_p
		and	nr_seq_mat		= nr_seq_mat_p
		and	nr_seq_ocorrencia	= nr_seq_ocorrencia_p;

	else
		select	count(1)
		into STRICT    qt_ocorrencia_w
		from	pls_ocorrencia_benef
		where	nr_seq_guia_plano 	= nr_seq_guia_p
		and	nr_seq_ocorrencia	= nr_seq_ocorrencia_p;
	end if;

elsif (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
	if (nr_seq_proc_p IS NOT NULL AND nr_seq_proc_p::text <> '') then
		select	count(1)
		into STRICT    qt_ocorrencia_w
		from	pls_ocorrencia_benef
		where	nr_seq_requisicao 	= nr_seq_requisicao_p
		and	nr_seq_proc		= nr_seq_proc_p
		and	nr_seq_ocorrencia	= nr_seq_ocorrencia_p;

	elsif (nr_seq_mat_p IS NOT NULL AND nr_seq_mat_p::text <> '') then
		select	count(1)
		into STRICT    qt_ocorrencia_w
		from	pls_ocorrencia_benef
		where	nr_seq_requisicao	= nr_seq_requisicao_p
		and	nr_seq_mat		= nr_seq_mat_p
		and	nr_seq_ocorrencia	= nr_seq_ocorrencia_p;

	else
		select	count(1)
		into STRICT    qt_ocorrencia_w
		from	pls_ocorrencia_benef
		where	nr_seq_requisicao	= nr_seq_requisicao_p
		and	nr_seq_ocorrencia	= nr_seq_ocorrencia_p;
	end if;

elsif (nr_seq_execucao_p IS NOT NULL AND nr_seq_execucao_p::text <> '') then
	if (nr_seq_proc_p IS NOT NULL AND nr_seq_proc_p::text <> '') then
		select	count(1)
		into STRICT    qt_ocorrencia_w
		from	pls_ocorrencia_benef
		where	nr_seq_execucao 	= nr_seq_execucao_p
		and	nr_seq_proc		= nr_seq_proc_p
		and	nr_seq_ocorrencia	= nr_seq_ocorrencia_p;

	elsif (nr_seq_mat_p IS NOT NULL AND nr_seq_mat_p::text <> '') then
		select	count(1)
		into STRICT    qt_ocorrencia_w
		from	pls_ocorrencia_benef
		where	nr_seq_execucao 	= nr_seq_execucao_p
		and	nr_seq_mat		= nr_seq_mat_p
		and	nr_seq_ocorrencia	= nr_seq_ocorrencia_p;

	else
		select	count(1)
		into STRICT    qt_ocorrencia_w
		from	pls_ocorrencia_benef
		where	nr_seq_execucao 	= nr_seq_execucao_p
		and	nr_seq_ocorrencia	= nr_seq_ocorrencia_p;
	end if;
end if;

if (qt_ocorrencia_w > 0) then
	ds_retorno_w	:= 'S';
else
	ds_retorno_w 	:= 'N';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_verificar_se_existe_ocorr ( nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_execucao_p bigint, nr_seq_proc_p bigint, nr_seq_mat_p bigint, nr_seq_ocorrencia_p bigint) FROM PUBLIC;
