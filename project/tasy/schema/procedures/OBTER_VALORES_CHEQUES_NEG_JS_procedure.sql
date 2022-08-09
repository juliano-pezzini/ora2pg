-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_valores_cheques_neg_js ( nr_sequencia_p bigint, ie_cheque_cr_p INOUT text, cd_tipo_portador_p INOUT bigint, cd_portador_p INOUT bigint, ds_erro_1_p INOUT text, ds_erro_2_p INOUT text, ds_erro_3_p INOUT text) AS $body$
BEGIN

	select	coalesce(ie_cheque_cr,'N') ie_cheque_cr,
		cd_tipo_portador,
		cd_portador
	into STRICT	ie_cheque_cr_p,
		cd_tipo_portador_p,
		cd_portador_p
	from	transacao_financeira
	where	nr_sequencia = nr_sequencia_p;

	ds_erro_1_p :=	obter_texto_tasy(98469, wheb_usuario_pck.get_nr_seq_idioma);
	ds_erro_2_p :=	obter_texto_tasy(98470, wheb_usuario_pck.get_nr_seq_idioma);
	ds_erro_3_p :=	obter_texto_tasy(98471, wheb_usuario_pck.get_nr_seq_idioma);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_valores_cheques_neg_js ( nr_sequencia_p bigint, ie_cheque_cr_p INOUT text, cd_tipo_portador_p INOUT bigint, cd_portador_p INOUT bigint, ds_erro_1_p INOUT text, ds_erro_2_p INOUT text, ds_erro_3_p INOUT text) FROM PUBLIC;
