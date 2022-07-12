-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_execucao_cirurgica_pck.obter_se_checkin_checkout ( nr_seq_exec_cirurgica_p pls_execucao_cirurgica.nr_sequencia%type, cd_medico_p pessoa_fisica.cd_pessoa_fisica%type, ie_checkin_p INOUT text, ie_checkout_p INOUT text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Validar se o medico pode iniciar e/ou finalizar participacao na execucao cirurgica.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_checkin_w		varchar(1)	:= 'N';
ie_checkout_w		varchar(1)	:= 'N';
ie_permite_bio_cirurg_w	varchar(1);


BEGIN

ie_permite_bio_cirurg_w	:= pls_obter_permite_bio_cirur(cd_medico_p);

if (ie_permite_bio_cirurg_w <> 'S') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1158735);
end if;

begin
	select	'S'
	into STRICT	ie_checkin_w
	from	pls_execucao_cirurgica a
	where	a.nr_sequencia	= nr_seq_exec_cirurgica_p
	and	not exists (	SELECT	1
				from	pls_exec_cirurg_biometria b,
					pls_exec_cirurg_bio_partic c,
					pls_exec_cirurgica_proc d
				where	c.nr_seq_exec_cirurg_bio	= b.nr_sequencia
				and	c.nr_seq_exec_cirurg_proc	= d.nr_sequencia
				and	c.ie_status			= 'A'
				and	b.nr_seq_exec_cirurgica		= a.nr_sequencia
				and	d.ie_finalizado			= 'N'
				and	b.ie_situacao			= 'A'
				and	(b.dt_check_in IS NOT NULL AND b.dt_check_in::text <> '')
				and	b.cd_medico			= cd_medico_p);	
exception
when others then
	ie_checkin_w	:= 'N';
end;

begin
	select	'S'
	into STRICT	ie_checkout_w
	from	pls_execucao_cirurgica a
	where	a.nr_sequencia	= nr_seq_exec_cirurgica_p
	and	exists (	SELECT	1
				from	pls_exec_cirurg_biometria b,
					pls_exec_cirurg_bio_partic c,
					pls_exec_cirurgica_proc d
				where	c.nr_seq_exec_cirurg_bio	= b.nr_sequencia
				and	c.nr_seq_exec_cirurg_proc	= d.nr_sequencia
				and	b.nr_seq_exec_cirurgica		= a.nr_sequencia
				and	c.ie_status			= 'E'
				and	d.ie_finalizado			= 'N'
				and	b.ie_situacao			= 'A'
				and	(b.dt_check_in IS NOT NULL AND b.dt_check_in::text <> '')
				and	coalesce(b.dt_check_out::text, '') = ''
				and	b.cd_medico			= cd_medico_p);	
exception
when others then
	ie_checkout_w	:= 'N';
end;
			
ie_checkin_p	:= ie_checkin_w;
ie_checkout_p	:= ie_checkout_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_execucao_cirurgica_pck.obter_se_checkin_checkout ( nr_seq_exec_cirurgica_p pls_execucao_cirurgica.nr_sequencia%type, cd_medico_p pessoa_fisica.cd_pessoa_fisica%type, ie_checkin_p INOUT text, ie_checkout_p INOUT text) FROM PUBLIC;
