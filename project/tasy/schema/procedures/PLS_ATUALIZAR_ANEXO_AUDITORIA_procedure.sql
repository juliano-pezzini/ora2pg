-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_anexo_auditoria ( nr_seq_auditoria_p pls_auditoria.nr_sequencia%type, ie_tipo_anexo_p text) AS $body$
BEGIN

--Verifica se existe anexo de OPME
if ( ie_tipo_anexo_p = 'OP' ) then

	update	pls_auditoria
	set	ie_anexo_guia = 'S',
		ie_anexo_opme = 'S'
	where 	nr_sequencia = nr_seq_auditoria_p;

end if;

--Verifica se existe anexo de Quimioterapia
if ( ie_tipo_anexo_p = 'QU' ) then

	update	pls_auditoria
	set	ie_anexo_guia		= 'S',
		ie_anexo_quimioterapia	= 'S'
	where 	nr_sequencia = nr_seq_auditoria_p;

end if;

--Verifica se existe anexo de Radioterapia
if ( ie_tipo_anexo_p = 'RA' ) then

	update	pls_auditoria
	set	ie_anexo_guia		= 'S',
		ie_anexo_radioterapia	= 'S'
	where 	nr_sequencia = nr_seq_auditoria_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_anexo_auditoria ( nr_seq_auditoria_p pls_auditoria.nr_sequencia%type, ie_tipo_anexo_p text) FROM PUBLIC;

