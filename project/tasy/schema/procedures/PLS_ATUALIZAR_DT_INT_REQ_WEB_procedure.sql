-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_dt_int_req_web ( nr_seq_guia_princ_p bigint, dt_internacao_p text, dt_alta_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_atend_w		bigint;


BEGIN

select  max(nr_sequencia)
into STRICT	nr_seq_atend_w
from	pls_guia_atendimento
where	nr_seq_guia = nr_seq_guia_princ_p;

if (nr_seq_atend_w IS NOT NULL AND nr_seq_atend_w::text <> '') then

	if (dt_internacao_p IS NOT NULL AND dt_internacao_p::text <> '') then
		update	pls_guia_atendimento
		set	dt_internacao = to_date(dt_internacao_p,'dd/mm/yyyy')
		where	nr_sequencia = nr_seq_atend_w;
	end if;

	if (dt_alta_p IS NOT NULL AND dt_alta_p::text <> '') then
		update	pls_guia_atendimento
		set	dt_alta = to_date(dt_alta_p,'dd/mm/yyyy')
		where	nr_sequencia = nr_seq_atend_w;
	end if;

elsif ((nr_seq_guia_princ_p IS NOT NULL AND nr_seq_guia_princ_p::text <> '') and ((dt_alta_p IS NOT NULL AND dt_alta_p::text <> '') or (dt_internacao_p IS NOT NULL AND dt_internacao_p::text <> ''))) then

	insert	into pls_guia_atendimento(nr_sequencia, nr_seq_guia, dt_atualizacao,
		     nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
		     ds_observacao, dt_internacao, dt_alta)
	      values (nextval('pls_guia_atendimento_seq'), nr_seq_guia_princ_p, clock_timestamp(),
		     nm_usuario_p, clock_timestamp(), nm_usuario_p,
		     null, to_date(dt_internacao_p,'dd/mm/yyyy'), to_date(dt_alta_p,'dd/mm/yyyy'));

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_dt_int_req_web ( nr_seq_guia_princ_p bigint, dt_internacao_p text, dt_alta_p text, nm_usuario_p text) FROM PUBLIC;
