-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_item_glosa ( nr_seq_item_p bigint, ie_tipo_item_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			varchar(1)	:= 'N';
qt_glosa_w			integer	:= 0;
qt_glosa_guia_w			integer	:= 0;
qt_glosa_guia_proc_w		integer	:= 0;
qt_glosa_guia_mat_w		integer	:= 0;


BEGIN

if (ie_tipo_item_p = 1) then
	select	count(*)
	into STRICT	qt_glosa_guia_proc_w
	from	pls_guia_glosa
	where	nr_seq_guia_proc in (	SELECT	nr_sequencia
					from 	pls_guia_plano_proc
					where 	nr_sequencia = nr_seq_item_p
					and	coalesce(nr_seq_motivo_exc::text, '') = '')
	and	(nr_seq_ocorrencia IS NOT NULL AND nr_seq_ocorrencia::text <> '');
elsif (ie_tipo_item_p = 2) then
	select	count(*)
	into STRICT	qt_glosa_guia_mat_w
	from	pls_guia_glosa
	where	nr_seq_guia_mat in (	SELECT	nr_sequencia
					from 	pls_guia_plano_mat
					where 	nr_sequencia = nr_seq_item_p
					and	coalesce(nr_seq_motivo_exc::text, '') = '')
	and	(nr_seq_ocorrencia IS NOT NULL AND nr_seq_ocorrencia::text <> '');
elsif (ie_tipo_item_p = 5) then
	select	count(*)
	into STRICT	qt_glosa_guia_proc_w
	from	pls_requisicao_glosa
	where	nr_seq_req_proc in (	SELECT	nr_sequencia
					from 	pls_requisicao_proc
					where 	nr_sequencia = nr_seq_item_p
					and	coalesce(nr_seq_motivo_exc::text, '') = '')
	and	(nr_seq_ocorrencia IS NOT NULL AND nr_seq_ocorrencia::text <> '');
elsif (ie_tipo_item_p = 6) then
	select	count(*)
	into STRICT	qt_glosa_guia_mat_w
	from	pls_requisicao_glosa
	where	nr_seq_req_mat in (	SELECT	nr_sequencia
					from 	pls_requisicao_mat
					where 	nr_sequencia = nr_seq_item_p
					and	coalesce(nr_seq_motivo_exc::text, '') = '')
	and	(nr_seq_ocorrencia IS NOT NULL AND nr_seq_ocorrencia::text <> '');
elsif (ie_tipo_item_p = 10) then
	select	count(*)
	into STRICT	qt_glosa_guia_proc_w
	from	pls_requisicao_glosa
	where	nr_seq_exec_proc in (	SELECT	nr_sequencia
					from 	pls_execucao_req_item
					where 	nr_sequencia = nr_seq_item_p)
	--and	nr_seq_ocorrencia is not null
	and	(nr_seq_execucao IS NOT NULL AND nr_seq_execucao::text <> '');
elsif (ie_tipo_item_p = 11) then
	select	count(*)
	into STRICT	qt_glosa_guia_mat_w
	from	pls_requisicao_glosa
	where	nr_seq_exec_mat in (	SELECT	nr_sequencia
					from 	pls_execucao_req_item
					where 	nr_sequencia = nr_seq_item_p)
	--and	nr_seq_ocorrencia is not null
	and	(nr_seq_execucao IS NOT NULL AND nr_seq_execucao::text <> '');
end if;

qt_glosa_w	:= qt_glosa_guia_proc_w + qt_glosa_guia_mat_w;

if (qt_glosa_w	> 0) then
	ie_retorno_w	:= 'S';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_item_glosa ( nr_seq_item_p bigint, ie_tipo_item_p bigint) FROM PUBLIC;
