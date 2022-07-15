-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function aghos_agendamento_solicitacao as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE aghos_agendamento_solicitacao (nr_seq_agenda_p bigint, cd_tipo_atenda_p bigint) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL aghos_agendamento_solicitacao_atx ( ' || quote_nullable(nr_seq_agenda_p) || ',' || quote_nullable(cd_tipo_atenda_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE aghos_agendamento_solicitacao_atx (nr_seq_agenda_p bigint, cd_tipo_atenda_p bigint) AS $body$
DECLARE

 
nr_internacao_w			bigint;
cd_cnes_solicitante_w		varchar(1000);
ds_sep_bv_w			varchar(50);
ds_comando_w			varchar(2000);
cd_pessoa_fisica_w		varchar(10);
dt_agenda_w			timestamp;
hr_inicio_w			timestamp;
cd_tipo_acomodacao_w		smallint;
ds_data_agenda_w		varchar(25);
dt_agendamento_w		timestamp;
ds_usuario_w			varchar(15);
BEGIN
 
/*  
IDF_GSH_I_INTERN_AGENDA_ENT 	NUMBER 		not null 
TIP_STATUS 			VARCHAR2 1 	not null 
DES_ERRO 			VARCHAR2 500 	null 
DAT_INTEGRACAO 		DATE 		not null 
DES_USUARIO 			VARCHAR2 15 	not null 
COD_CNES_SOLICITANTE 		NUMBER 7 	not null 
IDF_INTERNACAO 		NUMBER 9 	not null 
DAT_AGENDAMENTO		DATE		not null 
IDF_TIPO_ACOMODACAO_AGENDAM	NUMBER 2	null 
*/
 
 
if (cd_tipo_atenda_p = 1) then -- Gestão da agenda cirúrgica 
	select	max(cd_pessoa_fisica), 
		max(dt_agenda), 
		max(hr_inicio), 
		max(cd_tipo_acomodacao) 
	into STRICT	cd_pessoa_fisica_w, 
		dt_agenda_w, 
		hr_inicio_w, 
		cd_tipo_acomodacao_w 
	from	agenda_paciente 
	where	nr_sequencia = nr_seq_agenda_p;
end if;
 
select	max(substr(obter_cnes_estab(a.cd_estabelecimento), 1, 7)), 
	max(nr_internacao), 
	coalesce(max(substr(obter_dados_param_atend(a.cd_estabelecimento, 'US'), 1, 15)), 'TREINA') 
into STRICT	cd_cnes_solicitante_w, 
	nr_internacao_w, 
	ds_usuario_w 
from	atendimento_paciente a, 
	solicitacao_tasy_aghos b 
where	a.nr_atendimento = b.nr_atendimento 
and	a.cd_pessoa_fisica = cd_pessoa_fisica_w 
and	b.ie_situacao not in ('AL');
 
dt_agendamento_w := to_date(to_char(dt_agenda_w, 'dd/mm/yyyy') || ' ' || to_char(hr_inicio_w, 'hh24:mi:ss'));
 
ds_sep_bv_w := obter_separador_bv;
 
ds_comando_w :=	'declare '|| 
		'	agenda_sai gsh_i_pkg_integra_sai.agenda_sai@tasy_aghos; '|| 
		'	ds_erro_ww	varchar2(500); '|| 
		'begin '|| 
		' '|| 
		' begin ' ||		 
		'	gsh_i_prc_intern_agenda_ent@tasy_aghos(	0, '|| 
		'						''A'', '|| 
		'						ds_erro_ww, '|| 
		'						sysdate, '|| 
		'						:ds_usuario, '|| 
		'						:cd_cnes_solicitante_p, '|| 
		'						:nr_internacao_p, '|| 
		'						''' || to_char(dt_agendamento_w, 'dd/mm/yyyy hh24:mi:ss') || ''', '|| 
		'						:ie_tipo_acomodacao_p '|| 
		'						); '|| 
		' '|| 
		'	gsh_i_pkg_integra_sai.gsh_i_prc_intern_agenda_sai@tasy_aghos(agenda_sai); '|| 
		' '|| 
		'	if	(agenda_sai.first is not null) then '|| 
		'		for i in agenda_sai.first..agenda_sai.last loop '|| 
		' '|| 
		'		if	(agenda_sai(i).idf_internacao = :nr_internacao_p) then '|| 
		' '|| 
		'			update	solicitacao_tasy_aghos '|| 
		'			set	ie_situacao = ''AG'' '|| 
		'				ds_motivo_situacao = ''Agendado no Aghos, aguardando autorização'' '|| 
		'			where	nr_internacao = :nr_internacao_p; '|| 
		' '|| 
		'				commit; '|| 
		' '|| 
		'			ds_erro_ww := null; '||	 
		'			gsh_i_prc_intern_agenda_s_u@tasy_aghos(	agenda_sai(i).idf_gsh_i_intern_agenda_sai, '|| 
		'								''P'', '|| 
		'								ds_erro_ww); '||			 
		'		end if; '|| 
		'		end loop; '|| 
		'	end if; '|| 
		' DBMS_SESSION.CLOSE_DATABASE_LINK(''tasy_aghos''); ' ||			 
		'  exception '|| 
		'  when others then '|| 
		'   rollback; ' || 
		'   DBMS_SESSION.CLOSE_DATABASE_LINK(''tasy_aghos''); ' ||				 
		'  end; '||					 
		'end;';
 
CALL exec_sql_dinamico_bv('AGHOS', 	ds_comando_w, 	'nr_internacao_p='	|| nr_internacao_w			|| ds_sep_bv_w || 
						'cd_cnes_solicitante_p='|| cd_cnes_solicitante_w		|| ds_sep_bv_w || 
						'ie_tipo_acomodacao_p=' || coalesce(cd_tipo_acomodacao_w, 'null')	|| ds_sep_bv_w || 
						'ds_usuario='		|| coalesce(ds_usuario_w, 'TREINA'));
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE aghos_agendamento_solicitacao (nr_seq_agenda_p bigint, cd_tipo_atenda_p bigint) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE aghos_agendamento_solicitacao_atx (nr_seq_agenda_p bigint, cd_tipo_atenda_p bigint) FROM PUBLIC;

