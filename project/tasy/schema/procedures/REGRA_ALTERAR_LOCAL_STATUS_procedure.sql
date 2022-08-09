-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function regra_alterar_local_status as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE regra_alterar_local_status (nr_atendimento_p text, ie_acao_p text, nm_usuario_p text, ds_erro_p INOUT text, nr_seq_local_p bigint default null) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'SELECT * FROM regra_alterar_local_status_atx ( ' || quote_nullable(nr_atendimento_p) || ',' || quote_nullable(ie_acao_p) || ',' || quote_nullable(nm_usuario_p) || ',' || quote_nullable(ds_erro_p) || ',' || quote_nullable(nr_seq_local_p) || ' )';
	SELECT v_ret INTO ds_erro_p FROM dblink(v_conn_str, v_query) AS p (v_ret text);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE regra_alterar_local_status_atx (nr_atendimento_p text, ie_acao_p text, nm_usuario_p text, ds_erro_p INOUT text, nr_seq_local_p bigint default null) AS $body$
DECLARE

			
nr_seq_local_pa_w	bigint;
nr_seq_pa_status_w	bigint;
cd_perfil_w		integer;
cd_estabelecimento_w	smallint;
qt_registros_w		integer;
ds_erro_w		varchar(255);
nr_seq_status_w	REGRA_ATEND_LOCAL_STATUS.nr_seq_status%type;
BEGIN

cd_perfil_w := obter_perfil_ativo;
cd_estabelecimento_w := obter_estabelecimento_ativo;

SELECT	count(*)
INTO STRICT	qt_registros_w
FROM	REGRA_ATEND_LOCAL_STATUS
WHERE	ie_situacao = 'A'
and	ie_acao = ie_acao_p
AND	cd_estabelecimento = cd_estabelecimento_w
AND	cd_perfil = cd_perfil_w;

if (qt_registros_w > 0) then
	begin
	SELECT	max(nr_seq_local_pa),
		max(nr_seq_pa_status),
		max(NR_SEQ_STATUS)
	INTO STRICT	nr_seq_local_pa_w,
		nr_seq_pa_status_w,
		nr_seq_status_w
	FROM	REGRA_ATEND_LOCAL_STATUS
	WHERE	ie_situacao = 'A'
	and	ie_acao = ie_acao_p
	AND	cd_estabelecimento = cd_estabelecimento_w
	AND	cd_perfil = cd_perfil_w;
	
	if (ie_acao_p	= 'AM') and (nr_seq_local_p IS NOT NULL AND nr_seq_local_p::text <> '') and (nr_seq_local_p	> 0)then
		nr_seq_local_pa_w:= nr_seq_local_p;
	end if;

	if (nr_seq_local_pa_w IS NOT NULL AND nr_seq_local_pa_w::text <> '') and (nr_seq_pa_status_w IS NOT NULL AND nr_seq_pa_status_w::text <> '') and (nr_atendimento_p > 0) then
		begin
		ds_erro_w := troca_local_paciente_pa(nr_seq_local_pa_w, nr_atendimento_p, '0', nm_usuario_p, wheb_mensagem_pck.get_texto(278543), ds_erro_w);
			
		if (coalesce(ds_erro_w::text, '') = '') then
			CALL alterar_status_pa_atend(nr_seq_pa_status_w, nr_atendimento_p,nr_seq_status_w);
		end if;
		end;
	end if;
	end;
end if;

if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
	ds_erro_p := ds_erro_w;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE regra_alterar_local_status (nr_atendimento_p text, ie_acao_p text, nm_usuario_p text, ds_erro_p INOUT text, nr_seq_local_p bigint default null) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE regra_alterar_local_status_atx (nr_atendimento_p text, ie_acao_p text, nm_usuario_p text, ds_erro_p INOUT text, nr_seq_local_p bigint default null) FROM PUBLIC;
