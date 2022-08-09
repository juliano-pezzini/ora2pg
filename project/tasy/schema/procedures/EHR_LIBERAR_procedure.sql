-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ehr_liberar ( nr_sequencia_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


qt_nao_lib_w		bigint;


BEGIN

if (ie_opcao_p = 'TD') then /*Tipo de dado*/
	begin
	update	ehr_tipo_dado
	set	dt_liberacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_sequencia_p;
	end;
elsif (ie_opcao_p = 'EL') then /*Elemento*/
	begin
	update	ehr_elemento
	set	dt_liberacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_sequencia_p;
	end;
elsif (ie_opcao_p = 'DEL') then /*Desfazer elemento*/
	begin
	update	ehr_elemento
	set	dt_liberacao	 = NULL,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_sequencia_p;
	end;
elsif (ie_opcao_p = 'ARQ') then /*Arquetipo*/
	begin
	update	ehr_arquetipo
	set	dt_liberacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_sequencia_p;
	end;
elsif (ie_opcao_p = 'TE') then /*Template*/
	begin
	select	count(*)
	into STRICT	qt_nao_lib_w
	from	ehr_elemento b,
		ehr_template_conteudo a
	where	a.nr_seq_template	= nr_sequencia_p
	and	a.nr_seq_elemento	= b.nr_sequencia
	and	coalesce(b.dt_liberacao::text, '') = '';

	if (qt_nao_lib_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(174252);
	else
		update	ehr_template
		set	dt_liberacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp()
		where	nr_sequencia	= nr_sequencia_p;
	end if;
	end;
elsif (ie_opcao_p = 'DTE') then /*Desfazer Template*/
	begin
	update	ehr_template
	set	dt_liberacao	 = NULL,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_sequencia_p;
	end;
elsif (ie_opcao_p = 'REG') then /*Registro*/
	begin
	update	ehr_registro
	set	dt_liberacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_sequencia_p;
	end;
elsif (ie_opcao_p = 'REGTE') then /*Template do Registro*/
	begin
	update	ehr_reg_template
	set	dt_liberacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_sequencia_p;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ehr_liberar ( nr_sequencia_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;
