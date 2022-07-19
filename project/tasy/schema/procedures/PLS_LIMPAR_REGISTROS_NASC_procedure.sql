-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_limpar_registros_nasc ( nr_seq_conta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
BEGIN

update	pls_conta
set	ie_gestacao = 'N',
	ie_aborto = 'N',
	ie_parto_normal = 'N',
	ie_complicacao_puerperio = 'N',
	ie_complicacao_neonatal = 'N',
	ie_parto_cesaria = 'N',
	ie_baixo_peso = 'N',
	ie_atend_rn_sala_parto = 'N',
	ie_transtorno = 'N',
	ie_obito_mulher  = NULL,
	qt_nasc_vivos  = NULL,
	qt_obito_precoce  = NULL,
	qt_obito_tardio  = NULL,
	qt_nasc_mortos  = NULL,
	qt_nasc_vivos_prematuros  = NULL,
	qt_nasc_vivos_termo  = NULL,
	nm_usuario	= nm_usuario_p
where	nr_sequencia	= nr_seq_conta_p
and	cd_estabelecimento_p = cd_estabelecimento_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_limpar_registros_nasc ( nr_seq_conta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

