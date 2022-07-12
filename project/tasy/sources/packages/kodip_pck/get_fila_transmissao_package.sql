-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--
-- dblink wrapper to call function kodip_pck.get_fila_transmissao() as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION kodip_pck.get_fila_transmissao ( nr_seq_episodio_p bigint, ie_evento_p text, ie_status_p text) RETURNS bigint AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	bigint;
BEGIN
	v_query := 'SELECT * FROM kodip_pck.get_fila_transmissao_atx ( ' || quote_nullable(nr_seq_episodio_p) || ',' || quote_nullable(ie_evento_p) || ',' || quote_nullable(ie_status_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret bigint);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION kodip_pck.get_fila_transmissao_atx ( nr_seq_episodio_p bigint, ie_evento_p text, ie_status_p text) RETURNS bigint AS $body$
DECLARE

		
nr_seq_documento_w	intpd_fila_transmissao.nr_seq_documento%type;
nr_seq_fila_ww		bigint;
intpd_fila_transmissao_w	intpd_fila_transmissao%rowtype;
BEGIN
nr_seq_documento_w	:=	nr_seq_episodio_p;

begin
nr_seq_fila_ww	:=	kodip_pck.get_seq_fila();

if (nr_seq_fila_ww IS NOT NULL AND nr_seq_fila_ww::text <> '') then
	begin
	select	*
	into STRICT	intpd_fila_transmissao_w
	from	intpd_fila_transmissao
	where	nr_sequencia = nr_seq_fila_ww;
	exception
	when others then
		intpd_fila_transmissao_w	:=	null;
	end;
end if;

if (coalesce(intpd_fila_transmissao_w.nr_sequencia::text, '') = '') then
	begin
	select	*
	into STRICT	intpd_fila_transmissao_w
	from	intpd_fila_transmissao
	where	ie_evento = ie_evento_p
	and	ie_status = ie_status_p
	and	nr_seq_documento = nr_seq_documento_w  LIMIT 1;
	exception
	when others then
		intpd_fila_transmissao_w	:=	null;
	end;

	if (coalesce(intpd_fila_transmissao_w.nr_sequencia::text, '') = '') then
		begin
		intpd_fila_transmissao_w.dt_atualizacao		:=	clock_timestamp();
		intpd_fila_transmissao_w.ie_envio_recebe	:=	'C';
		intpd_fila_transmissao_w.ie_operacao		:=	'I';
		intpd_fila_transmissao_w.ie_evento		:=	ie_evento_p;
		intpd_fila_transmissao_w.ie_status		:=	ie_status_p;
		intpd_fila_transmissao_w.nm_usuario		:=	coalesce(obter_usuario_ativo,'TASY');
		intpd_fila_transmissao_w.nr_seq_documento	:=	nr_seq_documento_w;
		
		begin
		select	b.nr_sequencia
		into STRICT	intpd_fila_transmissao_w.nr_seq_evento_sistema
		from	intpd_eventos a,
			intpd_eventos_sistema b
		where	a.nr_sequencia = b.nr_seq_evento
		and	a.ie_evento = ie_evento_p
		and	a.ie_situacao = 'A'
		and	b.ie_situacao = 'A'  LIMIT 1;
		
		select	nextval('intpd_fila_transmissao_seq')
		into STRICT	intpd_fila_transmissao_w.nr_sequencia
		;
		
		insert into intpd_fila_transmissao values (intpd_fila_transmissao_w.*);
		exception
		when others then
			intpd_fila_transmissao_w.nr_sequencia	:=	null;
		end;
		end;
	end if;
end if;

if (intpd_fila_transmissao_w.ie_status = 'E') then
	begin
	intpd_fila_transmissao_w.dt_atualizacao	:=	clock_timestamp();
	intpd_fila_transmissao_w.ie_status	:=	ie_status_p;
	intpd_fila_transmissao_w.nm_usuario	:=	coalesce(obter_usuario_ativo,'TASY');
	
	update	intpd_fila_transmissao
	set	row = intpd_fila_transmissao_w
	where	nr_sequencia = intpd_fila_transmissao_w.nr_sequencia;
	end;
end if;

CALL kodip_pck.set_seq_fila(intpd_fila_transmissao_w.nr_sequencia);
exception
when others then
	rollback;
end;

commit;

return	intpd_fila_transmissao_w.nr_sequencia;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION kodip_pck.get_fila_transmissao ( nr_seq_episodio_p bigint, ie_evento_p text, ie_status_p text) FROM PUBLIC; -- REVOKE ALL ON FUNCTION kodip_pck.get_fila_transmissao_atx ( nr_seq_episodio_p bigint, ie_evento_p text, ie_status_p text) FROM PUBLIC;
