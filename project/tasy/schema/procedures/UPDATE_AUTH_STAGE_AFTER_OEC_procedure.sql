-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_auth_stage_after_oec ( nm_usuario_p text, cd_seq_transaction_P text, ie_status_p text) AS $body$
DECLARE

   nr_seq_estagio_w estagio_autorizacao.nr_sequencia%type;
   authorization_id_w oec_claim.NR_SEQUENCIA_AUTOR%type;
   oec_status_w OEC_CLAIM.IE_STATUS_TASY%type;
   medicare_status_w OEC_CLAIM.CD_MEDICARE_STATUS%type;
   health_fund_status_w OEC_CLAIM.CD_HEALTH_FUND_STATUS%type;
   history_w autorizacao_convenio_hist.ds_historico%type;

  -- Text used to create the history
   medicare_status_text_w ECLIPSE_STATUS_CODES.DS_CODE%type;
   health_fund_status_text_w ECLIPSE_STATUS_CODES.DS_CODE%type;
   oec_status_text_w ECLIPSE_STATUS_CODES.DS_CODE%type;
   oec_process_status_text OEC_CLAIM.CD_OEC_PROCESS_STATUS%type;


BEGIN

select 	max(a.NR_SEQUENCIA_AUTOR),
max(a.IE_STATUS_TASY),
max(a.CD_MEDICARE_STATUS),
max(a.CD_HEALTH_FUND_STATUS),
max(a.CD_OEC_PROCESS_STATUS)
into STRICT 	authorization_id_w,
oec_status_w,
medicare_status_w,
health_fund_status_w,
oec_process_status_text
from 	oec_claim a
where 	a.CD_SEQ_TRANSACTION = cd_seq_transaction_P;

IF (oec_status_w = 1716 ) then
	SELECT 	Max(nr_sequencia)
		INTO STRICT   	nr_seq_estagio_w
		FROM   	estagio_autorizacao
		WHERE  	ie_situacao = 'A'
		AND 	ie_interno = 66;
else

	SELECT 	Max(nr_sequencia)
			INTO STRICT   	nr_seq_estagio_w
			FROM   	estagio_autorizacao
			WHERE  	ie_situacao = 'A'
			AND 	ie_interno = 67;
end if;

UPDATE 	autorizacao_convenio
SET    	nr_seq_estagio = nr_seq_estagio_w,
	nm_usuario = nm_usuario_p,
	dt_atualizacao = clock_timestamp()
WHERE  nr_sequencia = authorization_id_w;

-- fetch the status code 
select max(a.DS_CODE)
into STRICT oec_status_text_w
from ECLIPSE_STATUS_CODES a
where a.CD_CODE = oec_status_w;


-- fetch the medicare status code
if (medicare_status_w IS NOT NULL AND medicare_status_w::text <> '') then
select max(a.DS_CODE)
into STRICT medicare_status_text_w
from ECLIPSE_STATUS_CODES a
where a.CD_CODE = medicare_status_w;
end if;

-- fetch the health fund status code
if (health_fund_status_w IS NOT NULL AND health_fund_status_w::text <> '') then 
select max(a.DS_CODE)
into STRICT health_fund_status_text_w
from ECLIPSE_STATUS_CODES a
where a.CD_CODE = health_fund_status_w;
end if;
history_w := 	'History generated after receiving a response from ECLIPSE ' || oec_status_text_w || chr(10);

if (oec_process_status_text IS NOT NULL AND oec_process_status_text::text <> '') then
	history_w := history_w || ' Status code ' || oec_process_status_text || chr(10);
end if;

if (medicare_status_w IS NOT NULL AND medicare_status_w::text <> '') then
	history_w := history_w || ' Medicare response: ' || medicare_status_text_w || chr(10);

end if;

if (health_fund_status_w IS NOT NULL AND health_fund_status_w::text <> '') then
	history_w := history_w || ' Health Fund response: ' || health_fund_status_text_w || chr(10);

end if;
insert into autorizacao_convenio_hist(nr_sequencia,
		 dt_atualizacao,
		 nm_usuario,
		 nr_atendimento,
		 ds_historico,
		 nr_sequencia_autor)
	values (nextval('autorizacao_convenio_hist_seq'),
		 clock_timestamp(),
		 nm_usuario_p,
		 null,
		 history_w,
		 authorization_id_w);
EXCEPTION
	WHEN OTHERS THEN
	NULL;


commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_auth_stage_after_oec ( nm_usuario_p text, cd_seq_transaction_P text, ie_status_p text) FROM PUBLIC;
