-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_documentos_lote_cobr ( nr_seq_lote_p bigint, nr_documento_p bigint, ie_tipo_lote_p text) AS $body$
BEGIN

if (ie_tipo_lote_p = 'T') then

	if (coalesce(nr_documento_p,0) = 0) then
		delete	FROM cobranca_paciente_titulo
		where	nr_seq_lote 	= nr_seq_lote_p;
	else
		delete	FROM cobranca_paciente_titulo
		where	nr_seq_lote	= nr_seq_lote_p
		and	nr_titulo	= nr_documento_p;
	end if;

elsif (ie_tipo_lote_p = 'C') then

	if (coalesce(nr_documento_p,0) = 0) then
		delete	FROM cobranca_paciente_conta
		where	nr_seq_lote 	= nr_seq_lote_p;
	else
		delete	FROM cobranca_paciente_conta
		where	nr_seq_lote		= nr_seq_lote_p
		and	nr_interno_conta	= nr_documento_p;
	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_documentos_lote_cobr ( nr_seq_lote_p bigint, nr_documento_p bigint, ie_tipo_lote_p text) FROM PUBLIC;

