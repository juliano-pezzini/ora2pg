-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE codificacao_adicionar_diag ( nr_seq_codificacao_p bigint, ie_classificacao_p text, cd_doenca_cid_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		codificacao_atend_item.nr_sequencia%type;
ds_classificacao_w	varchar(50) := '';


BEGIN

select 	coalesce(max(nr_sequencia),1) + 1
into STRICT	nr_sequencia_w
from	codificacao_atend_item
where	nr_seq_codificacao = nr_seq_codificacao_p;

if (cd_doenca_cid_p IS NOT NULL AND cd_doenca_cid_p::text <> '') then

	select	max(obter_desc_expressao(CASE WHEN coalesce(ie_classificacao_p, 'N')='S' THEN  896466  ELSE 896468 END ))
	into STRICT	ds_classificacao_w
	;

	insert into codificacao_atend_item(
			nr_sequencia,
			nr_seq_codificacao,
			nr_seq_proc_pac,
			nr_seq_proc_interno,
			cd_doenca_cid,
			ie_tipo_item,
			ie_status,
			ie_classificacao,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec)
		values (
			nr_sequencia_w,
			nr_seq_codificacao_p,
			null,
			null,
			cd_doenca_cid_p,
			'D',
			'A',
			'S',
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp());

	if (ie_classificacao_p = 'S') then
		CALL codificacao_classificar_cid(nm_usuario_p, nr_seq_codificacao_p, nr_sequencia_w, 'D');
	end if;

	CALL gerar_codificacao_atend_log(nr_seq_codificacao_p, ds_classificacao_w || ' : ' || substr(obter_desc_cid(cd_doenca_cid_p),1,255), nm_usuario_p);

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE codificacao_adicionar_diag ( nr_seq_codificacao_p bigint, ie_classificacao_p text, cd_doenca_cid_p text, nm_usuario_p text) FROM PUBLIC;

