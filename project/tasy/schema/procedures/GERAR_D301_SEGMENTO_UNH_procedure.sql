-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_d301_segmento_unh ( nr_seq_dataset_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_w			bigint;
ie_dataset_w		d301_dataset_envio.ie_dataset%type;
ie_versao_w		c301_versao_arquivo.ie_versao%type;
nr_release_w		c301_versao_arquivo.nr_release%type;
nr_versao_organiz_w	c301_versao_arquivo.nr_versao_organiz%type;


BEGIN

select	count(*)
into STRICT	qt_w
from	d301_segmento_unh
where	nr_seq_dataset	= nr_seq_dataset_p;

select	max(a.ie_dataset),
	coalesce(max(c.ie_versao),'14'),
	coalesce(max(c.nr_release),'000'),
	coalesce(max(c.nr_versao_organiz),'00')
into STRICT	ie_dataset_w,
	ie_versao_w,
	nr_release_w,
	nr_versao_organiz_w
from	d301_dataset_envio a,
	d301_arquivo_envio b,
	c301_estrutura_arq c
where	a.nr_sequencia		= nr_seq_dataset_p
and	a.nr_seq_arquivo	= b.nr_sequencia
and	b.nr_seq_estrut_arq	= c.nr_sequencia;

/*select	nvl(max(ie_versao),'14'),
	nvl(max(nr_release),'000'),
	nvl(max(nr_versao_organiz),'00')
into	ie_versao_w,
	nr_release_w,
	nr_versao_organiz_w
from	 C301_ESTRUTURA_ARQ
where	sysdate between nvl(DT_INICIO_VIGENCIA,sysdate-1) and nvl(DT_FIM_VIGENCIA,sysdate+1);*/
insert into d301_segmento_unh(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_ref_segmento,
	ie_dataset,
	ie_versao_dataset,
	nr_release_dataset,
	nr_versao_organiz,
	nr_seq_dataset)
values (nextval('d301_segmento_unh_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	lpad(to_char(qt_w + 1),5,'0'),
	ie_dataset_w,
	ie_versao_w,
	nr_release_w,
	nr_versao_organiz_w,
	nr_seq_dataset_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_d301_segmento_unh ( nr_seq_dataset_p bigint, nm_usuario_p text) FROM PUBLIC;

