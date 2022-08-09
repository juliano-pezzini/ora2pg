-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE codificacao_adicionar_proc ( nr_seq_codificacao_p bigint, nr_seq_proc_interno_p bigint, cd_doenca_cid_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		codificacao_atend_item.nr_sequencia%type;
ds_procedimento_w	cat_procedimento.ds_procedimento%type;
cd_proc_vinculado_w	procedimento.cd_procedimento%type;


BEGIN

select 	coalesce(max(nr_sequencia),1) + 1
into STRICT	nr_sequencia_w
from	codificacao_atend_item
where	nr_seq_codificacao = nr_seq_codificacao_p;

if (cd_doenca_cid_p IS NOT NULL AND cd_doenca_cid_p::text <> '') then

	select	max(ds_procedimento)
	into STRICT	ds_procedimento_w
	from	cat_procedimento
	where	cd_procedimento = cd_doenca_cid_p;

end if;

select	max(cd_procedimento)
into STRICT	cd_proc_vinculado_w
from	procedimento
where	cd_procimento_mx = (	SELECT	max(nr_sequencia)
								from	cat_procedimento
								where	cd_procedimento = cd_doenca_cid_p);

insert into codificacao_atend_item(
	nr_sequencia,
	nr_seq_codificacao,
	nr_seq_proc_pac,
	nr_seq_proc_interno,
	cd_doenca_cid,
	ie_tipo_item,
	ie_status,
	nm_usuario,
	dt_atualizacao,
	nm_usuario_nrec,
	dt_atualizacao_nrec)
values (
	nr_sequencia_w,
	nr_seq_codificacao_p,
	null,
	coalesce(nr_seq_proc_interno_p, cd_proc_vinculado_w),
	cd_doenca_cid_p,
	'P',
	'A',
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp());

CALL gerar_codificacao_atend_log(nr_seq_codificacao_p, obter_desc_expressao(500390) || ' : '
	|| coalesce(ds_procedimento_w, SUBSTR(Obter_Descricao_Procedimento(nr_seq_proc_interno_p, NULL),1,255)), nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE codificacao_adicionar_proc ( nr_seq_codificacao_p bigint, nr_seq_proc_interno_p bigint, cd_doenca_cid_p text, nm_usuario_p text) FROM PUBLIC;
