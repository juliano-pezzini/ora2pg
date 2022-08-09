-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_apre_prod_portal ( nr_sequencia_p bigint, ie_inclusao_portal_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_plano_w 		pls_contrato_plano.nr_seq_plano%type;
ie_inclusao_portal_w 	pls_contrato_plano.ie_inclusao_portal%type;
nr_contrato_w		pls_contrato.nr_contrato%type;
nr_seq_contrato_w	pls_contrato.nr_sequencia%type;


BEGIN

select	ie_inclusao_portal,
	nr_seq_contrato,
	nr_seq_plano
into STRICT	ie_inclusao_portal_w,
	nr_seq_contrato_w,
	nr_seq_plano_w
from 	pls_contrato_plano
where 	nr_sequencia = nr_sequencia_p;



update	pls_contrato_plano
set	ie_inclusao_portal = ie_inclusao_portal_p
where 	nr_sequencia = nr_sequencia_p;

insert into pls_contrato_historico(nr_sequencia,
			cd_estabelecimento,
			nr_seq_contrato,
			nm_usuario,
			nm_usuario_nrec,
			dt_atualizacao,
			dt_historico,
			dt_atualizacao_nrec,
			ie_tipo_historico,
			ds_historico
			)
		values (nextval('pls_contrato_historico_seq'),
			cd_estabelecimento_p,
			nr_seq_contrato_w,
			nm_usuario_p,
			nm_usuario_p,
			clock_timestamp(),
			clock_timestamp(),
			clock_timestamp(),
			'99', wheb_mensagem_pck.get_texto(331531, 'NR_SEQ_PLANO_P=' || nr_seq_plano_w ||
								';IE_INCLUSAO_PORTAL_OLD=' || ie_inclusao_portal_w ||
								';IE_INCLUSAO_PORTAL_NEW=' || ie_inclusao_portal_p ||
								';DATA_P=' || to_char(clock_timestamp(),'dd/mm/yyyy'))
			-- Apresentação no portal do Produto #@NR_SEQ_PLANO_P#@, alterada de #@IE_INCLUSAO_PORTAL_OLD#@ para #@IE_INCLUSAO_PORTAL_NEW#@ em #@DATA_P#@
			);



commit;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_apre_prod_portal ( nr_sequencia_p bigint, ie_inclusao_portal_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
