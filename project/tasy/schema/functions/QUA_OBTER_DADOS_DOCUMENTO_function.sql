-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qua_obter_dados_documento ( nr_seq_documento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*ie_opcao_p
	D - Nome do documento
	DT - Descricao do tipo do documento
	A - Anexo (Sim ou nao)
	S - Situacao (Ativo/Inativo)
	UR - Ultima revisao
	AR - Aprovacao da revisao	
	C - Codigo do documento
	UAR - Ultima aprovacao de revisao do documento
	UST - Ultima sequencia do treinamento do documento
	CUR - Codigo da ultima revisao
	CPR - Codigo do processo
	DPR - Descricao Processo
	DSP - Descricao Subprocesso
	AP - Aprovacao parcial
	OUR - Observacao da ultima revisao
	TD - Tipo do documento
*/
nm_documento_w		varchar(255);
nr_seq_tipo_w		bigint;
ds_retorno_w		varchar(255);
ds_tipo_doc_w		varchar(255);
ie_situacao_w		varchar(01);
cd_documento_w		varchar(20);
dt_ult_revisao_w		timestamp;
nr_seq_processo_w		bigint;
nr_seq_subproc_w		bigint;
qt_existe_w		bigint;
qt_aprov_w		bigint;


BEGIN

select	nm_documento,
	nr_seq_tipo,
	ie_situacao,
	cd_documento
into STRICT	nm_documento_w,
	nr_seq_tipo_w,
	ie_situacao_w,
	cd_documento_w
from	qua_documento
where	nr_sequencia    = nr_seq_documento_p;

if (ie_opcao_p = 'D') then
	ds_retorno_w := nm_documento_w;
elsif (ie_opcao_p = 'DT') then
	select	substr(obter_desc_expressao(CD_EXP_TIPO_DOC,DS_TIPO_DOC),1,60) ds_tipo_doc
	into STRICT	ds_tipo_doc_w
	from	qua_tipo_doc
	where	nr_sequencia    = nr_seq_tipo_w;
	ds_retorno_w := ds_tipo_doc_w;
elsif (ie_opcao_p = 'A') then
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	from	qua_doc_anexo
	where	nr_seq_doc = nr_seq_documento_p;
elsif (ie_opcao_p = 'S') then
	ds_retorno_w := ie_situacao_w;
elsif (ie_opcao_p in ('UR','CUR','OUR')) then
	select	max(dt_revisao)
	into STRICT	dt_ult_revisao_w
	from	qua_doc_revisao
	where	nr_seq_doc = nr_seq_documento_p;
	
	if (ie_opcao_p = 'CUR') then
		select 	max(cd_revisao)
		into STRICT	ds_retorno_w
		from	qua_doc_revisao
		where	nr_seq_doc = nr_seq_documento_p
		and	dt_revisao = dt_ult_revisao_w;
	elsif (ie_opcao_p = 'UR') then
		ds_retorno_w := to_char(dt_ult_revisao_w,'dd/mm/yyyy hh24:mi:ss');
	elsif (ie_opcao_p = 'OUR') then
		select 	max(ds_observacao)
		into STRICT	ds_retorno_w
		from	qua_doc_revisao
		where	nr_seq_doc = nr_seq_documento_p
		and	dt_revisao = dt_ult_revisao_w;
	end if;	
	
elsif (ie_opcao_p = 'AR') then
	select 	to_char(max(dt_aprovacao),'dd/mm/yyyy hh24:mi:ss')
	into STRICT	ds_retorno_w
	from	qua_doc_revisao
	where	nr_seq_doc = nr_seq_documento_p;
elsif (ie_opcao_p = 'C') then
	ds_retorno_w := cd_documento_w;
elsif (ie_opcao_p = 'UAR') then
	select 	to_char(max(dt_aprovacao),'dd/mm/yyyy hh24:mi:ss')
	into STRICT	ds_retorno_w
	from	qua_doc_revisao
	where	nr_seq_doc = nr_seq_documento_p
	and	(dt_aprovacao IS NOT NULL AND dt_aprovacao::text <> '');
elsif (ie_opcao_p = 'UST') then
	select	max(nr_sequencia)
	into STRICT	ds_retorno_w
	from	qua_doc_treinamento
	where	nr_seq_documento = nr_seq_documento_p;	
elsif (ie_opcao_p = 'DPR') then
	select	max(nr_seq_proc)
	into STRICT	nr_seq_processo_w
	from	qua_doc_proc_emp
	where	nr_seq_doc = nr_seq_documento_p;
	
	if (coalesce(nr_seq_processo_w,0) > 0) then
		select	substr(obter_desc_expressao(CD_EXP_PROCESSO,DS_PROCESSO),1,80) ds_processo
		into STRICT	ds_retorno_w
		from	qua_processo
		where	nr_sequencia = nr_seq_processo_w;		
	end if;
elsif (ie_opcao_p = 'CPR') then
	select	max(nr_seq_proc)
	into STRICT	ds_retorno_w
	from	qua_doc_proc_emp
	where	nr_seq_doc = nr_seq_documento_p;
elsif (ie_opcao_p = 'DSP') then
	select	max(nr_seq_subprocesso)
	into STRICT	nr_seq_subproc_w
	from	qua_doc_subproc_emp
	where	nr_seq_doc = nr_seq_documento_p;
	
	if (coalesce(nr_seq_subproc_w,0) > 0) then
		select	 substr(obter_desc_expressao(CD_EXP_SUBPROCESSO,DS_SUBPROCESSO),1,80) ds_subprocesso
		into STRICT	ds_retorno_w
		from	qua_subprocesso
		where	nr_sequencia = nr_seq_subproc_w;
	end if;
elsif (ie_opcao_p = 'AP') then
	select	count(*),
		sum(CASE WHEN coalesce(dt_aprovacao::text, '') = '' THEN 0  ELSE 1 END )
	into STRICT	qt_existe_w,
		qt_aprov_w
	from	qua_doc_aprov
	where	nr_seq_doc = nr_seq_documento_p;
	
	ds_retorno_w := 'N';
	
	if (qt_existe_w > 0) and /*se existir aprovadores*/
		(qt_aprov_w > 0) and /*e se algum ja aprovou*/
		(qt_existe_w <> qt_aprov_w) then /*mas nao todos*/
		ds_retorno_w := 'S';
	end if;
elsif (ie_opcao_p = 'TD') then
	ds_retorno_w := nr_seq_tipo_w;
end if;

return  ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qua_obter_dados_documento ( nr_seq_documento_p bigint, ie_opcao_p text) FROM PUBLIC;
