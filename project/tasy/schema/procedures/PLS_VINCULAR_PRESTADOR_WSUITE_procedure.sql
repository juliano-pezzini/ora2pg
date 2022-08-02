-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_vincular_prestador_wsuite ( nr_seq_prestador_p pls_cad_prestador_auxiliar.nr_seq_prestador%TYPE, ie_acao_p text ) AS $body$
DECLARE


/*
ie_acao_p
	'V' - Vincular
	'D' - Desvincular
*/
BEGIN

if (ie_acao_p = 'V') then
	insert  into pls_cad_prestador_auxiliar(
		nr_sequencia,
        nr_seq_prestador,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec
        )
	values (
        nextval('pls_cad_prestador_auxiliar_seq'),
		nr_seq_prestador_p,
        clock_timestamp(),
		wheb_usuario_pck.get_nm_usuario,
		clock_timestamp(),
		wheb_usuario_pck.get_nm_usuario
        );
elsif (ie_acao_p = 'D') then
	delete from pls_cad_prestador_auxiliar
	where	nr_seq_prestador	= nr_seq_prestador_p;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_vincular_prestador_wsuite ( nr_seq_prestador_p pls_cad_prestador_auxiliar.nr_seq_prestador%TYPE, ie_acao_p text ) FROM PUBLIC;

