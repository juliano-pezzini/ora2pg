-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_acao_recebimento ( nr_sequencia_p bigint, cd_tipo_recebimento_p bigint, ie_acao_p INOUT bigint, nr_seq_regra_p INOUT bigint, ds_caption_p INOUT text) AS $body$
DECLARE


nr_tag_w	smallint;


BEGIN
	if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
		select	coalesce(max(ie_acao),9999) ie_acao
		into STRICT	ie_acao_p
		from	transacao_financeira
		where	nr_sequencia = nr_sequencia_p;

	elsif (cd_tipo_recebimento_p IS NOT NULL AND cd_tipo_recebimento_p::text <> '') then
		select	coalesce(max(ie_acao_rec_caixa),9999) ie_acao
		into STRICT	ie_acao_p
		from	tipo_recebimento
		where	cd_tipo_recebimento = cd_tipo_recebimento_p;

	end if;


	if (ie_acao_p = 0 or ie_acao_p = 32) then
		nr_tag_w 	:= 3;
		ds_caption_p 	:= obter_texto_tasy(96684, wheb_usuario_pck.get_nr_seq_idioma);
	elsif (ie_acao_p = 1 or ie_acao_p = 18 or ie_acao_p = 99 or ie_acao_p = 34) then
		nr_tag_w	:= 1;
		ds_caption_p 	:= obter_texto_tasy(96685, wheb_usuario_pck.get_nr_seq_idioma);
	elsif (ie_acao_p = 3) then
		nr_tag_w	:= 2;
		ds_caption_p 	:= obter_texto_tasy(96686, wheb_usuario_pck.get_nr_seq_idioma);
	elsif (ie_acao_p = 98 or ie_acao_p = 9999) then
		nr_tag_w	:= 0;
		ds_caption_p 	:= '';
	end if;

	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_regra_p
	from	funcao_regra
	where	cd_funcao	= 813
	and	nr_tag		= nr_tag_w
	and	ie_situacao	= 'A';


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_acao_recebimento ( nr_sequencia_p bigint, cd_tipo_recebimento_p bigint, ie_acao_p INOUT bigint, nr_seq_regra_p INOUT bigint, ds_caption_p INOUT text) FROM PUBLIC;
