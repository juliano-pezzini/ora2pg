-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE codificacao_classificar_cid ( nm_usuario_p text, nr_seq_codificacao_p bigint, nr_sequencia_p bigint, ie_tipo_item_p text) AS $body$
DECLARE

								
ds_item_w	varchar(255);	


BEGIN

	if (nr_seq_codificacao_p IS NOT NULL AND nr_seq_codificacao_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

		update	codificacao_atend_item
		set	ie_classificacao	= 'S'
		where	nr_seq_codificacao 	= nr_seq_codificacao_p
		and	ie_tipo_item		= ie_tipo_item_p;

		update	codificacao_atend_item
		set	ie_classificacao 	= 'P',
			nm_usuario			= nm_usuario,
			dt_atualizacao		= clock_timestamp()
		where	nr_sequencia		= nr_sequencia_p
		and	nr_seq_codificacao	= nr_seq_codificacao_p;

		select	CASE WHEN ie_tipo_item='D' THEN  substr(obter_desc_cid(a.cd_doenca_cid),1,255)  ELSE substr(Obter_Descricao_Procedimento(a.nr_seq_proc_interno, null),1,255) END
		into STRICT 	ds_item_w
		from	codificacao_atend_item a
		where	nr_sequencia = nr_sequencia_p
		and	nr_seq_codificacao = nr_seq_codificacao_p
		and 	coalesce(dt_inativacao::text, '') = '';
		
		CALL gerar_codificacao_atend_log(nr_seq_codificacao_p, obter_desc_expressao(919172) || '. ' || obter_desc_expressao(606383) || ds_item_w || '. ', nm_usuario_p);	
		
	end if;

	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE codificacao_classificar_cid ( nm_usuario_p text, nr_seq_codificacao_p bigint, nr_sequencia_p bigint, ie_tipo_item_p text) FROM PUBLIC;

