-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function tasy_gerar_solicitacao_compl as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE tasy_gerar_solicitacao_compl ( cd_pessoa_fisica_p bigint, ie_tipo_complemento_p bigint) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL tasy_gerar_solicitacao_compl_atx ( ' || quote_nullable(cd_pessoa_fisica_p) || ',' || quote_nullable(ie_tipo_complemento_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE tasy_gerar_solicitacao_compl_atx ( cd_pessoa_fisica_p bigint, ie_tipo_complemento_p bigint) AS $body$
DECLARE


nm_campo_w			varchar(255);
vl_campo_ant_w			varchar(255);
vl_campo_novo_w			varchar(255);
nm_usuario_w			varchar(15);
i_w				bigint;
nr_seq_tasy_solic_alt_w		bigint;
nr_seq_tasy_solic_alt_aux_w	bigint;
dt_ant_alteracao_w		timestamp;

C01 CURSOR FOR
	SELECT	nm_campo,
		vl_campo_ant,
		vl_campo_novo,
		nm_usuario
	from	pessoa_fisica_solic_alt
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p;
BEGIN

select	max(nm_usuario)
into STRICT	nm_usuario_w
from	pessoa_fisica_solic_alt
where	cd_pessoa_fisica	= cd_pessoa_fisica_p;

select	max(a.nr_sequencia)
into STRICT	nr_seq_tasy_solic_alt_aux_w
from	tasy_solic_alteracao	a
where	a.ie_processo				= 'M'
and	a.nm_usuario				= nm_usuario_w
and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(a.dt_atualizacao_nrec)	= ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(clock_timestamp())

and	exists	(	SELECT	1
			from	tasy_solic_alt_campo	x
			where	x.nr_seq_solicitacao	= a.nr_sequencia
			and	x.nm_tabela		= 'COMPL_PESSOA_FISICA'
			and	x.ie_status		= 'P'
			and	((x.ds_chave_composta	= 'CD_PESSOA_FISICA='||cd_pessoa_fisica_p||'#@#@IE_TIPO_COMPLEMENTO=1')
			or (x.ds_chave_composta 	= 'CD_PESSOA_FISICA='||cd_pessoa_fisica_p||'#@#@IE_TIPO_COMPLEMENTO=2')
			or (x.ds_chave_composta 	= 'CD_PESSOA_FISICA='||cd_pessoa_fisica_p||'#@#@IE_TIPO_COMPLEMENTO=3')
			or (x.ds_chave_composta 	= 'CD_PESSOA_FISICA='||cd_pessoa_fisica_p||'#@#@IE_TIPO_COMPLEMENTO=4')
			or (x.ds_chave_composta 	= 'CD_PESSOA_FISICA='||cd_pessoa_fisica_p||'#@#@IE_TIPO_COMPLEMENTO=5')
			or (x.ds_chave_composta 	= 'CD_PESSOA_FISICA='||cd_pessoa_fisica_p||'#@#@IE_TIPO_COMPLEMENTO=6')
			or (x.ds_chave_composta 	= 'CD_PESSOA_FISICA='||cd_pessoa_fisica_p||'#@#@IE_TIPO_COMPLEMENTO=7')
			or (x.ds_chave_composta 	= 'CD_PESSOA_FISICA='||cd_pessoa_fisica_p||'#@#@IE_TIPO_COMPLEMENTO=8')));

/*aaschlote 02/07/2012 OS 452939*/

if (nr_seq_tasy_solic_alt_aux_w IS NOT NULL AND nr_seq_tasy_solic_alt_aux_w::text <> '') then
	select	dt_atualizacao_nrec
	into STRICT	dt_ant_alteracao_w
	from	tasy_solic_alteracao
	where	nr_sequencia	= nr_seq_tasy_solic_alt_aux_w;
	
	if	to_char(dt_ant_alteracao_w,'mi') = to_char(clock_timestamp(),'mi') then
		goto final;
	end if;
end if;

i_w	:= 0;
open C01;
loop
fetch C01 into	
	nm_campo_w,
	vl_campo_ant_w,
	vl_campo_novo_w,
	nm_usuario_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (i_w = 0) then
	
		select	nextval('tasy_solic_alteracao_seq')
		into STRICT	nr_seq_tasy_solic_alt_w
		;
		
		insert into tasy_solic_alteracao(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,ie_processo,
				cd_funcao, cd_estabelecimento, ie_status)
		values (	nr_seq_tasy_solic_alt_w,clock_timestamp(),nm_usuario_w,clock_timestamp(),nm_usuario_w,'M',
				wheb_usuario_pck.get_cd_funcao, wheb_usuario_pck.get_cd_estabelecimento, 'A');
	end if;
	
	insert into tasy_solic_alt_campo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
			nr_seq_solicitacao,nm_tabela,nm_atributo,ie_status,ds_valor_old,ds_valor_new,ds_observacao,ds_chave_composta)
	values (	nextval('tasy_solic_alt_campo_seq'),clock_timestamp(),nm_usuario_w,clock_timestamp(),nm_usuario_w,
			nr_seq_tasy_solic_alt_w,'COMPL_PESSOA_FISICA',nm_campo_w,'P',vl_campo_ant_w,vl_campo_novo_w,'COMPL_PESSOA_FISICA_UPDATE','CD_PESSOA_FISICA='||cd_pessoa_fisica_p||'#@#@IE_TIPO_COMPLEMENTO='||ie_tipo_complemento_p);
	
	i_w	:= i_w + 1;
	end;
end loop;
close C01;

<<final>>

delete	FROM pessoa_fisica_solic_alt
where	cd_pessoa_fisica	= cd_pessoa_fisica_p;

if (pls_usuario_pck.get_ie_commit = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_gerar_solicitacao_compl ( cd_pessoa_fisica_p bigint, ie_tipo_complemento_p bigint) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE tasy_gerar_solicitacao_compl_atx ( cd_pessoa_fisica_p bigint, ie_tipo_complemento_p bigint) FROM PUBLIC;

