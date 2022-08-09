-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function gerar_dados_diagnostika as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE gerar_dados_diagnostika ( nr_prescricao_p bigint, nr_seq_interno_p bigint, ie_tipo_p bigint, nm_usuario_p text) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL gerar_dados_diagnostika_atx ( ' || quote_nullable(nr_prescricao_p) || ',' || quote_nullable(nr_seq_interno_p) || ',' || quote_nullable(ie_tipo_p) || ',' || quote_nullable(nm_usuario_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE gerar_dados_diagnostika_atx ( nr_prescricao_p bigint, nr_seq_interno_p bigint, ie_tipo_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_projeto_w 		bigint;
nr_seq_log_w		bigint;
ds_parametros_w		varchar(255);
ds_xml_w			text;
nr_seq_prescr_w		bigint;
BEGIN

/*Sequencia do projeto XML*/

if (ie_tipo_p = 1) then
	nr_seq_projeto_w := 100258;
else
	nr_seq_projeto_w := 100264;
end if;

/*Parametros do projeto XML*/

ds_parametros_w :='NR_SEQ_INTERNO='||nr_seq_interno_p||';';
/*Pegar a sequencia da tabela que irá gerar o XML*/

select 	nextval('tasy_xml_banco_seq')
into STRICT 	nr_seq_log_w
;

CALL wheb_exportar_xml(nr_seq_projeto_w,nr_seq_log_w,'',ds_parametros_w);

select	ds_xml
into STRICT	ds_xml_w
from	tasy_xml_banco
where	nr_sequencia = nr_seq_log_w;

select	max(nr_sequencia)
into STRICT	nr_seq_prescr_w
from	prescr_procedimento
where	nr_seq_interno = nr_seq_interno_p;

CALL Gerar_lab_log_interf_imp(nr_prescricao_p,
			nr_seq_prescr_w,
			null,
			null,
			'Projeto: '||nr_seq_projeto_w||' Seq. interno: '||nr_seq_interno_p||' Seq. tasy_xml_banco: '||nr_seq_log_w,
			'XML Diagnóstika',
			'',
			nm_usuario_p,
			'N');

insert into 	integracao_diagnostika(nr_sequencia,
					dt_atualizacao,
					dt_atualizacao_nrec,
					nm_usuario,
					nm_usuario_nrec,
					nr_seq_interno,
					ds_xml)
			values (	nextval('integracao_diagnostika_seq'),
					clock_timestamp(),
					clock_timestamp(),
					nm_usuario_p,
					nm_usuario_p,
					nr_seq_interno_p,
					ds_xml_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_dados_diagnostika ( nr_prescricao_p bigint, nr_seq_interno_p bigint, ie_tipo_p bigint, nm_usuario_p text) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE gerar_dados_diagnostika_atx ( nr_prescricao_p bigint, nr_seq_interno_p bigint, ie_tipo_p bigint, nm_usuario_p text) FROM PUBLIC;
