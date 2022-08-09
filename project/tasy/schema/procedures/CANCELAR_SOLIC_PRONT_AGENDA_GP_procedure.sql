-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function cancelar_solic_pront_agenda_gp as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE cancelar_solic_pront_agenda_gp (nr_seq_agecons_p bigint, nm_usuario_p text) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL cancelar_solic_pront_agenda_gp_atx ( ' || quote_nullable(nr_seq_agecons_p) || ',' || quote_nullable(nm_usuario_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE cancelar_solic_pront_agenda_gp_atx (nr_seq_agecons_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_solic_w				bigint;
cd_pessoa_fisica_w			agenda_consulta.cd_pessoa_fisica%type;
cd_setor_atendimento_w		agenda_consulta.cd_setor_atendimento%type;
dt_agenda_w					agenda_consulta.dt_agenda%type;
qt_agendamentos_nao_canc_w	bigint;
ie_setor_atendimento_w 		varchar(1);
cd_agenda_w					agenda_consulta.cd_agenda%type;
nr_seq_sala_w				agenda_consulta.nr_seq_sala%type;
BEGIN
if (nr_seq_agecons_p IS NOT NULL AND nr_seq_agecons_p::text <> '') then 
 
	ie_setor_atendimento_w 	:= coalesce(Obter_Valor_Param_Usuario(821,356, Obter_perfil_Ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento),'E');
 
	/* obter solicitação */
 
	select	coalesce(max(nr_sequencia),0) 
	into STRICT	nr_seq_solic_w 
	from	same_solic_pront 
	where	nr_seq_agecons = nr_seq_agecons_p;	
 
	select	max(cd_pessoa_fisica), 
			max(cd_setor_atendimento), 
			max(dt_agenda), 
			max(cd_agenda), 
			max(nr_seq_sala) 
	into STRICT	cd_pessoa_fisica_w, 
			cd_setor_atendimento_w, 
			dt_agenda_w, 
			cd_agenda_w, 
			nr_seq_sala_w 
	from	agenda_consulta 
	where	nr_sequencia = nr_seq_agecons_p;
 
 
 
	if (coalesce(cd_setor_atendimento_w::text, '') = '') then 
		select	max(CD_SETOR_EXCLUSIVO) 
		into STRICT	cd_setor_atendimento_w 
		from	agenda 
		where	cd_agenda = cd_agenda_w;
 
		if (ie_setor_atendimento_w = 'S') then 
			select	coalesce(max(a.cd_setor_atendimento), cd_setor_atendimento_w)		 
			into STRICT	cd_setor_atendimento_w		 
			from	agenda_sala_consulta a 
			where	a.nr_sequencia = nr_seq_sala_w;
		end if;
	end if;	
 
	select	count(*) 
	into STRICT	qt_agendamentos_nao_canc_w 
	from	agenda_consulta a 
	where	obter_estab_agenda(cd_agenda) = wheb_usuario_pck.get_cd_estabelecimento 
	and		cd_pessoa_fisica = cd_pessoa_fisica_w 
	and		trunc(dt_agenda) = trunc(dt_agenda_w) 
	and		nr_sequencia <> nr_seq_agecons_p 
	and		coalesce(cd_setor_atendimento,cd_setor_atendimento_w) = cd_setor_atendimento_w 
	and		ie_status_agenda <> 'C';	
 
 
	if (nr_seq_solic_w = 0) then --Busca a sequencia da solicitação das outras agendas caso a atual não possua 
		select	coalesce(max(nr_sequencia),0) 
		into STRICT	nr_seq_solic_w 
		from	same_solic_pront 
		where	nr_seq_agecons in (	SELECT	nr_sequencia 
									from	agenda_consulta a 
									where	obter_estab_agenda(cd_agenda) = wheb_usuario_pck.get_cd_estabelecimento 
									and		cd_pessoa_fisica = cd_pessoa_fisica_w 
									and		trunc(dt_agenda) = trunc(dt_agenda_w)									 
									and		coalesce(cd_setor_atendimento,cd_setor_atendimento_w) = cd_setor_atendimento_w);
	end if;
 
	/* cancelar solicitação */
 
	if (coalesce(nr_seq_solic_w,0) > 0) and (qt_agendamentos_nao_canc_w = 0) then 
		update	same_solic_pront 
		set		ie_status		= 'C', 
				dt_atualizacao	= clock_timestamp(), 
				nm_usuario		= nm_usuario_p, 
				nm_usuario_cancelamento = nm_usuario_p 
		where	nr_sequencia	= nr_seq_solic_w 
		and	ie_status		= 'P';
	end if;	
 
	commit;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_solic_pront_agenda_gp (nr_seq_agecons_p bigint, nm_usuario_p text) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE cancelar_solic_pront_agenda_gp_atx (nr_seq_agecons_p bigint, nm_usuario_p text) FROM PUBLIC;
