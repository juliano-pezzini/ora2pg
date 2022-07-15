-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cm_substituir_conj_requisicao ( nr_seq_requisicao_p bigint, nr_seq_item_req_p bigint, nr_seq_novo_conj_p bigint, nm_usuario_p text, nr_seq_novo_item_p bigint) AS $body$
DECLARE


		nr_seq_conjunto_w	bigint;
		nm_conjunto_w		varchar(255);
		ds_observacao_w		varchar(255);		
		desc_classificacao_w	varchar(255);
		nr_seq_classif_w			cm_requisicao_item.nr_seq_classif%type;

	
BEGIN

		if (nr_seq_novo_conj_p IS NOT NULL AND nr_seq_novo_conj_p::text <> '') then
				select	nr_seq_conjunto,
					substr(cme_obter_nome_conjunto(nr_seq_conjunto),1,255)
				into STRICT	nr_seq_conjunto_w,
					nm_conjunto_w
				from	cm_requisicao_item
				where	nr_seq_requisicao = nr_seq_requisicao_p
				and	nr_sequencia = nr_seq_item_req_p;

				ds_observacao_w	:=	WHEB_MENSAGEM_PCK.get_texto(455585,'nm_conjunto_w='|| nm_conjunto_w ||';nr_seq_conjunto_w='|| nr_seq_conjunto_w||';data_substituicao='|| PKG_DATE_FORMATERS.TO_VARCHAR(clock_timestamp(), 'timestamp', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, WHEB_USUARIO_PCK.GET_NM_USUARIO) ||';nm_usuario_p='|| nm_usuario_p);

				update	cm_requisicao_item
				set	nr_seq_conjunto = nr_seq_novo_conj_p,
					ds_observacao = ds_observacao_w
				where	nr_seq_requisicao = nr_seq_requisicao_p
				and	nr_sequencia = nr_seq_item_req_p;

				commit;
		end if;
		if (nr_seq_novo_item_p IS NOT NULL AND nr_seq_novo_item_p::text <> '') then
				select
					b.nr_seq_classif ,
					substr(cme_obter_desc_classificacao(nr_seq_novo_item_p),1,255)
				into STRICT	nr_seq_classif_w,
					desc_classificacao_w
				from	cm_requisicao_item a, cm_item b
				where	a.nr_seq_requisicao = nr_seq_requisicao_p
				and	a.nr_sequencia = nr_seq_item_req_p
				and b.nr_sequencia = nr_seq_novo_item_p;
				
					ds_observacao_w	:=	WHEB_MENSAGEM_PCK.get_texto(1086163,'desc_classificacao_w='|| desc_classificacao_w ||';nr_seq_classif_w='|| nr_seq_classif_w||';data_substituicao='|| PKG_DATE_FORMATERS.TO_VARCHAR(clock_timestamp(), 'timestamp', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, WHEB_USUARIO_PCK.GET_NM_USUARIO) ||';nm_usuario_p='|| nm_usuario_p);

				update	cm_requisicao_item
				set	nr_seq_classif = nr_seq_classif_w,
					ds_observacao = ds_observacao_w
				where	nr_seq_requisicao = nr_seq_requisicao_p
				and	nr_sequencia = nr_seq_item_req_p;

				commit;
		end if;
	end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cm_substituir_conj_requisicao ( nr_seq_requisicao_p bigint, nr_seq_item_req_p bigint, nr_seq_novo_conj_p bigint, nm_usuario_p text, nr_seq_novo_item_p bigint) FROM PUBLIC;

