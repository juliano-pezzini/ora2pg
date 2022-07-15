-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_campo_conf_nom ( nr_seq_guia_p bigint, nm_usuario_p text ) AS $body$
BEGIN
	if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then

		update  w_geracao_guia
		set ds_valor_criptografado = ds_valor
		where nm_usuario = nm_usuario_p
		and ie_tipo_guia = nr_seq_guia_p
		and ie_confidencial = 'S';

		commit;
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_campo_conf_nom ( nr_seq_guia_p bigint, nm_usuario_p text ) FROM PUBLIC;

